; FUN_1001ff30 @ 0x1001ff30
1001ff30  7c0802a6    mfspr r0,LR                 
1001ff34  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001ff38  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001ff3c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001ff40  3c607174    lis r3,0x7174               
1001ff44  3863696d    addi r3,r3,0x696d           
1001ff48  38810038    addi r4,r1,0x38             
1001ff4c  4801140d    bl 0x10031358                  ; -> 10031358
1001ff50  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001ff54  7c7f1b78    or r31,r3,r3                
1001ff58  7fe30734    extsh r3,r31                
1001ff5c  2c030000    cmpwi r3,0x0                
1001ff60  7c800026    mfcr r4                     
1001ff64  54831ffe    rlwinm r3,r4,0x3,0x1f,0x1f  
1001ff68  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001ff6c  38210050    addi r1,r1,0x50             
1001ff70  7c0803a6    mtspr LR,r0                 
1001ff74  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001ff78  4e800020    blr                         
