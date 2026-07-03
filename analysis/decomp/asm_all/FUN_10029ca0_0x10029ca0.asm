; FUN_10029ca0 @ 0x10029ca0
10029ca0  7c0802a6    mfspr r0,LR                 
10029ca4  be41ffc8    stmw r18,-0x38(r1)             ; -> Stack[-0x38]
10029ca8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10029cac  9421ff50    stwu r1,-0xb0(r1)              ; -> Stack[-0xb0]
10029cb0  3ae26840    addi r23,r2,0x6840          
10029cb4  38600000    li r3,0x0                   
10029cb8  98770090    stb r3,0x90(r23)            
10029cbc  38800000    li r4,0x0                   
10029cc0  98970091    stb r4,0x91(r23)            
10029cc4  38a00000    li r5,0x0                   
10029cc8  98b70092    stb r5,0x92(r23)            
10029ccc  38c00000    li r6,0x0                   
10029cd0  98d70094    stb r6,0x94(r23)            
10029cd4  38e00000    li r7,0x0                   
10029cd8  98f70093    stb r7,0x93(r23)            
10029cdc  39000000    li r8,0x0                   
10029ce0  3ac27559    addi r22,r2,0x7559          
10029ce4  9917008e    stb r8,0x8e(r23)            
10029ce8  39200000    li r9,0x0                   
10029cec  9937008f    stb r9,0x8f(r23)            
10029cf0  89560000    lbz r10,0x0(r22)            
10029cf4  3a62759c    addi r19,r2,0x759c          
10029cf8  554a07bc    rlwinm r10,r10,0x0,0x1e,0x1e
10029cfc  2c0a0000    cmpwi r10,0x0               
10029d00  3a427558    addi r18,r2,0x7558          
10029d04  3a82755c    addi r20,r2,0x755c          
10029d08  3b62758c    addi r27,r2,0x758c          
10029d0c  3b827554    addi r28,r2,0x7554          
10029d10  3b22757c    addi r25,r2,0x757c          
10029d14  4081000c    ble 0x10029d20                 ; -> 10029d20
10029d18  39600001    li r11,0x1                  
10029d1c  9977008e    stb r11,0x8e(r23)           
10029d20  89960000    lbz r12,0x0(r22)            
10029d24  558c07fe    rlwinm r12,r12,0x0,0x1f,0x1f
10029d28  2c0c0000    cmpwi r12,0x0               
10029d2c  4182000c    beq 0x10029d38                 ; -> 10029d38
10029d30  38600001    li r3,0x1                   
10029d34  9877008f    stb r3,0x8f(r23)            
10029d38  88960000    lbz r4,0x0(r22)             
10029d3c  5484077a    rlwinm r4,r4,0x0,0x1d,0x1d  
10029d40  2c040000    cmpwi r4,0x0                
10029d44  4182000c    beq 0x10029d50                 ; -> 10029d50
10029d48  38a00001    li r5,0x1                   
10029d4c  98b70090    stb r5,0x90(r23)            
10029d50  88d60000    lbz r6,0x0(r22)             
10029d54  54c60738    rlwinm r6,r6,0x0,0x1c,0x1c  
10029d58  2c060000    cmpwi r6,0x0                
10029d5c  4182000c    beq 0x10029d68                 ; -> 10029d68
10029d60  38e00001    li r7,0x1                   
10029d64  98f70091    stb r7,0x91(r23)            
10029d68  89160000    lbz r8,0x0(r22)             
10029d6c  550806f6    rlwinm r8,r8,0x0,0x1b,0x1b  
10029d70  2c080000    cmpwi r8,0x0                
10029d74  4182000c    beq 0x10029d80                 ; -> 10029d80
10029d78  39200001    li r9,0x1                   
10029d7c  99370092    stb r9,0x92(r23)            
10029d80  89560000    lbz r10,0x0(r22)            
10029d84  554a06b4    rlwinm r10,r10,0x0,0x1a,0x1a
10029d88  2c0a0000    cmpwi r10,0x0               
10029d8c  4182000c    beq 0x10029d98                 ; -> 10029d98
10029d90  39600001    li r11,0x1                  
10029d94  99770094    stb r11,0x94(r23)           
10029d98  89960000    lbz r12,0x0(r22)            
10029d9c  558c0672    rlwinm r12,r12,0x0,0x19,0x19
10029da0  2c0c0000    cmpwi r12,0x0               
10029da4  4182000c    beq 0x10029db0                 ; -> 10029db0
10029da8  38600001    li r3,0x1                   
10029dac  98770093    stb r3,0x93(r23)            
10029db0  88920000    lbz r4,0x0(r18)             
10029db4  3884ffff    subi r4,r4,0x1              
10029db8  98920000    stb r4,0x0(r18)             
10029dbc  5484063e    rlwinm r4,r4,0x0,0x18,0x1f  
10029dc0  28040000    cmplwi r4,0x0               
10029dc4  40820034    bne 0x10029df8                 ; -> 10029df8
10029dc8  80b40000    lwz r5,0x0(r20)             
10029dcc  88a50000    lbz r5,0x0(r5)              
10029dd0  98b20000    stb r5,0x0(r18)             
10029dd4  80d40000    lwz r6,0x0(r20)             
10029dd8  38c60001    addi r6,r6,0x1              
10029ddc  90d40000    stw r6,0x0(r20)             
10029de0  80f40000    lwz r7,0x0(r20)             
10029de4  88e70000    lbz r7,0x0(r7)              
10029de8  98f60000    stb r7,0x0(r22)             
10029dec  81140000    lwz r8,0x0(r20)             
10029df0  39080001    addi r8,r8,0x1              
10029df4  91140000    stw r8,0x0(r20)             
10029df8  89320000    lbz r9,0x0(r18)             
10029dfc  28090000    cmplwi r9,0x0               
10029e00  40820288    bne 0x1002a088                 ; -> 1002a088
10029e04  815c0000    lwz r10,0x0(r28)            
10029e08  3be00000    li r31,0x0                  
10029e0c  7d4b5378    or r11,r10,r10              
10029e10  394a0001    addi r10,r10,0x1            
10029e14  915c0000    stw r10,0x0(r28)            
10029e18  8b4b0000    lbz r26,0x0(r11)            
10029e1c  48000140    b 0x10029f5c                   ; -> 10029f5c
10029e20  819c0000    lwz r12,0x0(r28)            
10029e24  7d836378    or r3,r12,r12               
10029e28  398c0001    addi r12,r12,0x1            
10029e2c  919c0000    stw r12,0x0(r28)            
10029e30  809c0000    lwz r4,0x0(r28)             
10029e34  8b030000    lbz r24,0x0(r3)             
10029e38  7c852378    or r5,r4,r4                 
10029e3c  38840001    addi r4,r4,0x1              
10029e40  909c0000    stw r4,0x0(r28)             
10029e44  88650000    lbz r3,0x0(r5)              
10029e48  48004865    bl 0x1002e6ac                  ; -> 1002e6ac
10029e4c  60000000    ori r0,r0,0x0               
10029e50  80dc0000    lwz r6,0x0(r28)             
10029e54  7c7e1b78    or r30,r3,r3                
10029e58  7cc73378    or r7,r6,r6                 
10029e5c  38c60001    addi r6,r6,0x1              
10029e60  90dc0000    stw r6,0x0(r28)             
10029e64  88670000    lbz r3,0x0(r7)              
10029e68  48004855    bl 0x1002e6bc                  ; -> 1002e6bc
10029e6c  60000000    ori r0,r0,0x0               
10029e70  89530000    lbz r10,0x0(r19)            
10029e74  a9390002    lha r9,0x2(r25)             
10029e78  a9190000    lha r8,0x0(r25)             
10029e7c  7c7d1b78    or r29,r3,r3                
10029e80  280a0000    cmplwi r10,0x0              
10029e84  7fbd4214    add r29,r29,r8              
10029e88  7fde4a14    add r30,r30,r9              
10029e8c  41820024    beq 0x10029eb0                 ; -> 10029eb0
10029e90  7fcb0734    extsh r11,r30               
10029e94  7fa30734    extsh r3,r29                
10029e98  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
10029e9c  39800005    li r12,0x5                  
10029ea0  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10029ea4  38800005    li r4,0x5                   
10029ea8  7fcb63d6    divw r30,r11,r12            
10029eac  7fa323d6    divw r29,r3,r4              
10029eb0  7f03c378    or r3,r24,r24               
10029eb4  48007d15    bl 0x10031bc8                  ; -> 10031bc8
10029eb8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
10029ebc  57e5063e    rlwinm r5,r31,0x0,0x18,0x1f 
10029ec0  57e7063e    rlwinm r7,r31,0x0,0x18,0x1f 
10029ec4  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
10029ec8  38c1004c    addi r6,r1,0x4c             
10029ecc  7c66292e    stwx r3,r6,r5                  ; -> Stack[-0x64]
10029ed0  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
10029ed4  3901004c    addi r8,r1,0x4c             
10029ed8  7d08382e    lwzx r8,r8,r7                  ; -> Stack[-0x64]
10029edc  81080000    lwz r8,0x0(r8)              
10029ee0  81280002    lwz r9,0x2(r8)              
10029ee4  81480006    lwz r10,0x6(r8)             
10029ee8  91210068    stw r9,0x68(r1)                ; -> Stack[-0x48]
10029eec  9141006c    stw r10,0x6c(r1)               ; -> Stack[-0x44]
10029ef0  a9610068    lha r11,0x68(r1)               ; -> Stack[-0x48]
10029ef4  a981006c    lha r12,0x6c(r1)               ; -> Stack[-0x44]
10029ef8  7d6bea14    add r11,r11,r29             
10029efc  a861006a    lha r3,0x6a(r1)                ; -> Stack[-0x46]
10029f00  a881006e    lha r4,0x6e(r1)                ; -> Stack[-0x42]
10029f04  b1610060    sth r11,0x60(r1)               ; -> Stack[-0x50]
10029f08  7d8cea14    add r12,r12,r29             
10029f0c  b1810064    sth r12,0x64(r1)               ; -> Stack[-0x4c]
10029f10  7c63f214    add r3,r3,r30               
10029f14  b0610062    sth r3,0x62(r1)                ; -> Stack[-0x4e]
10029f18  7c84f214    add r4,r4,r30               
10029f1c  b0810066    sth r4,0x66(r1)                ; -> Stack[-0x4a]
10029f20  38610060    addi r3,r1,0x60             
10029f24  4bfda991    bl 0x100048b4                  ; -> 100048b4
10029f28  60000000    ori r0,r0,0x0               
10029f2c  57e5063e    rlwinm r5,r31,0x0,0x18,0x1f 
10029f30  57e7063e    rlwinm r7,r31,0x0,0x18,0x1f 
10029f34  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
10029f38  38c10038    addi r6,r1,0x38             
10029f3c  7c66292e    stwx r3,r6,r5                  ; -> Stack[-0x78]
10029f40  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
10029f44  3901004c    addi r8,r1,0x4c             
10029f48  7c68382e    lwzx r3,r8,r7                  ; -> Stack[-0x64]
10029f4c  38810060    addi r4,r1,0x60             
10029f50  48007c91    bl 0x10031be0                  ; -> 10031be0
10029f54  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
10029f58  3bff0001    addi r31,r31,0x1            
10029f5c  57e9063e    rlwinm r9,r31,0x0,0x18,0x1f 
10029f60  574a063e    rlwinm r10,r26,0x0,0x18,0x1f
10029f64  7c095040    cmplw r9,r10                
10029f68  4180feb8    blt 0x10029e20                 ; -> 10029e20
10029f6c  4800705d    bl 0x10030fc8                  ; -> 10030fc8
10029f70  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
10029f74  3aa300c8    addi r21,r3,0xc8            
10029f78  7f63db78    or r3,r27,r27               
10029f7c  4800824d    bl 0x100321c8                  ; -> 100321c8
10029f80  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
10029f84  48000010    b 0x10029f94                   ; -> 10029f94
10029f88  7f63db78    or r3,r27,r27               
10029f8c  4800823d    bl 0x100321c8                  ; -> 100321c8
10029f90  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
10029f94  48007035    bl 0x10030fc8                  ; -> 10030fc8
10029f98  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
10029f9c  7c03a840    cmplw r3,r21                
10029fa0  40800040    bge 0x10029fe0                 ; -> 10029fe0
10029fa4  48007b4d    bl 0x10031af0                  ; -> 10031af0
10029fa8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
10029fac  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10029fb0  28030000    cmplwi r3,0x0               
10029fb4  4082002c    bne 0x10029fe0                 ; -> 10029fe0
10029fb8  38603100    li r3,0x3100                
10029fbc  480033cd    bl 0x1002d388                  ; -> 1002d388
10029fc0  60000000    ori r0,r0,0x0               
10029fc4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10029fc8  28030000    cmplwi r3,0x0               
10029fcc  4182ffbc    beq 0x10029f88                 ; -> 10029f88
10029fd0  48000010    b 0x10029fe0                   ; -> 10029fe0
10029fd4  7f63db78    or r3,r27,r27               
10029fd8  480081f1    bl 0x100321c8                  ; -> 100321c8
10029fdc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
10029fe0  48007b11    bl 0x10031af0                  ; -> 10031af0
10029fe4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
10029fe8  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10029fec  28030000    cmplwi r3,0x0               
10029ff0  4082ffe4    bne 0x10029fd4                 ; -> 10029fd4
10029ff4  38603100    li r3,0x3100                
10029ff8  48003391    bl 0x1002d388                  ; -> 1002d388
10029ffc  60000000    ori r0,r0,0x0               
1002a000  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002a004  28030000    cmplwi r3,0x0               
1002a008  4082ffcc    bne 0x10029fd4                 ; -> 10029fd4
1002a00c  3be00000    li r31,0x0                  
1002a010  48000038    b 0x1002a048                   ; -> 1002a048
1002a014  57eb063e    rlwinm r11,r31,0x0,0x18,0x1f
1002a018  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1002a01c  39810038    addi r12,r1,0x38            
1002a020  7c6c582e    lwzx r3,r12,r11                ; -> Stack[-0x78]
1002a024  4bfda9b5    bl 0x100049d8                  ; -> 100049d8
1002a028  60000000    ori r0,r0,0x0               
1002a02c  57e4063e    rlwinm r4,r31,0x0,0x18,0x1f 
1002a030  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002a034  38a1004c    addi r5,r1,0x4c             
1002a038  7c65202e    lwzx r3,r5,r4                  ; -> Stack[-0x64]
1002a03c  48007725    bl 0x10031760                  ; -> 10031760
1002a040  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1002a044  3bff0001    addi r31,r31,0x1            
1002a048  57e6063e    rlwinm r6,r31,0x0,0x18,0x1f 
1002a04c  5747063e    rlwinm r7,r26,0x0,0x18,0x1f 
1002a050  7c063840    cmplw r6,r7                 
1002a054  4180ffc0    blt 0x1002a014                 ; -> 1002a014
1002a058  81140000    lwz r8,0x0(r20)             
1002a05c  89080000    lbz r8,0x0(r8)              
1002a060  99120000    stb r8,0x0(r18)             
1002a064  81340000    lwz r9,0x0(r20)             
1002a068  39290001    addi r9,r9,0x1              
1002a06c  91340000    stw r9,0x0(r20)             
1002a070  81540000    lwz r10,0x0(r20)            
1002a074  894a0000    lbz r10,0x0(r10)            
1002a078  99560000    stb r10,0x0(r22)            
1002a07c  81740000    lwz r11,0x0(r20)            
1002a080  396b0001    addi r11,r11,0x1            
1002a084  91740000    stw r11,0x0(r20)            
1002a088  800100b8    lwz r0,0xb8(r1)                ; -> Stack[0x8]
1002a08c  382100b0    addi r1,r1,0xb0             
1002a090  7c0803a6    mtspr LR,r0                 
1002a094  ba41ffc8    lmw r18,-0x38(r1)              ; -> Stack[-0x38]
1002a098  4e800020    blr                         
