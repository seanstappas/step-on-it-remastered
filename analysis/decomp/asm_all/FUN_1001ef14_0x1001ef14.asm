; FUN_1001ef14 @ 0x1001ef14
1001ef14  7c0802a6    mfspr r0,LR                 
1001ef18  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001ef1c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001ef20  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001ef24  3860aa6e    li r3,-0x5592               
1001ef28  38800001    li r4,0x1                   
1001ef2c  4801224d    bl 0x10031178                  ; -> 10031178
1001ef30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1001ef34  7c7f1b78    or r31,r3,r3                
1001ef38  3860a86e    li r3,-0x5792               
1001ef3c  38800001    li r4,0x1                   
1001ef40  48012239    bl 0x10031178                  ; -> 10031178
1001ef44  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1001ef48  7c03f840    cmplw r3,r31                
1001ef4c  4082000c    bne 0x1001ef58                 ; -> 1001ef58
1001ef50  38600200    li r3,0x200                 
1001ef54  48000008    b 0x1001ef5c                   ; -> 1001ef5c
1001ef58  38600400    li r3,0x400                 
1001ef5c  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001ef60  38210040    addi r1,r1,0x40             
1001ef64  7c0803a6    mtspr LR,r0                 
1001ef68  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001ef6c  4e800020    blr                         
