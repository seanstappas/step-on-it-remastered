; FUN_10015fe4 @ 0x10015fe4
10015fe4  7c0802a6    mfspr r0,LR                 
10015fe8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10015fec  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10015ff0  4801afd9    bl 0x10030fc8                  ; -> 10030fc8
10015ff4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
10015ff8  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10015ffc  38210040    addi r1,r1,0x40             
10016000  7c0803a6    mtspr LR,r0                 
10016004  4e800020    blr                         
