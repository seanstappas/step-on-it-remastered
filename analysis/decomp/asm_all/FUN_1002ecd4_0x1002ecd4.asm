; FUN_1002ecd4 @ 0x1002ecd4
1002ecd4  7c0802a6    mfspr r0,LR                 
1002ecd8  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
1002ecdc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002ece0  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1002ece4  7c791b78    or r25,r3,r3                
1002ece8  7c9c2378    or r28,r4,r4                
1002ecec  7cba2b78    or r26,r5,r5                
1002ecf0  b0c10086    sth r6,0x86(r1)                ; -> Stack[0x26]
1002ecf4  7cfd3b78    or r29,r7,r7                
1002ecf8  7d1b4378    or r27,r8,r8                
1002ecfc  7f230734    extsh r3,r25                
1002ed00  2c03ffff    cmpwi r3,-0x1               
1002ed04  3bc00000    li r30,0x0                  
1002ed08  418200cc    beq 0x1002edd4                 ; -> 1002edd4
1002ed0c  7f840734    extsh r4,r28                
1002ed10  2c040001    cmpwi r4,0x1                
1002ed14  41820010    beq 0x1002ed24                 ; -> 1002ed24
1002ed18  7f850734    extsh r5,r28                
1002ed1c  2c050002    cmpwi r5,0x2                
1002ed20  408200b4    bne 0x1002edd4                 ; -> 1002edd4
1002ed24  281a0000    cmplwi r26,0x0              
1002ed28  418200ac    beq 0x1002edd4                 ; -> 1002edd4
1002ed2c  38600206    li r3,0x206                 
1002ed30  48002a61    bl 0x10031790                  ; -> 10031790
1002ed34  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002ed38  7c7f1b78    or r31,r3,r3                
1002ed3c  281f0000    cmplwi r31,0x0              
1002ed40  41820084    beq 0x1002edc4                 ; -> 1002edc4
1002ed44  b3810038    sth r28,0x38(r1)               ; -> Stack[-0x28]
1002ed48  80df0000    lwz r6,0x0(r31)             
1002ed4c  80fa0000    lwz r7,0x0(r26)             
1002ed50  a9010086    lha r8,0x86(r1)                ; -> Stack[0x26]
1002ed54  90e60000    stw r7,0x0(r6)              
1002ed58  813f0000    lwz r9,0x0(r31)             
1002ed5c  7fa3eb78    or r3,r29,r29               
1002ed60  b1090004    sth r8,0x4(r9)              
1002ed64  815f0000    lwz r10,0x0(r31)            
1002ed68  897d0000    lbz r11,0x0(r29)            
1002ed6c  388a0006    addi r4,r10,0x6             
1002ed70  38ab0001    addi r5,r11,0x1             
1002ed74  480026ed    bl 0x10031460                  ; -> 10031460
1002ed78  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002ed7c  819f0000    lwz r12,0x0(r31)            
1002ed80  88bd0000    lbz r5,0x0(r29)             
1002ed84  88db0000    lbz r6,0x0(r27)             
1002ed88  7ca56214    add r5,r5,r12               
1002ed8c  38850007    addi r4,r5,0x7              
1002ed90  7f63db78    or r3,r27,r27               
1002ed94  38a60001    addi r5,r6,0x1              
1002ed98  480026c9    bl 0x10031460                  ; -> 10031460
1002ed9c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002eda0  3c807665    lis r4,0x7665               
1002eda4  7f23cb78    or r3,r25,r25               
1002eda8  38847273    addi r4,r4,0x7273           
1002edac  38a10038    addi r5,r1,0x38             
1002edb0  7fe6fb78    or r6,r31,r31               
1002edb4  48000191    bl 0x1002ef44                  ; -> 1002ef44
1002edb8  60000000    ori r0,r0,0x0               
1002edbc  7c7e1b78    or r30,r3,r3                
1002edc0  48000018    b 0x1002edd8                   ; -> 1002edd8
1002edc4  480027ed    bl 0x100315b0                  ; -> 100315b0
1002edc8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002edcc  7c7e1b78    or r30,r3,r3                
1002edd0  48000008    b 0x1002edd8                   ; -> 1002edd8
1002edd4  3bc0ffce    li r30,-0x32                
1002edd8  7fc3f378    or r3,r30,r30               
1002eddc  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1002ede0  38210060    addi r1,r1,0x60             
1002ede4  7c0803a6    mtspr LR,r0                 
1002ede8  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
1002edec  4e800020    blr                         
