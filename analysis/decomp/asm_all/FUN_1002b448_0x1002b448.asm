; FUN_1002b448 @ 0x1002b448
1002b448  7c0802a6    mfspr r0,LR                 
1002b44c  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
1002b450  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002b454  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1002b458  7c791b78    or r25,r3,r3                
1002b45c  7f240734    extsh r4,r25                
1002b460  38627122    addi r3,r2,0x7122           
1002b464  2c04ff9c    cmpwi r4,-0x64              
1002b468  3b62711c    addi r27,r2,0x711c          
1002b46c  3b82711e    addi r28,r2,0x711e          
1002b470  3b427120    addi r26,r2,0x7120          
1002b474  3be27134    addi r31,r2,0x7134          
1002b478  3bc26840    addi r30,r2,0x6840          
1002b47c  b3230000    sth r25,0x0(r3)             
1002b480  40820040    bne 0x1002b4c0                 ; -> 1002b4c0
1002b484  38a251f0    addi r5,r2,0x51f0           
1002b488  a8650000    lha r3,0x0(r5)              
1002b48c  480061fd    bl 0x10031688                  ; -> 10031688
1002b490  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002b494  3c60424f    lis r3,0x424f               
1002b498  38635244    addi r3,r3,0x5244           
1002b49c  38990190    addi r4,r25,0x190           
1002b4a0  48006231    bl 0x100316d0                  ; -> 100316d0
1002b4a4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002b4a8  38c26b9c    addi r6,r2,0x6b9c           
1002b4ac  7c7d1b78    or r29,r3,r3                
1002b4b0  a8660000    lha r3,0x0(r6)              
1002b4b4  480061d5    bl 0x10031688                  ; -> 10031688
1002b4b8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002b4bc  48000058    b 0x1002b514                   ; -> 1002b514
1002b4c0  38e26b9c    addi r7,r2,0x6b9c           
1002b4c4  a8670000    lha r3,0x0(r7)              
1002b4c8  480061c1    bl 0x10031688                  ; -> 10031688
1002b4cc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002b4d0  390269fc    addi r8,r2,0x69fc           
1002b4d4  89080000    lbz r8,0x0(r8)              
1002b4d8  28080000    cmplwi r8,0x0               
1002b4dc  41820020    beq 0x1002b4fc                 ; -> 1002b4fc
1002b4e0  3c60424f    lis r3,0x424f               
1002b4e4  38635244    addi r3,r3,0x5244           
1002b4e8  389903e8    addi r4,r25,0x3e8           
1002b4ec  480061e5    bl 0x100316d0                  ; -> 100316d0
1002b4f0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002b4f4  7c7d1b78    or r29,r3,r3                
1002b4f8  4800001c    b 0x1002b514                   ; -> 1002b514
1002b4fc  3c60424f    lis r3,0x424f               
1002b500  38635244    addi r3,r3,0x5244           
1002b504  38990190    addi r4,r25,0x190           
1002b508  480061c9    bl 0x100316d0                  ; -> 100316d0
1002b50c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002b510  7c7d1b78    or r29,r3,r3                
1002b514  281d0000    cmplwi r29,0x0              
1002b518  40820010    bne 0x1002b528                 ; -> 1002b528
1002b51c  38600005    li r3,0x5                   
1002b520  4bfeddd9    bl 0x100192f8                  ; -> 100192f8
1002b524  60000000    ori r0,r0,0x0               
1002b528  7fa3eb78    or r3,r29,r29               
1002b52c  4800627d    bl 0x100317a8                  ; -> 100317a8
1002b530  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002b534  7fa3eb78    or r3,r29,r29               
1002b538  48005ac1    bl 0x10030ff8                  ; -> 10030ff8
1002b53c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002b540  7fa3eb78    or r3,r29,r29               
1002b544  7fe4fb78    or r4,r31,r31               
1002b548  4bfeee01    bl 0x1001a348                  ; -> 1001a348
1002b54c  60000000    ori r0,r0,0x0               
1002b550  392261f0    addi r9,r2,0x61f0           
1002b554  394261f4    addi r10,r2,0x61f4          
1002b558  81290000    lwz r9,0x0(r9)              
1002b55c  81290000    lwz r9,0x0(r9)              
1002b560  912a0000    stw r9,0x0(r10)             
1002b564  a97f0002    lha r11,0x2(r31)            
1002b568  b17e00a6    sth r11,0xa6(r30)           
1002b56c  a99f0004    lha r12,0x4(r31)            
1002b570  b19e0116    sth r12,0x116(r30)          
1002b574  a89f0006    lha r4,0x6(r31)             
1002b578  38640001    addi r3,r4,0x1              
1002b57c  48003131    bl 0x1002e6ac                  ; -> 1002e6ac
1002b580  60000000    ori r0,r0,0x0               
1002b584  b07e0070    sth r3,0x70(r30)            
1002b588  a8bf0008    lha r5,0x8(r31)             
1002b58c  38650001    addi r3,r5,0x1              
1002b590  4800312d    bl 0x1002e6bc                  ; -> 1002e6bc
1002b594  60000000    ori r0,r0,0x0               
1002b598  38630001    addi r3,r3,0x1              
1002b59c  b07e0074    sth r3,0x74(r30)            
1002b5a0  a8df000a    lha r6,0xa(r31)             
1002b5a4  38660001    addi r3,r6,0x1              
1002b5a8  48003105    bl 0x1002e6ac                  ; -> 1002e6ac
1002b5ac  60000000    ori r0,r0,0x0               
1002b5b0  b07e00e0    sth r3,0xe0(r30)            
1002b5b4  a8ff000c    lha r7,0xc(r31)             
1002b5b8  38670001    addi r3,r7,0x1              
1002b5bc  48003101    bl 0x1002e6bc                  ; -> 1002e6bc
1002b5c0  60000000    ori r0,r0,0x0               
1002b5c4  38630001    addi r3,r3,0x1              
1002b5c8  b07e00e4    sth r3,0xe4(r30)            
1002b5cc  a91f000e    lha r8,0xe(r31)             
1002b5d0  b11e00b0    sth r8,0xb0(r30)            
1002b5d4  a93f000e    lha r9,0xe(r31)             
1002b5d8  b13e0120    sth r9,0x120(r30)           
1002b5dc  a95f0016    lha r10,0x16(r31)           
1002b5e0  2c0a3a20    cmpwi r10,0x3a20            
1002b5e4  4082000c    bne 0x1002b5f0                 ; -> 1002b5f0
1002b5e8  39601388    li r11,0x1388               
1002b5ec  b17f0016    sth r11,0x16(r31)           
1002b5f0  a99f0016    lha r12,0x16(r31)           
1002b5f4  b19e00b2    sth r12,0xb2(r30)           
1002b5f8  a87f0016    lha r3,0x16(r31)            
1002b5fc  2c030000    cmpwi r3,0x0                
1002b600  4181000c    bgt 0x1002b60c                 ; -> 1002b60c
1002b604  38801388    li r4,0x1388                
1002b608  b09e00b2    sth r4,0xb2(r30)            
1002b60c  a8bf0016    lha r5,0x16(r31)            
1002b610  b0be0122    sth r5,0x122(r30)           
1002b614  a8df0016    lha r6,0x16(r31)            
1002b618  2c060000    cmpwi r6,0x0                
1002b61c  4181000c    bgt 0x1002b628                 ; -> 1002b628
1002b620  38e01388    li r7,0x1388                
1002b624  b0fe0122    sth r7,0x122(r30)           
1002b628  a91f0010    lha r8,0x10(r31)            
1002b62c  b11a0000    sth r8,0x0(r26)             
1002b630  a93f0012    lha r9,0x12(r31)            
1002b634  b13c0000    sth r9,0x0(r28)             
1002b638  a95f0014    lha r10,0x14(r31)           
1002b63c  b15b0000    sth r10,0x0(r27)            
1002b640  a97a0000    lha r11,0x0(r26)            
1002b644  2c0b0064    cmpwi r11,0x64              
1002b648  4081000c    ble 0x1002b654                 ; -> 1002b654
1002b64c  39800000    li r12,0x0                  
1002b650  b19a0000    sth r12,0x0(r26)            
1002b654  a87a0000    lha r3,0x0(r26)             
1002b658  2c030000    cmpwi r3,0x0                
1002b65c  4080000c    bge 0x1002b668                 ; -> 1002b668
1002b660  38800000    li r4,0x0                   
1002b664  b09a0000    sth r4,0x0(r26)             
1002b668  a8bc0000    lha r5,0x0(r28)             
1002b66c  2c050014    cmpwi r5,0x14               
1002b670  4081000c    ble 0x1002b67c                 ; -> 1002b67c
1002b674  38c00000    li r6,0x0                   
1002b678  b0dc0000    sth r6,0x0(r28)             
1002b67c  a8fc0000    lha r7,0x0(r28)             
1002b680  2c070000    cmpwi r7,0x0                
1002b684  4080000c    bge 0x1002b690                 ; -> 1002b690
1002b688  39000000    li r8,0x0                   
1002b68c  b11c0000    sth r8,0x0(r28)             
1002b690  a93b0000    lha r9,0x0(r27)             
1002b694  2c090064    cmpwi r9,0x64               
1002b698  4081000c    ble 0x1002b6a4                 ; -> 1002b6a4
1002b69c  39400000    li r10,0x0                  
1002b6a0  b15b0000    sth r10,0x0(r27)            
1002b6a4  a97b0000    lha r11,0x0(r27)            
1002b6a8  2c0b0000    cmpwi r11,0x0               
1002b6ac  4080000c    bge 0x1002b6b8                 ; -> 1002b6b8
1002b6b0  39800000    li r12,0x0                  
1002b6b4  b19b0000    sth r12,0x0(r27)            
1002b6b8  a87c0000    lha r3,0x0(r28)             
1002b6bc  2c030000    cmpwi r3,0x0                
1002b6c0  4082000c    bne 0x1002b6cc                 ; -> 1002b6cc
1002b6c4  38800000    li r4,0x0                   
1002b6c8  b09b0000    sth r4,0x0(r27)             
1002b6cc  a8bb0000    lha r5,0x0(r27)             
1002b6d0  2c050000    cmpwi r5,0x0                
1002b6d4  4082000c    bne 0x1002b6e0                 ; -> 1002b6e0
1002b6d8  38c00000    li r6,0x0                   
1002b6dc  b0dc0000    sth r6,0x0(r28)             
1002b6e0  48000029    bl 0x1002b708                  ; -> 1002b708
1002b6e4  60000000    ori r0,r0,0x0               
1002b6e8  7fa3eb78    or r3,r29,r29               
1002b6ec  48005925    bl 0x10031010                  ; -> 10031010
1002b6f0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002b6f4  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1002b6f8  38210060    addi r1,r1,0x60             
1002b6fc  7c0803a6    mtspr LR,r0                 
1002b700  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
1002b704  4e800020    blr                         
