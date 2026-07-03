; FUN_10004650 @ 0x10004650
10004650  7c0802a6    mfspr r0,LR                 
10004654  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
10004658  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000465c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10004660  7c7c1b78    or r28,r3,r3                
10004664  7c9d2378    or r29,r4,r4                
10004668  7fa3eb78    or r3,r29,r29               
1000466c  4802a051    bl 0x1002e6bc                  ; -> 1002e6bc
10004670  60000000    ori r0,r0,0x0               
10004674  38826bd0    addi r4,r2,0x6bd0           
10004678  7c630734    extsh r3,r3                 
1000467c  a8840000    lha r4,0x0(r4)              
10004680  7c8321d6    mullw r4,r3,r4              
10004684  7c9b2378    or r27,r4,r4                
10004688  7f83e378    or r3,r28,r28               
1000468c  4802a021    bl 0x1002e6ac                  ; -> 1002e6ac
10004690  60000000    ori r0,r0,0x0               
10004694  38a26bd4    addi r5,r2,0x6bd4           
10004698  7c630734    extsh r3,r3                 
1000469c  80a50000    lwz r5,0x0(r5)              
100046a0  7c63da14    add r3,r3,r27               
100046a4  7fe51a14    add r31,r5,r3               
100046a8  7fa3eb78    or r3,r29,r29               
100046ac  4802a011    bl 0x1002e6bc                  ; -> 1002e6bc
100046b0  60000000    ori r0,r0,0x0               
100046b4  38c270e4    addi r6,r2,0x70e4           
100046b8  7c630734    extsh r3,r3                 
100046bc  80c60000    lwz r6,0x0(r6)              
100046c0  7cc619d6    mullw r6,r6,r3              
100046c4  7cdb3378    or r27,r6,r6                
100046c8  7f83e378    or r3,r28,r28               
100046cc  48029fe1    bl 0x1002e6ac                  ; -> 1002e6ac
100046d0  60000000    ori r0,r0,0x0               
100046d4  38e270e8    addi r7,r2,0x70e8           
100046d8  7c630734    extsh r3,r3                 
100046dc  39026bd0    addi r8,r2,0x6bd0           
100046e0  392270e4    addi r9,r2,0x70e4           
100046e4  80e70000    lwz r7,0x0(r7)              
100046e8  7c63da14    add r3,r3,r27               
100046ec  7fc71a14    add r30,r7,r3               
100046f0  a8a80000    lha r5,0x0(r8)              
100046f4  80c90000    lwz r6,0x0(r9)              
100046f8  7fe3fb78    or r3,r31,r31               
100046fc  7fc4f378    or r4,r30,r30               
10004700  4bffea85    bl 0x10003184                  ; -> 10003184
10004704  60000000    ori r0,r0,0x0               
10004708  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000470c  38210050    addi r1,r1,0x50             
10004710  7c0803a6    mtspr LR,r0                 
10004714  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10004718  4e800020    blr                         
