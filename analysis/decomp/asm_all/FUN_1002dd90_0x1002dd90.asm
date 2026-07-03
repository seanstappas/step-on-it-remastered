; FUN_1002dd90 @ 0x1002dd90
1002dd90  7c0802a6    mfspr r0,LR                 
1002dd94  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002dd98  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002dd9c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002dda0  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002dda4  38627564    addi r3,r2,0x7564           
1002dda8  80630000    lwz r3,0x0(r3)              
1002ddac  80630000    lwz r3,0x0(r3)              
1002ddb0  83c30016    lwz r30,0x16(r3)            
1002ddb4  809e0000    lwz r4,0x0(r30)             
1002ddb8  abe40020    lha r31,0x20(r4)            
1002ddbc  7fe50734    extsh r5,r31                
1002ddc0  2c050008    cmpwi r5,0x8                
1002ddc4  41820024    beq 0x1002dde8                 ; -> 1002dde8
1002ddc8  38c27564    addi r6,r2,0x7564           
1002ddcc  38800008    li r4,0x8                   
1002ddd0  80660000    lwz r3,0x0(r6)              
1002ddd4  38a00001    li r5,0x1                   
1002ddd8  38c00001    li r6,0x1                   
1002dddc  48003625    bl 0x10031400                  ; -> 10031400
1002dde0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1002dde4  b0610038    sth r3,0x38(r1)                ; -> Stack[-0x18]
1002dde8  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002ddec  38210050    addi r1,r1,0x50             
1002ddf0  7c0803a6    mtspr LR,r0                 
1002ddf4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002ddf8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002ddfc  4e800020    blr                         
