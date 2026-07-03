; FUN_1001b2c0 @ 0x1001b2c0
1001b2c0  7c0802a6    mfspr r0,LR                 
1001b2c4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001b2c8  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001b2cc  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001b2d0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001b2d4  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1001b2d8  7c7e1b78    or r30,r3,r3                
1001b2dc  a87e00a4    lha r3,0xa4(r30)            
1001b2e0  38a10044    addi r5,r1,0x44             
1001b2e4  3be30001    addi r31,r3,0x1             
1001b2e8  7fc3f378    or r3,r30,r30               
1001b2ec  7fe4fb78    or r4,r31,r31               
1001b2f0  38c10040    addi r6,r1,0x40             
1001b2f4  38e10038    addi r7,r1,0x38             
1001b2f8  48015ee1    bl 0x100311d8                  ; -> 100311d8
1001b2fc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001b300  38610046    addi r3,r1,0x46             
1001b304  48015eed    bl 0x100311f0                  ; -> 100311f0
1001b308  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001b30c  80610046    lwz r3,0x46(r1)                ; -> Stack[-0x1a]
1001b310  38810038    addi r4,r1,0x38             
1001b314  48015ef5    bl 0x10031208                  ; -> 10031208
1001b318  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001b31c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1001b320  28030000    cmplwi r3,0x0               
1001b324  41820024    beq 0x1001b348                 ; -> 1001b348
1001b328  38600001    li r3,0x1                   
1001b32c  48015ef5    bl 0x10031220                  ; -> 10031220
1001b330  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001b334  7c7d1b78    or r29,r3,r3                
1001b338  807d0000    lwz r3,0x0(r29)             
1001b33c  48015dad    bl 0x100310e8                  ; -> 100310e8
1001b340  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001b344  4800000c    b 0x1001b350                   ; -> 1001b350
1001b348  48015c09    bl 0x10030f50                  ; -> 10030f50
1001b34c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001b350  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1001b354  38210060    addi r1,r1,0x60             
1001b358  7c0803a6    mtspr LR,r0                 
1001b35c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001b360  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001b364  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001b368  4e800020    blr                         
