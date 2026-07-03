; FUN_10012228 @ 0x10012228
10012228  7c0802a6    mfspr r0,LR                 
1001222c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10012230  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10012234  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10012238  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001223c  7c7f1b78    or r31,r3,r3                
10012240  7fe30734    extsh r3,r31                
10012244  1c630070    mulli r3,r3,0x70            
10012248  3bc26840    addi r30,r2,0x6840          
1001224c  38630028    addi r3,r3,0x28             
10012250  7c7e18ae    lbzx r3,r30,r3              
10012254  28030000    cmplwi r3,0x0               
10012258  408200d8    bne 0x10012330                 ; -> 10012330
1001225c  7fe3fb78    or r3,r31,r31               
10012260  480067b9    bl 0x10018a18                  ; -> 10018a18
10012264  60000000    ori r0,r0,0x0               
10012268  38600021    li r3,0x21                  
1001226c  38800064    li r4,0x64                  
10012270  48018db1    bl 0x1002b020                  ; -> 1002b020
10012274  60000000    ori r0,r0,0x0               
10012278  7fe50734    extsh r5,r31                
1001227c  1ca50070    mulli r5,r5,0x70            
10012280  7fe70734    extsh r7,r31                
10012284  1ce70070    mulli r7,r7,0x70            
10012288  7fe80734    extsh r8,r31                
1001228c  1d080070    mulli r8,r8,0x70            
10012290  7fe90734    extsh r9,r31                
10012294  1d290070    mulli r9,r9,0x70            
10012298  7feb0734    extsh r11,r31               
1001229c  1d6b0070    mulli r11,r11,0x70          
100122a0  7fe30734    extsh r3,r31                
100122a4  1c630070    mulli r3,r3,0x70            
100122a8  38800001    li r4,0x1                   
100122ac  38a50028    addi r5,r5,0x28             
100122b0  7c9e29ae    stbx r4,r30,r5              
100122b4  7fe50734    extsh r5,r31                
100122b8  38c00000    li r6,0x0                   
100122bc  38e70032    addi r7,r7,0x32             
100122c0  7cde3b2e    sthx r6,r30,r7              
100122c4  39080004    addi r8,r8,0x4              
100122c8  7d1e42ae    lhax r8,r30,r8              
100122cc  7fe60734    extsh r6,r31                
100122d0  1cc60070    mulli r6,r6,0x70            
100122d4  7fe70734    extsh r7,r31                
100122d8  3908fffd    subi r8,r8,0x3              
100122dc  39290034    addi r9,r9,0x34             
100122e0  7d1e4b2e    sthx r8,r30,r9              
100122e4  7fe80734    extsh r8,r31                
100122e8  1d080070    mulli r8,r8,0x70            
100122ec  39400075    li r10,0x75                 
100122f0  396b000e    addi r11,r11,0xe            
100122f4  7d5e5b2e    sthx r10,r30,r11            
100122f8  3980ffff    li r12,-0x1                 
100122fc  3863002e    addi r3,r3,0x2e             
10012300  38826bc4    addi r4,r2,0x6bc4           
10012304  1ce70070    mulli r7,r7,0x70            
10012308  7d9e1b2e    sthx r12,r30,r3             
1001230c  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
10012310  7c84282e    lwzx r4,r4,r5               
10012314  38c60006    addi r6,r6,0x6              
10012318  7c9e312e    stwx r4,r30,r6              
1001231c  7cfe3aae    lhax r7,r30,r7              
10012320  39080002    addi r8,r8,0x2              
10012324  38e7fffc    subi r7,r7,0x4              
10012328  54e7043a    rlwinm r7,r7,0x0,0x10,0x1d  
1001232c  7cfe432e    sthx r7,r30,r8              
10012330  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10012334  38210040    addi r1,r1,0x40             
10012338  7c0803a6    mtspr LR,r0                 
1001233c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10012340  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10012344  4e800020    blr                         
