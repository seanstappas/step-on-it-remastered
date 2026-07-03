; FUN_1000b44c @ 0x1000b44c
1000b44c  7c0802a6    mfspr r0,LR                 
1000b450  bea1ffd4    stmw r21,-0x2c(r1)             ; -> Stack[-0x2c]
1000b454  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000b458  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
1000b45c  7c751b78    or r21,r3,r3                
1000b460  7c962378    or r22,r4,r4                
1000b464  b0a10092    sth r5,0x92(r1)                ; -> Stack[0x22]
1000b468  3b023be2    addi r24,r2,0x3be2          
1000b46c  3b223be6    addi r25,r2,0x3be6          
1000b470  3bc23cd8    addi r30,r2,0x3cd8          
1000b474  38600013    li r3,0x13                  
1000b478  38800004    li r4,0x4                   
1000b47c  4801fba5    bl 0x1002b020                  ; -> 1002b020
1000b480  60000000    ori r0,r0,0x0               
1000b484  a8790000    lha r3,0x0(r25)             
1000b488  2c0303e8    cmpwi r3,0x3e8              
1000b48c  40810014    ble 0x1000b4a0                 ; -> 1000b4a0
1000b490  38823be0    addi r4,r2,0x3be0           
1000b494  abb80000    lha r29,0x0(r24)            
1000b498  ab840000    lha r28,0x0(r4)             
1000b49c  48000054    b 0x1000b4f0                   ; -> 1000b4f0
1000b4a0  a8b80000    lha r5,0x0(r24)             
1000b4a4  2c0503e8    cmpwi r5,0x3e8              
1000b4a8  40810014    ble 0x1000b4bc                 ; -> 1000b4bc
1000b4ac  38c23be4    addi r6,r2,0x3be4           
1000b4b0  abb90000    lha r29,0x0(r25)            
1000b4b4  ab860000    lha r28,0x0(r6)             
1000b4b8  48000038    b 0x1000b4f0                   ; -> 1000b4f0
1000b4bc  38600064    li r3,0x64                  
1000b4c0  48000db9    bl 0x1000c278                  ; -> 1000c278
1000b4c4  60000000    ori r0,r0,0x0               
1000b4c8  7c630734    extsh r3,r3                 
1000b4cc  2c030032    cmpwi r3,0x32               
1000b4d0  40810014    ble 0x1000b4e4                 ; -> 1000b4e4
1000b4d4  38e23be4    addi r7,r2,0x3be4           
1000b4d8  abb90000    lha r29,0x0(r25)            
1000b4dc  ab870000    lha r28,0x0(r7)             
1000b4e0  48000010    b 0x1000b4f0                   ; -> 1000b4f0
1000b4e4  39023be0    addi r8,r2,0x3be0           
1000b4e8  abb80000    lha r29,0x0(r24)            
1000b4ec  ab880000    lha r28,0x0(r8)             
1000b4f0  a8610092    lha r3,0x92(r1)                ; -> Stack[0x22]
1000b4f4  4bffa5d5    bl 0x10005ac8                  ; -> 10005ac8
1000b4f8  60000000    ori r0,r0,0x0               
1000b4fc  7c7f1b78    or r31,r3,r3                
1000b500  7fe90734    extsh r9,r31                
1000b504  1d290046    mulli r9,r9,0x46            
1000b508  7fea0734    extsh r10,r31               
1000b50c  1d4a0046    mulli r10,r10,0x46          
1000b510  39290010    addi r9,r9,0x10             
1000b514  7ebe4b2e    sthx r21,r30,r9             
1000b518  394a0012    addi r10,r10,0x12           
1000b51c  7ede532e    sthx r22,r30,r10            
1000b520  38600064    li r3,0x64                  
1000b524  48000d55    bl 0x1000c278                  ; -> 1000c278
1000b528  60000000    ori r0,r0,0x0               
1000b52c  39627120    addi r11,r2,0x7120          
1000b530  7c630734    extsh r3,r3                 
1000b534  a96b0000    lha r11,0x0(r11)            
1000b538  7c035800    cmpw r3,r11                 
1000b53c  40810030    ble 0x1000b56c                 ; -> 1000b56c
1000b540  7fe30734    extsh r3,r31                
1000b544  1c630046    mulli r3,r3,0x46            
1000b548  7fe50734    extsh r5,r31                
1000b54c  1ca50046    mulli r5,r5,0x46            
1000b550  39800001    li r12,0x1                  
1000b554  38630042    addi r3,r3,0x42             
1000b558  7d9e1b2e    sthx r12,r30,r3             
1000b55c  3880001f    li r4,0x1f                  
1000b560  38a5000e    addi r5,r5,0xe              
1000b564  7c9e2b2e    sthx r4,r30,r5              
1000b568  4800002c    b 0x1000b594                   ; -> 1000b594
1000b56c  7fe70734    extsh r7,r31                
1000b570  1ce70046    mulli r7,r7,0x46            
1000b574  7fe90734    extsh r9,r31                
1000b578  1d290046    mulli r9,r9,0x46            
1000b57c  38c00002    li r6,0x2                   
1000b580  38e70042    addi r7,r7,0x42             
1000b584  7cde3b2e    sthx r6,r30,r7              
1000b588  39000001    li r8,0x1                   
1000b58c  3929000e    addi r9,r9,0xe              
1000b590  7d1e4b2e    sthx r8,r30,r9              
1000b594  7feb0734    extsh r11,r31               
1000b598  1d6b0046    mulli r11,r11,0x46          
1000b59c  7fe30734    extsh r3,r31                
1000b5a0  1c630046    mulli r3,r3,0x46            
1000b5a4  7fe50734    extsh r5,r31                
1000b5a8  1ca50046    mulli r5,r5,0x46            
1000b5ac  7fe70734    extsh r7,r31                
1000b5b0  1ce70046    mulli r7,r7,0x46            
1000b5b4  7fe90734    extsh r9,r31                
1000b5b8  1d290046    mulli r9,r9,0x46            
1000b5bc  39400072    li r10,0x72                 
1000b5c0  396b0002    addi r11,r11,0x2            
1000b5c4  7d5e5b2e    sthx r10,r30,r11            
1000b5c8  39826ba4    addi r12,r2,0x6ba4          
1000b5cc  3863000a    addi r3,r3,0xa              
1000b5d0  818c0000    lwz r12,0x0(r12)            
1000b5d4  38800000    li r4,0x0                   
1000b5d8  7d9e192e    stwx r12,r30,r3             
1000b5dc  38a50014    addi r5,r5,0x14             
1000b5e0  7eaa0734    extsh r10,r21               
1000b5e4  7fab0734    extsh r11,r29               
1000b5e8  7ecc0734    extsh r12,r22               
1000b5ec  7f830734    extsh r3,r28                
1000b5f0  7c9e292e    stwx r4,r30,r5              
1000b5f4  7f6a5850    subf r27,r10,r11            
1000b5f8  7f4c1850    subf r26,r12,r3             
1000b5fc  7c9bd9d6    mullw r4,r27,r27            
1000b600  7cbad1d6    mullw r5,r26,r26            
1000b604  38c00000    li r6,0x0                   
1000b608  38e7001e    addi r7,r7,0x1e             
1000b60c  7cde39ae    stbx r6,r30,r7              
1000b610  39000001    li r8,0x1                   
1000b614  39290024    addi r9,r9,0x24             
1000b618  7d1e4b2e    sthx r8,r30,r9              
1000b61c  7c642a14    add r3,r4,r5                
1000b620  4bff8155    bl 0x10003774                  ; -> 10003774
1000b624  60000000    ori r0,r0,0x0               
1000b628  7c771b78    or r23,r3,r3                
1000b62c  57666026    rlwinm r6,r27,0xc,0x0,0x13  
1000b630  57486026    rlwinm r8,r26,0xc,0x0,0x13  
1000b634  7fe70734    extsh r7,r31                
1000b638  1ce70046    mulli r7,r7,0x46            
1000b63c  7fe90734    extsh r9,r31                
1000b640  1d290046    mulli r9,r9,0x46            
1000b644  7cc6bbd6    divw r6,r6,r23              
1000b648  7feb0734    extsh r11,r31               
1000b64c  1d6b0046    mulli r11,r11,0x46          
1000b650  7fe30734    extsh r3,r31                
1000b654  1c630046    mulli r3,r3,0x46            
1000b658  38e70028    addi r7,r7,0x28             
1000b65c  7eaa0734    extsh r10,r21               
1000b660  7ecc0734    extsh r12,r22               
1000b664  7d08bbd6    divw r8,r8,r23              
1000b668  7cde3b2e    sthx r6,r30,r7              
1000b66c  3929002a    addi r9,r9,0x2a             
1000b670  7d1e4b2e    sthx r8,r30,r9              
1000b674  554a2834    rlwinm r10,r10,0x5,0x0,0x1a 
1000b678  396b002c    addi r11,r11,0x2c           
1000b67c  7d5e5b2e    sthx r10,r30,r11            
1000b680  558c2834    rlwinm r12,r12,0x5,0x0,0x1a 
1000b684  3863002e    addi r3,r3,0x2e             
1000b688  7d9e1b2e    sthx r12,r30,r3             
1000b68c  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
1000b690  38210070    addi r1,r1,0x70             
1000b694  7c0803a6    mtspr LR,r0                 
1000b698  baa1ffd4    lmw r21,-0x2c(r1)              ; -> Stack[-0x2c]
1000b69c  4e800020    blr                         
