; FUN_100056d4 @ 0x100056d4
100056d4  7c0802a6    mfspr r0,LR                 
100056d8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100056dc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100056e0  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100056e4  b061005a    sth r3,0x5a(r1)                ; -> Stack[0x1a]
100056e8  b081005e    sth r4,0x5e(r1)                ; -> Stack[0x1e]
100056ec  a861005e    lha r3,0x5e(r1)                ; -> Stack[0x1e]
100056f0  48029009    bl 0x1002e6f8                  ; -> 1002e6f8
100056f4  60000000    ori r0,r0,0x0               
100056f8  7c630734    extsh r3,r3                 
100056fc  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10005700  7c7f1b78    or r31,r3,r3                
10005704  a861005a    lha r3,0x5a(r1)                ; -> Stack[0x1a]
10005708  48028fc5    bl 0x1002e6cc                  ; -> 1002e6cc
1000570c  60000000    ori r0,r0,0x0               
10005710  7c630734    extsh r3,r3                 
10005714  1c63003c    mulli r3,r3,0x3c            
10005718  38826bf8    addi r4,r2,0x6bf8           
1000571c  7c63fa14    add r3,r3,r31               
10005720  7c84182e    lwzx r4,r4,r3               
10005724  548405ee    rlwinm r4,r4,0x0,0x17,0x17  
10005728  2c040000    cmpwi r4,0x0                
1000572c  4182000c    beq 0x10005738                 ; -> 10005738
10005730  38600001    li r3,0x1                   
10005734  48000008    b 0x1000573c                   ; -> 1000573c
10005738  38600000    li r3,0x0                   
1000573c  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10005740  38210040    addi r1,r1,0x40             
10005744  7c0803a6    mtspr LR,r0                 
10005748  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000574c  4e800020    blr                         
