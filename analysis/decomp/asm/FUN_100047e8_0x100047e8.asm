; FUN_100047e8 @ 0x100047e8  (51 instructions)
100047e8  7c0802a6    mfspr r0,LR                 
100047ec  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
100047f0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100047f4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
100047f8  7c7c1b78    or r28,r3,r3                
100047fc  7c9d2378    or r29,r4,r4                
10004800  7fa3eb78    or r3,r29,r29               
10004804  48029eb9    bl 0x1002e6bc                  ; -> 1002e6bc
10004808  60000000    ori r0,r0,0x0               
1000480c  38826bd0    addi r4,r2,0x6bd0           
10004810  7c630734    extsh r3,r3                 
10004814  a8840000    lha r4,0x0(r4)              
10004818  7c8321d6    mullw r4,r3,r4              
1000481c  7c9b2378    or r27,r4,r4                
10004820  7f83e378    or r3,r28,r28               
10004824  48029e89    bl 0x1002e6ac                  ; -> 1002e6ac
10004828  60000000    ori r0,r0,0x0               
1000482c  38a26bd4    addi r5,r2,0x6bd4           
10004830  7c630734    extsh r3,r3                 
10004834  80a50000    lwz r5,0x0(r5)              
10004838  7c63da14    add r3,r3,r27               
1000483c  7fe51a14    add r31,r5,r3               
10004840  7fa3eb78    or r3,r29,r29               
10004844  48029e79    bl 0x1002e6bc                  ; -> 1002e6bc
10004848  60000000    ori r0,r0,0x0               
1000484c  38c270e4    addi r6,r2,0x70e4           
10004850  7c630734    extsh r3,r3                 
10004854  80c60000    lwz r6,0x0(r6)              
10004858  7cc619d6    mullw r6,r6,r3              
1000485c  7cdb3378    or r27,r6,r6                
10004860  7f83e378    or r3,r28,r28               
10004864  48029e49    bl 0x1002e6ac                  ; -> 1002e6ac
10004868  60000000    ori r0,r0,0x0               
1000486c  38e270e8    addi r7,r2,0x70e8           
10004870  7c630734    extsh r3,r3                 
10004874  39026bd0    addi r8,r2,0x6bd0           
10004878  392270e4    addi r9,r2,0x70e4           
1000487c  80e70000    lwz r7,0x0(r7)              
10004880  7c63da14    add r3,r3,r27               
10004884  7fc71a14    add r30,r7,r3               
10004888  a8a80000    lha r5,0x0(r8)              
1000488c  80c90000    lwz r6,0x0(r9)              
10004890  7fe3fb78    or r3,r31,r31               
10004894  7fc4f378    or r4,r30,r30               
10004898  4bffeb45    bl 0x100033dc                  ; -> 100033dc
1000489c  60000000    ori r0,r0,0x0               
100048a0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
100048a4  38210050    addi r1,r1,0x50             
100048a8  7c0803a6    mtspr LR,r0                 
100048ac  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
100048b0  4e800020    blr                         
