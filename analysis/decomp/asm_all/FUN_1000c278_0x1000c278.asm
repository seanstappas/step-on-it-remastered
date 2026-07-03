; FUN_1000c278 @ 0x1000c278
1000c278  7c0802a6    mfspr r0,LR                 
1000c27c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000c280  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000c284  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000c288  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000c28c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000c290  7c7e1b78    or r30,r3,r3                
1000c294  48025f1d    bl 0x100321b0                  ; -> 100321b0
1000c298  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1000c29c  7c630734    extsh r3,r3                 
1000c2a0  547d047e    rlwinm r29,r3,0x0,0x11,0x1f 
1000c2a4  7fc30734    extsh r3,r30                
1000c2a8  7c7d19d6    mullw r3,r29,r3             
1000c2ac  38807fff    li r4,0x7fff                
1000c2b0  7fe323d6    divw r31,r3,r4              
1000c2b4  3bff0001    addi r31,r31,0x1            
1000c2b8  7fc50734    extsh r5,r30                
1000c2bc  7c1f2800    cmpw r31,r5                 
1000c2c0  40810008    ble 0x1000c2c8                 ; -> 1000c2c8
1000c2c4  7fdf0734    extsh r31,r30               
1000c2c8  7fe3fb78    or r3,r31,r31               
1000c2cc  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000c2d0  38210050    addi r1,r1,0x50             
1000c2d4  7c0803a6    mtspr LR,r0                 
1000c2d8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000c2dc  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000c2e0  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000c2e4  4e800020    blr                         
