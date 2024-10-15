#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/types.h>

#include "fifo.h"
#include "process.h"

#define BUFFER_SIZE 1024
#define SERVER 0
#define CLIENT 0

char *buffer[BUFFER_SIZE];
Fifo *freeBuffers; // Declare freeBuffers globally
Fifo *pendingRequests; // Declare pendingRequests globally

int32_t getFreeBuffer() {
    Item item = fifoRetrieve(freeBuffers);
    return item.id;
}

void putRequestData(char *data, uint32_t id) {
    buffer[id] = data;
}

void submitRequest(uint32_t id) {
    Item item = {id, id, id};
    fifoInsert(pendingRequests, item);
}

void waitForResponse(uint32_t id) {
    // Aqui você deve implementar a lógica para esperar por uma resposta
}

char *getResponseData(uint32_t id) {
    return buffer[id];
}

void releaseBuffer(uint32_t id) {
    Item item = {id, id, id};
    fifoInsert(freeBuffers, item);
}

int main() {
    // Configuração da memória compartilhada e FIFO
    int shmid = pshmget(IPC_PRIVATE, sizeof(Fifo), IPC_CREAT | 0600);
    if (shmid < 0) {
        perror("Erro ao criar freeBuffers");
        exit(1);
    }
    freeBuffers = (Fifo *)shmat(shmid, NULL, 0);
    if (freeBuffers == (void *)-1) {
        perror("Erro ao anexar freeBuffers");
        exit(1);
    }

    int shmid2 = pshmget(IPC_PRIVATE, sizeof(Fifo), IPC_CREAT | 0600);
    if (shmid2 < 0) {
        perror("Erro ao criar pendingRequests");
        exit(1);
    }
    pendingRequests = (Fifo *)shmat(shmid2, NULL, 0);
    if (pendingRequests == (void *)-1) {
        perror("Erro ao anexar pendingRequests");
        exit(1);
    }

    while (true) {
        char *data = (char *)malloc(20 * sizeof(char));
        if (data == NULL) {
            perror("Erro ao alocar memória para data");
            exit(1);
        }

        printf("Question: ");
        scanf("%19s", data); // Limita a leitura a 19 caracteres para evitar buffer overflow

        uint32_t id = getFreeBuffer();
        strcpy(data, "OLA");
        putRequestData(data, id);
        submitRequest(id);
        waitForResponse(id);
        char *resp = getResponseData(id);
        printf("Response: %s\n", resp);
        releaseBuffer(id);

        free(data); // Libera a memória alocada
    }

    return 0;
}
