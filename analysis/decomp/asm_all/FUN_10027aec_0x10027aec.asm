; FUN_10027aec @ 0x10027aec
10027aec  7c0802a6    mfspr r0,LR                 
10027af0  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
10027af4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10027af8  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10027afc  7c7b1b78    or r27,r3,r3                
10027b00  7c9c2378    or r28,r4,r4                
10027b04  7f630734    extsh r3,r27                
10027b08  7f840734    extsh r4,r28                
10027b0c  1c63003c    mulli r3,r3,0x3c            
10027b10  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10027b14  3b226bf8    addi r25,r2,0x6bf8          
10027b18  7c632214    add r3,r3,r4                
10027b1c  7c79182e    lwzx r3,r25,r3              
10027b20  3b426bc0    addi r26,r2,0x6bc0          
10027b24  546305ee    rlwinm r3,r3,0x0,0x17,0x17  
10027b28  2c030000    cmpwi r3,0x0                
10027b2c  408200f4    bne 0x10027c20                 ; -> 10027c20
10027b30  7f650734    extsh r5,r27                
10027b34  7f860734    extsh r6,r28                
10027b38  1ca5003c    mulli r5,r5,0x3c            
10027b3c  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
10027b40  7ca53214    add r5,r5,r6                
10027b44  7cb9282e    lwzx r5,r25,r5              
10027b48  54a5063e    rlwinm r5,r5,0x0,0x18,0x1f  
10027b4c  2c050000    cmpwi r5,0x0                
10027b50  418200d0    beq 0x10027c20                 ; -> 10027c20
10027b54  7f63db78    or r3,r27,r27               
10027b58  48006b55    bl 0x1002e6ac                  ; -> 1002e6ac
10027b5c  60000000    ori r0,r0,0x0               
10027b60  7c7e1b78    or r30,r3,r3                
10027b64  7f83e378    or r3,r28,r28               
10027b68  48006b55    bl 0x1002e6bc                  ; -> 1002e6bc
10027b6c  60000000    ori r0,r0,0x0               
10027b70  7f670734    extsh r7,r27                
10027b74  7f880734    extsh r8,r28                
10027b78  7c7d1b78    or r29,r3,r3                
10027b7c  1ce7003c    mulli r7,r7,0x3c            
10027b80  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
10027b84  7ce74214    add r7,r7,r8                
10027b88  7cf9382e    lwzx r7,r25,r7              
10027b8c  7f63db78    or r3,r27,r27               
10027b90  54ff063e    rlwinm r31,r7,0x0,0x18,0x1f 
10027b94  7f84e378    or r4,r28,r28               
10027b98  48005079    bl 0x1002cc10                  ; -> 1002cc10
10027b9c  60000000    ori r0,r0,0x0               
10027ba0  807a0000    lwz r3,0x0(r26)             
10027ba4  389f0002    addi r4,r31,0x2             
10027ba8  7fc5f378    or r5,r30,r30               
10027bac  7fa6eb78    or r6,r29,r29               
10027bb0  38e0fff6    li r7,-0xa                  
10027bb4  3900000a    li r8,0xa                   
10027bb8  39200001    li r9,0x1                   
10027bbc  4bfffd01    bl 0x100278bc                  ; -> 100278bc
10027bc0  807a0000    lwz r3,0x0(r26)             
10027bc4  389f0003    addi r4,r31,0x3             
10027bc8  38be0010    addi r5,r30,0x10            
10027bcc  7fa6eb78    or r6,r29,r29               
10027bd0  38e0000a    li r7,0xa                   
10027bd4  3900000a    li r8,0xa                   
10027bd8  39200001    li r9,0x1                   
10027bdc  4bfffce1    bl 0x100278bc                  ; -> 100278bc
10027be0  807a0000    lwz r3,0x0(r26)             
10027be4  389f0004    addi r4,r31,0x4             
10027be8  38be0010    addi r5,r30,0x10            
10027bec  38dd0010    addi r6,r29,0x10            
10027bf0  38e0000f    li r7,0xf                   
10027bf4  3900000f    li r8,0xf                   
10027bf8  39200001    li r9,0x1                   
10027bfc  4bfffcc1    bl 0x100278bc                  ; -> 100278bc
10027c00  807a0000    lwz r3,0x0(r26)             
10027c04  389f0005    addi r4,r31,0x5             
10027c08  7fc5f378    or r5,r30,r30               
10027c0c  38dd0010    addi r6,r29,0x10            
10027c10  38e0fff1    li r7,-0xf                  
10027c14  3900000f    li r8,0xf                   
10027c18  39200001    li r9,0x1                   
10027c1c  4bfffca1    bl 0x100278bc                  ; -> 100278bc
10027c20  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10027c24  38210060    addi r1,r1,0x60             
10027c28  7c0803a6    mtspr LR,r0                 
10027c2c  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
10027c30  4e800020    blr                         
