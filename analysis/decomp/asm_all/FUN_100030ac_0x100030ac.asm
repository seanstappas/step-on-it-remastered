; FUN_100030ac @ 0x100030ac
100030ac  7c0802a6    mfspr r0,LR                 
100030b0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100030b4  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100030b8  38e23be8    addi r7,r2,0x3be8           
100030bc  48000019    bl 0x100030d4                  ; -> 100030d4
100030c0  60000000    ori r0,r0,0x0               
100030c4  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
100030c8  38210040    addi r1,r1,0x40             
100030cc  7c0803a6    mtspr LR,r0                 
100030d0  4e800020    blr                         
