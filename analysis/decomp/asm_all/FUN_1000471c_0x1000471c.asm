; FUN_1000471c @ 0x1000471c
1000471c  7c0802a6    mfspr r0,LR                 
10004720  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
10004724  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10004728  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000472c  7c7c1b78    or r28,r3,r3                
10004730  7c9d2378    or r29,r4,r4                
10004734  7fa3eb78    or r3,r29,r29               
10004738  48029f85    bl 0x1002e6bc                  ; -> 1002e6bc
1000473c  60000000    ori r0,r0,0x0               
10004740  38826bd0    addi r4,r2,0x6bd0           
10004744  7c630734    extsh r3,r3                 
10004748  a8840000    lha r4,0x0(r4)              
1000474c  7c8321d6    mullw r4,r3,r4              
10004750  7c9b2378    or r27,r4,r4                
10004754  7f83e378    or r3,r28,r28               
10004758  48029f55    bl 0x1002e6ac                  ; -> 1002e6ac
1000475c  60000000    ori r0,r0,0x0               
10004760  38a26bd4    addi r5,r2,0x6bd4           
10004764  7c630734    extsh r3,r3                 
10004768  80a50000    lwz r5,0x0(r5)              
1000476c  7c63da14    add r3,r3,r27               
10004770  7fe51a14    add r31,r5,r3               
10004774  7fa3eb78    or r3,r29,r29               
10004778  48029f45    bl 0x1002e6bc                  ; -> 1002e6bc
1000477c  60000000    ori r0,r0,0x0               
10004780  38c270e4    addi r6,r2,0x70e4           
10004784  7c630734    extsh r3,r3                 
10004788  80c60000    lwz r6,0x0(r6)              
1000478c  7cc619d6    mullw r6,r6,r3              
10004790  7cdb3378    or r27,r6,r6                
10004794  7f83e378    or r3,r28,r28               
10004798  48029f15    bl 0x1002e6ac                  ; -> 1002e6ac
1000479c  60000000    ori r0,r0,0x0               
100047a0  38e270e8    addi r7,r2,0x70e8           
100047a4  7c630734    extsh r3,r3                 
100047a8  39026bd0    addi r8,r2,0x6bd0           
100047ac  392270e4    addi r9,r2,0x70e4           
100047b0  80e70000    lwz r7,0x0(r7)              
100047b4  7c63da14    add r3,r3,r27               
100047b8  7fc71a14    add r30,r7,r3               
100047bc  a8a80000    lha r5,0x0(r8)              
100047c0  80c90000    lwz r6,0x0(r9)              
100047c4  7fe3fb78    or r3,r31,r31               
100047c8  7fc4f378    or r4,r30,r30               
100047cc  4bffeb05    bl 0x100032d0                  ; -> 100032d0
100047d0  60000000    ori r0,r0,0x0               
100047d4  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
100047d8  38210050    addi r1,r1,0x50             
100047dc  7c0803a6    mtspr LR,r0                 
100047e0  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
100047e4  4e800020    blr                         
