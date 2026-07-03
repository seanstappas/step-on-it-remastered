; FUN_10015f8c @ 0x10015f8c
10015f8c  7c0802a6    mfspr r0,LR                 
10015f90  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10015f94  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10015f98  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10015f9c  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10015fa0  90610058    stw r3,0x58(r1)                ; -> Stack[0x18]
10015fa4  4801b025    bl 0x10030fc8                  ; -> 10030fc8
10015fa8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
10015fac  80810058    lwz r4,0x58(r1)                ; -> Stack[0x18]
10015fb0  7fe41a14    add r31,r4,r3               
10015fb4  48000008    b 0x10015fbc                   ; -> 10015fbc
10015fb8  3bc00000    li r30,0x0                  
10015fbc  4801b00d    bl 0x10030fc8                  ; -> 10030fc8
10015fc0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
10015fc4  7c03f840    cmplw r3,r31                
10015fc8  4180fff0    blt 0x10015fb8                 ; -> 10015fb8
10015fcc  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10015fd0  38210040    addi r1,r1,0x40             
10015fd4  7c0803a6    mtspr LR,r0                 
10015fd8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10015fdc  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10015fe0  4e800020    blr                         
