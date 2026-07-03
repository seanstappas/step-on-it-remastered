; FUN_10004c5c @ 0x10004c5c
10004c5c  7c0802a6    mfspr r0,LR                 
10004c60  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10004c64  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10004c68  90610058    stw r3,0x58(r1)                ; -> Stack[0x18]
10004c6c  b081005e    sth r4,0x5e(r1)                ; -> Stack[0x1e]
10004c70  b0a10062    sth r5,0x62(r1)                ; -> Stack[0x22]
10004c74  b0c10066    sth r6,0x66(r1)                ; -> Stack[0x26]
10004c78  39026bdc    addi r8,r2,0x6bdc           
10004c7c  39226bd8    addi r9,r2,0x6bd8           
10004c80  80e80000    lwz r7,0x0(r8)              
10004c84  80610058    lwz r3,0x58(r1)                ; -> Stack[0x18]
10004c88  a881005e    lha r4,0x5e(r1)                ; -> Stack[0x1e]
10004c8c  a8a10062    lha r5,0x62(r1)                ; -> Stack[0x22]
10004c90  a8c10066    lha r6,0x66(r1)                ; -> Stack[0x26]
10004c94  81090000    lwz r8,0x0(r9)              
10004c98  4bffccc5    bl 0x1000195c                  ; -> 1000195c
10004c9c  60000000    ori r0,r0,0x0               
10004ca0  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10004ca4  38210040    addi r1,r1,0x40             
10004ca8  7c0803a6    mtspr LR,r0                 
10004cac  4e800020    blr                         
