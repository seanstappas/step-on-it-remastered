; .FSpOpenResFileCompat @ 0x1002fbd8
1002fbd8  7c0802a6    mfspr r0,LR                 
1002fbdc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002fbe0  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1002fbe4  90610058    stw r3,0x58(r1)                ; -> Stack[0x18]
1002fbe8  9881005f    stb r4,0x5f(r1)                ; -> Stack[0x1f]
1002fbec  80610058    lwz r3,0x58(r1)                ; -> Stack[0x18]
1002fbf0  8881005f    lbz r4,0x5f(r1)                ; -> Stack[0x1f]
1002fbf4  48001a7d    bl 0x10031670                  ; -> 10031670
1002fbf8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1002fbfc  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1002fc00  38210040    addi r1,r1,0x40             
1002fc04  7c0803a6    mtspr LR,r0                 
1002fc08  4e800020    blr                         
