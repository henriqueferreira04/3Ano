#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <math.h>
#include <libgen.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <pthread.h>
#include <string.h>
#include <ctype.h>

#include "utils.h"
#include "thread.h"
#include "fifo.h"

typedef struct {
    char sentence[256];  // Buffer para armazenar a requisição/resposta
    int num_chars, num_digits, num_letters;
    int done; // Flag para indicar se o buffer está pronto para ser processado
    pthread_mutex_t mtx; // Mutex para proteger o acesso ao buffer
    pthread_cond_t cond; // Variável de condição para sinalizar atualização do buffer
} Buffer;

bool verbose = false;

static void printUsage(FILE* fp, const char* cmd)
{
    fprintf(fp, "Synopsis %s [options]\n"
            "\t----------+--------------------------------------------\n"
            "\t  Option  |          Description                       \n"
            "\t----------+--------------------------------------------\n"
            "\t -i num   | number of items per producer (dfl: 500)    \n"
            "\t -p num   | number of producers (dfl: 5)               \n"
            "\t -c num   | number of consumers (dfl: 5)               \n"
            "\t -V       | verbose mode                               \n"
            "\t -h       | this help                                  \n"
            "\t----------+--------------------------------------------\n", cmd);
}
//////////////////////////////////////////////////////////////////////

static Fifo *freeBuffers = NULL; // Fifo para buffers livres
static Fifo *pendingRequests = NULL; // Fifo para requisições pendentes
static Buffer *pool = NULL; // Pool de buffers compartilhado
//////////////////////////////////////////////////////////////////////

void *serverThread(void *arg)
{   
    while (1)
    {
        Item item = fifoRetrieve(pendingRequests);

    
        mutex_lock(&pool[item.id].mtx);

        char *sentence = pool[item.id].sentence;

        if (strcmp(sentence, "exit") == 0) {
            break;
        }

        pool[item.id].num_chars = 0;
        pool[item.id].num_digits = 0;
        pool[item.id].num_letters = 0;

        // Contar caracteres, dígitos e letras
        for (size_t i = 0; i < strlen(sentence); i++) {
            if (isdigit(sentence[i])) {
                pool[item.id].num_digits++;
            } else if (isalpha(sentence[i])) {
                pool[item.id].num_letters++;
            } else if (isspace(sentence[i])) {
                continue;
            }
        }
        
        // Formatar os resultados na sentença do buffer
        snprintf(pool[item.id].sentence, sizeof(pool[item.id].sentence), 
         "Num digits: %d, Num letters: %d\n", 
         pool[item.id].num_digits, pool[item.id].num_letters);

        // Marcar o buffer como pronto (done = 1)
        pool[item.id].done = 1;

        // Sinalizar que a resposta está pronta
        cond_broadcast(&pool[item.id].cond);

        mutex_unlock(&pool[item.id].mtx);
    }

    thread_exit(NULL);
    return NULL;
}

void *clientThread(void *arg)
{   
    while(1) {
        Item item = fifoRetrieve(freeBuffers);

        
        mutex_lock(&pool[item.id].mtx);

        // Solicitar entrada do cliente
        printf("Sentence: ");
        fgets(pool[item.id].sentence, sizeof(pool[item.id].sentence), stdin);

        // Remover newline da entrada
        size_t len = strlen(pool[item.id].sentence);
        if (len > 0 && pool[item.id].sentence[len - 1] == '\n') {
            pool[item.id].sentence[len - 1] = '\0';
        }

        // Colocar a requisição no FIFO de requisições pendentes
        fifoInsert(pendingRequests, item);

        if (strcmp(pool[item.id].sentence, "exit") == 0) {
            pool[item.id].done = 1; // Mark as done to release the buffer
            cond_broadcast(&pool[item.id].cond);
            mutex_unlock(&pool[item.id].mtx);
            break;  // Break the loop and exit the client

        }

        // Esperar pela resposta do servidor
        while (!pool[item.id].done) {
            cond_wait(&pool[item.id].cond, &pool[item.id].mtx);
        }

        // Imprimir a resposta processada
        printf("Processed Sentence: %s", pool[item.id].sentence);

        // Marcar o buffer como disponível novamente
        pool[item.id].done = 0;

        // Colocar o buffer de volta no FIFO de buffers livres
        fifoInsert(freeBuffers, item);

        mutex_unlock(&pool[item.id].mtx);

        
        }

    thread_exit(NULL);
    return NULL;
}

int main (int argc, char *argv[])
{
    uint32_t ni = 500;    /* número de itens */
    uint32_t np = 1;      /* número de produtores (servidores) */
    uint32_t nc = 1;      /* número de consumidores (clientes) */

    /* argumentos da linha de comando */
    const char *optstr = "i:p:c:Vh";
    int option;
    while ((option = getopt(argc, argv, optstr)) != -1)
    {
        switch (option)
        {
            case 'i': ni = atoi(optarg); break;
            case 'p': np = atoi(optarg); break;
            case 'c': nc = atoi(optarg); break;
            case 'V': verbose = true; break;
            case 'h': printUsage(stdout, basename(argv[0])); return 0;
            default: printUsage(stderr, basename(argv[0])); return EXIT_FAILURE;
        }
    }

    printf("Parameters: %d producers, %d consumers, %d items\n", np, nc, ni);

    uint32_t n = 10;  // Número de buffers
    freeBuffers = (Fifo*)mem_alloc(sizeof(Fifo));
    pendingRequests = (Fifo*)mem_alloc(sizeof(Fifo));
    pool = (Buffer*)mem_alloc(sizeof(Buffer) * n);

    fifoInit(freeBuffers);
    fifoInit(pendingRequests);

    for (uint32_t i = 0; i < n; i++) {
        // Inicializar o buffer
        memset(pool[i].sentence, 0, sizeof(pool[i].sentence));
        pool[i].num_chars = 0;
        pool[i].num_digits = 0;
        pool[i].num_letters = 0;
        pool[i].done = 0;  // Não pronto inicialmente
        
        mutex_init(&pool[i].mtx, NULL);
        cond_init(&pool[i].cond, NULL);

        Item item = Item{i, i * 1000000 + i, i * 1000000 + i};
        fifoInsert(freeBuffers, item);
    }

    // Criar threads de clientes
    pthread_t client[nc];
    for (uint32_t i = 0; i < nc; i++) {
        thread_create(&client[i], NULL, clientThread, freeBuffers);
    }

    // Criar threads de servidores
    pthread_t server[np];
    for (uint32_t i = 0; i < np; i++) {
        thread_create(&server[i], NULL, serverThread, pendingRequests);
    }

    

    // Esperar threads dos servidores finalizarem
    for (uint32_t i = 0; i < np; i++) {
        thread_join(server[i], NULL);
        printf("Server %u finished\n", i + 1);
    }

    

    // Esperar threads dos clientes finalizarem
    for (uint32_t i = 0; i < nc; i++) {
        thread_join(client[i], NULL);
        printf("Client %u finished\n", i + 1);
    }

    // Destruir FIFOs e buffers
    fifoDestroy(freeBuffers);
    fifoDestroy(pendingRequests);

    return 0;
}
