; FUN_10000a4c @ 0x10000a4c
10000a4c  7c0802a6    mfspr r0,LR                 
10000a50  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10000a54  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10000a58  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10000a5c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10000a60  38600000    li r3,0x0                   
10000a64  b061003a    sth r3,0x3a(r1)                ; -> Stack[-0x16]
10000a68  b061003c    sth r3,0x3c(r1)                ; -> Stack[-0x14]
10000a6c  b0610038    sth r3,0x38(r1)                ; -> Stack[-0x18]
10000a70  38610038    addi r3,r1,0x38             
10000a74  48031125    bl 0x10031b98                  ; -> 10031b98
10000a78  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10000a7c  38a2756c    addi r5,r2,0x756c           
10000a80  38827564    addi r4,r2,0x7564           
10000a84  80a50000    lwz r5,0x0(r5)              
10000a88  80840000    lwz r4,0x0(r4)              
10000a8c  80a50000    lwz r5,0x0(r5)              
10000a90  80840000    lwz r4,0x0(r4)              
10000a94  83e50016    lwz r31,0x16(r5)            
10000a98  83c40016    lwz r30,0x16(r4)            
10000a9c  80df0000    lwz r6,0x0(r31)             
10000aa0  8066002a    lwz r3,0x2a(r6)             
10000aa4  480305b5    bl 0x10031058                  ; -> 10031058
10000aa8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10000aac  80fe0000    lwz r7,0x0(r30)             
10000ab0  3861003e    addi r3,r1,0x3e             
10000ab4  80e7002a    lwz r7,0x2a(r7)             
10000ab8  90e1003e    stw r7,0x3e(r1)                ; -> Stack[-0x12]
10000abc  48030525    bl 0x10030fe0                  ; -> 10030fe0
10000ac0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10000ac4  8101003e    lwz r8,0x3e(r1)                ; -> Stack[-0x12]
10000ac8  813f0000    lwz r9,0x0(r31)             
10000acc  9109002a    stw r8,0x2a(r9)             
10000ad0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10000ad4  38210050    addi r1,r1,0x50             
10000ad8  7c0803a6    mtspr LR,r0                 
10000adc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10000ae0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10000ae4  4e800020    blr                         
