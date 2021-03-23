#include <stdio.h>  // needed for size_t etc.
#include <unistd.h> // needed for sbrk etc.
#include <sys/mman.h> // needed for mmap
#include <assert.h> // needed for asserts
#include "dmm.h"

/* 
 * The lab handout and code guide you to a solution with a single free list containing all free
 * blocks (and only the blocks that are free) sorted by starting address.  Every block (allocated
 * or free) has a header (type metadata_t) with list pointers, but no footers are defined.
 * That solution is "simple" but inefficient.  You can improve it using the concepts from the
 * reading.
 */

/* 
 *size_t is the return type of the sizeof operator.   size_t type is large enough to represent
 * the size of the largest possible object (equivalently, the maximum virtual address).
 */

typedef struct metadata {
  size_t size;
  struct metadata* next;
  struct metadata* prev;
  bool fille;
} metadata_t;

//"the block returned by the allocator is aligned on an 8-byte (double-word) boundary"
//"blocksize is always a multiple of 8 and 3 low-order bits of block size = 0"
/*
 * Head of the freelist: pointer to the header of the first free block.
 */

static metadata_t* freelist = NULL;
metadata_t* testit = NULL;

void* dmalloc(size_t numbytes) {

  if(freelist == NULL) {
    if(!dmalloc_init()) {
      return NULL;
    }
  }

  assert(numbytes > 0);

  // new_header->size = curr->size - ALIGN(numbytes) - METADATA_T_ALIGNED;
  // block->size = ALIGN(num_bytes) + METADATA_T_ALIGNED;
  /* your code here */

  //return (void*)current + METADATA_T_ALIGNED;
  metadata_t* walker = freelist;
  //metadata_t* ret = NULL;
  while(walker != NULL){
    if((walker->size >= (ALIGN(numbytes)+METADATA_T_ALIGNED))&&(walker->fille==false)){
      if(walker == testit){
        testit = walker;
        return NULL;
      }
      if((walker->size - ALIGN(numbytes) - METADATA_T_ALIGNED) < METADATA_T_ALIGNED){
        walker -> fille = true;
        return ((void*)walker + METADATA_T_ALIGNED);
      }
      metadata_t* newBlock = (void*)walker + ALIGN(numbytes)+METADATA_T_ALIGNED;

      newBlock -> prev = walker;
      if(walker -> next == NULL){
        newBlock -> next = NULL;
      }
      else{
        newBlock -> next = walker -> next;
        walker -> next -> prev = newBlock;
      }
      
      newBlock -> size = (walker->size - ALIGN(numbytes) - METADATA_T_ALIGNED);
      //newBlock -> size = (walker->size - ALIGN(numbytes));
      newBlock -> fille = false;

      walker -> next = newBlock;
      walker -> fille = true;
      walker -> size = ALIGN(numbytes);
      //walker -> size = ALIGN(numbytes+sizeof(metadata_t));
      /*
      if(walker->prev != NULL){
        walker->prev->next = newBlock;
      }
      else{
        freelist = newBlock;
      }
      if(walker->next!=NULL){
        walker->next->prev = newBlock;
      }
      */
      metadata_t* ret = walker;
      return ((void*)ret + METADATA_T_ALIGNED);
    }
    walker = walker->next;
 }

  return NULL;
}

/*
void free(void * ptr){
  header_t *hptr = (header_t *) ptr - 1;
  size of free region = size of the header + size space allocated to user
  -> when requesting N bytes, search for free chunk of size N + header
}
*/
void dfree(void* ptr) {
  /* your code here */
  /*
  if(ptr == NULL){
    break;
  }
  */
  metadata_t* actualHead = (metadata_t*)(ptr-METADATA_T_ALIGNED);
  actualHead->fille = false;
  if((actualHead->prev != NULL)&&((actualHead->next != NULL))){
    if((actualHead->prev->fille == false)&&((actualHead->next->fille==true))){
      metadata_t* prevHead = actualHead->prev;
      prevHead -> next = actualHead->next;
      actualHead -> next -> prev = prevHead;
      prevHead -> fille = false;
      prevHead -> size = (prevHead -> size) + (actualHead -> size) + METADATA_T_ALIGNED;
      //free(actualHead);
    }
    
    //Case 3: Previous block allocated, next block free
    else if((actualHead->prev->fille == true)&&((actualHead->next->fille==false))){
      metadata_t* nextHead = actualHead->next;
      if(nextHead -> next == NULL){
        actualHead -> next = NULL;
      }
      else{
        actualHead -> next = nextHead->next;
        nextHead -> next -> prev = actualHead;
      }
      actualHead -> fille = false;
      actualHead -> size = (actualHead -> size) + (nextHead -> size) + METADATA_T_ALIGNED;
      //free(nextHead);
    }

    //Case 4: Previous block and next block free
    else if((actualHead->prev->fille == false)&&((actualHead->next->fille==false))){
      metadata_t* prevHead = actualHead -> prev;
      metadata_t* nextHead = actualHead->next;
      if(nextHead -> next == NULL){
        prevHead->next = NULL;
      }
      else{
        prevHead->next = nextHead -> next;
        nextHead -> next -> prev = prevHead;
      }
      prevHead-> fille = false;
      prevHead-> size = (prevHead -> size) + (actualHead -> size) + (nextHead -> size) + 2*METADATA_T_ALIGNED;
      //free(actualHead);
      //free(nextHead);
    }
  }
  //If this is the very start of the list
  else if((actualHead->prev == NULL)&&((actualHead->next != NULL))){
    if(actualHead->next->fille == false){
      metadata_t* nextHead = actualHead->next;
      if(nextHead->next == NULL){
        actualHead -> next = NULL;
      }
      else{
        actualHead->next = nextHead->next;
        nextHead->next->prev = actualHead;
      }
      actualHead -> fille = false;
      actualHead -> size = (actualHead->size)+(nextHead->size)+METADATA_T_ALIGNED;
    }
  }
  //If this is the very end of the list
  else if((actualHead->prev != NULL)&&((actualHead->next == NULL))){
    if(actualHead->prev->fille == false){
      metadata_t* prevHead = actualHead->prev;
      prevHead -> next = NULL;
      prevHead -> fille = false;
      prevHead -> size = (actualHead->size)+(prevHead->size)+METADATA_T_ALIGNED;
    }
  }
  /*
  //Case 1: Previous block allocated, next block allocated
  if((actualHead->prev->fille == true)&&((actualHead->next->fille==true))){

  }
  //Case 2: Previous block free, next block allocated
  
  */
  //case 2: previous block free, next block allocated
  /* 
  if((current->prev == NULL)&&(current->next != NULL)){
    assuming current is pointer to current block -> so pointing to address
  }
*/

  /*
  if(newBlock->next != NULL){
    newBlock->next->prev = newBlock;
  }
  */
 /*
 metadata_t* actualHead = (metadata_t*)(((void*)(ptr))-METADATA_T_ALIGNED);
 metadata_t* nextHead = actualHead + actualHead->size + METADATA_T_ALIGNED;
 //metadata_t* prevHead = nextHead->prev;


 if(nextHead -> prev != NULL){
   actualHead->prev = nextHead->prev;
   actualHead-> next = nextHead;
  
 }
 */
 
}

/*
 * Allocate heap_region slab with a suitable syscall.
 */
bool dmalloc_init() {

  size_t max_bytes = ALIGN(MAX_HEAP_SIZE);

  /*
   * Get a slab with mmap, and put it on the freelist as one large block, starting
   * with an empty header.
   */
  freelist = (metadata_t*)
     mmap(NULL, max_bytes, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

  if (freelist == (void *)-1) {
    perror("dmalloc_init: mmap failed");
    return false;
  }
  freelist->next = NULL;
  freelist->prev = NULL;
  freelist->size = max_bytes-METADATA_T_ALIGNED;
  freelist->fille = false;
  return true;
}


/* for debugging; can be turned off through -NDEBUG flag*/
/*

This code is here for reference.  It may be useful.
Warning: the NDEBUG flag also turns off assert protection.

*/
void print_freelist(); 

#ifdef NDEBUG
	#define DEBUG(M, ...)
	#define PRINT_FREELIST print_freelist
#else
	#define DEBUG(M, ...) fprintf(stderr, "[DEBUG] %s:%d: " M "\n", __FILE__, __LINE__, ##__VA_ARGS__)
	#define PRINT_FREELIST
#endif


void print_freelist() {
  metadata_t *freelist_head = freelist;
  while(freelist_head != NULL) {
    DEBUG("\tFreelist Size:%zd, Head:%p, Prev:%p, Next:%p, Status:%d",
	  freelist_head->size,
	  freelist_head,
	  freelist_head->prev,
	  freelist_head->next,
    freelist_head->fille);
    freelist_head = freelist_head->next;
  }
  DEBUG("\n");
}

