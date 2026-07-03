; FUN_10027d84 @ 0x10027d84
10027d84  7c0802a6    mfspr r0,LR                 
10027d88  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
10027d8c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10027d90  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10027d94  7c7b1b78    or r27,r3,r3                
10027d98  7c9c2378    or r28,r4,r4                
10027d9c  7f630734    extsh r3,r27                
10027da0  7f840734    extsh r4,r28                
10027da4  1c63003c    mulli r3,r3,0x3c            
10027da8  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10027dac  3b226bf8    addi r25,r2,0x6bf8          
10027db0  7c632214    add r3,r3,r4                
10027db4  7c79182e    lwzx r3,r25,r3              
10027db8  3b426bc0    addi r26,r2,0x6bc0          
10027dbc  546305ee    rlwinm r3,r3,0x0,0x17,0x17  
10027dc0  2c030000    cmpwi r3,0x0                
10027dc4  408200f4    bne 0x10027eb8                 ; -> 10027eb8
10027dc8  7f650734    extsh r5,r27                
10027dcc  7f860734    extsh r6,r28                
10027dd0  1ca5003c    mulli r5,r5,0x3c            
10027dd4  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
10027dd8  7ca53214    add r5,r5,r6                
10027ddc  7cb9282e    lwzx r5,r25,r5              
10027de0  54a5063e    rlwinm r5,r5,0x0,0x18,0x1f  
10027de4  2c050000    cmpwi r5,0x0                
10027de8  418200d0    beq 0x10027eb8                 ; -> 10027eb8
10027dec  7f63db78    or r3,r27,r27               
10027df0  480068bd    bl 0x1002e6ac                  ; -> 1002e6ac
10027df4  60000000    ori r0,r0,0x0               
10027df8  7c7e1b78    or r30,r3,r3                
10027dfc  7f83e378    or r3,r28,r28               
10027e00  480068bd    bl 0x1002e6bc                  ; -> 1002e6bc
10027e04  60000000    ori r0,r0,0x0               
10027e08  7f670734    extsh r7,r27                
10027e0c  7f880734    extsh r8,r28                
10027e10  7c7d1b78    or r29,r3,r3                
10027e14  1ce7003c    mulli r7,r7,0x3c            
10027e18  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
10027e1c  7ce74214    add r7,r7,r8                
10027e20  7cf9382e    lwzx r7,r25,r7              
10027e24  7f63db78    or r3,r27,r27               
10027e28  54ff063e    rlwinm r31,r7,0x0,0x18,0x1f 
10027e2c  7f84e378    or r4,r28,r28               
10027e30  48004de1    bl 0x1002cc10                  ; -> 1002cc10
10027e34  60000000    ori r0,r0,0x0               
10027e38  807a0000    lwz r3,0x0(r26)             
10027e3c  389f0002    addi r4,r31,0x2             
10027e40  7fc5f378    or r5,r30,r30               
10027e44  7fa6eb78    or r6,r29,r29               
10027e48  38e00028    li r7,0x28                  
10027e4c  3900ffd8    li r8,-0x28                 
10027e50  39200000    li r9,0x0                   
10027e54  4bfffa69    bl 0x100278bc                  ; -> 100278bc
10027e58  807a0000    lwz r3,0x0(r26)             
10027e5c  389f0003    addi r4,r31,0x3             
10027e60  38be0010    addi r5,r30,0x10            
10027e64  7fa6eb78    or r6,r29,r29               
10027e68  38e00035    li r7,0x35                  
10027e6c  3900ffec    li r8,-0x14                 
10027e70  39200000    li r9,0x0                   
10027e74  4bfffa49    bl 0x100278bc                  ; -> 100278bc
10027e78  807a0000    lwz r3,0x0(r26)             
10027e7c  389f0004    addi r4,r31,0x4             
10027e80  38be0010    addi r5,r30,0x10            
10027e84  38dd0010    addi r6,r29,0x10            
10027e88  38e00035    li r7,0x35                  
10027e8c  39000014    li r8,0x14                  
10027e90  39200000    li r9,0x0                   
10027e94  4bfffa29    bl 0x100278bc                  ; -> 100278bc
10027e98  807a0000    lwz r3,0x0(r26)             
10027e9c  389f0005    addi r4,r31,0x5             
10027ea0  7fc5f378    or r5,r30,r30               
10027ea4  38dd0010    addi r6,r29,0x10            
10027ea8  38e00028    li r7,0x28                  
10027eac  39000028    li r8,0x28                  
10027eb0  39200000    li r9,0x0                   
10027eb4  4bfffa09    bl 0x100278bc                  ; -> 100278bc
10027eb8  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10027ebc  38210060    addi r1,r1,0x60             
10027ec0  7c0803a6    mtspr LR,r0                 
10027ec4  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
10027ec8  4e800020    blr                         
