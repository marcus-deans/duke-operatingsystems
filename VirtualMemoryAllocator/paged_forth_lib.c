#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdbool.h>
#include <signal.h>
#include <sys/mman.h>
#include <unistd.h>
#include "forth/forth_embed.h"
#include "paged_forth.h"

void* stackheap;
int max_pages;
int* lifearr;
bool* loadarr;
int* namearr;
int* fdarr;
int totcount = 0;

static void handler(int sig, siginfo_t *si, void *unused)
{
    totcount += 1;
    void* fault_address = si->si_addr;
    int pagenum = 0;
    int maxcount = 0;
    int locmax = 0;
    char* curstring = (char *)malloc(sizeof(char)*13);
    int pagesiz = getpagesize();
    char data = '\0';
    //printf("in handler with invalid address %p\n", fault_address);
    int distance = (void*)fault_address - (void*) STACKHEAP_MEM_START;
    if(distance < 0 || distance > NUM_PAGES*getpagesize()) {
        printf("address not within expected page!\n");
        exit(2);
    }
    pagenum = distance/pagesiz;

    for(int p = 0; p<max_pages; p++){
        lifearr[p] += 1;
    }
    if(totcount > max_pages){
        //if already at max pages, we will first write our oldest memory page onto disk, then unmmap it from meomory
        //find the oldest memory page
        for(int z= 0; z<max_pages; z++){
            if(maxcount < lifearr[z]){
                maxcount = lifearr[z];
                locmax = z;
            }
        }

        //write oldest memory page onto disk
       // sprintf(curstring, "page_%d.dat", namearr[locmax]);
        //int fd = open(curstring, O_RDWR | O_CREAT, S_IRWXU);
        //int fd = fdarr[namearr[locmax]];
        /*
        char* result = mmap((void*) STACKHEAP_MEM_START+namearr[locmax]*pagesiz,
                        pagesiz,
                        PROT_READ | PROT_WRITE | PROT_EXEC,
                        MAP_FIXED | MAP_SHARED,
                        fd, 0);
        if(result == MAP_FAILED) {
            perror("map failed");
            exit(1);
        }
        */
        //unmmap it from memory
        int munmap_result = munmap((void*) STACKHEAP_MEM_START+namearr[locmax]*pagesiz, pagesiz);
        if(munmap_result < 0) {
            perror("munmap failed");
            exit(6);
        }
        //close(fd);

        // then we will map newly required page into memory -> if page we have loaded before, load page from file instead
        if(loadarr[pagenum]==true){ //if page has been loaded before
            sprintf(curstring, "page_%d.dat", pagenum);
            int fd = open(curstring, O_RDWR | O_CREAT, S_IRWXU);
            //int curfd = fdarr[pagenum];
            char* result = mmap((void*) STACKHEAP_MEM_START+pagenum*pagesiz,
                        pagesiz,
                        PROT_READ | PROT_WRITE | PROT_EXEC,
                        MAP_FIXED | MAP_SHARED,
                        fd, 0);
            if(result == MAP_FAILED) {
                perror("map failed");
                exit(1);
            }
            //printf("existing load - ");
            loadarr[pagenum] = true;
            close(fd);
        }
        else{
            sprintf(curstring, "page_%d.dat", pagenum);
            int fld = open(curstring, O_RDWR | O_CREAT, S_IRWXU);
            lseek(fld, pagesiz - 1, SEEK_SET);
            write(fld, &data, 1);
            lseek(fld, 0, SEEK_SET);
            char* result = mmap((void*) STACKHEAP_MEM_START+pagenum*pagesiz,
                        pagesiz,
                        PROT_READ | PROT_WRITE | PROT_EXEC,
                        MAP_FIXED | MAP_SHARED,
                        fld,
                        0);
            if(result == MAP_FAILED) {
                perror("map failed");
                exit(1);
            }
            //printf("first-time load - ");
            fdarr[pagenum] = fld;
            close(fld);
            loadarr[pagenum] = true;
        }
        // update metadata in array to keep track of which pages have been in memory the longest
        lifearr[locmax] = 0; //resetting new page to having just been put in        
        page_map_callback(fault_address, pagenum, namearr[locmax]); //address, page mapped, page unampped
        namearr[locmax] = pagenum; //tell us which pages are currently saved in oldest spots
    }
    else{
        // in your code you'll have to compute a particular page start and
    // map that, but in this example we can just map the same page
    // start all the time
    //printf("mapping page starting at %d\n", STACKHEAP_MEM_START);
        sprintf(curstring, "page_%d.dat", pagenum);
        int nfd = open(curstring, O_RDWR | O_CREAT, S_IRWXU);
        lseek(nfd, pagesiz - 1, SEEK_SET);
        write(nfd, &data, 1);
        lseek(nfd, 0, SEEK_SET);
        for(int q = 0; q<max_pages; q++){
            if((namearr[q])==-1){
                namearr[q]=pagenum;
                locmax = q;
                break;
            }
        }
        char* result = mmap((void*) STACKHEAP_MEM_START+pagenum*pagesiz,
                            pagesiz,
                            PROT_READ | PROT_WRITE | PROT_EXEC,
                            MAP_FIXED | MAP_SHARED,
                            nfd,
                            0);        
        fdarr[pagenum] = nfd;
        close(nfd);
        lifearr[locmax] = 0;
        loadarr[pagenum] = true;
        //printf("basic map - ");
        if(result == MAP_FAILED) {
            perror("map failed");
            exit(1);
        }
        page_map_callback(fault_address, pagenum, NO_UNMAP);
    }
}

void initialize_forth(struct forth_data *forth, int max_pages_input) {

    max_pages = max_pages_input;
    lifearr = (int *)malloc(sizeof(int)*max_pages);
    namearr = (int *)malloc(sizeof(int)*max_pages);
    loadarr = (bool *)malloc(sizeof(bool)*NUM_PAGES);
    fdarr = (int *)malloc(sizeof(int)*NUM_PAGES);
    for(int p = 0; p<max_pages; p++){
        lifearr[p]=0;
        namearr[p]=-1;
    }
    for(int z = 0; z<NUM_PAGES; z++){
        loadarr[z]=false;
        fdarr[z] = 0;
    }
    // the return stack is a forth-specific data structure if we
    // wanted to, we could give it an expanding memory segment like we
    // do for the stack/heap but I opted to keep things simple
    //
    // note this static is really important
    static char returnstack[1024];

    // because this might be called multiple times, we unmap the
    // region
    int result = munmap((void*) STACKHEAP_MEM_START, getpagesize()*NUM_PAGES);
    if(result == -1) {
        perror("error unmapping");
        exit(1);
    }

    static char stack[SIGSTKSZ];
    
    stack_t ss = {
                  .ss_size = SIGSTKSZ,
                  .ss_sp = stack,
    };
    
    sigaltstack(&ss, NULL);

    struct sigaction sa;

    // SIGINFO tells sigaction that the handler is expecting extra parameters
    // ONSTACK tells sigaction our signal handler should use the alternate stack
    sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
    sigemptyset(&sa.sa_mask);
    sa.sa_sigaction = handler;

    //this is the more modern equalivant of signal, but with a few
    //more options
    if (sigaction(SIGSEGV, &sa, NULL) == -1) {
        perror("error installing handler");
        exit(3);
    }

    int stackheap_size = getpagesize() * NUM_PAGES;

    //stackheap = mmap((void*) STACKHEAP_MEM_START, stackheap_size, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_ANON | MAP_PRIVATE, -1, 0);
    stackheap = (void*) STACKHEAP_MEM_START;
    //totcount += 1;
    // printf("stack at %p\n", stackheap);

    initialize_forth_data(forth,
                          returnstack + sizeof(returnstack), //beginning of returnstack
                          stackheap, //begining of heap
                          stackheap + stackheap_size);

    
}
