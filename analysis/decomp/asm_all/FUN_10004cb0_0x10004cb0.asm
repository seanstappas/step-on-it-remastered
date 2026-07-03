; FUN_10004cb0 @ 0x10004cb0
10004cb0  7c0802a6    mfspr r0,LR                 
10004cb4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10004cb8  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10004cbc  90610058    stw r3,0x58(r1)                ; -> Stack[0x18]
10004cc0  b081005e    sth r4,0x5e(r1)                ; -> Stack[0x1e]
10004cc4  b0a10062    sth r5,0x62(r1)                ; -> Stack[0x22]
10004cc8  b0c10066    sth r6,0x66(r1)                ; -> Stack[0x26]
10004ccc  39026bd4    addi r8,r2,0x6bd4           
10004cd0  39226bd0    addi r9,r2,0x6bd0           
10004cd4  80e80000    lwz r7,0x0(r8)              
10004cd8  394270e8    addi r10,r2,0x70e8          
10004cdc  a9090000    lha r8,0x0(r9)              
10004ce0  396270e4    addi r11,r2,0x70e4          
10004ce4  812a0000    lwz r9,0x0(r10)             
10004ce8  80610058    lwz r3,0x58(r1)                ; -> Stack[0x18]
10004cec  a881005e    lha r4,0x5e(r1)                ; -> Stack[0x1e]
10004cf0  a8a10062    lha r5,0x62(r1)                ; -> Stack[0x22]
10004cf4  a8c10066    lha r6,0x66(r1)                ; -> Stack[0x26]
10004cf8  814b0000    lwz r10,0x0(r11)            
10004cfc  4bffc77d    bl 0x10001478                  ; -> 10001478
10004d00  60000000    ori r0,r0,0x0               
10004d04  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10004d08  38210040    addi r1,r1,0x40             
10004d0c  7c0803a6    mtspr LR,r0                 
10004d10  4e800020    blr                         
