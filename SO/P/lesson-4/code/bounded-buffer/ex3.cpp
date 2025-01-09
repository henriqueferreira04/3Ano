#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <math.h>
#include <libgen.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>

#include "utils.h"
#include "thread.h"
#include "fifo.h"

pthread_mutex_t lock;
pthread_cond_t cond;

bool turn = 0;

static int *counter = NULL;

void * child_execute(void *arg) {
    int id = *(int*)arg;
    

    while(1) {
        mutex_lock(&lock);

        while (turn != id) {
            cond_wait(&cond, &lock);
        }

        if (*counter > 1) {
            (*counter)--;
            printf("Thread ID = %ld | counter = %d\n", thread_self(), *counter);

            turn = !turn;
            cond_broadcast(&cond);
        } 

        mutex_unlock(&lock);
        
        if (*counter == 1) break;

        
    }

    thread_exit(NULL);
    return NULL;
}

int main() {

    counter = (int *)mem_alloc(sizeof(int));

    int n1;
    while(1) {
        printf("Choose a number between 10-20: ");
        scanf("%d", &n1);

        if (n1 >= 10 && n1 <= 20) {
            *counter = n1;
            break;
        }
        else printf("Incorrect value. Try again!\n");

    }


 

    pthread_t child[2];
    int id[2] = {0, 1};
  

    mutex_init(&lock, NULL);

    cond_init(&cond, NULL);

    thread_create(&child[0], NULL, child_execute, &id[0]);

    thread_create(&child[1], NULL, child_execute, &id[1]);


    thread_join(child[0], NULL);
    thread_join(child[1], NULL);


    

    return 0;
}