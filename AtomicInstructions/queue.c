#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <assert.h>
#include <pthread.h>
#include <atomic>
#include "queue.h"

#define DEQUEUE_FAIL -99

// this is not a type you need to think about yourself
// I use it to do the appropiate conversions in the cas function
union union_type {
    pointer_t parts;
    unsigned __int128 as_int128;
};

bool cas(pointer_t *src,
         pointer_t expected,
         pointer_t value)
{
    union union_type uexp = { .parts = expected };
    union union_type uvalue = { .parts = value };
    return __sync_bool_compare_and_swap((__int128*) src,
                                        uexp.as_int128,
                                        uvalue.as_int128);
}

//Creates pointer and makes counter correct value
/*
bool update_and_increment(pointer_t * src, pointer_t old_value, node_t * new_pointer){
    // for CAS(&Q->Tail, tail, <next.ptr, tail.count+1>)
    // PASS IN(, tail, next.tr)
    //Gets counter variable from old value, makes new pointer_t with new pointer and the incremented counter, and calls cas

    uint64_t old_count = old_value.counter;
    
    pointer_t new_ptr;
    new_ptr.pointer = old_value.pointer;
    uint64_t incre = old_value+1;
    new_ptr.counter = incre;
    if(cas(*src, old_value, new_ptr)){
        new_ptr.pointer = new_pointer;
        return true;
    }
    
    new_ptr.counter = old_count += 1;
    new.ptr.pointer->next = 
    if(cas(*src, old_value, new_ptr)){
        return true;
    }
    return false;
   //src->pointer = new_pointer;
   //src->counter = old_count += 1;
    //cas(*src, old_value, new_ptr);)
    //node_t -> next = new_ptr;

}
*/
bool update_and_increment(pointer_t *src, pointer_t old_value, node_t * new_pointer){
    //pointer_t nouvelle_pointer = {next.pointer, dummy_head.counter+1};
    //assert(nouvelle_pointer.pointer != NULL);
    //if(cas(&queue->head, dummy_head, nouvelle_pointer)){

    //update_and_increment(&queue->head, dummy_head, next)
    //assert(new_pointer != NULL);
    pointer_t new_ptr = {new_pointer, old_value.counter+1};
    //new_ptr.counter = old_value.counter+1;
    //new_ptr.pointer =
    /*
    if(old_value.pointer!= NULL && new_pointer!= NULL){
        //printf("trying cas with *src, old_value %d, new_pointer %d \t", old_value.pointer->value, new_pointer->value);
    } 
    */
    if(cas(src, old_value, new_ptr)){
        //printf("cas worked? \n");
        return true;
    }
    //printf("no cas \n");
    return false;
}
/*
pointer_t gen_increment(node_t* old_point, uint64_t old_value){
    pointer_t newgen;
    newgen.pointer = old_point;
    newgen.counter = old_value+1;
    return newgen;
}
*/

void initialize(queue_t *new_queue) {
    node_t *node = (node_t*) malloc(sizeof(node_t));
    assert(node != NULL);
    node->next.pointer = NULL;
    node->next.counter = 0;
    new_queue->head.pointer = new_queue->tail.pointer = node;
    new_queue->head.counter = new_queue->tail.counter = 0;
    
}

bool checkequals(pointer_t alpha, pointer_t bravo){
    //printf("Checking equals \n");


    if (alpha.pointer == NULL && bravo.pointer == NULL){
        return true;
    }

    if (alpha.pointer == NULL || bravo.pointer == NULL){
        return false;
    }
  

    if(alpha.counter != bravo.counter){
        return false;
    }
    /*
    if((alpha.pointer==NULL)&&(bravo.pointer==NULL)){
        return true;
    }
    */
    //printf("checking again \n");
    if((alpha.pointer)!=(bravo.pointer)){
        //printf("third break \n");
        return false;
    } 
    //printf("before third \n");
    /*
    if((alpha.pointer->value!=NULL)&&(bravo.pointer->value!=NULL)){
        
    }
    */
   /*
    if((alpha.pointer->value)!=(bravo.pointer->value)){
        //printf("second break \n");
        //printf("alpha pointer val: %d \t bravo pointer val: %d", alpha.pointer->value, bravo.pointer->value);
        return false;
    }
    */
    //printf("successful \n");
    return true;
}

bool equalchecker(node_t* alpha, node_t* bravo){
    //printf("equalchecker \n");
    if(alpha == NULL && bravo==NULL){
        return true;
    }
    if(alpha == NULL || bravo == NULL){
        return false;
    }

    if(alpha != bravo){
        return false;
    }

    if((alpha->value)!=(bravo->value)){
        return false;
    }
    //printf("try checkequals \n");
    /*
    if(checkequals(alpha->next, bravo->next)){
        return true;
    }
    return false;
    */
   return checkequals(alpha->next, bravo->next);
}

/* Inserts an item in the queue */

void enqueue(queue_t *queue, int value) {
    node_t *node = (node_t*) malloc(sizeof(node_t));
    assert(node != NULL);
    node->value = value;
    node->next.pointer = NULL;
    pointer_t tail;
    while(1){
        tail = queue->tail;
        assert(tail.pointer != NULL);
        pointer_t next = tail.pointer->next;
        if(checkequals(tail, queue->tail)){
            if(next.pointer == NULL){
                //pointer_t newn = {node, next.counter+1};
                //assert(newn.pointer != NULL);
                //if(cas(&queue->tail, tail, newn)){
                //    break;
                //}
                assert(next.pointer == NULL);
                //assert(node != NULL);
                if(update_and_increment(&tail.pointer->next, next, node)==true){
                    //printf("ready to break \n");
                    //assert(next.pointer != NULL);
                    break;
                }
            }
            else{
                //pointer_t bewn = {next.pointer, tail.counter+1};
                //cas(&queue->tail, tail, bewn);
                //printf("else loop \n");
                update_and_increment(&queue->tail, tail, next.pointer);
            }
        }
    }
    update_and_increment(&queue->tail, tail, node);
        //pointer_t fal = {node, tail.counter+1};
    //cas(&queue->tail, tail, fal);
    //queue->tail.pointer->next.pointer = node ;
    //printf("finito \n");
    //queue->tail.pointer = node;
}

/*
void enqueue(queue_t *queue, int value) {
    node_t *node = (node_t*) malloc(sizeof(node_t));
    assert(node != NULL);
    node->value = value;
    node->next.pointer = NULL;

    queue->tail.pointer->next.pointer = node;
    queue->tail.pointer = node;
}
*/

/**
Removes an item from the queue and returns its value, or DEQUEUE_FAIL
if the list is empty.

 */
int dequeue(queue_t *queue) {
    int return_val = 0;
    pointer_t dummy_head;
    while(1){
        dummy_head = queue->head;
        //assert(dummy_head.pointer != NULL);
        pointer_t tail = queue->tail;
        //assert(tail.pointer != NULL);
        pointer_t next = dummy_head.pointer->next;
        if(checkequals(dummy_head, queue->head)){
            if(equalchecker(dummy_head.pointer, tail.pointer)){
            //if(checkequals(dummy_head, tail)){
                if(next.pointer == NULL) {
                    // there is always a "dummy" in our list, so if a remove would
                    // elliminate it that means the list is empty
                    //assert(dummy_head.pointer->next.pointer == NULL);
                    return DEQUEUE_FAIL;
                }
                /*
                bool alpha = false;
                while(!alpha){
                    alpha = update_and_increment(&queue->tail, tail, next);
                }
                printf("first if \n");
                */
                //pointer_t acombine = gen_increment(next.pointer, tail.counter);
                //pointer_t nouveau_pointer = {next.pointer, tail.counter+1};
                //assert(nouveau_pointer.pointer != NULL);
                //cas(&queue->tail, tail, nouveau_pointer);

                update_and_increment(&queue->tail, tail, next.pointer);
                //free(nouveau_pointer.pointer);
            }
            else{
                //printf("Else loop \n");
                //Read value beforeCAS, otherwise another dequeue might free the next node
                //assert(next.pointer != NULL);
                //if(next.pointer != NULL){
                  //  return_val = next.pointer->value;
                //}
                if(next.pointer != NULL){
                    return_val = next.pointer->value;

                    if(update_and_increment(&queue->head, dummy_head, next.pointer)){
                        break;
                    }
                }
                /*bool bravo = false;
                while(!bravo){
                    update_and_increment(next, dummy_head.counter, next->pointer);
                }*/
                //printf("Incrementing \n");
                //pointer_t bcombine = gen_increment(next.pointer, dummy_head.counter);
                //if (cas(&queue->head, dummy_head, bcombine)){
                //pointer_t nouvelle_pointer = {next.pointer, dummy_head.counter+1};
                //assert(nouvelle_pointer.pointer != NULL);
                    //queue->head = dummy_head.pointer->next;
                    //break;
                //if(cas(&queue->head, dummy_head, nouvelle_pointer)){
                    // in a somewhat odd approach, the value we're returning is
                    // the one after the dummy head
                    // the old value node becomes the new dummy head
                    /*
                    printf("First Assertion: \n");
                    assert(queue->head.pointer != NULL);
                    printf("Finished Assertion One \n");
                    printf("Second Assertion: \n");
                    assert(dummy_head.pointer != NULL);
                    printf("Finished Assertion Two \n");
                    printf("Third Assertion: \n");
                    printf("value of dummy_head.pointer->next.pointer->value %d \n", dummy_head.pointer->next.pointer->value);
                    assert(dummy_head.pointer->next.pointer != NULL);
                    printf("Finished Assertion Three \n");
                    assert(dummy_head.pointer->next.pointer->value != NULL);
                    printf("Finished Assertion Four \n");
                    */
                    //int result = dummy_head.pointer->next.pointer->value;
                    //queue->head = dummy_head.pointer->next;
                    //printf("prochaine \n");
                    //printf("value of queue->head.pointer->value: %d \n", queue->head.pointer->value);
                    //printf("value of dummy_head.pointer->value: %d \n", dummy_head.pointer->value);
                    //printf("value of dummy_head.pointer->next.pointer->value: %d \n", dummy_head.pointer->next.pointer->value);
                    //assert(dummy_head.pointer != NULL);
                    //printf("dummy_head.pointer-> value: %d \t result: %d \n", dummy_head.pointer->value, result);
                    //printf("f \n");
                    //printf("finallement \n");
                    //free(nouvelle_pointer.pointer);
                    //free(dummy_head.pointer);
                    //return result;
            }
        }
    }
    //printf("here? \n");
    free(dummy_head.pointer);
    return return_val;
}

// frees resources associated with the queue
// not intented to be called in a concurrent context
void destroy(queue_t *queue) {
    while(queue->head.pointer != NULL) {
        node_t *to_free = queue->head.pointer;
        queue->head = to_free->next;
        free(to_free);
    }
}
