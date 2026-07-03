; FUN_10027c34 @ 0x10027c34
10027c34  7c0802a6    mfspr r0,LR                 
10027c38  bee1ffdc    stmw r23,-0x24(r1)             ; -> Stack[-0x24]
10027c3c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10027c40  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10027c44  7c7b1b78    or r27,r3,r3                
10027c48  7c9c2378    or r28,r4,r4                
10027c4c  7cb82b78    or r24,r5,r5                
10027c50  7cd93378    or r25,r6,r6                
10027c54  7f630734    extsh r3,r27                
10027c58  7f840734    extsh r4,r28                
10027c5c  1c63003c    mulli r3,r3,0x3c            
10027c60  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10027c64  3ae26bf8    addi r23,r2,0x6bf8          
10027c68  7c632214    add r3,r3,r4                
10027c6c  7c77182e    lwzx r3,r23,r3              
10027c70  3b426bc0    addi r26,r2,0x6bc0          
10027c74  546305ee    rlwinm r3,r3,0x0,0x17,0x17  
10027c78  2c030000    cmpwi r3,0x0                
10027c7c  408200f4    bne 0x10027d70                 ; -> 10027d70
10027c80  7f650734    extsh r5,r27                
10027c84  7f860734    extsh r6,r28                
10027c88  1ca5003c    mulli r5,r5,0x3c            
10027c8c  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
10027c90  7ca53214    add r5,r5,r6                
10027c94  7cb7282e    lwzx r5,r23,r5              
10027c98  54a5063e    rlwinm r5,r5,0x0,0x18,0x1f  
10027c9c  2c050000    cmpwi r5,0x0                
10027ca0  418200d0    beq 0x10027d70                 ; -> 10027d70
10027ca4  7f63db78    or r3,r27,r27               
10027ca8  48006a05    bl 0x1002e6ac                  ; -> 1002e6ac
10027cac  60000000    ori r0,r0,0x0               
10027cb0  7c7e1b78    or r30,r3,r3                
10027cb4  7f83e378    or r3,r28,r28               
10027cb8  48006a05    bl 0x1002e6bc                  ; -> 1002e6bc
10027cbc  60000000    ori r0,r0,0x0               
10027cc0  7f670734    extsh r7,r27                
10027cc4  7f880734    extsh r8,r28                
10027cc8  7c7d1b78    or r29,r3,r3                
10027ccc  1ce7003c    mulli r7,r7,0x3c            
10027cd0  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
10027cd4  7ce74214    add r7,r7,r8                
10027cd8  7cf7382e    lwzx r7,r23,r7              
10027cdc  7f63db78    or r3,r27,r27               
10027ce0  54ff063e    rlwinm r31,r7,0x0,0x18,0x1f 
10027ce4  7f84e378    or r4,r28,r28               
10027ce8  48004f29    bl 0x1002cc10                  ; -> 1002cc10
10027cec  60000000    ori r0,r0,0x0               
10027cf0  807a0000    lwz r3,0x0(r26)             
10027cf4  389f0002    addi r4,r31,0x2             
10027cf8  7fc5f378    or r5,r30,r30               
10027cfc  7fa6eb78    or r6,r29,r29               
10027d00  38f8fffd    subi r7,r24,0x3             
10027d04  3919fffd    subi r8,r25,0x3             
10027d08  39200000    li r9,0x0                   
10027d0c  4bfffbb1    bl 0x100278bc                  ; -> 100278bc
10027d10  807a0000    lwz r3,0x0(r26)             
10027d14  389f0003    addi r4,r31,0x3             
10027d18  38be0010    addi r5,r30,0x10            
10027d1c  7fa6eb78    or r6,r29,r29               
10027d20  38f80003    addi r7,r24,0x3             
10027d24  3919fffd    subi r8,r25,0x3             
10027d28  39200000    li r9,0x0                   
10027d2c  4bfffb91    bl 0x100278bc                  ; -> 100278bc
10027d30  807a0000    lwz r3,0x0(r26)             
10027d34  389f0004    addi r4,r31,0x4             
10027d38  38be0010    addi r5,r30,0x10            
10027d3c  38dd0010    addi r6,r29,0x10            
10027d40  38f80003    addi r7,r24,0x3             
10027d44  39190003    addi r8,r25,0x3             
10027d48  39200000    li r9,0x0                   
10027d4c  4bfffb71    bl 0x100278bc                  ; -> 100278bc
10027d50  807a0000    lwz r3,0x0(r26)             
10027d54  389f0005    addi r4,r31,0x5             
10027d58  7fc5f378    or r5,r30,r30               
10027d5c  38dd0010    addi r6,r29,0x10            
10027d60  38f8fffd    subi r7,r24,0x3             
10027d64  39190003    addi r8,r25,0x3             
10027d68  39200000    li r9,0x0                   
10027d6c  4bfffb51    bl 0x100278bc                  ; -> 100278bc
10027d70  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10027d74  38210060    addi r1,r1,0x60             
10027d78  7c0803a6    mtspr LR,r0                 
10027d7c  bae1ffdc    lmw r23,-0x24(r1)              ; -> Stack[-0x24]
10027d80  4e800020    blr                         
