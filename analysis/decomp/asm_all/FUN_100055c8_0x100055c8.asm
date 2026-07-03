; FUN_100055c8 @ 0x100055c8
100055c8  7c0802a6    mfspr r0,LR                 
100055cc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100055d0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100055d4  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100055d8  b061005a    sth r3,0x5a(r1)                ; -> Stack[0x1a]
100055dc  b081005e    sth r4,0x5e(r1)                ; -> Stack[0x1e]
100055e0  a861005e    lha r3,0x5e(r1)                ; -> Stack[0x1e]
100055e4  48029115    bl 0x1002e6f8                  ; -> 1002e6f8
100055e8  60000000    ori r0,r0,0x0               
100055ec  7c630734    extsh r3,r3                 
100055f0  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100055f4  7c7f1b78    or r31,r3,r3                
100055f8  a861005a    lha r3,0x5a(r1)                ; -> Stack[0x1a]
100055fc  480290d1    bl 0x1002e6cc                  ; -> 1002e6cc
10005600  60000000    ori r0,r0,0x0               
10005604  7c630734    extsh r3,r3                 
10005608  1c63003c    mulli r3,r3,0x3c            
1000560c  38826bf8    addi r4,r2,0x6bf8           
10005610  7c63fa14    add r3,r3,r31               
10005614  7c84182e    lwzx r4,r4,r3               
10005618  5483043e    rlwinm r3,r4,0x0,0x10,0x1f  
1000561c  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10005620  38210040    addi r1,r1,0x40             
10005624  7c0803a6    mtspr LR,r0                 
10005628  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000562c  4e800020    blr                         
