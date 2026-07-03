; .HGetVolParms @ 0x1002f8a4
1002f8a4  7c0802a6    mfspr r0,LR                 
1002f8a8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002f8ac  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002f8b0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002f8b4  9421ff40    stwu r1,-0xc0(r1)              ; -> Stack[-0xc0]
1002f8b8  906100d8    stw r3,0xd8(r1)                ; -> Stack[0x18]
1002f8bc  b08100de    sth r4,0xde(r1)                ; -> Stack[0x1e]
1002f8c0  90a100e0    stw r5,0xe0(r1)                ; -> Stack[0x20]
1002f8c4  7cde3378    or r30,r6,r6                
1002f8c8  806100d8    lwz r3,0xd8(r1)                ; -> Stack[0x18]
1002f8cc  9061004a    stw r3,0x4a(r1)                ; -> Stack[-0x76]
1002f8d0  a88100de    lha r4,0xde(r1)                ; -> Stack[0x1e]
1002f8d4  b081004e    sth r4,0x4e(r1)                ; -> Stack[-0x72]
1002f8d8  80a100e0    lwz r5,0xe0(r1)                ; -> Stack[0x20]
1002f8dc  90a10058    stw r5,0x58(r1)                ; -> Stack[-0x68]
1002f8e0  80de0000    lwz r6,0x0(r30)             
1002f8e4  90c1005c    stw r6,0x5c(r1)                ; -> Stack[-0x64]
1002f8e8  38610038    addi r3,r1,0x38             
1002f8ec  48001bd5    bl 0x100314c0                  ; -> 100314c0
1002f8f0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0xac]
1002f8f4  7c7f1b78    or r31,r3,r3                
1002f8f8  80e10060    lwz r7,0x60(r1)                ; -> Stack[-0x60]
1002f8fc  90fe0000    stw r7,0x0(r30)             
1002f900  7fe3fb78    or r3,r31,r31               
1002f904  800100c8    lwz r0,0xc8(r1)                ; -> Stack[0x8]
1002f908  382100c0    addi r1,r1,0xc0             
1002f90c  7c0803a6    mtspr LR,r0                 
1002f910  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002f914  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002f918  4e800020    blr                         
