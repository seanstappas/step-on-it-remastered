; FUN_1002f640 @ 0x1002f640
1002f640  7c0802a6    mfspr r0,LR                 
1002f644  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002f648  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002f64c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1002f650  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002f654  9421ff30    stwu r1,-0xd0(r1)              ; -> Stack[-0xd0]
1002f658  7c7d1b78    or r29,r3,r3                
1002f65c  7fa30734    extsh r3,r29                
1002f660  2c03ffff    cmpwi r3,-0x1               
1002f664  3be00000    li r31,0x0                  
1002f668  3bc00000    li r30,0x0                  
1002f66c  41820048    beq 0x1002f6b4                 ; -> 1002f6b4
1002f670  38810038    addi r4,r1,0x38             
1002f674  9081008a    stw r4,0x8a(r1)                ; -> Stack[-0x46]
1002f678  38a00000    li r5,0x0                   
1002f67c  b0a1008e    sth r5,0x8e(r1)                ; -> Stack[-0x42]
1002f680  b3a10090    sth r29,0x90(r1)               ; -> Stack[-0x40]
1002f684  38c00000    li r6,0x0                   
1002f688  b0c10094    sth r6,0x94(r1)                ; -> Stack[-0x3c]
1002f68c  38610078    addi r3,r1,0x78             
1002f690  48002029    bl 0x100316b8                  ; -> 100316b8
1002f694  80410014    lwz r2,0x14(r1)                ; -> Stack[-0xbc]
1002f698  7c7f1b78    or r31,r3,r3                
1002f69c  7fe70734    extsh r7,r31                
1002f6a0  2c070000    cmpwi r7,0x0                
1002f6a4  4082000c    bne 0x1002f6b0                 ; -> 1002f6b0
1002f6a8  abc100ac    lha r30,0xac(r1)               ; -> Stack[-0x24]
1002f6ac  48000008    b 0x1002f6b4                   ; -> 1002f6b4
1002f6b0  48000004    b 0x1002f6b4                   ; -> 1002f6b4
1002f6b4  7fc3f378    or r3,r30,r30               
1002f6b8  800100d8    lwz r0,0xd8(r1)                ; -> Stack[0x8]
1002f6bc  382100d0    addi r1,r1,0xd0             
1002f6c0  7c0803a6    mtspr LR,r0                 
1002f6c4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002f6c8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002f6cc  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1002f6d0  4e800020    blr                         
