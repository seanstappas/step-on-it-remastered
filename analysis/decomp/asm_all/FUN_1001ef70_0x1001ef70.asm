; FUN_1001ef70 @ 0x1001ef70
1001ef70  7c0802a6    mfspr r0,LR                 
1001ef74  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001ef78  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001ef7c  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001ef80  90610058    stw r3,0x58(r1)                ; -> Stack[0x18]
1001ef84  80610058    lwz r3,0x58(r1)                ; -> Stack[0x18]
1001ef88  38827530    addi r4,r2,0x7530           
1001ef8c  83e30002    lwz r31,0x2(r3)             
1001ef90  80840000    lwz r4,0x0(r4)              
1001ef94  7c1f2040    cmplw r31,r4                
1001ef98  40820010    bne 0x1001efa8                 ; -> 1001efa8
1001ef9c  48006f7d    bl 0x10025f18                  ; -> 10025f18
1001efa0  60000000    ori r0,r0,0x0               
1001efa4  4800001c    b 0x1001efc0                   ; -> 1001efc0
1001efa8  38a27534    addi r5,r2,0x7534           
1001efac  80a50000    lwz r5,0x0(r5)              
1001efb0  7c1f2840    cmplw r31,r5                
1001efb4  4082000c    bne 0x1001efc0                 ; -> 1001efc0
1001efb8  48007001    bl 0x10025fb8                  ; -> 10025fb8
1001efbc  60000000    ori r0,r0,0x0               
1001efc0  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001efc4  38210040    addi r1,r1,0x40             
1001efc8  7c0803a6    mtspr LR,r0                 
1001efcc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001efd0  4e800020    blr                         
