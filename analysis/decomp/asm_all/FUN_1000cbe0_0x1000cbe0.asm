; FUN_1000cbe0 @ 0x1000cbe0
1000cbe0  7c0802a6    mfspr r0,LR                 
1000cbe4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000cbe8  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000cbec  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000cbf0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000cbf4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000cbf8  7c7e1b78    or r30,r3,r3                
1000cbfc  480255b5    bl 0x100321b0                  ; -> 100321b0
1000cc00  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1000cc04  7c630734    extsh r3,r3                 
1000cc08  547d047e    rlwinm r29,r3,0x0,0x11,0x1f 
1000cc0c  7fc30734    extsh r3,r30                
1000cc10  7c7d19d6    mullw r3,r29,r3             
1000cc14  38807fff    li r4,0x7fff                
1000cc18  7fe323d6    divw r31,r3,r4              
1000cc1c  3bff0001    addi r31,r31,0x1            
1000cc20  7fc50734    extsh r5,r30                
1000cc24  7c1f2800    cmpw r31,r5                 
1000cc28  40810008    ble 0x1000cc30                 ; -> 1000cc30
1000cc2c  7fdf0734    extsh r31,r30               
1000cc30  7fe3fb78    or r3,r31,r31               
1000cc34  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000cc38  38210050    addi r1,r1,0x50             
1000cc3c  7c0803a6    mtspr LR,r0                 
1000cc40  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000cc44  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000cc48  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000cc4c  4e800020    blr                         
