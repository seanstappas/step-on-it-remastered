; FUN_10025e08 @ 0x10025e08
10025e08  7c0802a6    mfspr r0,LR                 
10025e0c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10025e10  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10025e14  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10025e18  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10025e1c  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
10025e20  3bc270ec    addi r30,r2,0x70ec          
10025e24  a861006a    lha r3,0x6a(r1)                ; -> Stack[0x1a]
10025e28  4800bda1    bl 0x10031bc8                  ; -> 10031bc8
10025e2c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10025e30  7c7f1b78    or r31,r3,r3                
10025e34  281f0000    cmplwi r31,0x0              
10025e38  40820014    bne 0x10025e4c                 ; -> 10025e4c
10025e3c  38600005    li r3,0x5                   
10025e40  4bff34b9    bl 0x100192f8                  ; -> 100192f8
10025e44  60000000    ori r0,r0,0x0               
10025e48  480000b8    b 0x10025f00                   ; -> 10025f00
10025e4c  4bfdac01    bl 0x10000a4c                  ; -> 10000a4c
10025e50  60000000    ori r0,r0,0x0               
10025e54  38827570    addi r4,r2,0x7570           
10025e58  80640000    lwz r3,0x0(r4)              
10025e5c  4800b365    bl 0x100311c0                  ; -> 100311c0
10025e60  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10025e64  38a2756c    addi r5,r2,0x756c           
10025e68  80650000    lwz r3,0x0(r5)              
10025e6c  4800bc55    bl 0x10031ac0                  ; -> 10031ac0
10025e70  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10025e74  38c00000    li r6,0x0                   
10025e78  b0de0002    sth r6,0x2(r30)             
10025e7c  38e00000    li r7,0x0                   
10025e80  b0fe0000    sth r7,0x0(r30)             
10025e84  39000000    li r8,0x0                   
10025e88  b11e0004    sth r8,0x4(r30)             
10025e8c  7fc3f378    or r3,r30,r30               
10025e90  4800bd09    bl 0x10031b98                  ; -> 10031b98
10025e94  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10025e98  38627584    addi r3,r2,0x7584           
10025e9c  4800bd15    bl 0x10031bb0                  ; -> 10031bb0
10025ea0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10025ea4  813f0000    lwz r9,0x0(r31)             
10025ea8  38610038    addi r3,r1,0x38             
10025eac  81490002    lwz r10,0x2(r9)             
10025eb0  81690006    lwz r11,0x6(r9)             
10025eb4  91410038    stw r10,0x38(r1)               ; -> Stack[-0x18]
10025eb8  9161003c    stw r11,0x3c(r1)               ; -> Stack[-0x14]
10025ebc  48000489    bl 0x10026344                  ; -> 10026344
10025ec0  60000000    ori r0,r0,0x0               
10025ec4  7fe3fb78    or r3,r31,r31               
10025ec8  38825336    addi r4,r2,0x5336           
10025ecc  4800bd15    bl 0x10031be0                  ; -> 10031be0
10025ed0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10025ed4  7fe3fb78    or r3,r31,r31               
10025ed8  4800b889    bl 0x10031760                  ; -> 10031760
10025edc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10025ee0  39827568    addi r12,r2,0x7568          
10025ee4  806c0000    lwz r3,0x0(r12)             
10025ee8  4800b2d9    bl 0x100311c0                  ; -> 100311c0
10025eec  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10025ef0  38827564    addi r4,r2,0x7564           
10025ef4  80640000    lwz r3,0x0(r4)              
10025ef8  4800bbc9    bl 0x10031ac0                  ; -> 10031ac0
10025efc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10025f00  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10025f04  38210050    addi r1,r1,0x50             
10025f08  7c0803a6    mtspr LR,r0                 
10025f0c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10025f10  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10025f14  4e800020    blr                         
