; FUN_10021c14 @ 0x10021c14
10021c14  7c0802a6    mfspr r0,LR                 
10021c18  bf01ffe0    stmw r24,-0x20(r1)             ; -> Stack[-0x20]
10021c1c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10021c20  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10021c24  38625324    addi r3,r2,0x5324           
10021c28  3b625328    addi r27,r2,0x5328          
10021c2c  88630000    lbz r3,0x0(r3)              
10021c30  28030000    cmplwi r3,0x0               
10021c34  41820218    beq 0x10021e4c                 ; -> 10021e4c
10021c38  4800f379    bl 0x10030fb0                  ; -> 10030fb0
10021c3c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021c40  38827564    addi r4,r2,0x7564           
10021c44  90610038    stw r3,0x38(r1)                ; -> Stack[-0x28]
10021c48  80840000    lwz r4,0x0(r4)              
10021c4c  80840000    lwz r4,0x0(r4)              
10021c50  83240016    lwz r25,0x16(r4)            
10021c54  80b90000    lwz r5,0x0(r25)             
10021c58  80a5002a    lwz r5,0x2a(r5)             
10021c5c  80a50000    lwz r5,0x0(r5)              
10021c60  83050000    lwz r24,0x0(r5)             
10021c64  4800f365    bl 0x10030fc8                  ; -> 10030fc8
10021c68  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021c6c  3ba30001    addi r29,r3,0x1             
10021c70  3bc00001    li r30,0x1                  
10021c74  4800016c    b 0x10021de0                   ; -> 10021de0
10021c78  80db0000    lwz r6,0x0(r27)             
10021c7c  3861003c    addi r3,r1,0x3c             
10021c80  90c1003c    stw r6,0x3c(r1)                ; -> Stack[-0x24]
10021c84  4800f35d    bl 0x10030fe0                  ; -> 10030fe0
10021c88  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021c8c  8061003c    lwz r3,0x3c(r1)                ; -> Stack[-0x24]
10021c90  4800f369    bl 0x10030ff8                  ; -> 10030ff8
10021c94  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021c98  3be00000    li r31,0x0                  
10021c9c  480000bc    b 0x10021d58                   ; -> 10021d58
10021ca0  80e1003c    lwz r7,0x3c(r1)                ; -> Stack[-0x24]
10021ca4  7fe80734    extsh r8,r31                
10021ca8  80e70000    lwz r7,0x0(r7)              
10021cac  8141003c    lwz r10,0x3c(r1)               ; -> Stack[-0x24]
10021cb0  55081838    rlwinm r8,r8,0x3,0x0,0x1c   
10021cb4  38e7000a    addi r7,r7,0xa              
10021cb8  7ce7422e    lhzx r7,r7,r8               
10021cbc  3920000a    li r9,0xa                   
10021cc0  7ce74bd6    divw r7,r7,r9               
10021cc4  7ce7f1d6    mullw r7,r7,r30             
10021cc8  814a0000    lwz r10,0x0(r10)            
10021ccc  7feb0734    extsh r11,r31               
10021cd0  556b1838    rlwinm r11,r11,0x3,0x0,0x1c 
10021cd4  394a000a    addi r10,r10,0xa            
10021cd8  7cea5b2e    sthx r7,r10,r11             
10021cdc  8181003c    lwz r12,0x3c(r1)               ; -> Stack[-0x24]
10021ce0  7fe30734    extsh r3,r31                
10021ce4  818c0000    lwz r12,0x0(r12)            
10021ce8  54631838    rlwinm r3,r3,0x3,0x0,0x1c   
10021cec  398c000c    addi r12,r12,0xc            
10021cf0  7d8c1a2e    lhzx r12,r12,r3             
10021cf4  3880000a    li r4,0xa                   
10021cf8  7d8c23d6    divw r12,r12,r4             
10021cfc  80a1003c    lwz r5,0x3c(r1)                ; -> Stack[-0x24]
10021d00  7fe60734    extsh r6,r31                
10021d04  80a50000    lwz r5,0x0(r5)              
10021d08  7d8cf1d6    mullw r12,r12,r30           
10021d0c  7fe80734    extsh r8,r31                
10021d10  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
10021d14  38a5000c    addi r5,r5,0xc              
10021d18  7d85332e    sthx r12,r5,r6              
10021d1c  80e1003c    lwz r7,0x3c(r1)                ; -> Stack[-0x24]
10021d20  55081838    rlwinm r8,r8,0x3,0x0,0x1c   
10021d24  80e70000    lwz r7,0x0(r7)              
10021d28  3920000a    li r9,0xa                   
10021d2c  38e7000e    addi r7,r7,0xe              
10021d30  7ce7422e    lhzx r7,r7,r8               
10021d34  7feb0734    extsh r11,r31               
10021d38  7ce74bd6    divw r7,r7,r9               
10021d3c  8141003c    lwz r10,0x3c(r1)               ; -> Stack[-0x24]
10021d40  7ce7f1d6    mullw r7,r7,r30             
10021d44  814a0000    lwz r10,0x0(r10)            
10021d48  556b1838    rlwinm r11,r11,0x3,0x0,0x1c 
10021d4c  394a000e    addi r10,r10,0xe            
10021d50  7cea5b2e    sthx r7,r10,r11             
10021d54  3bff0001    addi r31,r31,0x1            
10021d58  8061003c    lwz r3,0x3c(r1)                ; -> Stack[-0x24]
10021d5c  7fec0734    extsh r12,r31               
10021d60  80630000    lwz r3,0x0(r3)              
10021d64  a8630006    lha r3,0x6(r3)              
10021d68  7c0c1800    cmpw r12,r3                 
10021d6c  4081ff34    ble 0x10021ca0                 ; -> 10021ca0
10021d70  8061003c    lwz r3,0x3c(r1)                ; -> Stack[-0x24]
10021d74  4800f29d    bl 0x10031010                  ; -> 10031010
10021d78  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021d7c  48000008    b 0x10021d84                   ; -> 10021d84
10021d80  3b800000    li r28,0x0                  
10021d84  4800f245    bl 0x10030fc8                  ; -> 10030fc8
10021d88  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021d8c  7c1d1840    cmplw r29,r3                
10021d90  4181fff0    bgt 0x10021d80                 ; -> 10021d80
10021d94  4800f235    bl 0x10030fc8                  ; -> 10030fc8
10021d98  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021d9c  80a1003c    lwz r5,0x3c(r1)                ; -> Stack[-0x24]
10021da0  80c1003c    lwz r6,0x3c(r1)                ; -> Stack[-0x24]
10021da4  80a50000    lwz r5,0x0(r5)              
10021da8  3ba30001    addi r29,r3,0x1             
10021dac  a8850006    lha r4,0x6(r5)              
10021db0  80c60000    lwz r6,0x0(r6)              
10021db4  3860ffff    li r3,-0x1                  
10021db8  38a60008    addi r5,r6,0x8              
10021dbc  4800f26d    bl 0x10031028                  ; -> 10031028
10021dc0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021dc4  4800f27d    bl 0x10031040                  ; -> 10031040
10021dc8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021dcc  7c7a0734    extsh r26,r3                
10021dd0  8061003c    lwz r3,0x3c(r1)                ; -> Stack[-0x24]
10021dd4  4800f285    bl 0x10031058                  ; -> 10031058
10021dd8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021ddc  3bde0001    addi r30,r30,0x1            
10021de0  7fc70734    extsh r7,r30                
10021de4  2c07000a    cmpwi r7,0xa                
10021de8  4180fe90    blt 0x10021c78                 ; -> 10021c78
10021dec  811b0000    lwz r8,0x0(r27)             
10021df0  813b0000    lwz r9,0x0(r27)             
10021df4  81080000    lwz r8,0x0(r8)              
10021df8  81290000    lwz r9,0x0(r9)              
10021dfc  a8880006    lha r4,0x6(r8)              
10021e00  3860ffff    li r3,-0x1                  
10021e04  38a90008    addi r5,r9,0x8              
10021e08  4800f221    bl 0x10031028                  ; -> 10031028
10021e0c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021e10  81590000    lwz r10,0x0(r25)            
10021e14  814a002a    lwz r10,0x2a(r10)           
10021e18  814a0000    lwz r10,0x0(r10)            
10021e1c  930a0000    stw r24,0x0(r10)            
10021e20  807b0000    lwz r3,0x0(r27)             
10021e24  4800f235    bl 0x10031058                  ; -> 10031058
10021e28  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021e2c  39825324    addi r12,r2,0x5324          
10021e30  39600000    li r11,0x0                  
10021e34  996c0000    stb r11,0x0(r12)            
10021e38  38600000    li r3,0x0                   
10021e3c  38800000    li r4,0x0                   
10021e40  38a00000    li r5,0x0                   
10021e44  4800f22d    bl 0x10031070                  ; -> 10031070
10021e48  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021e4c  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10021e50  38210060    addi r1,r1,0x60             
10021e54  7c0803a6    mtspr LR,r0                 
10021e58  bb01ffe0    lmw r24,-0x20(r1)              ; -> Stack[-0x20]
10021e5c  4e800020    blr                         
