; FUN_1002f338 @ 0x1002f338
1002f338  7c0802a6    mfspr r0,LR                 
1002f33c  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
1002f340  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002f344  9421ff50    stwu r1,-0xb0(r1)              ; -> Stack[-0xb0]
1002f348  7c7b1b78    or r27,r3,r3                
1002f34c  7c9c2378    or r28,r4,r4                
1002f350  7cb92b78    or r25,r5,r5                
1002f354  28190000    cmplwi r25,0x0              
1002f358  3be00000    li r31,0x0                  
1002f35c  418201c0    beq 0x1002f51c                 ; -> 1002f51c
1002f360  3c807072    lis r4,0x7072               
1002f364  3ba00000    li r29,0x0                  
1002f368  38608000    li r3,-0x8000               
1002f36c  38846566    addi r4,r4,0x6566           
1002f370  38a00001    li r5,0x1                   
1002f374  38c10082    addi r6,r1,0x82             
1002f378  38e10084    addi r7,r1,0x84             
1002f37c  480020cd    bl 0x10031448                  ; -> 10031448
1002f380  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1002f384  7c7f1b78    or r31,r3,r3                
1002f388  7fe30734    extsh r3,r31                
1002f38c  2c030000    cmpwi r3,0x0                
1002f390  38a00000    li r5,0x0                   
1002f394  38c10082    addi r6,r1,0x82             
1002f398  7c800026    mfcr r4                     
1002f39c  549a1ffe    rlwinm r26,r4,0x3,0x1f,0x1f 
1002f3a0  3c806d61    lis r4,0x6d61               
1002f3a4  38608000    li r3,-0x8000               
1002f3a8  38846373    addi r4,r4,0x6373           
1002f3ac  38e10088    addi r7,r1,0x88             
1002f3b0  48002099    bl 0x10031448                  ; -> 10031448
1002f3b4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1002f3b8  7c7f1b78    or r31,r3,r3                
1002f3bc  7fe50734    extsh r5,r31                
1002f3c0  2c050000    cmpwi r5,0x0                
1002f3c4  40820154    bne 0x1002f518                 ; -> 1002f518
1002f3c8  5746063e    rlwinm r6,r26,0x0,0x18,0x1f 
1002f3cc  28060000    cmplwi r6,0x0               
1002f3d0  3bc00001    li r30,0x1                  
1002f3d4  4182007c    beq 0x1002f450                 ; -> 1002f450
1002f3d8  a8810082    lha r4,0x82(r1)                ; -> Stack[-0x2e]
1002f3dc  38600000    li r3,0x0                   
1002f3e0  7f65db78    or r5,r27,r27               
1002f3e4  7f86e378    or r6,r28,r28               
1002f3e8  38e1003c    addi r7,r1,0x3c             
1002f3ec  39000001    li r8,0x1                   
1002f3f0  39210038    addi r9,r1,0x38             
1002f3f4  7fcaf378    or r10,r30,r30              
1002f3f8  480016d5    bl 0x10030acc                  ; -> 10030acc
1002f3fc  60000000    ori r0,r0,0x0               
1002f400  80e10038    lwz r7,0x38(r1)                ; -> Stack[-0x78]
1002f404  7c7f1b78    or r31,r3,r3                
1002f408  2c070001    cmpwi r7,0x1                
1002f40c  3bc00000    li r30,0x0                  
1002f410  40820028    bne 0x1002f438                 ; -> 1002f438
1002f414  a8610082    lha r3,0x82(r1)                ; -> Stack[-0x2e]
1002f418  8081003e    lwz r4,0x3e(r1)                ; -> Stack[-0x72]
1002f41c  80a10084    lwz r5,0x84(r1)                ; -> Stack[-0x2c]
1002f420  48000119    bl 0x1002f538                  ; -> 1002f538
1002f424  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002f428  28030000    cmplwi r3,0x0               
1002f42c  4182000c    beq 0x1002f438                 ; -> 1002f438
1002f430  3ba00001    li r29,0x1                  
1002f434  4800001c    b 0x1002f450                   ; -> 1002f450
1002f438  7fe80734    extsh r8,r31                
1002f43c  2c080000    cmpwi r8,0x0                
1002f440  4182ff98    beq 0x1002f3d8                 ; -> 1002f3d8
1002f444  7fe90734    extsh r9,r31                
1002f448  2c09fae8    cmpwi r9,-0x518             
1002f44c  4182ff8c    beq 0x1002f3d8                 ; -> 1002f3d8
1002f450  57aa063e    rlwinm r10,r29,0x0,0x18,0x1f
1002f454  280a0000    cmplwi r10,0x0              
1002f458  40820074    bne 0x1002f4cc                 ; -> 1002f4cc
1002f45c  3bc00001    li r30,0x1                  
1002f460  a8810082    lha r4,0x82(r1)                ; -> Stack[-0x2e]
1002f464  38600000    li r3,0x0                   
1002f468  7f65db78    or r5,r27,r27               
1002f46c  7f86e378    or r6,r28,r28               
1002f470  38e1003c    addi r7,r1,0x3c             
1002f474  39000001    li r8,0x1                   
1002f478  39210038    addi r9,r1,0x38             
1002f47c  7fcaf378    or r10,r30,r30              
1002f480  4800164d    bl 0x10030acc                  ; -> 10030acc
1002f484  60000000    ori r0,r0,0x0               
1002f488  81610038    lwz r11,0x38(r1)               ; -> Stack[-0x78]
1002f48c  7c7f1b78    or r31,r3,r3                
1002f490  2c0b0001    cmpwi r11,0x1               
1002f494  3bc00000    li r30,0x0                  
1002f498  4082001c    bne 0x1002f4b4                 ; -> 1002f4b4
1002f49c  8181003e    lwz r12,0x3e(r1)               ; -> Stack[-0x72]
1002f4a0  80610088    lwz r3,0x88(r1)                ; -> Stack[-0x28]
1002f4a4  7c0c1800    cmpw r12,r3                 
1002f4a8  4082000c    bne 0x1002f4b4                 ; -> 1002f4b4
1002f4ac  3ba00001    li r29,0x1                  
1002f4b0  4800001c    b 0x1002f4cc                   ; -> 1002f4cc
1002f4b4  7fe40734    extsh r4,r31                
1002f4b8  2c040000    cmpwi r4,0x0                
1002f4bc  4182ffa4    beq 0x1002f460                 ; -> 1002f460
1002f4c0  7fe50734    extsh r5,r31                
1002f4c4  2c05fae8    cmpwi r5,-0x518             
1002f4c8  4182ff98    beq 0x1002f460                 ; -> 1002f460
1002f4cc  57a6063e    rlwinm r6,r29,0x0,0x18,0x1f 
1002f4d0  28060000    cmplwi r6,0x0               
1002f4d4  4182003c    beq 0x1002f510                 ; -> 1002f510
1002f4d8  39200008    li r9,0x8                   
1002f4dc  7d2903a6    mtspr CTR,r9                
1002f4e0  38f9fff8    subi r7,r25,0x8             
1002f4e4  39010034    addi r8,r1,0x34             
1002f4e8  85480008    lwzu r10,0x8(r8)               ; -> Stack[-0x74]
1002f4ec  81680004    lwz r11,0x4(r8)                ; -> Stack[-0x70]
1002f4f0  95470008    stwu r10,0x8(r7)            
1002f4f4  91670004    stw r11,0x4(r7)             
1002f4f8  4200fff0    bdnz 0x1002f4e8                ; -> 1002f4e8
1002f4fc  81880008    lwz r12,0x8(r8)                ; -> Stack[-0x6c]
1002f500  a068000c    lhz r3,0xc(r8)                 ; -> Stack[-0x68]
1002f504  91870008    stw r12,0x8(r7)             
1002f508  b067000c    sth r3,0xc(r7)              
1002f50c  48000014    b 0x1002f520                   ; -> 1002f520
1002f510  3be0ffd5    li r31,-0x2b                
1002f514  4800000c    b 0x1002f520                   ; -> 1002f520
1002f518  48000008    b 0x1002f520                   ; -> 1002f520
1002f51c  3be0ffce    li r31,-0x32                
1002f520  7fe3fb78    or r3,r31,r31               
1002f524  800100b8    lwz r0,0xb8(r1)                ; -> Stack[0x8]
1002f528  382100b0    addi r1,r1,0xb0             
1002f52c  7c0803a6    mtspr LR,r0                 
1002f530  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
1002f534  4e800020    blr                         
