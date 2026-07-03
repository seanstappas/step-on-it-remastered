; .FSpDeleteCompat @ 0x1002fb88
1002fb88  7c0802a6    mfspr r0,LR                 
1002fb8c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002fb90  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1002fb94  90610058    stw r3,0x58(r1)                ; -> Stack[0x18]
1002fb98  80610058    lwz r3,0x58(r1)                ; -> Stack[0x18]
1002fb9c  48001c6d    bl 0x10031808                  ; -> 10031808
1002fba0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1002fba4  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1002fba8  38210040    addi r1,r1,0x40             
1002fbac  7c0803a6    mtspr LR,r0                 
1002fbb0  4e800020    blr                         
