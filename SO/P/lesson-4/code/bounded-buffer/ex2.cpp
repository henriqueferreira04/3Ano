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


static int *counter = NULL;

void * child_execute(void *arg){
    
    int *value = (int *)arg;
    int n2; 

    while(1) {
        printf("Choose a number between 11-20: ");
        scanf("%d", &n2);

        
        if (n2 >= 11 && n2 <= 20){
            
            break;
        } 
        else printf("Incorrect value. Try again!");
    }

    while(*value < n2) {
            
        (*value)++;
        printf("CHILD: %d\n", *value);
    }
    

    thread_exit(NULL);
    return NULL;
}


int main() {


    counter = (int*)mem_alloc(sizeof(int));

    pthread_t child;

    
    int n1;

    while(1) {
        printf("Choose a number between 1-9: ");
        scanf("%d", &n1);

        if (n1 >= 1 && n1 <= 9){
            *counter = n1;
            break;
        } 
        else printf("Incorrect value. Try again!");
    }

    
    

    thread_create(&child, NULL, child_execute, counter);

    
    thread_join(child, NULL);

    while(*counter > 1) {

        (*counter)--;
        printf("MAIN: %d\n", *counter);
    }

    free(counter);

    return 0;
}