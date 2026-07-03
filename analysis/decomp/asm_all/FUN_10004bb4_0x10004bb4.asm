; FUN_10004bb4 @ 0x10004bb4
10004bb4  7c0802a6    mfspr r0,LR                 
10004bb8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10004bbc  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10004bc0  90610058    stw r3,0x58(r1)                ; -> Stack[0x18]
10004bc4  b081005e    sth r4,0x5e(r1)                ; -> Stack[0x1e]
10004bc8  b0a10062    sth r5,0x62(r1)                ; -> Stack[0x22]
10004bcc  b0c10066    sth r6,0x66(r1)                ; -> Stack[0x26]
10004bd0  39026bd4    addi r8,r2,0x6bd4           
10004bd4  39226bd0    addi r9,r2,0x6bd0           
10004bd8  80e80000    lwz r7,0x0(r8)              
10004bdc  80610058    lwz r3,0x58(r1)                ; -> Stack[0x18]
10004be0  a881005e    lha r4,0x5e(r1)                ; -> Stack[0x1e]
10004be4  a8a10062    lha r5,0x62(r1)                ; -> Stack[0x22]
10004be8  a8c10066    lha r6,0x66(r1)                ; -> Stack[0x26]
10004bec  a9090000    lha r8,0x0(r9)              
10004bf0  4bffcd6d    bl 0x1000195c                  ; -> 1000195c
10004bf4  60000000    ori r0,r0,0x0               
10004bf8  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10004bfc  38210040    addi r1,r1,0x40             
10004c00  7c0803a6    mtspr LR,r0                 
10004c04  4e800020    blr                         
