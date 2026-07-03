; FUN_10024e70 @ 0x10024e70
10024e70  7c0802a6    mfspr r0,LR                 
10024e74  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10024e78  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10024e7c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10024e80  7c7f1b78    or r31,r3,r3                
10024e84  38610038    addi r3,r1,0x38             
10024e88  4800c321    bl 0x100311a8                  ; -> 100311a8
10024e8c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10024e90  38827530    addi r4,r2,0x7530           
10024e94  80640000    lwz r3,0x0(r4)              
10024e98  4800c329    bl 0x100311c0                  ; -> 100311c0
10024e9c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10024ea0  7fe50734    extsh r5,r31                
10024ea4  2c050001    cmpwi r5,0x1                
10024ea8  40820018    bne 0x10024ec0                 ; -> 10024ec0
10024eac  7fe3fb78    or r3,r31,r31               
10024eb0  38800023    li r4,0x23                  
10024eb4  38a000dc    li r5,0xdc                  
10024eb8  4bffee35    bl 0x10023cec                  ; -> 10023cec
10024ebc  48000014    b 0x10024ed0                   ; -> 10024ed0
10024ec0  7fe3fb78    or r3,r31,r31               
10024ec4  388000bf    li r4,0xbf                  
10024ec8  38a000dc    li r5,0xdc                  
10024ecc  4bffee21    bl 0x10023cec                  ; -> 10023cec
10024ed0  38c27570    addi r6,r2,0x7570           
10024ed4  80660000    lwz r3,0x0(r6)              
10024ed8  4800c2e9    bl 0x100311c0                  ; -> 100311c0
10024edc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10024ee0  38e2756c    addi r7,r2,0x756c           
10024ee4  80670000    lwz r3,0x0(r7)              
10024ee8  4800cbd9    bl 0x10031ac0                  ; -> 10031ac0
10024eec  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10024ef0  38600001    li r3,0x1                   
10024ef4  38800023    li r4,0x23                  
10024ef8  38a000de    li r5,0xde                  
10024efc  4bffe639    bl 0x10023534                  ; -> 10023534
10024f00  38600002    li r3,0x2                   
10024f04  388000bf    li r4,0xbf                  
10024f08  38a000de    li r5,0xde                  
10024f0c  4bffe629    bl 0x10023534                  ; -> 10023534
10024f10  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x18]
10024f14  4800c2ad    bl 0x100311c0                  ; -> 100311c0
10024f18  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10024f1c  39027564    addi r8,r2,0x7564           
10024f20  80680000    lwz r3,0x0(r8)              
10024f24  4800cb9d    bl 0x10031ac0                  ; -> 10031ac0
10024f28  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10024f2c  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10024f30  38210050    addi r1,r1,0x50             
10024f34  7c0803a6    mtspr LR,r0                 
10024f38  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10024f3c  4e800020    blr                         
