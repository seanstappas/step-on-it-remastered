; FUN_1002b020 @ 0x1002b020
1002b020  7c0802a6    mfspr r0,LR                 
1002b024  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002b028  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1002b02c  b061005a    sth r3,0x5a(r1)                ; -> Stack[0x1a]
1002b030  9081005c    stw r4,0x5c(r1)                ; -> Stack[0x1c]
1002b034  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[0x1a]
1002b038  38826a7c    addi r4,r2,0x6a7c           
1002b03c  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
1002b040  7c64282e    lwzx r3,r4,r5               
1002b044  8081005c    lwz r4,0x5c(r1)                ; -> Stack[0x1c]
1002b048  4bfeea39    bl 0x10019a80                  ; -> 10019a80
1002b04c  60000000    ori r0,r0,0x0               
1002b050  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1002b054  38210040    addi r1,r1,0x40             
1002b058  7c0803a6    mtspr LR,r0                 
1002b05c  4e800020    blr                         
