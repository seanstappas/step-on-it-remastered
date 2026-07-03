; FUN_1001ec9c @ 0x1001ec9c
1001ec9c  7c0802a6    mfspr r0,LR                 
1001eca0  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001eca4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001eca8  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001ecac  7c7f1b78    or r31,r3,r3                
1001ecb0  7fe3fb78    or r3,r31,r31               
1001ecb4  480000b1    bl 0x1001ed64                  ; -> 1001ed64
1001ecb8  60000000    ori r0,r0,0x0               
1001ecbc  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1001ecc0  28030000    cmplwi r3,0x0               
1001ecc4  41820014    beq 0x1001ecd8                 ; -> 1001ecd8
1001ecc8  a87f006c    lha r3,0x6c(r31)            
1001eccc  48013845    bl 0x10032510                  ; -> 10032510
1001ecd0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1001ecd4  48000038    b 0x1001ed0c                   ; -> 1001ed0c
1001ecd8  7fe3fb78    or r3,r31,r31               
1001ecdc  480000ad    bl 0x1001ed88                  ; -> 1001ed88
1001ece0  60000000    ori r0,r0,0x0               
1001ece4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1001ece8  28030000    cmplwi r3,0x0               
1001ecec  41820014    beq 0x1001ed00                 ; -> 1001ed00
1001ecf0  7fe3fb78    or r3,r31,r31               
1001ecf4  48013445    bl 0x10032138                  ; -> 10032138
1001ecf8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1001ecfc  48000010    b 0x1001ed0c                   ; -> 1001ed0c
1001ed00  7fe3fb78    or r3,r31,r31               
1001ed04  4800001d    bl 0x1001ed20                  ; -> 1001ed20
1001ed08  60000000    ori r0,r0,0x0               
1001ed0c  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001ed10  38210040    addi r1,r1,0x40             
1001ed14  7c0803a6    mtspr LR,r0                 
1001ed18  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001ed1c  4e800020    blr                         
