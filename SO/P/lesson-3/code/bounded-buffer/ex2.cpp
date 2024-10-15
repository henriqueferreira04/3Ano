#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/wait.h>
#include <stdbool.h>

int main() {
    // Criação de uma chave para a memória compartilhada
    
    
    // Criação da memória compartilhada
    int shmid = shmget(IPC_PRIVATE, sizeof(int), IPC_CREAT | 0666);
    if (shmid < 0) {
        perror("shmget");
        exit(1);
    }
    
    // Anexando a memória compartilhada
    int *counter = (int *)shmat(shmid, NULL, 0);
    *counter = 1;  // Inicia o contador em 1

    // Criando o processo filho
    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        exit(1);
    } else if (pid == 0) {
        // Processo filho: Incrementar até N
        int value;
        // Validação da entrada
        while (true) {
            printf("Choose a value between 10 and 20: ");
            scanf("%d", &value);
            if (value >= 10 && value <= 20) {
                break;
            } else {
                printf("Invalid value! Try again.\n");
            }
        }
        
        // Incrementa o contador até N
        while(*counter < value) {
            (*counter)++;
            printf("Child: %d\n", *counter);
            sleep(1);  // Espera 1 segundo para visualizar a contagem
        }
        
        // O processo filho termina
        exit(0);
    } else {
        // Processo pai: Decrementar até 1
        wait(NULL);  // Espera o processo filho terminar
        
        while(*counter > 1) {
            (*counter)--;
            printf("Parent: %d\n", *counter);
            sleep(1);  // Espera 1 segundo para visualizar a contagem
        }

        // Liberar a memória compartilhada
        shmdt(counter);
        shmctl(shmid, IPC_RMID, NULL);  // Remove a memória compartilhada
    }
    
    return 0;
}
