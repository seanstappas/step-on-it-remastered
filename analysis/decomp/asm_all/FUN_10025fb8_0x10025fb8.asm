; FUN_10025fb8 @ 0x10025fb8
10025fb8  7c0802a6    mfspr r0,LR                 
10025fbc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10025fc0  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10025fc4  38600000    li r3,0x0                   
10025fc8  b061003a    sth r3,0x3a(r1)                ; -> Stack[-0x6]
10025fcc  38800000    li r4,0x0                   
10025fd0  b0810038    sth r4,0x38(r1)                ; -> Stack[-0x8]
10025fd4  38a00000    li r5,0x0                   
10025fd8  b0a1003c    sth r5,0x3c(r1)                ; -> Stack[-0x4]
10025fdc  38610038    addi r3,r1,0x38             
10025fe0  4800bbb9    bl 0x10031b98                  ; -> 10031b98
10025fe4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
10025fe8  38c27534    addi r6,r2,0x7534           
10025fec  80c60000    lwz r6,0x0(r6)              
10025ff0  38660010    addi r3,r6,0x10             
10025ff4  4800bbbd    bl 0x10031bb0                  ; -> 10031bb0
10025ff8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
10025ffc  4800b915    bl 0x10031910                  ; -> 10031910
10026000  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
10026004  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10026008  38210040    addi r1,r1,0x40             
1002600c  7c0803a6    mtspr LR,r0                 
10026010  4e800020    blr                         
