; FUN_10005750 @ 0x10005750
10005750  7c0802a6    mfspr r0,LR                 
10005754  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10005758  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000575c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10005760  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10005764  b061005a    sth r3,0x5a(r1)                ; -> Stack[0x1a]
10005768  b081005e    sth r4,0x5e(r1)                ; -> Stack[0x1e]
1000576c  7cbf2b78    or r31,r5,r5                
10005770  7fe3fb78    or r3,r31,r31               
10005774  48028f85    bl 0x1002e6f8                  ; -> 1002e6f8
10005778  60000000    ori r0,r0,0x0               
1000577c  7c630734    extsh r3,r3                 
10005780  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10005784  7c7e1b78    or r30,r3,r3                
10005788  a861005a    lha r3,0x5a(r1)                ; -> Stack[0x1a]
1000578c  48028f41    bl 0x1002e6cc                  ; -> 1002e6cc
10005790  60000000    ori r0,r0,0x0               
10005794  7c630734    extsh r3,r3                 
10005798  1c63003c    mulli r3,r3,0x3c            
1000579c  38826bf8    addi r4,r2,0x6bf8           
100057a0  7c63f214    add r3,r3,r30               
100057a4  7c84182e    lwzx r4,r4,r3               
100057a8  548405ac    rlwinm r4,r4,0x0,0x16,0x16  
100057ac  2c040000    cmpwi r4,0x0                
100057b0  40820050    bne 0x10005800                 ; -> 10005800
100057b4  7fe3fb78    or r3,r31,r31               
100057b8  48028f41    bl 0x1002e6f8                  ; -> 1002e6f8
100057bc  60000000    ori r0,r0,0x0               
100057c0  7c630734    extsh r3,r3                 
100057c4  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100057c8  7c7e1b78    or r30,r3,r3                
100057cc  a861005e    lha r3,0x5e(r1)                ; -> Stack[0x1e]
100057d0  48028efd    bl 0x1002e6cc                  ; -> 1002e6cc
100057d4  60000000    ori r0,r0,0x0               
100057d8  7c630734    extsh r3,r3                 
100057dc  1c63003c    mulli r3,r3,0x3c            
100057e0  38a26bf8    addi r5,r2,0x6bf8           
100057e4  7c63f214    add r3,r3,r30               
100057e8  7ca5182e    lwzx r5,r5,r3               
100057ec  54a505ac    rlwinm r5,r5,0x0,0x16,0x16  
100057f0  2c050000    cmpwi r5,0x0                
100057f4  4082000c    bne 0x10005800                 ; -> 10005800
100057f8  38600001    li r3,0x1                   
100057fc  48000008    b 0x10005804                   ; -> 10005804
10005800  38600000    li r3,0x0                   
10005804  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10005808  38210040    addi r1,r1,0x40             
1000580c  7c0803a6    mtspr LR,r0                 
10005810  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10005814  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10005818  4e800020    blr                         
