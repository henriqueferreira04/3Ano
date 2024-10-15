#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <libgen.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>

#include "fifo.h"
#include "process.h"

#define ACCESS 0
#define SLOTS 1
#define ITEMS 2

int main() {


    int shmid = pshmget(IPC_PRIVATE, sizeof(int), IPC_CREAT | 0666);
    
    
    // Anexando a memória compartilhada
    int *counter = (int *)shmat(shmid, NULL, 0);

    int value = 0;

    while(true) {

        printf("Chooose a number between 10 and 20: ");
        scanf("%d", &value);

        if (value < 10 || value > 20){
            printf("Invalid value! Try again.\n");
        }
        else  {
            *counter = value;
            break;
        }
        

    }

    int sem = psemget(IPC_PRIVATE, 3, IPC_CREAT | 0600);

    psem_up(sem, SLOTS);
    psem_up(sem, ACCESS);

    //child 1
    pid_t pid = fork();

    if (pid == 0) {

        while(true) {

            psem_down(sem, SLOTS);
            psem_down(sem, ACCESS);

            (*counter)--;

            printf("Child1 (pid = %d): counter = %d\n",getpid(), *counter);
            
            if (*counter == 1) break;

            if (*counter < 1) *counter = value;

            psem_up(sem, ACCESS);
            psem_up(sem, SLOTS);

            
        }
        exit(0);
    }
    else {

        pid_t pid2 = fork();


        if (pid2 == 0) {

            while(true) {

                psem_down(sem, SLOTS);
                psem_down(sem, ACCESS);

                (*counter)--;
                printf("Child2 (pid = %d): counter = %d\n",getpid(), *counter);

                if (*counter == 1) break;

                if (*counter < 1) *counter = value;

                psem_up(sem, ACCESS);
                psem_up(sem, SLOTS);

                

            } 
            exit(0);  
        }
        else {
            pwait(NULL);


        }

    }

    pshmdt(counter);
    pshmctl(shmid, 0, NULL);

    printf("Memory released\n");

}