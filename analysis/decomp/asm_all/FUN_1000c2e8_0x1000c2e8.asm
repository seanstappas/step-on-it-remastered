; FUN_1000c2e8 @ 0x1000c2e8
1000c2e8  7c0802a6    mfspr r0,LR                 
1000c2ec  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000c2f0  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000c2f4  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000c2f8  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1000c2fc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000c300  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000c304  7c7e1b78    or r30,r3,r3                
1000c308  7fc40734    extsh r4,r30                
1000c30c  1c840046    mulli r4,r4,0x46            
1000c310  38623cd8    addi r3,r2,0x3cd8           
1000c314  7fe32214    add r31,r3,r4               
1000c318  88bf001f    lbz r5,0x1f(r31)            
1000c31c  28050000    cmplwi r5,0x0               
1000c320  418200a4    beq 0x1000c3c4                 ; -> 1000c3c4
1000c324  38c00000    li r6,0x0                   
1000c328  3980040d    li r12,0x40d                
1000c32c  98df001f    stb r6,0x1f(r31)            
1000c330  38e00002    li r7,0x2                   
1000c334  b0ff0024    sth r7,0x24(r31)            
1000c338  39000001    li r8,0x1                   
1000c33c  392261a4    addi r9,r2,0x61a4           
1000c340  b11f0026    sth r8,0x26(r31)            
1000c344  81290034    lwz r9,0x34(r9)             
1000c348  39400000    li r10,0x0                  
1000c34c  913f000a    stw r9,0xa(r31)             
1000c350  915f0014    stw r10,0x14(r31)           
1000c354  39600001    li r11,0x1                  
1000c358  b17f000e    sth r11,0xe(r31)            
1000c35c  a87f0012    lha r3,0x12(r31)            
1000c360  7d9d6378    or r29,r12,r12              
1000c364  48022395    bl 0x1002e6f8                  ; -> 1002e6f8
1000c368  60000000    ori r0,r0,0x0               
1000c36c  7c630734    extsh r3,r3                 
1000c370  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1000c374  7c7c1b78    or r28,r3,r3                
1000c378  a87f0010    lha r3,0x10(r31)            
1000c37c  48022351    bl 0x1002e6cc                  ; -> 1002e6cc
1000c380  60000000    ori r0,r0,0x0               
1000c384  7c630734    extsh r3,r3                 
1000c388  1c63003c    mulli r3,r3,0x3c            
1000c38c  38826bf8    addi r4,r2,0x6bf8           
1000c390  7c63e214    add r3,r3,r28               
1000c394  7fa4192e    stwx r29,r4,r3              
1000c398  a8bf0012    lha r5,0x12(r31)            
1000c39c  38e00001    li r7,0x1                   
1000c3a0  38a5ffd0    subi r5,r5,0x30             
1000c3a4  b0bf0012    sth r5,0x12(r31)            
1000c3a8  a8df0010    lha r6,0x10(r31)            
1000c3ac  390003e8    li r8,0x3e8                 
1000c3b0  38c6fff0    subi r6,r6,0x10             
1000c3b4  b0df0010    sth r6,0x10(r31)            
1000c3b8  98ff001e    stb r7,0x1e(r31)            
1000c3bc  b11f0042    sth r8,0x42(r31)            
1000c3c0  48000164    b 0x1000c524                   ; -> 1000c524
1000c3c4  a93f0024    lha r9,0x24(r31)            
1000c3c8  7d2a4b78    or r10,r9,r9                
1000c3cc  7d4a0734    extsh r10,r10               
1000c3d0  3929ffff    subi r9,r9,0x1              
1000c3d4  2c0a0000    cmpwi r10,0x0               
1000c3d8  b13f0024    sth r9,0x24(r31)            
1000c3dc  41810148    bgt 0x1000c524                 ; -> 1000c524
1000c3e0  39600001    li r11,0x1                  
1000c3e4  997f001e    stb r11,0x1e(r31)           
1000c3e8  a99f0026    lha r12,0x26(r31)           
1000c3ec  2c0c0001    cmpwi r12,0x1               
1000c3f0  40820048    bne 0x1000c438                 ; -> 1000c438
1000c3f4  3b800005    li r28,0x5                  
1000c3f8  b39f0024    sth r28,0x24(r31)           
1000c3fc  abbf000e    lha r29,0xe(r31)            
1000c400  2c1d0010    cmpwi r29,0x10              
1000c404  40810024    ble 0x1000c428                 ; -> 1000c428
1000c408  38600003    li r3,0x3                   
1000c40c  b07f0026    sth r3,0x26(r31)            
1000c410  a89f0006    lha r4,0x6(r31)             
1000c414  38a00005    li r5,0x5                   
1000c418  1c840006    mulli r4,r4,0x6             
1000c41c  7c842bd6    divw r4,r4,r5               
1000c420  b09f0028    sth r4,0x28(r31)            
1000c424  480000d0    b 0x1000c4f4                   ; -> 1000c4f4
1000c428  a8df000e    lha r6,0xe(r31)             
1000c42c  38c60001    addi r6,r6,0x1              
1000c430  b0df000e    sth r6,0xe(r31)             
1000c434  480000c0    b 0x1000c4f4                   ; -> 1000c4f4
1000c438  a8ff0026    lha r7,0x26(r31)            
1000c43c  2c070003    cmpwi r7,0x3                
1000c440  40820038    bne 0x1000c478                 ; -> 1000c478
1000c444  39000003    li r8,0x3                   
1000c448  b11f0024    sth r8,0x24(r31)            
1000c44c  39200010    li r9,0x10                  
1000c450  b13f000e    sth r9,0xe(r31)             
1000c454  a95f0028    lha r10,0x28(r31)           
1000c458  394affff    subi r10,r10,0x1            
1000c45c  b15f0028    sth r10,0x28(r31)           
1000c460  7d4a0734    extsh r10,r10               
1000c464  2c0a0000    cmpwi r10,0x0               
1000c468  4181008c    bgt 0x1000c4f4                 ; -> 1000c4f4
1000c46c  39600002    li r11,0x2                  
1000c470  b17f0026    sth r11,0x26(r31)           
1000c474  48000080    b 0x1000c4f4                   ; -> 1000c4f4
1000c478  a99f0026    lha r12,0x26(r31)           
1000c47c  2c0c0002    cmpwi r12,0x2               
1000c480  40820070    bne 0x1000c4f0                 ; -> 1000c4f0
1000c484  3b800003    li r28,0x3                  
1000c488  b39f0024    sth r28,0x24(r31)           
1000c48c  abbf000e    lha r29,0xe(r31)            
1000c490  2c1d0040    cmpwi r29,0x40              
1000c494  4081004c    ble 0x1000c4e0                 ; -> 1000c4e0
1000c498  38600003    li r3,0x3                   
1000c49c  b07f0026    sth r3,0x26(r31)            
1000c4a0  a89f0008    lha r4,0x8(r31)             
1000c4a4  38a00005    li r5,0x5                   
1000c4a8  1c840006    mulli r4,r4,0x6             
1000c4ac  7c842bd6    divw r4,r4,r5               
1000c4b0  b09f0028    sth r4,0x28(r31)            
1000c4b4  38c00010    li r6,0x10                  
1000c4b8  b0df000e    sth r6,0xe(r31)             
1000c4bc  a8ff0010    lha r7,0x10(r31)            
1000c4c0  a91f0012    lha r8,0x12(r31)            
1000c4c4  3867001e    addi r3,r7,0x1e             
1000c4c8  3888fff8    subi r4,r8,0x8              
1000c4cc  38a00001    li r5,0x1                   
1000c4d0  7fc6f378    or r6,r30,r30               
1000c4d4  480003e9    bl 0x1000c8bc                  ; -> 1000c8bc
1000c4d8  60000000    ori r0,r0,0x0               
1000c4dc  48000018    b 0x1000c4f4                   ; -> 1000c4f4
1000c4e0  a93f000e    lha r9,0xe(r31)             
1000c4e4  39290001    addi r9,r9,0x1              
1000c4e8  b13f000e    sth r9,0xe(r31)             
1000c4ec  48000008    b 0x1000c4f4                   ; -> 1000c4f4
1000c4f0  48000034    b 0x1000c524                   ; -> 1000c524
1000c4f4  a95f0010    lha r10,0x10(r31)           
1000c4f8  394a0009    addi r10,r10,0x9            
1000c4fc  b15f003a    sth r10,0x3a(r31)           
1000c500  a97f0010    lha r11,0x10(r31)           
1000c504  396b0019    addi r11,r11,0x19           
1000c508  b17f003c    sth r11,0x3c(r31)           
1000c50c  a99f0012    lha r12,0x12(r31)           
1000c510  398c0006    addi r12,r12,0x6            
1000c514  b19f0038    sth r12,0x38(r31)           
1000c518  ab9f0012    lha r28,0x12(r31)           
1000c51c  3b9c001e    addi r28,r28,0x1e           
1000c520  b39f0036    sth r28,0x36(r31)           
1000c524  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000c528  38210050    addi r1,r1,0x50             
1000c52c  7c0803a6    mtspr LR,r0                 
1000c530  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000c534  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000c538  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000c53c  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1000c540  4e800020    blr                         
