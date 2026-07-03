; FUN_1001fba4 @ 0x1001fba4
1001fba4  7c0802a6    mfspr r0,LR                 
1001fba8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001fbac  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001fbb0  4bfff949    bl 0x1001f4f8                  ; -> 1001f4f8
1001fbb4  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001fbb8  38210040    addi r1,r1,0x40             
1001fbbc  7c0803a6    mtspr LR,r0                 
1001fbc0  4e800020    blr                         
