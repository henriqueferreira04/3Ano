#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <stdlib.h>
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

int32_t getPendingRequest() {
    Item item = fifoRetrieve(pendingRequests);
    return item.id;
}

char *getRequestData(uint32_t id) {
    return buffer[id];
}

char *produceResponse(char *req) {
    printf("Received: %s\n", req);
    printf("Response: ");
    
    char *data = (char *)malloc(20 * sizeof(char));
    if (data == NULL) {
        perror("Erro ao alocar memória para data");
        exit(1);
    }

    scanf("%19s", data); // Limita a leitura a 19 caracteres para evitar buffer overflow

    return data;
}

void putResponseData(char *resp, uint32_t id) {
    buffer[id] = resp;
}

void notifyClient(uint32_t id) {
    // Implementar notificação ao cliente aqui
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
        if (pendingRequests->count > 0) {
            uint32_t id = getPendingRequest();
            char *req = getRequestData(id);
            char *resp = produceResponse(req);
            putResponseData(resp, id);
            notifyClient(id);
        }
    }

    return 0;
}
