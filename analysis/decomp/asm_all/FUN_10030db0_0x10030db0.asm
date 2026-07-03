; FUN_10030db0 @ 0x10030db0
10030db0  7c0802a6    mfspr r0,LR                 
10030db4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10030db8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10030dbc  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10030dc0  3be27930    addi r31,r2,0x7930          
10030dc4  48000020    b 0x10030de4                   ; -> 10030de4
10030dc8  80050000    lwz r0,0x0(r5)              
10030dcc  3880ffff    li r4,-0x1                  
10030dd0  901f0000    stw r0,0x0(r31)             
10030dd4  80650008    lwz r3,0x8(r5)              
10030dd8  81850004    lwz r12,0x4(r5)             
10030ddc  480018cd    bl 0x100326a8                  ; -> 100326a8
10030de0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
10030de4  80bf0000    lwz r5,0x0(r31)             
10030de8  28050000    cmplwi r5,0x0               
10030dec  4082ffdc    bne 0x10030dc8                 ; -> 10030dc8
10030df0  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10030df4  38210040    addi r1,r1,0x40             
10030df8  7c0803a6    mtspr LR,r0                 
10030dfc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10030e00  4e800020    blr                         
