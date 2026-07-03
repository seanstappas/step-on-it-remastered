; FUN_10003bbc @ 0x10003bbc
10003bbc  7c0802a6    mfspr r0,LR                 
10003bc0  be61ffcc    stmw r19,-0x34(r1)             ; -> Stack[-0x34]
10003bc4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10003bc8  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
10003bcc  386261fa    addi r3,r2,0x61fa           
10003bd0  3a623cd8    addi r19,r2,0x3cd8          
10003bd4  3ac23704    addi r22,r2,0x3704          
10003bd8  3bc2372e    addi r30,r2,0x372e          
10003bdc  ab430000    lha r26,0x0(r3)             
10003be0  4800037c    b 0x10003f5c                   ; -> 10003f5c
10003be4  7f440734    extsh r4,r26                
10003be8  1c840046    mulli r4,r4,0x46            
10003bec  7fb32214    add r29,r19,r4              
10003bf0  88bd001f    lbz r5,0x1f(r29)            
10003bf4  28050000    cmplwi r5,0x0               
10003bf8  40820360    bne 0x10003f58                 ; -> 10003f58
10003bfc  80dd000a    lwz r6,0xa(r29)             
10003c00  28060000    cmplwi r6,0x0               
10003c04  41820354    beq 0x10003f58                 ; -> 10003f58
10003c08  88fd0035    lbz r7,0x35(r29)            
10003c0c  28070000    cmplwi r7,0x0               
10003c10  40820348    bne 0x10003f58                 ; -> 10003f58
10003c14  a91d000e    lha r8,0xe(r29)             
10003c18  2c080000    cmpwi r8,0x0                
10003c1c  4182033c    beq 0x10003f58                 ; -> 10003f58
10003c20  a87d0010    lha r3,0x10(r29)            
10003c24  4802aaa9    bl 0x1002e6cc                  ; -> 1002e6cc
10003c28  60000000    ori r0,r0,0x0               
10003c2c  7c791b78    or r25,r3,r3                
10003c30  4bfffc99    bl 0x100038c8                  ; -> 100038c8
10003c34  7c7f1b78    or r31,r3,r3                
10003c38  7fe90734    extsh r9,r31                
10003c3c  1d290014    mulli r9,r9,0x14            
10003c40  7feb0734    extsh r11,r31               
10003c44  1d6b0014    mulli r11,r11,0x14          
10003c48  7f2a0734    extsh r10,r25               
10003c4c  7f2c0734    extsh r12,r25               
10003c50  7f5e4b2e    sthx r26,r30,r9             
10003c54  554a083c    rlwinm r10,r10,0x1,0x0,0x1e 
10003c58  7d5652ae    lhax r10,r22,r10            
10003c5c  396b0002    addi r11,r11,0x2            
10003c60  7d5e5b2e    sthx r10,r30,r11            
10003c64  558c083c    rlwinm r12,r12,0x1,0x0,0x1e 
10003c68  7ff6632e    sthx r31,r22,r12            
10003c6c  807d000a    lwz r3,0xa(r29)             
10003c70  a89d000e    lha r4,0xe(r29)             
10003c74  83630000    lwz r27,0x0(r3)             
10003c78  7c840734    extsh r4,r4                 
10003c7c  a8bb0000    lha r5,0x0(r27)             
10003c80  7c042800    cmpw r4,r5                  
10003c84  4081000c    ble 0x10003c90                 ; -> 10003c90
10003c88  38c00001    li r6,0x1                   
10003c8c  b0dd000e    sth r6,0xe(r29)             
10003c90  a8fd000e    lha r7,0xe(r29)             
10003c94  2c070000    cmpwi r7,0x0                
10003c98  4082000c    bne 0x10003ca4                 ; -> 10003ca4
10003c9c  39000001    li r8,0x1                   
10003ca0  b11d000e    sth r8,0xe(r29)             
10003ca4  a95d000e    lha r10,0xe(r29)            
10003ca8  813d000a    lwz r9,0xa(r29)             
10003cac  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
10003cb0  7fe40734    extsh r4,r31                
10003cb4  394a0008    addi r10,r10,0x8            
10003cb8  1c840014    mulli r4,r4,0x14            
10003cbc  7fe60734    extsh r6,r31                
10003cc0  1cc60014    mulli r6,r6,0x14            
10003cc4  7fe80734    extsh r8,r31                
10003cc8  1d080014    mulli r8,r8,0x14            
10003ccc  81290000    lwz r9,0x0(r9)              
10003cd0  7d5b502e    lwzx r10,r27,r10            
10003cd4  a87d0010    lha r3,0x10(r29)            
10003cd8  7f895214    add r28,r9,r10              
10003cdc  a97c0000    lha r11,0x0(r28)            
10003ce0  a99c0002    lha r12,0x2(r28)            
10003ce4  38840006    addi r4,r4,0x6              
10003ce8  7c7e232e    sthx r3,r30,r4              
10003cec  7fea0734    extsh r10,r31               
10003cf0  1d4a0014    mulli r10,r10,0x14          
10003cf4  a8bd0012    lha r5,0x12(r29)            
10003cf8  38c60004    addi r6,r6,0x4              
10003cfc  7cbe332e    sthx r5,r30,r6              
10003d00  a8fd0010    lha r7,0x10(r29)            
10003d04  3b0bffff    subi r24,r11,0x1            
10003d08  7ce7c214    add r7,r7,r24               
10003d0c  3908000a    addi r8,r8,0xa              
10003d10  7cfe432e    sthx r7,r30,r8              
10003d14  a93d0012    lha r9,0x12(r29)            
10003d18  3aecffff    subi r23,r12,0x1            
10003d1c  7d29ba14    add r9,r9,r23               
10003d20  394a0008    addi r10,r10,0x8            
10003d24  7d3e532e    sthx r9,r30,r10             
10003d28  817d0014    lwz r11,0x14(r29)           
10003d2c  280b0000    cmplwi r11,0x0              
10003d30  418201c4    beq 0x10003ef4                 ; -> 10003ef4
10003d34  819d0014    lwz r12,0x14(r29)           
10003d38  a89d0018    lha r4,0x18(r29)            
10003d3c  836c0000    lwz r27,0x0(r12)            
10003d40  807d0014    lwz r3,0x14(r29)            
10003d44  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10003d48  7fe80734    extsh r8,r31                
10003d4c  38840008    addi r4,r4,0x8              
10003d50  1d080014    mulli r8,r8,0x14            
10003d54  7fea0734    extsh r10,r31               
10003d58  1d4a0014    mulli r10,r10,0x14          
10003d5c  80630000    lwz r3,0x0(r3)              
10003d60  7c9b202e    lwzx r4,r27,r4              
10003d64  a8fd001a    lha r7,0x1a(r29)            
10003d68  7f832214    add r28,r3,r4               
10003d6c  a8bc0000    lha r5,0x0(r28)             
10003d70  a8dc0002    lha r6,0x2(r28)             
10003d74  3908000e    addi r8,r8,0xe              
10003d78  7cfe432e    sthx r7,r30,r8              
10003d7c  7fec0734    extsh r12,r31               
10003d80  1d8c0014    mulli r12,r12,0x14          
10003d84  3aa5ffff    subi r21,r5,0x1             
10003d88  7fe40734    extsh r4,r31                
10003d8c  3a86ffff    subi r20,r6,0x1             
10003d90  1c840014    mulli r4,r4,0x14            
10003d94  7fe50734    extsh r5,r31                
10003d98  1ca50014    mulli r5,r5,0x14            
10003d9c  7fe60734    extsh r6,r31                
10003da0  1cc60014    mulli r6,r6,0x14            
10003da4  a93d001c    lha r9,0x1c(r29)            
10003da8  394a000c    addi r10,r10,0xc            
10003dac  7d3e532e    sthx r9,r30,r10             
10003db0  a97d001a    lha r11,0x1a(r29)           
10003db4  398c0012    addi r12,r12,0x12           
10003db8  7d6baa14    add r11,r11,r21             
10003dbc  7d7e632e    sthx r11,r30,r12            
10003dc0  a87d001c    lha r3,0x1c(r29)            
10003dc4  38840010    addi r4,r4,0x10             
10003dc8  7c63a214    add r3,r3,r20               
10003dcc  7c7e232e    sthx r3,r30,r4              
10003dd0  38a50006    addi r5,r5,0x6              
10003dd4  7cbe2aae    lhax r5,r30,r5              
10003dd8  38c6000e    addi r6,r6,0xe              
10003ddc  7cde32ae    lhax r6,r30,r6              
10003de0  7ca50734    extsh r5,r5                 
10003de4  7c053000    cmpw r5,r6                  
10003de8  40800024    bge 0x10003e0c                 ; -> 10003e0c
10003dec  7fe70734    extsh r7,r31                
10003df0  1ce70014    mulli r7,r7,0x14            
10003df4  7fe80734    extsh r8,r31                
10003df8  1d080014    mulli r8,r8,0x14            
10003dfc  38e70006    addi r7,r7,0x6              
10003e00  7cfe3aae    lhax r7,r30,r7              
10003e04  3908000e    addi r8,r8,0xe              
10003e08  7cfe432e    sthx r7,r30,r8              
10003e0c  7fe90734    extsh r9,r31                
10003e10  1d290014    mulli r9,r9,0x14            
10003e14  7fea0734    extsh r10,r31               
10003e18  1d4a0014    mulli r10,r10,0x14          
10003e1c  39290004    addi r9,r9,0x4              
10003e20  7d3e4aae    lhax r9,r30,r9              
10003e24  394a000c    addi r10,r10,0xc            
10003e28  7d5e52ae    lhax r10,r30,r10            
10003e2c  7d290734    extsh r9,r9                 
10003e30  7c095000    cmpw r9,r10                 
10003e34  40800024    bge 0x10003e58                 ; -> 10003e58
10003e38  7feb0734    extsh r11,r31               
10003e3c  1d6b0014    mulli r11,r11,0x14          
10003e40  7fec0734    extsh r12,r31               
10003e44  1d8c0014    mulli r12,r12,0x14          
10003e48  396b0004    addi r11,r11,0x4            
10003e4c  7d7e5aae    lhax r11,r30,r11            
10003e50  398c000c    addi r12,r12,0xc            
10003e54  7d7e632e    sthx r11,r30,r12            
10003e58  7fe30734    extsh r3,r31                
10003e5c  1c630014    mulli r3,r3,0x14            
10003e60  7fe40734    extsh r4,r31                
10003e64  1c840014    mulli r4,r4,0x14            
10003e68  3863000a    addi r3,r3,0xa              
10003e6c  7c7e1aae    lhax r3,r30,r3              
10003e70  38840012    addi r4,r4,0x12             
10003e74  7c9e22ae    lhax r4,r30,r4              
10003e78  7c630734    extsh r3,r3                 
10003e7c  7c032000    cmpw r3,r4                  
10003e80  40810024    ble 0x10003ea4                 ; -> 10003ea4
10003e84  7fe50734    extsh r5,r31                
10003e88  1ca50014    mulli r5,r5,0x14            
10003e8c  7fe60734    extsh r6,r31                
10003e90  1cc60014    mulli r6,r6,0x14            
10003e94  38a5000a    addi r5,r5,0xa              
10003e98  7cbe2aae    lhax r5,r30,r5              
10003e9c  38c60012    addi r6,r6,0x12             
10003ea0  7cbe332e    sthx r5,r30,r6              
10003ea4  7fe70734    extsh r7,r31                
10003ea8  1ce70014    mulli r7,r7,0x14            
10003eac  7fe80734    extsh r8,r31                
10003eb0  1d080014    mulli r8,r8,0x14            
10003eb4  38e70008    addi r7,r7,0x8              
10003eb8  7cfe3aae    lhax r7,r30,r7              
10003ebc  39080010    addi r8,r8,0x10             
10003ec0  7d1e42ae    lhax r8,r30,r8              
10003ec4  7ce70734    extsh r7,r7                 
10003ec8  7c074000    cmpw r7,r8                  
10003ecc  40810058    ble 0x10003f24                 ; -> 10003f24
10003ed0  7fe90734    extsh r9,r31                
10003ed4  1d290014    mulli r9,r9,0x14            
10003ed8  7fea0734    extsh r10,r31               
10003edc  1d4a0014    mulli r10,r10,0x14          
10003ee0  39290008    addi r9,r9,0x8              
10003ee4  7d3e4aae    lhax r9,r30,r9              
10003ee8  394a0010    addi r10,r10,0x10           
10003eec  7d3e532e    sthx r9,r30,r10             
10003ef0  48000034    b 0x10003f24                   ; -> 10003f24
10003ef4  7feb0734    extsh r11,r31               
10003ef8  1d6b0014    mulli r11,r11,0x14          
10003efc  7fec0734    extsh r12,r31               
10003f00  1d8c0014    mulli r12,r12,0x14          
10003f04  396b0004    addi r11,r11,0x4            
10003f08  7c9e5a14    add r4,r30,r11              
10003f0c  398c000c    addi r12,r12,0xc            
10003f10  80a40000    lwz r5,0x0(r4)              
10003f14  80c40004    lwz r6,0x4(r4)              
10003f18  7c7e6214    add r3,r30,r12              
10003f1c  90a30000    stw r5,0x0(r3)              
10003f20  90c30004    stw r6,0x4(r3)              
10003f24  7fe70734    extsh r7,r31                
10003f28  1ce70014    mulli r7,r7,0x14            
10003f2c  38e7000a    addi r7,r7,0xa              
10003f30  7cfe3aae    lhax r7,r30,r7              
10003f34  2c0703e8    cmpwi r7,0x3e8              
10003f38  4181001c    bgt 0x10003f54                 ; -> 10003f54
10003f3c  7fe80734    extsh r8,r31                
10003f40  1d080014    mulli r8,r8,0x14            
10003f44  39080012    addi r8,r8,0x12             
10003f48  7d1e42ae    lhax r8,r30,r8              
10003f4c  2c0803e8    cmpwi r8,0x3e8              
10003f50  40810008    ble 0x10003f58                 ; -> 10003f58
10003f54  7ef8bb78    or r24,r23,r23              
10003f58  ab5d003e    lha r26,0x3e(r29)           
10003f5c  7f490734    extsh r9,r26                
10003f60  2c090000    cmpwi r9,0x0                
10003f64  4082fc80    bne 0x10003be4                 ; -> 10003be4
10003f68  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
10003f6c  38210070    addi r1,r1,0x70             
10003f70  7c0803a6    mtspr LR,r0                 
10003f74  ba61ffcc    lmw r19,-0x34(r1)              ; -> Stack[-0x34]
10003f78  4e800020    blr                         
