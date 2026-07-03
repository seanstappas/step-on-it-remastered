; FUN_10004c08 @ 0x10004c08
10004c08  7c0802a6    mfspr r0,LR                 
10004c0c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10004c10  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10004c14  90610058    stw r3,0x58(r1)                ; -> Stack[0x18]
10004c18  b081005e    sth r4,0x5e(r1)                ; -> Stack[0x1e]
10004c1c  b0a10062    sth r5,0x62(r1)                ; -> Stack[0x22]
10004c20  b0c10066    sth r6,0x66(r1)                ; -> Stack[0x26]
10004c24  390270e8    addi r8,r2,0x70e8           
10004c28  392270e4    addi r9,r2,0x70e4           
10004c2c  80e80000    lwz r7,0x0(r8)              
10004c30  80610058    lwz r3,0x58(r1)                ; -> Stack[0x18]
10004c34  a881005e    lha r4,0x5e(r1)                ; -> Stack[0x1e]
10004c38  a8a10062    lha r5,0x62(r1)                ; -> Stack[0x22]
10004c3c  a8c10066    lha r6,0x66(r1)                ; -> Stack[0x26]
10004c40  81090000    lwz r8,0x0(r9)              
10004c44  4bffcd19    bl 0x1000195c                  ; -> 1000195c
10004c48  60000000    ori r0,r0,0x0               
10004c4c  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10004c50  38210040    addi r1,r1,0x40             
10004c54  7c0803a6    mtspr LR,r0                 
10004c58  4e800020    blr                         
