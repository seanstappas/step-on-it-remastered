; FUN_100179c4 @ 0x100179c4
100179c4  7c0802a6    mfspr r0,LR                 
100179c8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100179cc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100179d0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100179d4  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100179d8  90610058    stw r3,0x58(r1)                ; -> Stack[0x18]
100179dc  480195ed    bl 0x10030fc8                  ; -> 10030fc8
100179e0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
100179e4  80810058    lwz r4,0x58(r1)                ; -> Stack[0x18]
100179e8  7fe41a14    add r31,r4,r3               
100179ec  48000008    b 0x100179f4                   ; -> 100179f4
100179f0  3bc00000    li r30,0x0                  
100179f4  480195d5    bl 0x10030fc8                  ; -> 10030fc8
100179f8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
100179fc  7c03f840    cmplw r3,r31                
10017a00  4180fff0    blt 0x100179f0                 ; -> 100179f0
10017a04  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10017a08  38210040    addi r1,r1,0x40             
10017a0c  7c0803a6    mtspr LR,r0                 
10017a10  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10017a14  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10017a18  4e800020    blr                         
