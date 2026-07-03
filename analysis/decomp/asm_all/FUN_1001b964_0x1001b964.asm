; FUN_1001b964 @ 0x1001b964
1001b964  7c0802a6    mfspr r0,LR                 
1001b968  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001b96c  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001b970  90610058    stw r3,0x58(r1)                ; -> Stack[0x18]
1001b974  80610058    lwz r3,0x58(r1)                ; -> Stack[0x18]
1001b978  48016c59    bl 0x100325d0                  ; -> 100325d0
1001b97c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1001b980  b0610038    sth r3,0x38(r1)                ; -> Stack[-0x8]
1001b984  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001b988  38210040    addi r1,r1,0x40             
1001b98c  7c0803a6    mtspr LR,r0                 
1001b990  4e800020    blr                         
