; FUN_1002ea68 @ 0x1002ea68
1002ea68  7c0802a6    mfspr r0,LR                 
1002ea6c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002ea70  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002ea74  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002ea78  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1002ea7c  7c7e1b78    or r30,r3,r3                
1002ea80  7fc30734    extsh r3,r30                
1002ea84  2c03ffff    cmpwi r3,-0x1               
1002ea88  3be00000    li r31,0x0                  
1002ea8c  41820020    beq 0x1002eaac                 ; -> 1002eaac
1002ea90  7fc3f378    or r3,r30,r30               
1002ea94  48002ce5    bl 0x10031778                  ; -> 10031778
1002ea98  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1002ea9c  48002b8d    bl 0x10031628                  ; -> 10031628
1002eaa0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1002eaa4  7c7f1b78    or r31,r3,r3                
1002eaa8  48000008    b 0x1002eab0                   ; -> 1002eab0
1002eaac  3be0ffce    li r31,-0x32                
1002eab0  7fe3fb78    or r3,r31,r31               
1002eab4  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1002eab8  38210040    addi r1,r1,0x40             
1002eabc  7c0803a6    mtspr LR,r0                 
1002eac0  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002eac4  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002eac8  4e800020    blr                         
