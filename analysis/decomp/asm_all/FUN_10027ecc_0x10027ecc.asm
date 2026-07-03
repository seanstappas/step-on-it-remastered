; FUN_10027ecc @ 0x10027ecc
10027ecc  7c0802a6    mfspr r0,LR                 
10027ed0  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
10027ed4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10027ed8  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10027edc  7c7b1b78    or r27,r3,r3                
10027ee0  7c9c2378    or r28,r4,r4                
10027ee4  7f630734    extsh r3,r27                
10027ee8  7f840734    extsh r4,r28                
10027eec  1c63003c    mulli r3,r3,0x3c            
10027ef0  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10027ef4  3b226bf8    addi r25,r2,0x6bf8          
10027ef8  7c632214    add r3,r3,r4                
10027efc  7c79182e    lwzx r3,r25,r3              
10027f00  3b426bc0    addi r26,r2,0x6bc0          
10027f04  546305ee    rlwinm r3,r3,0x0,0x17,0x17  
10027f08  2c030000    cmpwi r3,0x0                
10027f0c  408200f4    bne 0x10028000                 ; -> 10028000
10027f10  7f650734    extsh r5,r27                
10027f14  7f860734    extsh r6,r28                
10027f18  1ca5003c    mulli r5,r5,0x3c            
10027f1c  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
10027f20  7ca53214    add r5,r5,r6                
10027f24  7cb9282e    lwzx r5,r25,r5              
10027f28  54a5063e    rlwinm r5,r5,0x0,0x18,0x1f  
10027f2c  2c050000    cmpwi r5,0x0                
10027f30  418200d0    beq 0x10028000                 ; -> 10028000
10027f34  7f63db78    or r3,r27,r27               
10027f38  48006775    bl 0x1002e6ac                  ; -> 1002e6ac
10027f3c  60000000    ori r0,r0,0x0               
10027f40  7c7e1b78    or r30,r3,r3                
10027f44  7f83e378    or r3,r28,r28               
10027f48  48006775    bl 0x1002e6bc                  ; -> 1002e6bc
10027f4c  60000000    ori r0,r0,0x0               
10027f50  7f670734    extsh r7,r27                
10027f54  7f880734    extsh r8,r28                
10027f58  7c7d1b78    or r29,r3,r3                
10027f5c  1ce7003c    mulli r7,r7,0x3c            
10027f60  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
10027f64  7ce74214    add r7,r7,r8                
10027f68  7cf9382e    lwzx r7,r25,r7              
10027f6c  7f63db78    or r3,r27,r27               
10027f70  54ff063e    rlwinm r31,r7,0x0,0x18,0x1f 
10027f74  7f84e378    or r4,r28,r28               
10027f78  48004c99    bl 0x1002cc10                  ; -> 1002cc10
10027f7c  60000000    ori r0,r0,0x0               
10027f80  807a0000    lwz r3,0x0(r26)             
10027f84  389f0002    addi r4,r31,0x2             
10027f88  7fc5f378    or r5,r30,r30               
10027f8c  7fa6eb78    or r6,r29,r29               
10027f90  38e0ffcb    li r7,-0x35                 
10027f94  3900ffec    li r8,-0x14                 
10027f98  39200000    li r9,0x0                   
10027f9c  4bfff921    bl 0x100278bc                  ; -> 100278bc
10027fa0  807a0000    lwz r3,0x0(r26)             
10027fa4  389f0003    addi r4,r31,0x3             
10027fa8  7fc5f378    or r5,r30,r30               
10027fac  7fa6eb78    or r6,r29,r29               
10027fb0  38e0ffd8    li r7,-0x28                 
10027fb4  3900ffd8    li r8,-0x28                 
10027fb8  39200000    li r9,0x0                   
10027fbc  4bfff901    bl 0x100278bc                  ; -> 100278bc
10027fc0  807a0000    lwz r3,0x0(r26)             
10027fc4  389f0004    addi r4,r31,0x4             
10027fc8  38be0010    addi r5,r30,0x10            
10027fcc  38dd0010    addi r6,r29,0x10            
10027fd0  38e0ffd8    li r7,-0x28                 
10027fd4  39000028    li r8,0x28                  
10027fd8  39200000    li r9,0x0                   
10027fdc  4bfff8e1    bl 0x100278bc                  ; -> 100278bc
10027fe0  807a0000    lwz r3,0x0(r26)             
10027fe4  389f0005    addi r4,r31,0x5             
10027fe8  7fc5f378    or r5,r30,r30               
10027fec  38dd0010    addi r6,r29,0x10            
10027ff0  38e0ffcb    li r7,-0x35                 
10027ff4  39000014    li r8,0x14                  
10027ff8  39200000    li r9,0x0                   
10027ffc  4bfff8c1    bl 0x100278bc                  ; -> 100278bc
10028000  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10028004  38210060    addi r1,r1,0x60             
10028008  7c0803a6    mtspr LR,r0                 
1002800c  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
10028010  4e800020    blr                         
