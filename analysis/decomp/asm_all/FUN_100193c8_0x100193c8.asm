; FUN_100193c8 @ 0x100193c8
100193c8  7c0802a6    mfspr r0,LR                 
100193cc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100193d0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100193d4  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100193d8  3be27100    addi r31,r2,0x7100          
100193dc  38600000    li r3,0x0                   
100193e0  907f000e    stw r3,0xe(r31)             
100193e4  38800000    li r4,0x0                   
100193e8  b09f001a    sth r4,0x1a(r31)            
100193ec  809f0016    lwz r4,0x16(r31)            
100193f0  7fe3fb78    or r3,r31,r31               
100193f4  48018115    bl 0x10031508                  ; -> 10031508
100193f8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
100193fc  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10019400  38210040    addi r1,r1,0x40             
10019404  7c0803a6    mtspr LR,r0                 
10019408  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001940c  4e800020    blr                         
