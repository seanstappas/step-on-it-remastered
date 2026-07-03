; .CheckVol @ 0x1002fc34
1002fc34  7c0802a6    mfspr r0,LR                 
1002fc38  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002fc3c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002fc40  9421ff40    stwu r1,-0xc0(r1)              ; -> Stack[-0xc0]
1002fc44  906100d8    stw r3,0xd8(r1)                ; -> Stack[0x18]
1002fc48  b08100de    sth r4,0xde(r1)                ; -> Stack[0x1e]
1002fc4c  90a100e0    stw r5,0xe0(r1)                ; -> Stack[0x20]
1002fc50  90c100e4    stw r6,0xe4(r1)                ; -> Stack[0x24]
1002fc54  806100d8    lwz r3,0xd8(r1)                ; -> Stack[0x18]
1002fc58  a88100de    lha r4,0xde(r1)                ; -> Stack[0x1e]
1002fc5c  38a10038    addi r5,r1,0x38             
1002fc60  4bfffdd1    bl 0x1002fa30                  ; -> 1002fa30
1002fc64  60000000    ori r0,r0,0x0               
1002fc68  7c7f1b78    or r31,r3,r3                
1002fc6c  7fe30735    extsh. r3,r31               
1002fc70  4082003c    bne 0x1002fcac                 ; -> 1002fcac
1002fc74  a881004e    lha r4,0x4e(r1)                ; -> Stack[-0x72]
1002fc78  80a100e0    lwz r5,0xe0(r1)                ; -> Stack[0x20]
1002fc7c  b0850000    sth r4,0x0(r5)              
1002fc80  a8c1007e    lha r6,0x7e(r1)                ; -> Stack[-0x42]
1002fc84  80e10068    lwz r7,0x68(r1)                ; -> Stack[-0x58]
1002fc88  a1010066    lhz r8,0x66(r1)                ; -> Stack[-0x5a]
1002fc8c  81210056    lwz r9,0x56(r1)                ; -> Stack[-0x6a]
1002fc90  a941004e    lha r10,0x4e(r1)               ; -> Stack[-0x72]
1002fc94  7d4a4214    add r10,r10,r8              
1002fc98  7d4a3a14    add r10,r10,r7              
1002fc9c  7d4a3214    add r10,r10,r6              
1002fca0  7d295214    add r9,r9,r10               
1002fca4  816100e4    lwz r11,0xe4(r1)               ; -> Stack[0x24]
1002fca8  912b0000    stw r9,0x0(r11)             
1002fcac  7fe3fb78    or r3,r31,r31               
1002fcb0  800100c8    lwz r0,0xc8(r1)                ; -> Stack[0x8]
1002fcb4  382100c0    addi r1,r1,0xc0             
1002fcb8  7c0803a6    mtspr LR,r0                 
1002fcbc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002fcc0  4e800020    blr                         
