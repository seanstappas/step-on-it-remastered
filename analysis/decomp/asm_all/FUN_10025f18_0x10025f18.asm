; FUN_10025f18 @ 0x10025f18
10025f18  7c0802a6    mfspr r0,LR                 
10025f1c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10025f20  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10025f24  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10025f28  38600000    li r3,0x0                   
10025f2c  b061003a    sth r3,0x3a(r1)                ; -> Stack[-0x16]
10025f30  38800000    li r4,0x0                   
10025f34  3be27530    addi r31,r2,0x7530          
10025f38  b0810038    sth r4,0x38(r1)                ; -> Stack[-0x18]
10025f3c  38a00000    li r5,0x0                   
10025f40  b0a1003c    sth r5,0x3c(r1)                ; -> Stack[-0x14]
10025f44  38610038    addi r3,r1,0x38             
10025f48  4800bc51    bl 0x10031b98                  ; -> 10031b98
10025f4c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10025f50  807f0000    lwz r3,0x0(r31)             
10025f54  4800b26d    bl 0x100311c0                  ; -> 100311c0
10025f58  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10025f5c  38c27570    addi r6,r2,0x7570           
10025f60  80ff0000    lwz r7,0x0(r31)             
10025f64  80c60000    lwz r6,0x0(r6)              
10025f68  38870002    addi r4,r7,0x2              
10025f6c  811f0000    lwz r8,0x0(r31)             
10025f70  38660002    addi r3,r6,0x2              
10025f74  813f0000    lwz r9,0x0(r31)             
10025f78  38c80010    addi r6,r8,0x10             
10025f7c  38a25336    addi r5,r2,0x5336           
10025f80  81090018    lwz r8,0x18(r9)             
10025f84  38e00000    li r7,0x0                   
10025f88  4800bdc1    bl 0x10031d48                  ; -> 10031d48
10025f8c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10025f90  39425324    addi r10,r2,0x5324          
10025f94  894a0000    lbz r10,0x0(r10)            
10025f98  280a0000    cmplwi r10,0x0              
10025f9c  41820008    beq 0x10025fa4                 ; -> 10025fa4
10025fa0  4bffbc75    bl 0x10021c14                  ; -> 10021c14
10025fa4  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10025fa8  38210050    addi r1,r1,0x50             
10025fac  7c0803a6    mtspr LR,r0                 
10025fb0  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10025fb4  4e800020    blr                         
