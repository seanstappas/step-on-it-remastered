; FUN_10000d90 @ 0x10000d90
10000d90  7c0802a6    mfspr r0,LR                 
10000d94  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
10000d98  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10000d9c  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10000da0  7c7d1b78    or r29,r3,r3                
10000da4  7c9b2378    or r27,r4,r4                
10000da8  90a10080    stw r5,0x80(r1)                ; -> Stack[0x20]
10000dac  7cda3378    or r26,r6,r6                
10000db0  7cff3b78    or r31,r7,r7                
10000db4  7fa40734    extsh r4,r29                
10000db8  38600000    li r3,0x0                   
10000dbc  2c040008    cmpwi r4,0x8                
10000dc0  3bc00000    li r30,0x0                  
10000dc4  90610038    stw r3,0x38(r1)                ; -> Stack[-0x28]
10000dc8  3b800000    li r28,0x0                  
10000dcc  41810020    bgt 0x10000dec                 ; -> 10000dec
10000dd0  80a10080    lwz r5,0x80(r1)                ; -> Stack[0x20]
10000dd4  38610038    addi r3,r1,0x38             
10000dd8  90a10038    stw r5,0x38(r1)                ; -> Stack[-0x28]
10000ddc  48030205    bl 0x10030fe0                  ; -> 10030fe0
10000de0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10000de4  7c7e1b78    or r30,r3,r3                
10000de8  48000020    b 0x10000e08                   ; -> 10000e08
10000dec  38600008    li r3,0x8                   
10000df0  48030749    bl 0x10031538                  ; -> 10031538
10000df4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10000df8  90610038    stw r3,0x38(r1)                ; -> Stack[-0x28]
10000dfc  480307b5    bl 0x100315b0                  ; -> 100315b0
10000e00  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10000e04  7c7e1b78    or r30,r3,r3                
10000e08  7fc60734    extsh r6,r30                
10000e0c  2c060000    cmpwi r6,0x0                
10000e10  40820184    bne 0x10000f94                 ; -> 10000f94
10000e14  a91b0000    lha r8,0x0(r27)             
10000e18  a93b0004    lha r9,0x4(r27)             
10000e1c  7f470734    extsh r7,r26                
10000e20  7d084850    subf r8,r8,r9               
10000e24  7c6839d6    mullw r3,r8,r7              
10000e28  48030669    bl 0x10031490                  ; -> 10031490
10000e2c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10000e30  7c7c1b78    or r28,r3,r3                
10000e34  281c0000    cmplwi r28,0x0              
10000e38  4182014c    beq 0x10000f84                 ; -> 10000f84
10000e3c  815f0000    lwz r10,0x0(r31)            
10000e40  634b8000    ori r11,r26,0x8000          
10000e44  938a0000    stw r28,0x0(r10)            
10000e48  819f0000    lwz r12,0x0(r31)            
10000e4c  38c00000    li r6,0x0                   
10000e50  b16c0004    sth r11,0x4(r12)            
10000e54  807f0000    lwz r3,0x0(r31)             
10000e58  809b0000    lwz r4,0x0(r27)             
10000e5c  80bb0004    lwz r5,0x4(r27)             
10000e60  39000000    li r8,0x0                   
10000e64  90830006    stw r4,0x6(r3)              
10000e68  90a3000a    stw r5,0xa(r3)              
10000e6c  80ff0000    lwz r7,0x0(r31)             
10000e70  39400000    li r10,0x0                  
10000e74  b0c7000e    sth r6,0xe(r7)              
10000e78  813f0000    lwz r9,0x0(r31)             
10000e7c  3d800048    lis r12,0x48                
10000e80  b1090010    sth r8,0x10(r9)             
10000e84  817f0000    lwz r11,0x0(r31)            
10000e88  3c800048    lis r4,0x48                 
10000e8c  914b0012    stw r10,0x12(r11)           
10000e90  807f0000    lwz r3,0x0(r31)             
10000e94  7fab0734    extsh r11,r29               
10000e98  91830016    stw r12,0x16(r3)            
10000e9c  80bf0000    lwz r5,0x0(r31)             
10000ea0  38e00000    li r7,0x0                   
10000ea4  9085001a    stw r4,0x1a(r5)             
10000ea8  80df0000    lwz r6,0x0(r31)             
10000eac  2c0b0008    cmpwi r11,0x8               
10000eb0  b3a60020    sth r29,0x20(r6)            
10000eb4  811f0000    lwz r8,0x0(r31)             
10000eb8  39200000    li r9,0x0                   
10000ebc  90e80026    stw r7,0x26(r8)             
10000ec0  815f0000    lwz r10,0x0(r31)            
10000ec4  912a002e    stw r9,0x2e(r10)            
10000ec8  41810034    bgt 0x10000efc                 ; -> 10000efc
10000ecc  807f0000    lwz r3,0x0(r31)             
10000ed0  39800000    li r12,0x0                  
10000ed4  b183001e    sth r12,0x1e(r3)            
10000ed8  80bf0000    lwz r5,0x0(r31)             
10000edc  38800001    li r4,0x1                   
10000ee0  b0850022    sth r4,0x22(r5)             
10000ee4  80df0000    lwz r6,0x0(r31)             
10000ee8  b3a60024    sth r29,0x24(r6)            
10000eec  80e10038    lwz r7,0x38(r1)                ; -> Stack[-0x28]
10000ef0  811f0000    lwz r8,0x0(r31)             
10000ef4  90e8002a    stw r7,0x2a(r8)             
10000ef8  480000a4    b 0x10000f9c                   ; -> 10000f9c
10000efc  7fa30734    extsh r3,r29                
10000f00  815f0000    lwz r10,0x0(r31)            
10000f04  39200010    li r9,0x10                  
10000f08  b12a001e    sth r9,0x1e(r10)            
10000f0c  819f0000    lwz r12,0x0(r31)            
10000f10  39600003    li r11,0x3                  
10000f14  2c030010    cmpwi r3,0x10               
10000f18  b16c0022    sth r11,0x22(r12)           
10000f1c  40820014    bne 0x10000f30                 ; -> 10000f30
10000f20  80bf0000    lwz r5,0x0(r31)             
10000f24  38800005    li r4,0x5                   
10000f28  b0850024    sth r4,0x24(r5)             
10000f2c  48000010    b 0x10000f3c                   ; -> 10000f3c
10000f30  80ff0000    lwz r7,0x0(r31)             
10000f34  38c00008    li r6,0x8                   
10000f38  b0c70024    sth r6,0x24(r7)             
10000f3c  811f0000    lwz r8,0x0(r31)             
10000f40  81210038    lwz r9,0x38(r1)                ; -> Stack[-0x28]
10000f44  a9080024    lha r8,0x24(r8)             
10000f48  81290000    lwz r9,0x0(r9)              
10000f4c  1d080003    mulli r8,r8,0x3             
10000f50  91090000    stw r8,0x0(r9)              
10000f54  81610038    lwz r11,0x38(r1)               ; -> Stack[-0x28]
10000f58  39400000    li r10,0x0                  
10000f5c  816b0000    lwz r11,0x0(r11)            
10000f60  39800000    li r12,0x0                  
10000f64  b14b0004    sth r10,0x4(r11)            
10000f68  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x28]
10000f6c  80630000    lwz r3,0x0(r3)              
10000f70  b1830006    sth r12,0x6(r3)             
10000f74  80810038    lwz r4,0x38(r1)                ; -> Stack[-0x28]
10000f78  80bf0000    lwz r5,0x0(r31)             
10000f7c  9085002a    stw r4,0x2a(r5)             
10000f80  4800001c    b 0x10000f9c                   ; -> 10000f9c
10000f84  4803062d    bl 0x100315b0                  ; -> 100315b0
10000f88  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10000f8c  7c7e1b78    or r30,r3,r3                
10000f90  4800000c    b 0x10000f9c                   ; -> 10000f9c
10000f94  38c00000    li r6,0x0                   
10000f98  90c10038    stw r6,0x38(r1)                ; -> Stack[-0x28]
10000f9c  7fc70734    extsh r7,r30                
10000fa0  2c070000    cmpwi r7,0x0                
10000fa4  4182001c    beq 0x10000fc0                 ; -> 10000fc0
10000fa8  81010038    lwz r8,0x38(r1)                ; -> Stack[-0x28]
10000fac  28080000    cmplwi r8,0x0               
10000fb0  41820010    beq 0x10000fc0                 ; -> 10000fc0
10000fb4  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x28]
10000fb8  48030a91    bl 0x10031a48                  ; -> 10031a48
10000fbc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10000fc0  7fc3f378    or r3,r30,r30               
10000fc4  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10000fc8  38210060    addi r1,r1,0x60             
10000fcc  7c0803a6    mtspr LR,r0                 
10000fd0  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
10000fd4  4e800020    blr                         
