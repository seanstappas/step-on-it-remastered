; FUN_1002eb2c @ 0x1002eb2c
1002eb2c  7c0802a6    mfspr r0,LR                 
1002eb30  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002eb34  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002eb38  9421ff70    stwu r1,-0x90(r1)              ; -> Stack[-0x90]
1002eb3c  906100a8    stw r3,0xa8(r1)                ; -> Stack[0x18]
1002eb40  908100ac    stw r4,0xac(r1)                ; -> Stack[0x1c]
1002eb44  806100a8    lwz r3,0xa8(r1)                ; -> Stack[0x18]
1002eb48  808100ac    lwz r4,0xac(r1)                ; -> Stack[0x1c]
1002eb4c  3be00000    li r31,0x0                  
1002eb50  38a10038    addi r5,r1,0x38             
1002eb54  480007e5    bl 0x1002f338                  ; -> 1002f338
1002eb58  7c7f1b78    or r31,r3,r3                
1002eb5c  7fe30734    extsh r3,r31                
1002eb60  2c030000    cmpwi r3,0x0                
1002eb64  7c800026    mfcr r4                     
1002eb68  54831ffe    rlwinm r3,r4,0x3,0x1f,0x1f  
1002eb6c  80010098    lwz r0,0x98(r1)                ; -> Stack[0x8]
1002eb70  38210090    addi r1,r1,0x90             
1002eb74  7c0803a6    mtspr LR,r0                 
1002eb78  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002eb7c  4e800020    blr                         
