; FUN_1001604c @ 0x1001604c
1001604c  7c0802a6    mfspr r0,LR                 
10016050  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
10016054  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10016058  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1001605c  7c7d1b78    or r29,r3,r3                
10016060  7c9b2378    or r27,r4,r4                
10016064  7cbc2b78    or r28,r5,r5                
10016068  7fa30734    extsh r3,r29                
1001606c  2c03009d    cmpwi r3,0x9d               
10016070  3bc24d58    addi r30,r2,0x4d58          
10016074  3be24d56    addi r31,r2,0x4d56          
10016078  41800010    blt 0x10016088                 ; -> 10016088
1001607c  7fa40734    extsh r4,r29                
10016080  2c0400d3    cmpwi r4,0xd3               
10016084  4081000c    ble 0x10016090                 ; -> 10016090
10016088  38600000    li r3,0x0                   
1001608c  480004a4    b 0x10016530                   ; -> 10016530
10016090  a8bf0000    lha r5,0x0(r31)             
10016094  7fa90734    extsh r9,r29                
10016098  1ca5000e    mulli r5,r5,0xe             
1001609c  7f7e2b2e    sthx r27,r30,r5             
100160a0  a8df0000    lha r6,0x0(r31)             
100160a4  3929ff63    subi r9,r9,0x9d             
100160a8  1cc6000e    mulli r6,r6,0xe             
100160ac  38c60002    addi r6,r6,0x2              
100160b0  7f9e332e    sthx r28,r30,r6             
100160b4  a91f0000    lha r8,0x0(r31)             
100160b8  28090036    cmplwi r9,0x36              
100160bc  1d08000e    mulli r8,r8,0xe             
100160c0  38e00000    li r7,0x0                   
100160c4  39080006    addi r8,r8,0x6              
100160c8  7cfe432e    sthx r7,r30,r8              
100160cc  41810334    bgt 0x10016400                 ; -> 10016400
100160d0  3942078c    addi r10,r2,0x78c           
100160d4  5529103a    rlwinm r9,r9,0x2,0x0,0x1d   
100160d8  7d4a482e    lwzx r10,r10,r9             
100160dc  7d4903a6    mtspr CTR,r10               
100160e0  4e800420    bctr                        
10016400  a97f0000    lha r11,0x0(r31)            
10016404  1d6b000e    mulli r11,r11,0xe           
10016408  396b0004    addi r11,r11,0x4            
1001640c  7d7e5aae    lhax r11,r30,r11            
10016410  2c0b0002    cmpwi r11,0x2               
10016414  40820058    bne 0x1001646c                 ; -> 1001646c
10016418  7f83e378    or r3,r28,r28               
1001641c  480182a1    bl 0x1002e6bc                  ; -> 1002e6bc
10016420  60000000    ori r0,r0,0x0               
10016424  7c7a1b78    or r26,r3,r3                
10016428  7f63db78    or r3,r27,r27               
1001642c  48018281    bl 0x1002e6ac                  ; -> 1002e6ac
10016430  60000000    ori r0,r0,0x0               
10016434  a8bf0000    lha r5,0x0(r31)             
10016438  39826ba8    addi r12,r2,0x6ba8          
1001643c  1ca5000e    mulli r5,r5,0xe             
10016440  38a50008    addi r5,r5,0x8              
10016444  7cbe2aae    lhax r5,r30,r5              
10016448  7c791b78    or r25,r3,r3                
1001644c  54a51838    rlwinm r5,r5,0x3,0x0,0x1c   
10016450  38850001    addi r4,r5,0x1              
10016454  806c0000    lwz r3,0x0(r12)             
10016458  7f25cb78    or r5,r25,r25               
1001645c  7f46d378    or r6,r26,r26               
10016460  4bfedca9    bl 0x10004108                  ; -> 10004108
10016464  60000000    ori r0,r0,0x0               
10016468  48000054    b 0x100164bc                   ; -> 100164bc
1001646c  7f83e378    or r3,r28,r28               
10016470  4801824d    bl 0x1002e6bc                  ; -> 1002e6bc
10016474  60000000    ori r0,r0,0x0               
10016478  7c7a1b78    or r26,r3,r3                
1001647c  7f63db78    or r3,r27,r27               
10016480  4801822d    bl 0x1002e6ac                  ; -> 1002e6ac
10016484  60000000    ori r0,r0,0x0               
10016488  a8ff0000    lha r7,0x0(r31)             
1001648c  7c791b78    or r25,r3,r3                
10016490  1ce7000e    mulli r7,r7,0xe             
10016494  38c26ba8    addi r6,r2,0x6ba8           
10016498  38e70008    addi r7,r7,0x8              
1001649c  7cfe3aae    lhax r7,r30,r7              
100164a0  80660000    lwz r3,0x0(r6)              
100164a4  54e71838    rlwinm r7,r7,0x3,0x0,0x1c   
100164a8  38870008    addi r4,r7,0x8              
100164ac  7f25cb78    or r5,r25,r25               
100164b0  7f46d378    or r6,r26,r26               
100164b4  4bfedc55    bl 0x10004108                  ; -> 10004108
100164b8  60000000    ori r0,r0,0x0               
100164bc  a91f0000    lha r8,0x0(r31)             
100164c0  1d08000e    mulli r8,r8,0xe             
100164c4  39080004    addi r8,r8,0x4              
100164c8  7d1e42ae    lhax r8,r30,r8              
100164cc  2c080001    cmpwi r8,0x1                
100164d0  4082002c    bne 0x100164fc                 ; -> 100164fc
100164d4  7f6b0734    extsh r11,r27               
100164d8  7f8c0734    extsh r12,r28               
100164dc  7fa90734    extsh r9,r29                
100164e0  1d6b003c    mulli r11,r11,0x3c          
100164e4  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
100164e8  39426bf8    addi r10,r2,0x6bf8          
100164ec  39290100    addi r9,r9,0x100            
100164f0  7d6b6214    add r11,r11,r12             
100164f4  7d2a592e    stwx r9,r10,r11             
100164f8  48000028    b 0x10016520                   ; -> 10016520
100164fc  7f630734    extsh r3,r27                
10016500  7f840734    extsh r4,r28                
10016504  7fb90734    extsh r25,r29               
10016508  1c63003c    mulli r3,r3,0x3c            
1001650c  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10016510  3b426bf8    addi r26,r2,0x6bf8          
10016514  3b390300    addi r25,r25,0x300          
10016518  7c632214    add r3,r3,r4                
1001651c  7f3a192e    stwx r25,r26,r3             
10016520  a8bf0000    lha r5,0x0(r31)             
10016524  38600001    li r3,0x1                   
10016528  38a50001    addi r5,r5,0x1              
1001652c  b0bf0000    sth r5,0x0(r31)             
10016530  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10016534  38210060    addi r1,r1,0x60             
10016538  7c0803a6    mtspr LR,r0                 
1001653c  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
10016540  4e800020    blr                         
