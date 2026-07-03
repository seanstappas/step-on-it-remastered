; FUN_1002754c @ 0x1002754c
1002754c  7c0802a6    mfspr r0,LR                 
10027550  be81ffd0    stmw r20,-0x30(r1)             ; -> Stack[-0x30]
10027554  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10027558  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
1002755c  7c7c1b78    or r28,r3,r3                
10027560  7c9d2378    or r29,r4,r4                
10027564  7cb82b78    or r24,r5,r5                
10027568  7cd63378    or r22,r6,r6                
1002756c  7cf73b78    or r23,r7,r7                
10027570  3b226bf8    addi r25,r2,0x6bf8          
10027574  3be26200    addi r31,r2,0x6200          
10027578  3b426bea    addi r26,r2,0x6bea          
1002757c  7f83e378    or r3,r28,r28               
10027580  7fa4eb78    or r4,r29,r29               
10027584  480002b1    bl 0x10027834                  ; -> 10027834
10027588  60000000    ori r0,r0,0x0               
1002758c  7c7b1b78    or r27,r3,r3                
10027590  7f630734    extsh r3,r27                
10027594  2c03ffff    cmpwi r3,-0x1               
10027598  41820118    beq 0x100276b0                 ; -> 100276b0
1002759c  7f650734    extsh r5,r27                
100275a0  54a52036    rlwinm r5,r5,0x4,0x0,0x1b   
100275a4  7f660734    extsh r6,r27                
100275a8  54c62036    rlwinm r6,r6,0x4,0x0,0x1b   
100275ac  7f670734    extsh r7,r27                
100275b0  7f080734    extsh r8,r24                
100275b4  54e72036    rlwinm r7,r7,0x4,0x0,0x1b   
100275b8  38800000    li r4,0x0                   
100275bc  38a50004    addi r5,r5,0x4              
100275c0  7c9f2b2e    sthx r4,r31,r5              
100275c4  38c6000a    addi r6,r6,0xa              
100275c8  2c08ffff    cmpwi r8,-0x1               
100275cc  7eff312e    stwx r23,r31,r6             
100275d0  38e70006    addi r7,r7,0x6              
100275d4  7f1f3b2e    sthx r24,r31,r7             
100275d8  40820088    bne 0x10027660                 ; -> 10027660
100275dc  7f6a0734    extsh r10,r27               
100275e0  554a2036    rlwinm r10,r10,0x4,0x0,0x1b 
100275e4  39200006    li r9,0x6                   
100275e8  394a0004    addi r10,r10,0x4            
100275ec  7d3f532e    sthx r9,r31,r10             
100275f0  7fa3eb78    or r3,r29,r29               
100275f4  48007105    bl 0x1002e6f8                  ; -> 1002e6f8
100275f8  60000000    ori r0,r0,0x0               
100275fc  7c751b78    or r21,r3,r3                
10027600  7f83e378    or r3,r28,r28               
10027604  480070c9    bl 0x1002e6cc                  ; -> 1002e6cc
10027608  60000000    ori r0,r0,0x0               
1002760c  7c741b78    or r20,r3,r3                
10027610  7e83a378    or r3,r20,r20               
10027614  7ea4ab78    or r4,r21,r21               
10027618  480055f9    bl 0x1002cc10                  ; -> 1002cc10
1002761c  60000000    ori r0,r0,0x0               
10027620  7fa3eb78    or r3,r29,r29               
10027624  480070d5    bl 0x1002e6f8                  ; -> 1002e6f8
10027628  60000000    ori r0,r0,0x0               
1002762c  7c630734    extsh r3,r3                 
10027630  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10027634  7c751b78    or r21,r3,r3                
10027638  7f83e378    or r3,r28,r28               
1002763c  48007091    bl 0x1002e6cc                  ; -> 1002e6cc
10027640  60000000    ori r0,r0,0x0               
10027644  7c630734    extsh r3,r3                 
10027648  1c63003c    mulli r3,r3,0x3c            
1002764c  7c63aa14    add r3,r3,r21               
10027650  7d79182e    lwzx r11,r25,r3             
10027654  616b0200    ori r11,r11,0x200           
10027658  7d79192e    stwx r11,r25,r3             
1002765c  48000040    b 0x1002769c                   ; -> 1002769c
10027660  7fa3eb78    or r3,r29,r29               
10027664  48007095    bl 0x1002e6f8                  ; -> 1002e6f8
10027668  60000000    ori r0,r0,0x0               
1002766c  7c630734    extsh r3,r3                 
10027670  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10027674  7c751b78    or r21,r3,r3                
10027678  7f83e378    or r3,r28,r28               
1002767c  48007051    bl 0x1002e6cc                  ; -> 1002e6cc
10027680  60000000    ori r0,r0,0x0               
10027684  7c630734    extsh r3,r3                 
10027688  1c63003c    mulli r3,r3,0x3c            
1002768c  7c63aa14    add r3,r3,r21               
10027690  7d99182e    lwzx r12,r25,r3             
10027694  618c0300    ori r12,r12,0x300           
10027698  7d99192e    stwx r12,r25,r3             
1002769c  7f740734    extsh r20,r27               
100276a0  56942036    rlwinm r20,r20,0x4,0x0,0x1b 
100276a4  3a940008    addi r20,r20,0x8            
100276a8  7edfa32e    sthx r22,r31,r20            
100276ac  48000174    b 0x10027820                   ; -> 10027820
100276b0  aaba0000    lha r21,0x0(r26)            
100276b4  2c15ffff    cmpwi r21,-0x1              
100276b8  41820168    beq 0x10027820                 ; -> 10027820
100276bc  abda0000    lha r30,0x0(r26)            
100276c0  a87a0000    lha r3,0x0(r26)             
100276c4  7fc50734    extsh r5,r30                
100276c8  54632036    rlwinm r3,r3,0x4,0x0,0x1b   
100276cc  3863000e    addi r3,r3,0xe              
100276d0  7c7f1aae    lhax r3,r31,r3              
100276d4  54a52036    rlwinm r5,r5,0x4,0x0,0x1b   
100276d8  7fc70734    extsh r7,r30                
100276dc  7fc80734    extsh r8,r30                
100276e0  55082036    rlwinm r8,r8,0x4,0x0,0x1b   
100276e4  7fca0734    extsh r10,r30               
100276e8  554a2036    rlwinm r10,r10,0x4,0x0,0x1b 
100276ec  7fcb0734    extsh r11,r30               
100276f0  556b2036    rlwinm r11,r11,0x4,0x0,0x1b 
100276f4  7fcc0734    extsh r12,r30               
100276f8  7f140734    extsh r20,r24               
100276fc  558c2036    rlwinm r12,r12,0x4,0x0,0x1b 
10027700  38826be8    addi r4,r2,0x6be8           
10027704  b07a0000    sth r3,0x0(r26)             
10027708  a8840000    lha r4,0x0(r4)              
1002770c  38a5000e    addi r5,r5,0xe              
10027710  38c26be8    addi r6,r2,0x6be8           
10027714  7c9f2b2e    sthx r4,r31,r5              
10027718  b3c60000    sth r30,0x0(r6)             
1002771c  54e72036    rlwinm r7,r7,0x4,0x0,0x1b   
10027720  7f9f3b2e    sthx r28,r31,r7             
10027724  39080002    addi r8,r8,0x2              
10027728  7fbf432e    sthx r29,r31,r8             
1002772c  39200000    li r9,0x0                   
10027730  394a0004    addi r10,r10,0x4            
10027734  7d3f532e    sthx r9,r31,r10             
10027738  396b000a    addi r11,r11,0xa            
1002773c  2c14ffff    cmpwi r20,-0x1              
10027740  7eff592e    stwx r23,r31,r11            
10027744  398c0006    addi r12,r12,0x6            
10027748  7f1f632e    sthx r24,r31,r12            
1002774c  40820088    bne 0x100277d4                 ; -> 100277d4
10027750  7fc30734    extsh r3,r30                
10027754  54632036    rlwinm r3,r3,0x4,0x0,0x1b   
10027758  3aa00006    li r21,0x6                  
1002775c  38630004    addi r3,r3,0x4              
10027760  7ebf1b2e    sthx r21,r31,r3             
10027764  7fa3eb78    or r3,r29,r29               
10027768  48006f91    bl 0x1002e6f8                  ; -> 1002e6f8
1002776c  60000000    ori r0,r0,0x0               
10027770  7c751b78    or r21,r3,r3                
10027774  7f83e378    or r3,r28,r28               
10027778  48006f55    bl 0x1002e6cc                  ; -> 1002e6cc
1002777c  60000000    ori r0,r0,0x0               
10027780  7c741b78    or r20,r3,r3                
10027784  7e83a378    or r3,r20,r20               
10027788  7ea4ab78    or r4,r21,r21               
1002778c  48005485    bl 0x1002cc10                  ; -> 1002cc10
10027790  60000000    ori r0,r0,0x0               
10027794  7fa3eb78    or r3,r29,r29               
10027798  48006f61    bl 0x1002e6f8                  ; -> 1002e6f8
1002779c  60000000    ori r0,r0,0x0               
100277a0  7c630734    extsh r3,r3                 
100277a4  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100277a8  7c751b78    or r21,r3,r3                
100277ac  7f83e378    or r3,r28,r28               
100277b0  48006f1d    bl 0x1002e6cc                  ; -> 1002e6cc
100277b4  60000000    ori r0,r0,0x0               
100277b8  7c630734    extsh r3,r3                 
100277bc  1c63003c    mulli r3,r3,0x3c            
100277c0  7c63aa14    add r3,r3,r21               
100277c4  7c99182e    lwzx r4,r25,r3              
100277c8  60840200    ori r4,r4,0x200             
100277cc  7c99192e    stwx r4,r25,r3              
100277d0  48000040    b 0x10027810                   ; -> 10027810
100277d4  7fa3eb78    or r3,r29,r29               
100277d8  48006f21    bl 0x1002e6f8                  ; -> 1002e6f8
100277dc  60000000    ori r0,r0,0x0               
100277e0  7c630734    extsh r3,r3                 
100277e4  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100277e8  7c751b78    or r21,r3,r3                
100277ec  7f83e378    or r3,r28,r28               
100277f0  48006edd    bl 0x1002e6cc                  ; -> 1002e6cc
100277f4  60000000    ori r0,r0,0x0               
100277f8  7c630734    extsh r3,r3                 
100277fc  1c63003c    mulli r3,r3,0x3c            
10027800  7c63aa14    add r3,r3,r21               
10027804  7cb9182e    lwzx r5,r25,r3              
10027808  60a50300    ori r5,r5,0x300             
1002780c  7cb9192e    stwx r5,r25,r3              
10027810  7fc60734    extsh r6,r30                
10027814  54c62036    rlwinm r6,r6,0x4,0x0,0x1b   
10027818  38c60008    addi r6,r6,0x8              
1002781c  7edf332e    sthx r22,r31,r6             
10027820  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
10027824  38210070    addi r1,r1,0x70             
10027828  7c0803a6    mtspr LR,r0                 
1002782c  ba81ffd0    lmw r20,-0x30(r1)              ; -> Stack[-0x30]
10027830  4e800020    blr                         
