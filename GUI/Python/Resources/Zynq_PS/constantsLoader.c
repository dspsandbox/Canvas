/*********************************************************************
 NET2FPGA constantsLoader.c

 MIT License
 Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
**********************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <unistd.h>
#include <string.h>

#define on_error(...) { fprintf(stderr, __VA_ARGS__); fflush(stderr); exit(1); }

//MEMORY ADDR
#define GPIO_ADDR_regAddr  0x41200000
#define GPIO_ADDR_regVal   0x41220000
#define GPIO_ADDR_regWrtEn 0x41210000

#define FILE_NAME_CONST_32BIT "/home/Canvas/x32Const.txt"
#define FILE_NAME_CONST_1BIT "/home/Canvas/x1Const.txt"

char *name = "/dev/mem";
int fd;

uint32_t *regAddr_;
int32_t *regVal_;
uint32_t *regWrtEn_;

uint32_t regType;
FILE * f;

int main () {
    //Memory mapping
    if((fd = open(name, O_RDWR)) < 0) {
                    printf("CANNOT OPEN MEMORY FILE\n");
                    return 0;
                }
    
    regAddr_ = mmap(NULL, sysconf(_SC_PAGESIZE), 
                PROT_READ|PROT_WRITE, MAP_SHARED, fd, GPIO_ADDR_regAddr);
                
    regVal_ = mmap(NULL, sysconf(_SC_PAGESIZE), 
                PROT_READ|PROT_WRITE, MAP_SHARED, fd, GPIO_ADDR_regVal);
                
    regWrtEn_ = mmap(NULL, sysconf(_SC_PAGESIZE), 
                PROT_READ|PROT_WRITE, MAP_SHARED, fd, GPIO_ADDR_regWrtEn);


    // 1Bit 
    regType=0; // regType=0 -> 1Bit 
    f=fopen(FILE_NAME_CONST_1BIT,"r");
    for (int i=0; i<256; i++){
        uint32_t regAddr;
        int32_t regVal;
        fscanf(f,"%d   %d\r\n",&regAddr,&regVal);
     
        regAddr=regAddr|(regType<<31);
        *regAddr_=regAddr;
        *regVal_=regVal;
        *regWrtEn_=1;
        *regWrtEn_=0;
        if (regVal!=0){
            printf("1Bit -> Addr: %d   Val: %d\r\n",regAddr,regVal);
        }
    }
    printf("1Bit -> Addr: others   Val: 0 \r\n");
    fclose(f);
    printf("------------------------------------\r\n");
    
    // 32Bit
    regType=1; // regType=1 -> 32Bit 
    f=fopen(FILE_NAME_CONST_32BIT,"r");
    for (int i=0; i<256; i++){
        uint32_t regAddr;
        int32_t regVal;
        fscanf(f,"%d   %d\r\n",&regAddr,&regVal);
     
        regAddr=regAddr|(regType<<31);
        *regAddr_=regAddr;
        *regVal_=regVal;
        *regWrtEn_=1;
        *regWrtEn_=0;
        if (regVal!=0){
            printf("32Bit -> Addr: %d   Val: %d\r\n",regAddr&(~(1<<31)),regVal);
        }
    }
    printf("32Bit -> Addr: others   Val: 0 \r\n");
    fclose(f);   
                
    return 0;
}