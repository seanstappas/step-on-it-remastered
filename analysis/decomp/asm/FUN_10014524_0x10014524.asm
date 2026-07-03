; FUN_10014524 @ 0x10014524  (119 instructions)
10014524  7c0802a6    mfspr r0,LR                 
10014528  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001452c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10014530  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10014534  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10014538  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001453c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10014540  7c7f1b78    or r31,r3,r3                
10014544  7fe50734    extsh r5,r31                
10014548  1ca50070    mulli r5,r5,0x70            
1001454c  7fe60734    extsh r6,r31                
10014550  1cc60070    mulli r6,r6,0x70            
10014554  7fe40734    extsh r4,r31                
10014558  38626bc4    addi r3,r2,0x6bc4           
1001455c  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10014560  3bc26840    addi r30,r2,0x6840          
10014564  7c63202e    lwzx r3,r3,r4               
10014568  38a50006    addi r5,r5,0x6              
1001456c  7c7e292e    stwx r3,r30,r5              
10014570  38c60032    addi r6,r6,0x32             
10014574  7cfe32ae    lhax r7,r30,r6              
10014578  38e70001    addi r7,r7,0x1              
1001457c  7cfe332e    sthx r7,r30,r6              
10014580  7ce70734    extsh r7,r7                 
10014584  2c070009    cmpwi r7,0x9                
10014588  4081001c    ble 0x100145a4                 ; -> 100145a4
1001458c  7fe90734    extsh r9,r31                
10014590  1d290070    mulli r9,r9,0x70            
10014594  39000000    li r8,0x0                   
10014598  3929001c    addi r9,r9,0x1c             
1001459c  7d1e4b2e    sthx r8,r30,r9              
100145a0  48000140    b 0x100146e0                   ; -> 100146e0
100145a4  7fea0734    extsh r10,r31               
100145a8  1d4a0070    mulli r10,r10,0x70          
100145ac  394a0034    addi r10,r10,0x34           
100145b0  7d5e52ae    lhax r10,r30,r10            
100145b4  2c0a0001    cmpwi r10,0x1               
100145b8  40820098    bne 0x10014650                 ; -> 10014650
100145bc  7fec0734    extsh r12,r31               
100145c0  1d8c0070    mulli r12,r12,0x70          
100145c4  7fe30734    extsh r3,r31                
100145c8  398c0032    addi r12,r12,0x32           
100145cc  1c630070    mulli r3,r3,0x70            
100145d0  7fe40734    extsh r4,r31                
100145d4  7d9e62ae    lhax r12,r30,r12            
100145d8  1c840070    mulli r4,r4,0x70            
100145dc  396205b4    addi r11,r2,0x5b4           
100145e0  558c083c    rlwinm r12,r12,0x1,0x0,0x1e 
100145e4  7d6b62ae    lhax r11,r11,r12            
100145e8  3863000e    addi r3,r3,0xe              
100145ec  7d7e1b2e    sthx r11,r30,r3             
100145f0  38840032    addi r4,r4,0x32             
100145f4  7c9e22ae    lhax r4,r30,r4              
100145f8  2c040005    cmpwi r4,0x5                
100145fc  408200e4    bne 0x100146e0                 ; -> 100146e0
10014600  7fe50734    extsh r5,r31                
10014604  1ca50070    mulli r5,r5,0x70            
10014608  38a50004    addi r5,r5,0x4              
1001460c  7cbe2aae    lhax r5,r30,r5              
10014610  3865fffc    subi r3,r5,0x4              
10014614  4801a0e5    bl 0x1002e6f8                  ; -> 1002e6f8
10014618  60000000    ori r0,r0,0x0               
1001461c  7fe60734    extsh r6,r31                
10014620  1cc60070    mulli r6,r6,0x70            
10014624  7cde32ae    lhax r6,r30,r6              
10014628  7c7d1b78    or r29,r3,r3                
1001462c  38660012    addi r3,r6,0x12             
10014630  4801a09d    bl 0x1002e6cc                  ; -> 1002e6cc
10014634  60000000    ori r0,r0,0x0               
10014638  7c7c1b78    or r28,r3,r3                
1001463c  7f83e378    or r3,r28,r28               
10014640  7fa4eb78    or r4,r29,r29               
10014644  48018419    bl 0x1002ca5c                  ; -> 1002ca5c
10014648  60000000    ori r0,r0,0x0               
1001464c  48000094    b 0x100146e0                   ; -> 100146e0
10014650  7fe80734    extsh r8,r31                
10014654  1d080070    mulli r8,r8,0x70            
10014658  7fe90734    extsh r9,r31                
1001465c  39080032    addi r8,r8,0x32             
10014660  1d290070    mulli r9,r9,0x70            
10014664  7fea0734    extsh r10,r31               
10014668  7d1e42ae    lhax r8,r30,r8              
1001466c  1d4a0070    mulli r10,r10,0x70          
10014670  38e205c8    addi r7,r2,0x5c8            
10014674  5508083c    rlwinm r8,r8,0x1,0x0,0x1e   
10014678  7ce742ae    lhax r7,r7,r8               
1001467c  3929000e    addi r9,r9,0xe              
10014680  7cfe4b2e    sthx r7,r30,r9              
10014684  394a0032    addi r10,r10,0x32           
10014688  7d5e52ae    lhax r10,r30,r10            
1001468c  2c0a0005    cmpwi r10,0x5               
10014690  40820050    bne 0x100146e0                 ; -> 100146e0
10014694  7feb0734    extsh r11,r31               
10014698  1d6b0070    mulli r11,r11,0x70          
1001469c  396b0004    addi r11,r11,0x4            
100146a0  7d7e5aae    lhax r11,r30,r11            
100146a4  386bfffc    subi r3,r11,0x4             
100146a8  4801a051    bl 0x1002e6f8                  ; -> 1002e6f8
100146ac  60000000    ori r0,r0,0x0               
100146b0  7fec0734    extsh r12,r31               
100146b4  1d8c0070    mulli r12,r12,0x70          
100146b8  7d9e62ae    lhax r12,r30,r12            
100146bc  7c7d1b78    or r29,r3,r3                
100146c0  386c000c    addi r3,r12,0xc             
100146c4  4801a009    bl 0x1002e6cc                  ; -> 1002e6cc
100146c8  60000000    ori r0,r0,0x0               
100146cc  7c7c1b78    or r28,r3,r3                
100146d0  7f83e378    or r3,r28,r28               
100146d4  7fa4eb78    or r4,r29,r29               
100146d8  48018385    bl 0x1002ca5c                  ; -> 1002ca5c
100146dc  60000000    ori r0,r0,0x0               
100146e0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
100146e4  38210050    addi r1,r1,0x50             
100146e8  7c0803a6    mtspr LR,r0                 
100146ec  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100146f0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100146f4  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100146f8  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
100146fc  4e800020    blr                         
