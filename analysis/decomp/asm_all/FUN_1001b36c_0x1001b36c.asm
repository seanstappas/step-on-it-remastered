; FUN_1001b36c @ 0x1001b36c
1001b36c  7c0802a6    mfspr r0,LR                 
1001b370  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001b374  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001b378  90610068    stw r3,0x68(r1)                ; -> Stack[0x18]
1001b37c  b081006e    sth r4,0x6e(r1)                ; -> Stack[0x1e]
1001b380  80610068    lwz r3,0x68(r1)                ; -> Stack[0x18]
1001b384  a881006e    lha r4,0x6e(r1)                ; -> Stack[0x1e]
1001b388  38a10044    addi r5,r1,0x44             
1001b38c  38c10038    addi r6,r1,0x38             
1001b390  38e1003c    addi r7,r1,0x3c             
1001b394  48015e45    bl 0x100311d8                  ; -> 100311d8
1001b398  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001b39c  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x18]
1001b3a0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001b3a4  38210050    addi r1,r1,0x50             
1001b3a8  7c0803a6    mtspr LR,r0                 
1001b3ac  4e800020    blr                         
