#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "linked-list.h"

/*******************************************************/

SllNode* sllDestroy(SllNode* list)
{
    SllNode *curr = list;

    while(curr != NULL) {
        list = curr->next;
        if (curr->reg.name != NULL) {
            free(curr->reg.name);

        }
 
        free(curr);

        curr = curr->next;
    }
    return list;
}

/*******************************************************/

void sllPrint(SllNode *list, FILE *fout)
{
    while(list != NULL) {
        fprintf(fout, "%u %s\n", list->reg.nmec, list->reg.name);
        list = list->next;
    }
}

/*******************************************************/

SllNode* sllInsert(SllNode* list, uint32_t nmec, const char *name)
{
    assert(name != NULL && name[0] != '\0');
    assert(!sllExists(list, nmec));

    SllNode *new_node = (SllNode *) malloc(sizeof(SllNode));

    if (new_node == NULL) {
        fprintf(stderr, "Error allocating memory for new node\n");
        exit(1);
    }

    new_node->reg.name = (char *) malloc(strlen(name) + 1);

    if (new_node->reg.name == NULL) {
        fprintf(stderr, "Error allocating memory for new student name\n");
        exit(1);
    }

    strcpy(new_node->reg.name, name);
    new_node->reg.nmec = nmec;

    SllNode *curr_node = list;
    SllNode *prev_node = NULL;

    while (1){
        
        if (curr_node == NULL) { 
            list = new_node;
            
            new_node->next = NULL;
            break;
        }
        else if (new_node->reg.nmec < curr_node->reg.nmec) {
            if (prev_node == NULL) { // Insert at the beginning
                list = new_node;
            } else {
                prev_node->next = new_node; // Insert in the middle
            }
            new_node->next = curr_node;
            break;
        }
        else if(curr_node->next == NULL) { // Insert at the end
            curr_node->next = new_node;
            new_node->next = NULL;
            break;
        }

        prev_node = curr_node;
        curr_node = curr_node->next;
    }

    return list;
    
}

/*******************************************************/

bool sllExists(SllNode* list, uint32_t nmec)
{
    SllNode *curr = list;

    while(curr != NULL) {
        if (curr->reg.nmec == nmec) {
            return true;
        }
        curr = curr->next;
    }
    return false;
}

/*******************************************************/

SllNode* sllRemove(SllNode* list, uint32_t nmec)
{
    assert(list != NULL);
    assert(sllExists(list, nmec));

    SllNode *curr = list;
    SllNode *prev = NULL;

    while (curr != NULL) {

        if (curr->reg.nmec == nmec) {
            if (prev == NULL) {      // At beginning (head node)
                list = curr->next;

                if (curr->reg.name != NULL) {
                    free(curr->reg.name);
                }

                
                free(curr);
            } 
            else {  // Middle or end
                prev->next = curr->next;

                if (curr->reg.name != NULL) {
                    free(curr->reg.name);
                }

                free(curr);
            }

            break;
        }

        prev = curr;
        curr = curr->next;
    }

    return list;
}


/*******************************************************/

const char *sllGetName(SllNode* list, uint32_t nmec)
{
    assert(list != NULL);
    assert(sllExists(list, nmec));

    SllNode *curr = list;
    
    while(curr != NULL) {
        if (curr->reg.nmec == nmec) {
            return curr->reg.name;
            
        }

        curr = curr->next;
    }

    return NULL;
}

/*******************************************************/

SllNode* sllLoad(SllNode *list, FILE *fin, bool *ok)
{
    assert(fin != NULL);

    if (ok != NULL)
       *ok = false; // load failure

    uint32_t nmec;
    char name[80];

    while (fscanf(fin, "%u; %[^\n]", &nmec, name) == 2) {
        list = sllInsert(list, nmec, name);
    }

    if (feof(fin)) {
        if (ok != NULL)
            *ok = true; // load success
    }

    return list;
}

/*******************************************************/

