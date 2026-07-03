; FUN_10026bb8 @ 0x10026bb8
10026bb8  7c0802a6    mfspr r0,LR                 
10026bbc  bde1ffbc    stmw r15,-0x44(r1)             ; -> Stack[-0x44]
10026bc0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10026bc4  9421ff70    stwu r1,-0x90(r1)              ; -> Stack[-0x90]
10026bc8  b06100aa    sth r3,0xaa(r1)                ; -> Stack[0x1a]
10026bcc  b08100ae    sth r4,0xae(r1)                ; -> Stack[0x1e]
10026bd0  b0c100b6    sth r6,0xb6(r1)                ; -> Stack[0x26]
10026bd4  3b4270f8    addi r26,r2,0x70f8          
10026bd8  3ac2757c    addi r22,r2,0x757c          
10026bdc  4bfdc909    bl 0x100034e4                  ; -> 100034e4
10026be0  60000000    ori r0,r0,0x0               
10026be4  4800a3cd    bl 0x10030fb0                  ; -> 10030fb0
10026be8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026bec  90610038    stw r3,0x38(r1)                ; -> Stack[-0x58]
10026bf0  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x58]
10026bf4  80630000    lwz r3,0x0(r3)              
10026bf8  83830016    lwz r28,0x16(r3)            
10026bfc  809c0000    lwz r4,0x0(r28)             
10026c00  a86100aa    lha r3,0xaa(r1)                ; -> Stack[0x1a]
10026c04  8084002a    lwz r4,0x2a(r4)             
10026c08  80840000    lwz r4,0x0(r4)              
10026c0c  83640000    lwz r27,0x0(r4)             
10026c10  48007abd    bl 0x1002e6cc                  ; -> 1002e6cc
10026c14  60000000    ori r0,r0,0x0               
10026c18  7c6f1b78    or r15,r3,r3                
10026c1c  7de37b78    or r3,r15,r15               
10026c20  48007a8d    bl 0x1002e6ac                  ; -> 1002e6ac
10026c24  60000000    ori r0,r0,0x0               
10026c28  7c741b78    or r20,r3,r3                
10026c2c  a86100aa    lha r3,0xaa(r1)                ; -> Stack[0x1a]
10026c30  48007a9d    bl 0x1002e6cc                  ; -> 1002e6cc
10026c34  60000000    ori r0,r0,0x0               
10026c38  7c6f1b78    or r15,r3,r3                
10026c3c  386f0001    addi r3,r15,0x1             
10026c40  48007a6d    bl 0x1002e6ac                  ; -> 1002e6ac
10026c44  60000000    ori r0,r0,0x0               
10026c48  7c731b78    or r19,r3,r3                
10026c4c  a86100ae    lha r3,0xae(r1)                ; -> Stack[0x1e]
10026c50  48007aa9    bl 0x1002e6f8                  ; -> 1002e6f8
10026c54  60000000    ori r0,r0,0x0               
10026c58  7c6f1b78    or r15,r3,r3                
10026c5c  7de37b78    or r3,r15,r15               
10026c60  48007a5d    bl 0x1002e6bc                  ; -> 1002e6bc
10026c64  60000000    ori r0,r0,0x0               
10026c68  7c751b78    or r21,r3,r3                
10026c6c  a86100ae    lha r3,0xae(r1)                ; -> Stack[0x1e]
10026c70  48007a89    bl 0x1002e6f8                  ; -> 1002e6f8
10026c74  60000000    ori r0,r0,0x0               
10026c78  7c6f1b78    or r15,r3,r3                
10026c7c  386f0001    addi r3,r15,0x1             
10026c80  48007a3d    bl 0x1002e6bc                  ; -> 1002e6bc
10026c84  60000000    ori r0,r0,0x0               
10026c88  a8d60000    lha r6,0x0(r22)             
10026c8c  a9160002    lha r8,0x2(r22)             
10026c90  7eb53214    add r21,r21,r6              
10026c94  a8b60002    lha r5,0x2(r22)             
10026c98  a9360002    lha r9,0x2(r22)             
10026c9c  7e944214    add r20,r20,r8              
10026ca0  7ee9a050    subf r23,r9,r20             
10026ca4  a9560000    lha r10,0x0(r22)            
10026ca8  7eab0734    extsh r11,r21               
10026cac  7d4a5850    subf r10,r10,r11            
10026cb0  7eec0734    extsh r12,r23               
10026cb4  a8f60000    lha r7,0x0(r22)             
10026cb8  7c721b78    or r18,r3,r3                
10026cbc  7c0a6000    cmpw r10,r12                
10026cc0  7e732a14    add r19,r19,r5              
10026cc4  7e523a14    add r18,r18,r7              
10026cc8  4081000c    ble 0x10026cd4                 ; -> 10026cd4
10026ccc  a9f60000    lha r15,0x0(r22)            
10026cd0  7eefa850    subf r23,r15,r21            
10026cd4  a8960006    lha r4,0x6(r22)             
10026cd8  7e630734    extsh r3,r19                
10026cdc  7c632050    subf r3,r3,r4               
10026ce0  7ee50734    extsh r5,r23                
10026ce4  7c032800    cmpw r3,r5                  
10026ce8  4081000c    ble 0x10026cf4                 ; -> 10026cf4
10026cec  a8d60006    lha r6,0x6(r22)             
10026cf0  7ef33050    subf r23,r19,r6             
10026cf4  a9160004    lha r8,0x4(r22)             
10026cf8  7e470734    extsh r7,r18                
10026cfc  7ce74050    subf r7,r7,r8               
10026d00  7ee90734    extsh r9,r23                
10026d04  7c074800    cmpw r7,r9                  
10026d08  4081000c    ble 0x10026d14                 ; -> 10026d14
10026d0c  a9560004    lha r10,0x4(r22)            
10026d10  7ef25050    subf r23,r18,r10            
10026d14  a9960004    lha r12,0x4(r22)            
10026d18  7eab0734    extsh r11,r21               
10026d1c  7d8c0e70    srawi r12,r12,0x1           
10026d20  7d8c0194    addze r12,r12               
10026d24  7c0b6000    cmpw r11,r12                
10026d28  4180000c    blt 0x10026d34                 ; -> 10026d34
10026d2c  3a00ffff    li r16,-0x1                 
10026d30  48000008    b 0x10026d38                   ; -> 10026d38
10026d34  3a000001    li r16,0x1                  
10026d38  a8760006    lha r3,0x6(r22)             
10026d3c  7e8f0734    extsh r15,r20               
10026d40  7c630e70    srawi r3,r3,0x1             
10026d44  7c630194    addze r3,r3                 
10026d48  7c0f1800    cmpw r15,r3                 
10026d4c  4180000c    blt 0x10026d58                 ; -> 10026d58
10026d50  3a20ffff    li r17,-0x1                 
10026d54  48000008    b 0x10026d5c                   ; -> 10026d5c
10026d58  3a200001    li r17,0x1                  
10026d5c  38600001    li r3,0x1                   
10026d60  38800001    li r4,0x1                   
10026d64  4800a57d    bl 0x100312e0                  ; -> 100312e0
10026d68  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026d6c  3b200001    li r25,0x1                  
10026d70  3ba00000    li r29,0x0                  
10026d74  38790004    addi r3,r25,0x4             
10026d78  38990004    addi r4,r25,0x4             
10026d7c  4800a565    bl 0x100312e0                  ; -> 100312e0
10026d80  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026d84  3b000000    li r24,0x0                  
10026d88  4800a241    bl 0x10030fc8                  ; -> 10030fc8
10026d8c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026d90  7c7f1b78    or r31,r3,r3                
10026d94  48000170    b 0x10026f04                   ; -> 10026f04
10026d98  38a27534    addi r5,r2,0x7534           
10026d9c  7fa40734    extsh r4,r29                
10026da0  80a50000    lwz r5,0x0(r5)              
10026da4  208400fe    subfic r4,r4,0xfe           
10026da8  90850050    stw r4,0x50(r5)             
10026dac  a9360000    lha r9,0x0(r22)             
10026db0  7eaa0734    extsh r10,r21               
10026db4  7d295050    subf r9,r9,r10              
10026db8  a8d60002    lha r6,0x2(r22)             
10026dbc  7e870734    extsh r7,r20                
10026dc0  7cc63850    subf r6,r6,r7               
10026dc4  7d3849d6    mullw r9,r24,r9             
10026dc8  7eeb0734    extsh r11,r23               
10026dcc  7d295bd6    divw r9,r9,r11              
10026dd0  7d29a850    subf r9,r9,r21              
10026dd4  7cb94850    subf r5,r25,r9              
10026dd8  7cd831d6    mullw r6,r24,r6             
10026ddc  7ee80734    extsh r8,r23                
10026de0  7cc643d6    divw r6,r6,r8               
10026de4  7cc6a050    subf r6,r6,r20              
10026de8  a9f60006    lha r15,0x6(r22)            
10026dec  7e6c0734    extsh r12,r19               
10026df0  7d8c7850    subf r12,r12,r15            
10026df4  a9360004    lha r9,0x4(r22)             
10026df8  7e480734    extsh r8,r18                
10026dfc  7d084850    subf r8,r8,r9               
10026e00  7d9861d6    mullw r12,r24,r12           
10026e04  7ee70734    extsh r7,r23                
10026e08  7d8c3bd6    divw r12,r12,r7             
10026e0c  7d1841d6    mullw r8,r24,r8             
10026e10  7eea0734    extsh r10,r23               
10026e14  7d0853d6    divw r8,r8,r10              
10026e18  7d08ca14    add r8,r8,r25               
10026e1c  7c993050    subf r4,r25,r6              
10026e20  7d8cca14    add r12,r12,r25             
10026e24  3861003c    addi r3,r1,0x3c             
10026e28  7cd36214    add r6,r19,r12              
10026e2c  7cf24214    add r7,r18,r8               
10026e30  4800ad09    bl 0x10031b38                  ; -> 10031b38
10026e34  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026e38  3861003c    addi r3,r1,0x3c             
10026e3c  4800b405    bl 0x10032240                  ; -> 10032240
10026e40  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026e44  3bbd0001    addi r29,r29,0x1            
10026e48  7fab0734    extsh r11,r29               
10026e4c  2c0b001d    cmpwi r11,0x1d              
10026e50  40810008    ble 0x10026e58                 ; -> 10026e58
10026e54  3ba00000    li r29,0x0                  
10026e58  7faf0734    extsh r15,r29               
10026e5c  7f2c0734    extsh r12,r25               
10026e60  2c0f001d    cmpwi r15,0x1d              
10026e64  7f186214    add r24,r24,r12             
10026e68  40820018    bne 0x10026e80                 ; -> 10026e80
10026e6c  3b390003    addi r25,r25,0x3            
10026e70  38790004    addi r3,r25,0x4             
10026e74  38990004    addi r4,r25,0x4             
10026e78  4800a469    bl 0x100312e0                  ; -> 100312e0
10026e7c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026e80  80da0000    lwz r6,0x0(r26)             
10026e84  7fa70734    extsh r7,r29                
10026e88  80c60000    lwz r6,0x0(r6)              
10026e8c  38e70002    addi r7,r7,0x2              
10026e90  7e948a14    add r20,r20,r17             
10026e94  7e738a14    add r19,r19,r17             
10026e98  7eb58214    add r21,r21,r16             
10026e9c  7e528214    add r18,r18,r16             
10026ea0  54e71838    rlwinm r7,r7,0x3,0x0,0x1c   
10026ea4  38c60008    addi r6,r6,0x8              
10026ea8  7e948a14    add r20,r20,r17             
10026eac  7e738a14    add r19,r19,r17             
10026eb0  7eb58214    add r21,r21,r16             
10026eb4  7e528214    add r18,r18,r16             
10026eb8  386000e1    li r3,0xe1                  
10026ebc  3880001d    li r4,0x1d                  
10026ec0  7ca63a14    add r5,r6,r7                
10026ec4  4800a165    bl 0x10031028                  ; -> 10031028
10026ec8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026ecc  811c0000    lwz r8,0x0(r28)             
10026ed0  8108002a    lwz r8,0x2a(r8)             
10026ed4  81080000    lwz r8,0x0(r8)              
10026ed8  93680000    stw r27,0x0(r8)             
10026edc  48000008    b 0x10026ee4                   ; -> 10026ee4
10026ee0  3bc00000    li r30,0x0                  
10026ee4  4800a0e5    bl 0x10030fc8                  ; -> 10030fc8
10026ee8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026eec  393f0001    addi r9,r31,0x1             
10026ef0  7c091840    cmplw r9,r3                 
10026ef4  4080ffec    bge 0x10026ee0                 ; -> 10026ee0
10026ef8  4800a0d1    bl 0x10030fc8                  ; -> 10030fc8
10026efc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026f00  7c7f1b78    or r31,r3,r3                
10026f04  7eea0734    extsh r10,r23               
10026f08  7c185000    cmpw r24,r10                
10026f0c  4180fe8c    blt 0x10026d98                 ; -> 10026d98
10026f10  39600001    li r11,0x1                  
10026f14  b1610044    sth r11,0x44(r1)               ; -> Stack[-0x4c]
10026f18  48000088    b 0x10026fa0                   ; -> 10026fa0
10026f1c  819a0000    lwz r12,0x0(r26)            
10026f20  7faf0734    extsh r15,r29               
10026f24  818c0000    lwz r12,0x0(r12)            
10026f28  39ef0002    addi r15,r15,0x2            
10026f2c  55ef1838    rlwinm r15,r15,0x3,0x0,0x1c 
10026f30  398c0008    addi r12,r12,0x8            
10026f34  386000e1    li r3,0xe1                  
10026f38  3880001d    li r4,0x1d                  
10026f3c  7cac7a14    add r5,r12,r15              
10026f40  4800a0e9    bl 0x10031028                  ; -> 10031028
10026f44  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026f48  807c0000    lwz r3,0x0(r28)             
10026f4c  8063002a    lwz r3,0x2a(r3)             
10026f50  80630000    lwz r3,0x0(r3)              
10026f54  93630000    stw r27,0x0(r3)             
10026f58  48000008    b 0x10026f60                   ; -> 10026f60
10026f5c  3bc00000    li r30,0x0                  
10026f60  4800a069    bl 0x10030fc8                  ; -> 10030fc8
10026f64  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026f68  389f0001    addi r4,r31,0x1             
10026f6c  7c041840    cmplw r4,r3                 
10026f70  4080ffec    bge 0x10026f5c                 ; -> 10026f5c
10026f74  4800a055    bl 0x10030fc8                  ; -> 10030fc8
10026f78  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10026f7c  7c7f1b78    or r31,r3,r3                
10026f80  3bbd0001    addi r29,r29,0x1            
10026f84  7fa50734    extsh r5,r29                
10026f88  2c05001e    cmpwi r5,0x1e               
10026f8c  4180ff90    blt 0x10026f1c                 ; -> 10026f1c
10026f90  a8c10044    lha r6,0x44(r1)                ; -> Stack[-0x4c]
10026f94  3ba00000    li r29,0x0                  
10026f98  38c60001    addi r6,r6,0x1              
10026f9c  b0c10044    sth r6,0x44(r1)                ; -> Stack[-0x4c]
10026fa0  a8e10044    lha r7,0x44(r1)                ; -> Stack[-0x4c]
10026fa4  a90100b6    lha r8,0xb6(r1)                ; -> Stack[0x26]
10026fa8  7ce70734    extsh r7,r7                 
10026fac  7c074000    cmpw r7,r8                  
10026fb0  4081ffd4    ble 0x10026f84                 ; -> 10026f84
10026fb4  813c0000    lwz r9,0x0(r28)             
10026fb8  8129002a    lwz r9,0x2a(r9)             
10026fbc  81290000    lwz r9,0x0(r9)              
10026fc0  93690000    stw r27,0x0(r9)             
10026fc4  80010098    lwz r0,0x98(r1)                ; -> Stack[0x8]
10026fc8  38210090    addi r1,r1,0x90             
10026fcc  7c0803a6    mtspr LR,r0                 
10026fd0  b9e1ffbc    lmw r15,-0x44(r1)              ; -> Stack[-0x44]
10026fd4  4e800020    blr                         
