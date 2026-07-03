; FUN_1002eb80 @ 0x1002eb80
1002eb80  7c0802a6    mfspr r0,LR                 
1002eb84  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
1002eb88  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002eb8c  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1002eb90  7c7a1b78    or r26,r3,r3                
1002eb94  7c9d2378    or r29,r4,r4                
1002eb98  7cbb2b78    or r27,r5,r5                
1002eb9c  7cdc3378    or r28,r6,r6                
1002eba0  7cfe3b78    or r30,r7,r7                
1002eba4  9101008c    stw r8,0x8c(r1)                ; -> Stack[0x2c]
1002eba8  7f430734    extsh r3,r26                
1002ebac  2c03ffff    cmpwi r3,-0x1               
1002ebb0  3be00000    li r31,0x0                  
1002ebb4  41820104    beq 0x1002ecb8                 ; -> 1002ecb8
1002ebb8  7fa40734    extsh r4,r29                
1002ebbc  2c040001    cmpwi r4,0x1                
1002ebc0  41820010    beq 0x1002ebd0                 ; -> 1002ebd0
1002ebc4  7fa50734    extsh r5,r29                
1002ebc8  2c050002    cmpwi r5,0x2                
1002ebcc  408200ec    bne 0x1002ecb8                 ; -> 1002ecb8
1002ebd0  281b0000    cmplwi r27,0x0              
1002ebd4  418200e4    beq 0x1002ecb8                 ; -> 1002ecb8
1002ebd8  281c0000    cmplwi r28,0x0              
1002ebdc  418200dc    beq 0x1002ecb8                 ; -> 1002ecb8
1002ebe0  3c807665    lis r4,0x7665               
1002ebe4  b3a10038    sth r29,0x38(r1)               ; -> Stack[-0x28]
1002ebe8  7f43d378    or r3,r26,r26               
1002ebec  38847273    addi r4,r4,0x7273           
1002ebf0  38a10038    addi r5,r1,0x38             
1002ebf4  38c1003a    addi r6,r1,0x3a             
1002ebf8  480001f9    bl 0x1002edf0                  ; -> 1002edf0
1002ebfc  60000000    ori r0,r0,0x0               
1002ec00  7c7f1b78    or r31,r3,r3                
1002ec04  7fe60734    extsh r6,r31                
1002ec08  2c060000    cmpwi r6,0x0                
1002ec0c  408200b0    bne 0x1002ecbc                 ; -> 1002ecbc
1002ec10  80e1003a    lwz r7,0x3a(r1)                ; -> Stack[-0x26]
1002ec14  28070000    cmplwi r7,0x0               
1002ec18  418200a4    beq 0x1002ecbc                 ; -> 1002ecbc
1002ec1c  8101003a    lwz r8,0x3a(r1)                ; -> Stack[-0x26]
1002ec20  7fc4f378    or r4,r30,r30               
1002ec24  81080000    lwz r8,0x0(r8)              
1002ec28  81280000    lwz r9,0x0(r8)              
1002ec2c  913b0000    stw r9,0x0(r27)             
1002ec30  8141003a    lwz r10,0x3a(r1)               ; -> Stack[-0x26]
1002ec34  814a0000    lwz r10,0x0(r10)            
1002ec38  a94a0004    lha r10,0x4(r10)            
1002ec3c  b15c0000    sth r10,0x0(r28)            
1002ec40  8181003a    lwz r12,0x3a(r1)               ; -> Stack[-0x26]
1002ec44  8161003a    lwz r11,0x3a(r1)               ; -> Stack[-0x26]
1002ec48  818c0000    lwz r12,0x0(r12)            
1002ec4c  816b0000    lwz r11,0x0(r11)            
1002ec50  898c0006    lbz r12,0x6(r12)            
1002ec54  386b0006    addi r3,r11,0x6             
1002ec58  38ac0001    addi r5,r12,0x1             
1002ec5c  48002805    bl 0x10031460                  ; -> 10031460
1002ec60  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002ec64  80c1003a    lwz r6,0x3a(r1)                ; -> Stack[-0x26]
1002ec68  8081003a    lwz r4,0x3a(r1)                ; -> Stack[-0x26]
1002ec6c  80c60000    lwz r6,0x0(r6)              
1002ec70  88fe0000    lbz r7,0x0(r30)             
1002ec74  80840000    lwz r4,0x0(r4)              
1002ec78  88be0000    lbz r5,0x0(r30)             
1002ec7c  7ce73214    add r7,r7,r6                
1002ec80  7ca52214    add r5,r5,r4                
1002ec84  88e70007    lbz r7,0x7(r7)              
1002ec88  38650007    addi r3,r5,0x7              
1002ec8c  8081008c    lwz r4,0x8c(r1)                ; -> Stack[0x2c]
1002ec90  38a70001    addi r5,r7,0x1              
1002ec94  480027cd    bl 0x10031460                  ; -> 10031460
1002ec98  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002ec9c  8061003a    lwz r3,0x3a(r1)                ; -> Stack[-0x26]
1002eca0  480023b9    bl 0x10031058                  ; -> 10031058
1002eca4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002eca8  48002909    bl 0x100315b0                  ; -> 100315b0
1002ecac  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002ecb0  7c7f1b78    or r31,r3,r3                
1002ecb4  48000008    b 0x1002ecbc                   ; -> 1002ecbc
1002ecb8  3be0ffce    li r31,-0x32                
1002ecbc  7fe3fb78    or r3,r31,r31               
1002ecc0  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1002ecc4  38210060    addi r1,r1,0x60             
1002ecc8  7c0803a6    mtspr LR,r0                 
1002eccc  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
1002ecd0  4e800020    blr                         
