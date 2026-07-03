; FUN_10001b70 @ 0x10001b70
10001b70  7c0802a6    mfspr r0,LR                 
10001b74  be81ffd0    stmw r20,-0x30(r1)             ; -> Stack[-0x30]
10001b78  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10001b7c  9421ff60    stwu r1,-0xa0(r1)              ; -> Stack[-0xa0]
10001b80  ab2100da    lha r25,0xda(r1)               ; -> Stack[0x3a]
10001b84  834100dc    lwz r26,0xdc(r1)               ; -> Stack[0x3c]
10001b88  aa8100e2    lha r20,0xe2(r1)               ; -> Stack[0x42]
10001b8c  7c7c1b78    or r28,r3,r3                
10001b90  7cd63378    or r22,r6,r6                
10001b94  7cfb3b78    or r27,r7,r7                
10001b98  7d374b78    or r23,r9,r9                
10001b9c  7d585378    or r24,r10,r10              
10001ba0  b0a100c2    sth r5,0xc2(r1)                ; -> Stack[0x22]
10001ba4  b10100ce    sth r8,0xce(r1)                ; -> Stack[0x2e]
10001ba8  7f650734    extsh r5,r27                
10001bac  2c050001    cmpwi r5,0x1                
10001bb0  80dc0000    lwz r6,0x0(r28)             
10001bb4  41800910    blt 0x100024c4                 ; -> 100024c4
10001bb8  a8660000    lha r3,0x0(r6)              
10001bbc  7c051800    cmpw r5,r3                  
10001bc0  40810008    ble 0x10001bc8                 ; -> 10001bc8
10001bc4  48000900    b 0x100024c4                   ; -> 100024c4
10001bc8  7c800734    extsh r0,r4                 
10001bcc  2c000001    cmpwi r0,0x1                
10001bd0  418008f4    blt 0x100024c4                 ; -> 100024c4
10001bd4  7c001800    cmpw r0,r3                  
10001bd8  40810008    ble 0x10001be0                 ; -> 10001be0
10001bdc  480008e8    b 0x100024c4                   ; -> 100024c4
10001be0  5403103a    rlwinm r3,r0,0x2,0x0,0x1d   
10001be4  38030008    addi r0,r3,0x8              
10001be8  7c06002e    lwzx r0,r6,r0               
10001bec  54a3103a    rlwinm r3,r5,0x2,0x0,0x1d   
10001bf0  7ca60214    add r5,r6,r0                
10001bf4  38030008    addi r0,r3,0x8              
10001bf8  abc50000    lha r30,0x0(r5)             
10001bfc  aaa50002    lha r21,0x2(r5)             
10001c00  7c06002e    lwzx r0,r6,r0               
10001c04  7f83e378    or r3,r28,r28               
10001c08  7ca60214    add r5,r6,r0                
10001c0c  abe50000    lha r31,0x0(r5)             
10001c10  aba50002    lha r29,0x2(r5)             
10001c14  38c10060    addi r6,r1,0x60             
10001c18  38a100c2    addi r5,r1,0xc2             
10001c1c  4bfff72d    bl 0x10001348                  ; -> 10001348
10001c20  80a10060    lwz r5,0x60(r1)                ; -> Stack[-0x40]
10001c24  7f83e378    or r3,r28,r28               
10001c28  80050004    lwz r0,0x4(r5)              
10001c2c  7f64db78    or r4,r27,r27               
10001c30  7c050214    add r0,r5,r0                
10001c34  90010058    stw r0,0x58(r1)                ; -> Stack[-0x48]
10001c38  38a100ce    addi r5,r1,0xce             
10001c3c  38c1005c    addi r6,r1,0x5c             
10001c40  4bfff709    bl 0x10001348                  ; -> 10001348
10001c44  80a1005c    lwz r5,0x5c(r1)                ; -> Stack[-0x44]
10001c48  7ee30734    extsh r3,r23                
10001c4c  38050008    addi r0,r5,0x8              
10001c50  9001004c    stw r0,0x4c(r1)                ; -> Stack[-0x54]
10001c54  7ec00734    extsh r0,r22                
10001c58  80850000    lwz r4,0x0(r5)              
10001c5c  7c030000    cmpw r3,r0                  
10001c60  7c052214    add r0,r5,r4                
10001c64  90010048    stw r0,0x48(r1)                ; -> Stack[-0x58]
10001c68  4081000c    ble 0x10001c74                 ; -> 10001c74
10001c6c  7f96b850    subf r28,r22,r23            
10001c70  48000008    b 0x10001c78                   ; -> 10001c78
10001c74  7f97b050    subf r28,r23,r22            
10001c78  a88100ce    lha r4,0xce(r1)                ; -> Stack[0x2e]
10001c7c  a80100c2    lha r0,0xc2(r1)                ; -> Stack[0x22]
10001c80  7c830734    extsh r3,r4                 
10001c84  7c030000    cmpw r3,r0                  
10001c88  4081000c    ble 0x10001c94                 ; -> 10001c94
10001c8c  7f602050    subf r27,r0,r4              
10001c90  48000008    b 0x10001c98                   ; -> 10001c98
10001c94  7f640050    subf r27,r4,r0              
10001c98  7fa40734    extsh r4,r29                
10001c9c  7ea00734    extsh r0,r21                
10001ca0  7c040000    cmpw r4,r0                  
10001ca4  40820020    bne 0x10001cc4                 ; -> 10001cc4
10001ca8  7fe30734    extsh r3,r31                
10001cac  7fc00734    extsh r0,r30                
10001cb0  7c030000    cmpw r3,r0                  
10001cb4  40820010    bne 0x10001cc4                 ; -> 10001cc4
10001cb8  7f800734    extsh r0,r28                
10001cbc  7c002000    cmpw r0,r4                  
10001cc0  408101b0    ble 0x10001e70                 ; -> 10001e70
10001cc4  7ec50734    extsh r5,r22                
10001cc8  7ea00734    extsh r0,r21                
10001ccc  7efb0734    extsh r27,r23               
10001cd0  7c050214    add r0,r5,r0                
10001cd4  7c1b0000    cmpw r27,r0                 
10001cd8  4181003c    bgt 0x10001d14                 ; -> 10001d14
10001cdc  7fa00734    extsh r0,r29                
10001ce0  7c1b0214    add r0,r27,r0               
10001ce4  7c050000    cmpw r5,r0                  
10001ce8  4181002c    bgt 0x10001d14                 ; -> 10001d14
10001cec  a88100c2    lha r4,0xc2(r1)                ; -> Stack[0x22]
10001cf0  7fc00734    extsh r0,r30                
10001cf4  a86100ce    lha r3,0xce(r1)                ; -> Stack[0x2e]
10001cf8  7c040214    add r0,r4,r0                
10001cfc  7c030000    cmpw r3,r0                  
10001d00  41810014    bgt 0x10001d14                 ; -> 10001d14
10001d04  7fe00734    extsh r0,r31                
10001d08  7c030214    add r0,r3,r0                
10001d0c  7c040000    cmpw r4,r0                  
10001d10  408100b8    ble 0x10001dc8                 ; -> 10001dc8
10001d14  7e9b0734    extsh r27,r20               
10001d18  7ee30734    extsh r3,r23                
10001d1c  7f370734    extsh r23,r25               
10001d20  38000000    li r0,0x0                   
10001d24  7c83d9d6    mullw r4,r3,r27             
10001d28  a8a100ce    lha r5,0xce(r1)                ; -> Stack[0x2e]
10001d2c  7c63b9d6    mullw r3,r3,r23             
10001d30  7c852214    add r4,r5,r4                
10001d34  7c651a14    add r3,r5,r3                
10001d38  7c9a2214    add r4,r26,r4               
10001d3c  7c781a14    add r3,r24,r3               
10001d40  90810050    stw r4,0x50(r1)                ; -> Stack[-0x50]
10001d44  90610054    stw r3,0x54(r1)                ; -> Stack[-0x4c]
10001d48  b0010064    sth r0,0x64(r1)                ; -> Stack[-0x3c]
10001d4c  7ee4bb78    or r4,r23,r23               
10001d50  7f66db78    or r6,r27,r27               
10001d54  7faaeb78    or r10,r29,r29              
10001d58  93e10038    stw r31,0x38(r1)               ; -> Stack[-0x68]
10001d5c  38610054    addi r3,r1,0x54             
10001d60  38a10050    addi r5,r1,0x50             
10001d64  38e1004c    addi r7,r1,0x4c             
10001d68  39010048    addi r8,r1,0x48             
10001d6c  39210064    addi r9,r1,0x64             
10001d70  48000769    bl 0x100024d8                  ; -> 100024d8
10001d74  60000000    ori r0,r0,0x0               
10001d78  7ec00734    extsh r0,r22                
10001d7c  7c60d9d6    mullw r3,r0,r27             
10001d80  a88100c2    lha r4,0xc2(r1)                ; -> Stack[0x22]
10001d84  7c00b9d6    mullw r0,r0,r23             
10001d88  7c641a14    add r3,r4,r3                
10001d8c  7c040214    add r0,r4,r0                
10001d90  7c7a1a14    add r3,r26,r3               
10001d94  7c180214    add r0,r24,r0               
10001d98  7ee4bb78    or r4,r23,r23               
10001d9c  7f66db78    or r6,r27,r27               
10001da0  7ea8ab78    or r8,r21,r21               
10001da4  7fc9f378    or r9,r30,r30               
10001da8  90610050    stw r3,0x50(r1)                ; -> Stack[-0x50]
10001dac  90010054    stw r0,0x54(r1)                ; -> Stack[-0x4c]
10001db0  38610054    addi r3,r1,0x54             
10001db4  38a10050    addi r5,r1,0x50             
10001db8  38e10058    addi r7,r1,0x58             
10001dbc  480008f1    bl 0x100026ac                  ; -> 100026ac
10001dc0  60000000    ori r0,r0,0x0               
10001dc4  48000700    b 0x100024c4                   ; -> 100024c4
10001dc8  7e970734    extsh r23,r20               
10001dcc  7f360734    extsh r22,r25               
10001dd0  7c65b9d6    mullw r3,r5,r23             
10001dd4  7c05b1d6    mullw r0,r5,r22             
10001dd8  7c641a14    add r3,r4,r3                
10001ddc  7c040214    add r0,r4,r0                
10001de0  7c7a1a14    add r3,r26,r3               
10001de4  7c180214    add r0,r24,r0               
10001de8  7ec4b378    or r4,r22,r22               
10001dec  7ee6bb78    or r6,r23,r23               
10001df0  7ea8ab78    or r8,r21,r21               
10001df4  7fc9f378    or r9,r30,r30               
10001df8  90610050    stw r3,0x50(r1)                ; -> Stack[-0x50]
10001dfc  90010054    stw r0,0x54(r1)                ; -> Stack[-0x4c]
10001e00  38610054    addi r3,r1,0x54             
10001e04  38a10050    addi r5,r1,0x50             
10001e08  38e10058    addi r7,r1,0x58             
10001e0c  480008a1    bl 0x100026ac                  ; -> 100026ac
10001e10  60000000    ori r0,r0,0x0               
10001e14  38000000    li r0,0x0                   
10001e18  7c9bb9d6    mullw r4,r27,r23            
10001e1c  a8a100ce    lha r5,0xce(r1)                ; -> Stack[0x2e]
10001e20  7c7bb1d6    mullw r3,r27,r22            
10001e24  7c852214    add r4,r5,r4                
10001e28  7c651a14    add r3,r5,r3                
10001e2c  7c9a2214    add r4,r26,r4               
10001e30  7c781a14    add r3,r24,r3               
10001e34  90810050    stw r4,0x50(r1)                ; -> Stack[-0x50]
10001e38  90610054    stw r3,0x54(r1)                ; -> Stack[-0x4c]
10001e3c  b0010064    sth r0,0x64(r1)                ; -> Stack[-0x3c]
10001e40  7ec4b378    or r4,r22,r22               
10001e44  7ee6bb78    or r6,r23,r23               
10001e48  7faaeb78    or r10,r29,r29              
10001e4c  93e10038    stw r31,0x38(r1)               ; -> Stack[-0x68]
10001e50  38610054    addi r3,r1,0x54             
10001e54  38a10050    addi r5,r1,0x50             
10001e58  38e1004c    addi r7,r1,0x4c             
10001e5c  39010048    addi r8,r1,0x48             
10001e60  39210064    addi r9,r1,0x64             
10001e64  48000675    bl 0x100024d8                  ; -> 100024d8
10001e68  60000000    ori r0,r0,0x0               
10001e6c  48000658    b 0x100024c4                   ; -> 100024c4
10001e70  a86100ce    lha r3,0xce(r1)                ; -> Stack[0x2e]
10001e74  a80100c2    lha r0,0xc2(r1)                ; -> Stack[0x22]
10001e78  7c640734    extsh r4,r3                 
10001e7c  7c040000    cmpw r4,r0                  
10001e80  408201e4    bne 0x10002064                 ; -> 10002064
10001e84  7ee70734    extsh r7,r23                
10001e88  7ec50734    extsh r5,r22                
10001e8c  7c072800    cmpw r7,r5                  
10001e90  408100bc    ble 0x10001f4c                 ; -> 10001f4c
10001e94  7e960734    extsh r22,r20               
10001e98  7f340734    extsh r20,r25               
10001e9c  7c85b1d6    mullw r4,r5,r22             
10001ea0  7c65a1d6    mullw r3,r5,r20             
10001ea4  7c802214    add r4,r0,r4                
10001ea8  7c001a14    add r0,r0,r3                
10001eac  7c7a2214    add r3,r26,r4               
10001eb0  7c180214    add r0,r24,r0               
10001eb4  7e84a378    or r4,r20,r20               
10001eb8  7ec6b378    or r6,r22,r22               
10001ebc  7f88e378    or r8,r28,r28               
10001ec0  7fc9f378    or r9,r30,r30               
10001ec4  90610050    stw r3,0x50(r1)                ; -> Stack[-0x50]
10001ec8  90010054    stw r0,0x54(r1)                ; -> Stack[-0x4c]
10001ecc  38610054    addi r3,r1,0x54             
10001ed0  38a10050    addi r5,r1,0x50             
10001ed4  38e10058    addi r7,r1,0x58             
10001ed8  480007d5    bl 0x100026ac                  ; -> 100026ac
10001edc  60000000    ori r0,r0,0x0               
10001ee0  38000000    li r0,0x0                   
10001ee4  b0010064    sth r0,0x64(r1)                ; -> Stack[-0x3c]
10001ee8  7c1ce850    subf r0,r28,r29             
10001eec  90010038    stw r0,0x38(r1)                ; -> Stack[-0x68]
10001ef0  7e84a378    or r4,r20,r20               
10001ef4  7ec6b378    or r6,r22,r22               
10001ef8  93e1003c    stw r31,0x3c(r1)               ; -> Stack[-0x64]
10001efc  38610054    addi r3,r1,0x54             
10001f00  38a10050    addi r5,r1,0x50             
10001f04  38e1004c    addi r7,r1,0x4c             
10001f08  39010048    addi r8,r1,0x48             
10001f0c  39210058    addi r9,r1,0x58             
10001f10  39410064    addi r10,r1,0x64            
10001f14  4800085d    bl 0x10002770                  ; -> 10002770
10001f18  60000000    ori r0,r0,0x0               
10001f1c  7e84a378    or r4,r20,r20               
10001f20  7ec6b378    or r6,r22,r22               
10001f24  7f8ae378    or r10,r28,r28              
10001f28  93e10038    stw r31,0x38(r1)               ; -> Stack[-0x68]
10001f2c  38610054    addi r3,r1,0x54             
10001f30  38a10050    addi r5,r1,0x50             
10001f34  38e1004c    addi r7,r1,0x4c             
10001f38  39010048    addi r8,r1,0x48             
10001f3c  39210064    addi r9,r1,0x64             
10001f40  48000599    bl 0x100024d8                  ; -> 100024d8
10001f44  60000000    ori r0,r0,0x0               
10001f48  4800057c    b 0x100024c4                   ; -> 100024c4
10001f4c  408000bc    bge 0x10002008                 ; -> 10002008
10001f50  7e960734    extsh r22,r20               
10001f54  7f340734    extsh r20,r25               
10001f58  7c87b1d6    mullw r4,r7,r22             
10001f5c  7c07a1d6    mullw r0,r7,r20             
10001f60  7c832214    add r4,r3,r4                
10001f64  7c030214    add r0,r3,r0                
10001f68  7c9a2214    add r4,r26,r4               
10001f6c  7c780214    add r3,r24,r0               
10001f70  38000000    li r0,0x0                   
10001f74  90810050    stw r4,0x50(r1)                ; -> Stack[-0x50]
10001f78  90610054    stw r3,0x54(r1)                ; -> Stack[-0x4c]
10001f7c  b0010064    sth r0,0x64(r1)                ; -> Stack[-0x3c]
10001f80  7e84a378    or r4,r20,r20               
10001f84  7ec6b378    or r6,r22,r22               
10001f88  7f8ae378    or r10,r28,r28              
10001f8c  93e10038    stw r31,0x38(r1)               ; -> Stack[-0x68]
10001f90  38610054    addi r3,r1,0x54             
10001f94  38a10050    addi r5,r1,0x50             
10001f98  38e1004c    addi r7,r1,0x4c             
10001f9c  39010048    addi r8,r1,0x48             
10001fa0  39210064    addi r9,r1,0x64             
10001fa4  48000535    bl 0x100024d8                  ; -> 100024d8
10001fa8  60000000    ori r0,r0,0x0               
10001fac  7c1ce850    subf r0,r28,r29             
10001fb0  90010038    stw r0,0x38(r1)                ; -> Stack[-0x68]
10001fb4  7e84a378    or r4,r20,r20               
10001fb8  7ec6b378    or r6,r22,r22               
10001fbc  93e1003c    stw r31,0x3c(r1)               ; -> Stack[-0x64]
10001fc0  38610054    addi r3,r1,0x54             
10001fc4  38a10050    addi r5,r1,0x50             
10001fc8  38e1004c    addi r7,r1,0x4c             
10001fcc  39010048    addi r8,r1,0x48             
10001fd0  39210058    addi r9,r1,0x58             
10001fd4  39410064    addi r10,r1,0x64            
10001fd8  48000799    bl 0x10002770                  ; -> 10002770
10001fdc  60000000    ori r0,r0,0x0               
10001fe0  7e84a378    or r4,r20,r20               
10001fe4  7ec6b378    or r6,r22,r22               
10001fe8  7f88e378    or r8,r28,r28               
10001fec  7fc9f378    or r9,r30,r30               
10001ff0  38610054    addi r3,r1,0x54             
10001ff4  38a10050    addi r5,r1,0x50             
10001ff8  38e10058    addi r7,r1,0x58             
10001ffc  480006b1    bl 0x100026ac                  ; -> 100026ac
10002000  60000000    ori r0,r0,0x0               
10002004  480004c0    b 0x100024c4                   ; -> 100024c4
10002008  7e860734    extsh r6,r20                
1000200c  7f240734    extsh r4,r25                
10002010  7ca731d6    mullw r5,r7,r6              
10002014  7c0721d6    mullw r0,r7,r4              
10002018  7ca32a14    add r5,r3,r5                
1000201c  7c030214    add r0,r3,r0                
10002020  7c780214    add r3,r24,r0               
10002024  7cba2a14    add r5,r26,r5               
10002028  38000000    li r0,0x0                   
1000202c  90a10050    stw r5,0x50(r1)                ; -> Stack[-0x50]
10002030  90610054    stw r3,0x54(r1)                ; -> Stack[-0x4c]
10002034  b0010064    sth r0,0x64(r1)                ; -> Stack[-0x3c]
10002038  93a10038    stw r29,0x38(r1)               ; -> Stack[-0x68]
1000203c  93e1003c    stw r31,0x3c(r1)               ; -> Stack[-0x64]
10002040  38610054    addi r3,r1,0x54             
10002044  38a10050    addi r5,r1,0x50             
10002048  38e1004c    addi r7,r1,0x4c             
1000204c  39010048    addi r8,r1,0x48             
10002050  39210058    addi r9,r1,0x58             
10002054  39410064    addi r10,r1,0x64            
10002058  48000719    bl 0x10002770                  ; -> 10002770
1000205c  60000000    ori r0,r0,0x0               
10002060  48000464    b 0x100024c4                   ; -> 100024c4
10002064  40810234    ble 0x10002298                 ; -> 10002298
10002068  7ee50734    extsh r5,r23                
1000206c  7ec70734    extsh r7,r22                
10002070  7c053800    cmpw r5,r7                  
10002074  408100e0    ble 0x10002154                 ; -> 10002154
10002078  7e970734    extsh r23,r20               
1000207c  7f360734    extsh r22,r25               
10002080  7c87b9d6    mullw r4,r7,r23             
10002084  7c67b1d6    mullw r3,r7,r22             
10002088  7c802214    add r4,r0,r4                
1000208c  7c001a14    add r0,r0,r3                
10002090  7c7a2214    add r3,r26,r4               
10002094  7c180214    add r0,r24,r0               
10002098  7ec4b378    or r4,r22,r22               
1000209c  7ee6bb78    or r6,r23,r23               
100020a0  7f88e378    or r8,r28,r28               
100020a4  7fc9f378    or r9,r30,r30               
100020a8  90610050    stw r3,0x50(r1)                ; -> Stack[-0x50]
100020ac  90010054    stw r0,0x54(r1)                ; -> Stack[-0x4c]
100020b0  38610054    addi r3,r1,0x54             
100020b4  38a10050    addi r5,r1,0x50             
100020b8  38e10058    addi r7,r1,0x58             
100020bc  480005f1    bl 0x100026ac                  ; -> 100026ac
100020c0  60000000    ori r0,r0,0x0               
100020c4  38000000    li r0,0x0                   
100020c8  b0010064    sth r0,0x64(r1)                ; -> Stack[-0x3c]
100020cc  7c1ce850    subf r0,r28,r29             
100020d0  90010038    stw r0,0x38(r1)                ; -> Stack[-0x68]
100020d4  7c1fda14    add r0,r31,r27              
100020d8  9001003c    stw r0,0x3c(r1)                ; -> Stack[-0x64]
100020dc  7ec4b378    or r4,r22,r22               
100020e0  7ee6bb78    or r6,r23,r23               
100020e4  93610040    stw r27,0x40(r1)               ; -> Stack[-0x60]
100020e8  38610054    addi r3,r1,0x54             
100020ec  38a10050    addi r5,r1,0x50             
100020f0  38e1004c    addi r7,r1,0x4c             
100020f4  39010048    addi r8,r1,0x48             
100020f8  39210058    addi r9,r1,0x58             
100020fc  39410064    addi r10,r1,0x64            
10002100  480008d5    bl 0x100029d4                  ; -> 100029d4
10002104  60000000    ori r0,r0,0x0               
10002108  80610054    lwz r3,0x54(r1)                ; -> Stack[-0x4c]
1000210c  7f640734    extsh r4,r27                
10002110  80010050    lwz r0,0x50(r1)                ; -> Stack[-0x50]
10002114  7c632214    add r3,r3,r4                
10002118  7c002214    add r0,r0,r4                
1000211c  90610054    stw r3,0x54(r1)                ; -> Stack[-0x4c]
10002120  90010050    stw r0,0x50(r1)                ; -> Stack[-0x50]
10002124  7ec4b378    or r4,r22,r22               
10002128  7ee6bb78    or r6,r23,r23               
1000212c  7f8ae378    or r10,r28,r28              
10002130  93e10038    stw r31,0x38(r1)               ; -> Stack[-0x68]
10002134  38610054    addi r3,r1,0x54             
10002138  38a10050    addi r5,r1,0x50             
1000213c  38e1004c    addi r7,r1,0x4c             
10002140  39010048    addi r8,r1,0x48             
10002144  39210064    addi r9,r1,0x64             
10002148  48000391    bl 0x100024d8                  ; -> 100024d8
1000214c  60000000    ori r0,r0,0x0               
10002150  48000374    b 0x100024c4                   ; -> 100024c4
10002154  408000e0    bge 0x10002234                 ; -> 10002234
10002158  7e970734    extsh r23,r20               
1000215c  7f360734    extsh r22,r25               
10002160  7c85b9d6    mullw r4,r5,r23             
10002164  7c05b1d6    mullw r0,r5,r22             
10002168  7c832214    add r4,r3,r4                
1000216c  7c030214    add r0,r3,r0                
10002170  7c9a2214    add r4,r26,r4               
10002174  7c780214    add r3,r24,r0               
10002178  38000000    li r0,0x0                   
1000217c  90810050    stw r4,0x50(r1)                ; -> Stack[-0x50]
10002180  90610054    stw r3,0x54(r1)                ; -> Stack[-0x4c]
10002184  b0010064    sth r0,0x64(r1)                ; -> Stack[-0x3c]
10002188  7ec4b378    or r4,r22,r22               
1000218c  7ee6bb78    or r6,r23,r23               
10002190  7f8ae378    or r10,r28,r28              
10002194  93e10038    stw r31,0x38(r1)               ; -> Stack[-0x68]
10002198  38610054    addi r3,r1,0x54             
1000219c  38a10050    addi r5,r1,0x50             
100021a0  38e1004c    addi r7,r1,0x4c             
100021a4  39010048    addi r8,r1,0x48             
100021a8  39210064    addi r9,r1,0x64             
100021ac  4800032d    bl 0x100024d8                  ; -> 100024d8
100021b0  60000000    ori r0,r0,0x0               
100021b4  80610054    lwz r3,0x54(r1)                ; -> Stack[-0x4c]
100021b8  7f640734    extsh r4,r27                
100021bc  80010050    lwz r0,0x50(r1)                ; -> Stack[-0x50]
100021c0  7c641850    subf r3,r4,r3               
100021c4  7c040050    subf r0,r4,r0               
100021c8  90610054    stw r3,0x54(r1)                ; -> Stack[-0x4c]
100021cc  90010050    stw r0,0x50(r1)                ; -> Stack[-0x50]
100021d0  7c1ce850    subf r0,r28,r29             
100021d4  90010038    stw r0,0x38(r1)                ; -> Stack[-0x68]
100021d8  7c1fda14    add r0,r31,r27              
100021dc  9001003c    stw r0,0x3c(r1)                ; -> Stack[-0x64]
100021e0  7ec4b378    or r4,r22,r22               
100021e4  7ee6bb78    or r6,r23,r23               
100021e8  93610040    stw r27,0x40(r1)               ; -> Stack[-0x60]
100021ec  38610054    addi r3,r1,0x54             
100021f0  38a10050    addi r5,r1,0x50             
100021f4  38e1004c    addi r7,r1,0x4c             
100021f8  39010048    addi r8,r1,0x48             
100021fc  39210058    addi r9,r1,0x58             
10002200  39410064    addi r10,r1,0x64            
10002204  480007d1    bl 0x100029d4                  ; -> 100029d4
10002208  60000000    ori r0,r0,0x0               
1000220c  7ec4b378    or r4,r22,r22               
10002210  7ee6bb78    or r6,r23,r23               
10002214  7f88e378    or r8,r28,r28               
10002218  7fc9f378    or r9,r30,r30               
1000221c  38610054    addi r3,r1,0x54             
10002220  38a10050    addi r5,r1,0x50             
10002224  38e10058    addi r7,r1,0x58             
10002228  48000485    bl 0x100026ac                  ; -> 100026ac
1000222c  60000000    ori r0,r0,0x0               
10002230  48000294    b 0x100024c4                   ; -> 100024c4
10002234  7e860734    extsh r6,r20                
10002238  7f240734    extsh r4,r25                
1000223c  7ca731d6    mullw r5,r7,r6              
10002240  7c6721d6    mullw r3,r7,r4              
10002244  7ca02a14    add r5,r0,r5                
10002248  7c001a14    add r0,r0,r3                
1000224c  7c780214    add r3,r24,r0               
10002250  7cba2a14    add r5,r26,r5               
10002254  38000000    li r0,0x0                   
10002258  90a10050    stw r5,0x50(r1)                ; -> Stack[-0x50]
1000225c  90610054    stw r3,0x54(r1)                ; -> Stack[-0x4c]
10002260  b0010064    sth r0,0x64(r1)                ; -> Stack[-0x3c]
10002264  93a10038    stw r29,0x38(r1)               ; -> Stack[-0x68]
10002268  7c1fda14    add r0,r31,r27              
1000226c  9001003c    stw r0,0x3c(r1)                ; -> Stack[-0x64]
10002270  93610040    stw r27,0x40(r1)               ; -> Stack[-0x60]
10002274  38610054    addi r3,r1,0x54             
10002278  38a10050    addi r5,r1,0x50             
1000227c  38e1004c    addi r7,r1,0x4c             
10002280  39010048    addi r8,r1,0x48             
10002284  39210058    addi r9,r1,0x58             
10002288  39410064    addi r10,r1,0x64            
1000228c  48000749    bl 0x100029d4                  ; -> 100029d4
10002290  60000000    ori r0,r0,0x0               
10002294  48000230    b 0x100024c4                   ; -> 100024c4
10002298  7ee70734    extsh r7,r23                
1000229c  7ec50734    extsh r5,r22                
100022a0  7c072800    cmpw r7,r5                  
100022a4  408100e0    ble 0x10002384                 ; -> 10002384
100022a8  7e970734    extsh r23,r20               
100022ac  7f360734    extsh r22,r25               
100022b0  7c85b9d6    mullw r4,r5,r23             
100022b4  7c65b1d6    mullw r3,r5,r22             
100022b8  7c802214    add r4,r0,r4                
100022bc  7c001a14    add r0,r0,r3                
100022c0  7c7a2214    add r3,r26,r4               
100022c4  7c180214    add r0,r24,r0               
100022c8  7ec4b378    or r4,r22,r22               
100022cc  7ee6bb78    or r6,r23,r23               
100022d0  7f88e378    or r8,r28,r28               
100022d4  7fc9f378    or r9,r30,r30               
100022d8  90610050    stw r3,0x50(r1)                ; -> Stack[-0x50]
100022dc  90010054    stw r0,0x54(r1)                ; -> Stack[-0x4c]
100022e0  38610054    addi r3,r1,0x54             
100022e4  38a10050    addi r5,r1,0x50             
100022e8  38e10058    addi r7,r1,0x58             
100022ec  480003c1    bl 0x100026ac                  ; -> 100026ac
100022f0  60000000    ori r0,r0,0x0               
100022f4  38000000    li r0,0x0                   
100022f8  80810054    lwz r4,0x54(r1)                ; -> Stack[-0x4c]
100022fc  7f650734    extsh r5,r27                
10002300  80610050    lwz r3,0x50(r1)                ; -> Stack[-0x50]
10002304  7c852050    subf r4,r5,r4               
10002308  7c651850    subf r3,r5,r3               
1000230c  90810054    stw r4,0x54(r1)                ; -> Stack[-0x4c]
10002310  90610050    stw r3,0x50(r1)                ; -> Stack[-0x50]
10002314  b0010064    sth r0,0x64(r1)                ; -> Stack[-0x3c]
10002318  7c1ce850    subf r0,r28,r29             
1000231c  90010038    stw r0,0x38(r1)                ; -> Stack[-0x68]
10002320  7c1fda14    add r0,r31,r27              
10002324  9001003c    stw r0,0x3c(r1)                ; -> Stack[-0x64]
10002328  7ec4b378    or r4,r22,r22               
1000232c  7ee6bb78    or r6,r23,r23               
10002330  93610040    stw r27,0x40(r1)               ; -> Stack[-0x60]
10002334  38610054    addi r3,r1,0x54             
10002338  38a10050    addi r5,r1,0x50             
1000233c  38e1004c    addi r7,r1,0x4c             
10002340  39010048    addi r8,r1,0x48             
10002344  39210058    addi r9,r1,0x58             
10002348  39410064    addi r10,r1,0x64            
1000234c  48000a0d    bl 0x10002d58                  ; -> 10002d58
10002350  60000000    ori r0,r0,0x0               
10002354  7ec4b378    or r4,r22,r22               
10002358  7ee6bb78    or r6,r23,r23               
1000235c  7f8ae378    or r10,r28,r28              
10002360  93e10038    stw r31,0x38(r1)               ; -> Stack[-0x68]
10002364  38610054    addi r3,r1,0x54             
10002368  38a10050    addi r5,r1,0x50             
1000236c  38e1004c    addi r7,r1,0x4c             
10002370  39010048    addi r8,r1,0x48             
10002374  39210064    addi r9,r1,0x64             
10002378  48000161    bl 0x100024d8                  ; -> 100024d8
1000237c  60000000    ori r0,r0,0x0               
10002380  48000144    b 0x100024c4                   ; -> 100024c4
10002384  408000e0    bge 0x10002464                 ; -> 10002464
10002388  7e970734    extsh r23,r20               
1000238c  7f360734    extsh r22,r25               
10002390  7c87b9d6    mullw r4,r7,r23             
10002394  7c07b1d6    mullw r0,r7,r22             
10002398  7c832214    add r4,r3,r4                
1000239c  7c030214    add r0,r3,r0                
100023a0  7c9a2214    add r4,r26,r4               
100023a4  7c780214    add r3,r24,r0               
100023a8  38000000    li r0,0x0                   
100023ac  90810050    stw r4,0x50(r1)                ; -> Stack[-0x50]
100023b0  90610054    stw r3,0x54(r1)                ; -> Stack[-0x4c]
100023b4  b0010064    sth r0,0x64(r1)                ; -> Stack[-0x3c]
100023b8  7ec4b378    or r4,r22,r22               
100023bc  7ee6bb78    or r6,r23,r23               
100023c0  7f8ae378    or r10,r28,r28              
100023c4  93e10038    stw r31,0x38(r1)               ; -> Stack[-0x68]
100023c8  38610054    addi r3,r1,0x54             
100023cc  38a10050    addi r5,r1,0x50             
100023d0  38e1004c    addi r7,r1,0x4c             
100023d4  39010048    addi r8,r1,0x48             
100023d8  39210064    addi r9,r1,0x64             
100023dc  480000fd    bl 0x100024d8                  ; -> 100024d8
100023e0  60000000    ori r0,r0,0x0               
100023e4  7c1ce850    subf r0,r28,r29             
100023e8  90010038    stw r0,0x38(r1)                ; -> Stack[-0x68]
100023ec  7c1fda14    add r0,r31,r27              
100023f0  9001003c    stw r0,0x3c(r1)                ; -> Stack[-0x64]
100023f4  7ec4b378    or r4,r22,r22               
100023f8  7ee6bb78    or r6,r23,r23               
100023fc  93610040    stw r27,0x40(r1)               ; -> Stack[-0x60]
10002400  38610054    addi r3,r1,0x54             
10002404  38a10050    addi r5,r1,0x50             
10002408  38e1004c    addi r7,r1,0x4c             
1000240c  39010048    addi r8,r1,0x48             
10002410  39210058    addi r9,r1,0x58             
10002414  39410064    addi r10,r1,0x64            
10002418  48000941    bl 0x10002d58                  ; -> 10002d58
1000241c  60000000    ori r0,r0,0x0               
10002420  80610054    lwz r3,0x54(r1)                ; -> Stack[-0x4c]
10002424  7f640734    extsh r4,r27                
10002428  80010050    lwz r0,0x50(r1)                ; -> Stack[-0x50]
1000242c  7c632214    add r3,r3,r4                
10002430  7c002214    add r0,r0,r4                
10002434  7ec4b378    or r4,r22,r22               
10002438  7ee6bb78    or r6,r23,r23               
1000243c  7f88e378    or r8,r28,r28               
10002440  7fc9f378    or r9,r30,r30               
10002444  90610054    stw r3,0x54(r1)                ; -> Stack[-0x4c]
10002448  90010050    stw r0,0x50(r1)                ; -> Stack[-0x50]
1000244c  38610054    addi r3,r1,0x54             
10002450  38a10050    addi r5,r1,0x50             
10002454  38e10058    addi r7,r1,0x58             
10002458  48000255    bl 0x100026ac                  ; -> 100026ac
1000245c  60000000    ori r0,r0,0x0               
10002460  48000064    b 0x100024c4                   ; -> 100024c4
10002464  7e860734    extsh r6,r20                
10002468  7f240734    extsh r4,r25                
1000246c  7ca731d6    mullw r5,r7,r6              
10002470  7c0721d6    mullw r0,r7,r4              
10002474  7ca32a14    add r5,r3,r5                
10002478  7c030214    add r0,r3,r0                
1000247c  7c780214    add r3,r24,r0               
10002480  7cba2a14    add r5,r26,r5               
10002484  38000000    li r0,0x0                   
10002488  90a10050    stw r5,0x50(r1)                ; -> Stack[-0x50]
1000248c  90610054    stw r3,0x54(r1)                ; -> Stack[-0x4c]
10002490  b0010064    sth r0,0x64(r1)                ; -> Stack[-0x3c]
10002494  93a10038    stw r29,0x38(r1)               ; -> Stack[-0x68]
10002498  7c1fda14    add r0,r31,r27              
1000249c  9001003c    stw r0,0x3c(r1)                ; -> Stack[-0x64]
100024a0  93610040    stw r27,0x40(r1)               ; -> Stack[-0x60]
100024a4  38610054    addi r3,r1,0x54             
100024a8  38a10050    addi r5,r1,0x50             
100024ac  38e1004c    addi r7,r1,0x4c             
100024b0  39010048    addi r8,r1,0x48             
100024b4  39210058    addi r9,r1,0x58             
100024b8  39410064    addi r10,r1,0x64            
100024bc  4800089d    bl 0x10002d58                  ; -> 10002d58
100024c0  60000000    ori r0,r0,0x0               
100024c4  800100a8    lwz r0,0xa8(r1)                ; -> Stack[0x8]
100024c8  382100a0    addi r1,r1,0xa0             
100024cc  7c0803a6    mtspr LR,r0                 
100024d0  ba81ffd0    lmw r20,-0x30(r1)              ; -> Stack[-0x30]
100024d4  4e800020    blr                         
