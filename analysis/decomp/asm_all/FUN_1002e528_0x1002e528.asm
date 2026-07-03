; FUN_1002e528 @ 0x1002e528
1002e528  7c0802a6    mfspr r0,LR                 
1002e52c  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
1002e530  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002e534  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1002e538  7c7f1b78    or r31,r3,r3                
1002e53c  7c9a2378    or r26,r4,r4                
1002e540  7cbb2b78    or r27,r5,r5                
1002e544  7fe30734    extsh r3,r31                
1002e548  2c030000    cmpwi r3,0x0                
1002e54c  3bc26bb8    addi r30,r2,0x6bb8          
1002e550  40800008    bge 0x1002e558                 ; -> 1002e558
1002e554  7fff00d0    neg r31,r31                 
1002e558  7fe40734    extsh r4,r31                
1002e55c  2c0403e7    cmpwi r4,0x3e7              
1002e560  40810014    ble 0x1002e574                 ; -> 1002e574
1002e564  3ba00009    li r29,0x9                  
1002e568  3b800009    li r28,0x9                  
1002e56c  3b200009    li r25,0x9                  
1002e570  4800002c    b 0x1002e59c                   ; -> 1002e59c
1002e574  7fe50734    extsh r5,r31                
1002e578  38c00064    li r6,0x64                  
1002e57c  7fa533d6    divw r29,r5,r6              
1002e580  1cfd0064    mulli r7,r29,0x64           
1002e584  7fe7f850    subf r31,r7,r31             
1002e588  7fe80734    extsh r8,r31                
1002e58c  3920000a    li r9,0xa                   
1002e590  7f884bd6    divw r28,r8,r9              
1002e594  1d5c000a    mulli r10,r28,0xa           
1002e598  7f2af850    subf r25,r10,r31            
1002e59c  807e0000    lwz r3,0x0(r30)             
1002e5a0  3880001b    li r4,0x1b                  
1002e5a4  7f45d378    or r5,r26,r26               
1002e5a8  7f66db78    or r6,r27,r27               
1002e5ac  4bfd6609    bl 0x10004bb4                  ; -> 10004bb4
1002e5b0  60000000    ori r0,r0,0x0               
1002e5b4  807e0000    lwz r3,0x0(r30)             
1002e5b8  389d0005    addi r4,r29,0x5             
1002e5bc  38ba0030    addi r5,r26,0x30            
1002e5c0  7f66db78    or r6,r27,r27               
1002e5c4  4bfd65f1    bl 0x10004bb4                  ; -> 10004bb4
1002e5c8  60000000    ori r0,r0,0x0               
1002e5cc  807e0000    lwz r3,0x0(r30)             
1002e5d0  389c0005    addi r4,r28,0x5             
1002e5d4  38ba0038    addi r5,r26,0x38            
1002e5d8  7f66db78    or r6,r27,r27               
1002e5dc  4bfd65d9    bl 0x10004bb4                  ; -> 10004bb4
1002e5e0  60000000    ori r0,r0,0x0               
1002e5e4  807e0000    lwz r3,0x0(r30)             
1002e5e8  38990005    addi r4,r25,0x5             
1002e5ec  38ba0040    addi r5,r26,0x40            
1002e5f0  7f66db78    or r6,r27,r27               
1002e5f4  4bfd65c1    bl 0x10004bb4                  ; -> 10004bb4
1002e5f8  60000000    ori r0,r0,0x0               
1002e5fc  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1002e600  38210060    addi r1,r1,0x60             
1002e604  7c0803a6    mtspr LR,r0                 
1002e608  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
1002e60c  4e800020    blr                         
