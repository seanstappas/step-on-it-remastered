; FUN_1001b9f0 @ 0x1001b9f0
1001b9f0  7c0802a6    mfspr r0,LR                 
1001b9f4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001b9f8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001b9fc  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001ba00  7c7f1b78    or r31,r3,r3                
1001ba04  8062ffe0    lwz r3,-0x20(r2)               ; -> 10034150
1001ba08  90610038    stw r3,0x38(r1)                ; -> Stack[-0x18]
1001ba0c  809f0002    lwz r4,0x2(r31)             
1001ba10  5484843e    rlwinm r4,r4,0x10,0x10,0x1f 
1001ba14  28040000    cmplwi r4,0x0               
1001ba18  41820014    beq 0x1001ba2c                 ; -> 1001ba2c
1001ba1c  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x18]
1001ba20  809f0002    lwz r4,0x2(r31)             
1001ba24  48016b95    bl 0x100325b8                  ; -> 100325b8
1001ba28  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001ba2c  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001ba30  38210050    addi r1,r1,0x50             
1001ba34  7c0803a6    mtspr LR,r0                 
1001ba38  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001ba3c  4e800020    blr                         
