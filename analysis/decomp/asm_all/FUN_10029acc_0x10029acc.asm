; FUN_10029acc @ 0x10029acc
10029acc  7c0802a6    mfspr r0,LR                 
10029ad0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10029ad4  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10029ad8  b061005a    sth r3,0x5a(r1)                ; -> Stack[0x1a]
10029adc  b081005e    sth r4,0x5e(r1)                ; -> Stack[0x1e]
10029ae0  a861005a    lha r3,0x5a(r1)                ; -> Stack[0x1a]
10029ae4  48001965    bl 0x1002b448                  ; -> 1002b448
10029ae8  60000000    ori r0,r0,0x0               
10029aec  a861005e    lha r3,0x5e(r1)                ; -> Stack[0x1e]
10029af0  48001685    bl 0x1002b174                  ; -> 1002b174
10029af4  60000000    ori r0,r0,0x0               
10029af8  48003e89    bl 0x1002d980                  ; -> 1002d980
10029afc  60000000    ori r0,r0,0x0               
10029b00  4bffd985    bl 0x10027484                  ; -> 10027484
10029b04  4bffd9e5    bl 0x100274e8                  ; -> 100274e8
10029b08  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10029b0c  38210040    addi r1,r1,0x40             
10029b10  7c0803a6    mtspr LR,r0                 
10029b14  4e800020    blr                         
