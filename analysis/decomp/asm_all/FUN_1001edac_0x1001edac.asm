; FUN_1001edac @ 0x1001edac
1001edac  7c0802a6    mfspr r0,LR                 
1001edb0  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001edb4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001edb8  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001edbc  7c7f1b78    or r31,r3,r3                
1001edc0  7fe3fb78    or r3,r31,r31               
1001edc4  480123fd    bl 0x100311c0                  ; -> 100311c0
1001edc8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001edcc  807f0010    lwz r3,0x10(r31)            
1001edd0  809f0014    lwz r4,0x14(r31)            
1001edd4  90610038    stw r3,0x38(r1)                ; -> Stack[-0x18]
1001edd8  9081003c    stw r4,0x3c(r1)                ; -> Stack[-0x14]
1001eddc  a8a1003e    lha r5,0x3e(r1)                ; -> Stack[-0x12]
1001ede0  38610038    addi r3,r1,0x38             
1001ede4  38a5fff1    subi r5,r5,0xf              
1001ede8  b0a1003a    sth r5,0x3a(r1)                ; -> Stack[-0x16]
1001edec  48012f2d    bl 0x10031d18                  ; -> 10031d18
1001edf0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001edf4  38610038    addi r3,r1,0x38             
1001edf8  480136e9    bl 0x100324e0                  ; -> 100324e0
1001edfc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001ee00  80df0010    lwz r6,0x10(r31)            
1001ee04  80ff0014    lwz r7,0x14(r31)            
1001ee08  38610038    addi r3,r1,0x38             
1001ee0c  90c10038    stw r6,0x38(r1)                ; -> Stack[-0x18]
1001ee10  90e1003c    stw r7,0x3c(r1)                ; -> Stack[-0x14]
1001ee14  a901003c    lha r8,0x3c(r1)                ; -> Stack[-0x14]
1001ee18  3908fff1    subi r8,r8,0xf              
1001ee1c  b1010038    sth r8,0x38(r1)                ; -> Stack[-0x18]
1001ee20  48012ef9    bl 0x10031d18                  ; -> 10031d18
1001ee24  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001ee28  38610038    addi r3,r1,0x38             
1001ee2c  480136b5    bl 0x100324e0                  ; -> 100324e0
1001ee30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001ee34  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001ee38  38210050    addi r1,r1,0x50             
1001ee3c  7c0803a6    mtspr LR,r0                 
1001ee40  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001ee44  4e800020    blr                         
