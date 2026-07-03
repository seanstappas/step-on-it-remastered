; FUN_10008b18 @ 0x10008b18
10008b18  7c0802a6    mfspr r0,LR                 
10008b1c  bf01ffe0    stmw r24,-0x20(r1)             ; -> Stack[-0x20]
10008b20  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10008b24  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10008b28  7c7c1b78    or r28,r3,r3                
10008b2c  7f830734    extsh r3,r28                
10008b30  1c630046    mulli r3,r3,0x46            
10008b34  3bc23cd8    addi r30,r2,0x3cd8          
10008b38  3b4261a4    addi r26,r2,0x61a4          
10008b3c  7ffe1a14    add r31,r30,r3              
10008b40  889f001f    lbz r4,0x1f(r31)            
10008b44  28040000    cmplwi r4,0x0               
10008b48  418200e0    beq 0x10008c28                 ; -> 10008c28
10008b4c  38a00000    li r5,0x0                   
10008b50  98bf001f    stb r5,0x1f(r31)            
10008b54  a8df0008    lha r6,0x8(r31)             
10008b58  38e00001    li r7,0x1                   
10008b5c  1cc60003    mulli r6,r6,0x3             
10008b60  b0df0026    sth r6,0x26(r31)            
10008b64  b0ff0024    sth r7,0x24(r31)            
10008b68  811a0040    lwz r8,0x40(r26)            
10008b6c  39200000    li r9,0x0                   
10008b70  911f000a    stw r8,0xa(r31)             
10008b74  913f0014    stw r9,0x14(r31)            
10008b78  3940000f    li r10,0xf                  
10008b7c  b15f000e    sth r10,0xe(r31)            
10008b80  39600001    li r11,0x1                  
10008b84  997f001e    stb r11,0x1e(r31)           
10008b88  a99f0004    lha r12,0x4(r31)            
10008b8c  2c0c0002    cmpwi r12,0x2               
10008b90  4082000c    bne 0x10008b9c                 ; -> 10008b9c
10008b94  38600009    li r3,0x9                   
10008b98  b07f0004    sth r3,0x4(r31)             
10008b9c  a89f0004    lha r4,0x4(r31)             
10008ba0  2c040001    cmpwi r4,0x1                
10008ba4  4082000c    bne 0x10008bb0                 ; -> 10008bb0
10008ba8  38a00008    li r5,0x8                   
10008bac  b0bf0004    sth r5,0x4(r31)             
10008bb0  7f860734    extsh r6,r28                
10008bb4  7f870734    extsh r7,r28                
10008bb8  1cc60046    mulli r6,r6,0x46            
10008bbc  1ce70046    mulli r7,r7,0x46            
10008bc0  38c60010    addi r6,r6,0x10             
10008bc4  38e70012    addi r7,r7,0x12             
10008bc8  7c7e32ae    lhax r3,r30,r6              
10008bcc  7c9e3aae    lhax r4,r30,r7              
10008bd0  4bffc9f9    bl 0x100055c8                  ; -> 100055c8
10008bd4  60000000    ori r0,r0,0x0               
10008bd8  7f880734    extsh r8,r28                
10008bdc  1d080046    mulli r8,r8,0x46            
10008be0  7f8b0734    extsh r11,r28               
10008be4  7f890734    extsh r9,r28                
10008be8  7f8a0734    extsh r10,r28               
10008bec  1d6b0046    mulli r11,r11,0x46          
10008bf0  1d290046    mulli r9,r9,0x46            
10008bf4  1d4a0046    mulli r10,r10,0x46          
10008bf8  39080028    addi r8,r8,0x28             
10008bfc  7c7e432e    sthx r3,r30,r8              
10008c00  396b0028    addi r11,r11,0x28           
10008c04  39290010    addi r9,r9,0x10             
10008c08  394a0012    addi r10,r10,0x12           
10008c0c  7d7e5aae    lhax r11,r30,r11            
10008c10  7c7e4aae    lhax r3,r30,r9              
10008c14  7c9e52ae    lhax r4,r30,r10             
10008c18  61650300    ori r5,r11,0x300            
10008c1c  4bffca15    bl 0x10005630                  ; -> 10005630
10008c20  60000000    ori r0,r0,0x0               
10008c24  480003f8    b 0x1000901c                   ; -> 1000901c
10008c28  a99f0024    lha r12,0x24(r31)           
10008c2c  7d836378    or r3,r12,r12               
10008c30  7c630734    extsh r3,r3                 
10008c34  398cffff    subi r12,r12,0x1            
10008c38  2c030000    cmpwi r3,0x0                
10008c3c  b19f0024    sth r12,0x24(r31)           
10008c40  418103dc    bgt 0x1000901c                 ; -> 1000901c
10008c44  38800002    li r4,0x2                   
10008c48  b09f0024    sth r4,0x24(r31)            
10008c4c  a8bf0026    lha r5,0x26(r31)            
10008c50  2c050000    cmpwi r5,0x0                
10008c54  40810028    ble 0x10008c7c                 ; -> 10008c7c
10008c58  a8df000e    lha r6,0xe(r31)             
10008c5c  2c060001    cmpwi r6,0x1                
10008c60  40810064    ble 0x10008cc4                 ; -> 10008cc4
10008c64  a8ff000e    lha r7,0xe(r31)             
10008c68  39000001    li r8,0x1                   
10008c6c  38e7ffff    subi r7,r7,0x1              
10008c70  b0ff000e    sth r7,0xe(r31)             
10008c74  991f001e    stb r8,0x1e(r31)            
10008c78  4800004c    b 0x10008cc4                   ; -> 10008cc4
10008c7c  a93f0026    lha r9,0x26(r31)            
10008c80  2c090000    cmpwi r9,0x0                
10008c84  40800040    bge 0x10008cc4                 ; -> 10008cc4
10008c88  39400001    li r10,0x1                  
10008c8c  995f001e    stb r10,0x1e(r31)           
10008c90  a97f000e    lha r11,0xe(r31)            
10008c94  396b0001    addi r11,r11,0x1            
10008c98  b17f000e    sth r11,0xe(r31)            
10008c9c  7d6b0734    extsh r11,r11               
10008ca0  2c0b000f    cmpwi r11,0xf               
10008ca4  40820020    bne 0x10008cc4                 ; -> 10008cc4
10008ca8  39800001    li r12,0x1                  
10008cac  999f0020    stb r12,0x20(r31)           
10008cb0  a87f0010    lha r3,0x10(r31)            
10008cb4  a89f0012    lha r4,0x12(r31)            
10008cb8  a8bf0028    lha r5,0x28(r31)            
10008cbc  4bffc975    bl 0x10005630                  ; -> 10005630
10008cc0  60000000    ori r0,r0,0x0               
10008cc4  a87f0026    lha r3,0x26(r31)            
10008cc8  7c641b78    or r4,r3,r3                 
10008ccc  7c840734    extsh r4,r4                 
10008cd0  3863ffff    subi r3,r3,0x1              
10008cd4  2c040000    cmpwi r4,0x0                
10008cd8  b07f0026    sth r3,0x26(r31)            
10008cdc  40820340    bne 0x1000901c                 ; -> 1000901c
10008ce0  a8bf0004    lha r5,0x4(r31)             
10008ce4  2c050009    cmpwi r5,0x9                
10008ce8  40820198    bne 0x10008e80                 ; -> 10008e80
10008cec  a8df0012    lha r6,0x12(r31)            
10008cf0  a87f0010    lha r3,0x10(r31)            
10008cf4  38860020    addi r4,r6,0x20             
10008cf8  4bffc855    bl 0x1000554c                  ; -> 1000554c
10008cfc  60000000    ori r0,r0,0x0               
10008d00  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10008d04  28030000    cmplwi r3,0x0               
10008d08  41820018    beq 0x10008d20                 ; -> 10008d20
10008d0c  38e00008    li r7,0x8                   
10008d10  b0ff0004    sth r7,0x4(r31)             
10008d14  39000000    li r8,0x0                   
10008d18  b11f0026    sth r8,0x26(r31)            
10008d1c  48000300    b 0x1000901c                   ; -> 1000901c
10008d20  a93f0012    lha r9,0x12(r31)            
10008d24  38690020    addi r3,r9,0x20             
10008d28  480259d1    bl 0x1002e6f8                  ; -> 1002e6f8
10008d2c  60000000    ori r0,r0,0x0               
10008d30  7c791b78    or r25,r3,r3                
10008d34  a87f0010    lha r3,0x10(r31)            
10008d38  48025995    bl 0x1002e6cc                  ; -> 1002e6cc
10008d3c  60000000    ori r0,r0,0x0               
10008d40  7c781b78    or r24,r3,r3                
10008d44  7f03c378    or r3,r24,r24               
10008d48  7f24cb78    or r4,r25,r25               
10008d4c  4bffb905    bl 0x10004650                  ; -> 10004650
10008d50  60000000    ori r0,r0,0x0               
10008d54  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10008d58  28030000    cmplwi r3,0x0               
10008d5c  40820018    bne 0x10008d74                 ; -> 10008d74
10008d60  39400008    li r10,0x8                  
10008d64  b15f0004    sth r10,0x4(r31)            
10008d68  39600000    li r11,0x0                  
10008d6c  b17f0026    sth r11,0x26(r31)           
10008d70  480002ac    b 0x1000901c                   ; -> 1000901c
10008d74  a99f0012    lha r12,0x12(r31)           
10008d78  a87f0010    lha r3,0x10(r31)            
10008d7c  388c0020    addi r4,r12,0x20            
10008d80  4bffc849    bl 0x100055c8                  ; -> 100055c8
10008d84  60000000    ori r0,r0,0x0               
10008d88  7c7b1b78    or r27,r3,r3                
10008d8c  7f63db78    or r3,r27,r27               
10008d90  480002a1    bl 0x10009030                  ; -> 10009030
10008d94  60000000    ori r0,r0,0x0               
10008d98  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10008d9c  28030000    cmplwi r3,0x0               
10008da0  40820018    bne 0x10008db8                 ; -> 10008db8
10008da4  3b000008    li r24,0x8                  
10008da8  b31f0004    sth r24,0x4(r31)            
10008dac  3b200000    li r25,0x0                  
10008db0  b33f0026    sth r25,0x26(r31)           
10008db4  48000268    b 0x1000901c                   ; -> 1000901c
10008db8  4bffcb91    bl 0x10005948                  ; -> 10005948
10008dbc  60000000    ori r0,r0,0x0               
10008dc0  7c7d1b78    or r29,r3,r3                
10008dc4  7fa40734    extsh r4,r29                
10008dc8  1c840046    mulli r4,r4,0x46            
10008dcc  7fa60734    extsh r6,r29                
10008dd0  1cc60046    mulli r6,r6,0x46            
10008dd4  7fa80734    extsh r8,r29                
10008dd8  1d080046    mulli r8,r8,0x46            
10008ddc  7faa0734    extsh r10,r29               
10008de0  1d4a0046    mulli r10,r10,0x46          
10008de4  7fac0734    extsh r12,r29               
10008de8  1d8c0046    mulli r12,r12,0x46          
10008dec  7fb90734    extsh r25,r29               
10008df0  1f390046    mulli r25,r25,0x46          
10008df4  a87f0010    lha r3,0x10(r31)            
10008df8  38840010    addi r4,r4,0x10             
10008dfc  7c7e232e    sthx r3,r30,r4              
10008e00  a8bf0012    lha r5,0x12(r31)            
10008e04  7fa40734    extsh r4,r29                
10008e08  1c840046    mulli r4,r4,0x46            
10008e0c  38a50020    addi r5,r5,0x20             
10008e10  38c60012    addi r6,r6,0x12             
10008e14  7cbe332e    sthx r5,r30,r6              
10008e18  7fa60734    extsh r6,r29                
10008e1c  1cc60046    mulli r6,r6,0x46            
10008e20  38e00009    li r7,0x9                   
10008e24  39080004    addi r8,r8,0x4              
10008e28  7cfe432e    sthx r7,r30,r8              
10008e2c  7fa80734    extsh r8,r29                
10008e30  1d080046    mulli r8,r8,0x46            
10008e34  39200011    li r9,0x11                  
10008e38  394a0002    addi r10,r10,0x2            
10008e3c  7d3e532e    sthx r9,r30,r10             
10008e40  817a0040    lwz r11,0x40(r26)           
10008e44  398c000a    addi r12,r12,0xa            
10008e48  7d7e612e    stwx r11,r30,r12            
10008e4c  3b00000f    li r24,0xf                  
10008e50  3b39000e    addi r25,r25,0xe            
10008e54  7f1ecb2e    sthx r24,r30,r25            
10008e58  38600000    li r3,0x0                   
10008e5c  38840014    addi r4,r4,0x14             
10008e60  7c7e212e    stwx r3,r30,r4              
10008e64  38a00000    li r5,0x0                   
10008e68  38c6001e    addi r6,r6,0x1e             
10008e6c  7cbe31ae    stbx r5,r30,r6              
10008e70  a8ff0008    lha r7,0x8(r31)             
10008e74  39080008    addi r8,r8,0x8              
10008e78  7cfe432e    sthx r7,r30,r8              
10008e7c  480001a0    b 0x1000901c                   ; -> 1000901c
10008e80  a93f0004    lha r9,0x4(r31)             
10008e84  2c090008    cmpwi r9,0x8                
10008e88  40820194    bne 0x1000901c                 ; -> 1000901c
10008e8c  a95f0012    lha r10,0x12(r31)           
10008e90  a87f0010    lha r3,0x10(r31)            
10008e94  388affe0    subi r4,r10,0x20            
10008e98  4bffc6b5    bl 0x1000554c                  ; -> 1000554c
10008e9c  60000000    ori r0,r0,0x0               
10008ea0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10008ea4  28030000    cmplwi r3,0x0               
10008ea8  41820018    beq 0x10008ec0                 ; -> 10008ec0
10008eac  39600009    li r11,0x9                  
10008eb0  b17f0004    sth r11,0x4(r31)            
10008eb4  39800000    li r12,0x0                  
10008eb8  b19f0026    sth r12,0x26(r31)           
10008ebc  48000160    b 0x1000901c                   ; -> 1000901c
10008ec0  ab1f0012    lha r24,0x12(r31)           
10008ec4  3878ffe0    subi r3,r24,0x20            
10008ec8  48025831    bl 0x1002e6f8                  ; -> 1002e6f8
10008ecc  60000000    ori r0,r0,0x0               
10008ed0  7c791b78    or r25,r3,r3                
10008ed4  a87f0010    lha r3,0x10(r31)            
10008ed8  480257f5    bl 0x1002e6cc                  ; -> 1002e6cc
10008edc  60000000    ori r0,r0,0x0               
10008ee0  7c781b78    or r24,r3,r3                
10008ee4  7f03c378    or r3,r24,r24               
10008ee8  7f24cb78    or r4,r25,r25               
10008eec  4bffb765    bl 0x10004650                  ; -> 10004650
10008ef0  60000000    ori r0,r0,0x0               
10008ef4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10008ef8  28030000    cmplwi r3,0x0               
10008efc  40820018    bne 0x10008f14                 ; -> 10008f14
10008f00  3b200009    li r25,0x9                  
10008f04  b33f0004    sth r25,0x4(r31)            
10008f08  38600000    li r3,0x0                   
10008f0c  b07f0026    sth r3,0x26(r31)            
10008f10  4800010c    b 0x1000901c                   ; -> 1000901c
10008f14  a8bf0012    lha r5,0x12(r31)            
10008f18  a87f0010    lha r3,0x10(r31)            
10008f1c  3885ffe0    subi r4,r5,0x20             
10008f20  4bffc6a9    bl 0x100055c8                  ; -> 100055c8
10008f24  60000000    ori r0,r0,0x0               
10008f28  7c7b1b78    or r27,r3,r3                
10008f2c  7f63db78    or r3,r27,r27               
10008f30  48000101    bl 0x10009030                  ; -> 10009030
10008f34  60000000    ori r0,r0,0x0               
10008f38  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10008f3c  28030000    cmplwi r3,0x0               
10008f40  40820018    bne 0x10008f58                 ; -> 10008f58
10008f44  38c00009    li r6,0x9                   
10008f48  b0df0004    sth r6,0x4(r31)             
10008f4c  38e00000    li r7,0x0                   
10008f50  b0ff0026    sth r7,0x26(r31)            
10008f54  480000c8    b 0x1000901c                   ; -> 1000901c
10008f58  4bffc9f1    bl 0x10005948                  ; -> 10005948
10008f5c  60000000    ori r0,r0,0x0               
10008f60  7c7d1b78    or r29,r3,r3                
10008f64  7fa90734    extsh r9,r29                
10008f68  1d290046    mulli r9,r9,0x46            
10008f6c  7fab0734    extsh r11,r29               
10008f70  1d6b0046    mulli r11,r11,0x46          
10008f74  7fb80734    extsh r24,r29               
10008f78  1f180046    mulli r24,r24,0x46          
10008f7c  7fa30734    extsh r3,r29                
10008f80  1c630046    mulli r3,r3,0x46            
10008f84  7fa50734    extsh r5,r29                
10008f88  1ca50046    mulli r5,r5,0x46            
10008f8c  7fa70734    extsh r7,r29                
10008f90  1ce70046    mulli r7,r7,0x46            
10008f94  a91f0010    lha r8,0x10(r31)            
10008f98  39290010    addi r9,r9,0x10             
10008f9c  7d1e4b2e    sthx r8,r30,r9              
10008fa0  a95f0012    lha r10,0x12(r31)           
10008fa4  7fa90734    extsh r9,r29                
10008fa8  1d290046    mulli r9,r9,0x46            
10008fac  394affe0    subi r10,r10,0x20           
10008fb0  396b0012    addi r11,r11,0x12           
10008fb4  7d5e5b2e    sthx r10,r30,r11            
10008fb8  7fab0734    extsh r11,r29               
10008fbc  1d6b0046    mulli r11,r11,0x46          
10008fc0  39800008    li r12,0x8                  
10008fc4  3b180004    addi r24,r24,0x4            
10008fc8  7d9ec32e    sthx r12,r30,r24            
10008fcc  7fb80734    extsh r24,r29               
10008fd0  1f180046    mulli r24,r24,0x46          
10008fd4  3b200011    li r25,0x11                 
10008fd8  38630002    addi r3,r3,0x2              
10008fdc  7f3e1b2e    sthx r25,r30,r3             
10008fe0  809a0040    lwz r4,0x40(r26)            
10008fe4  38a5000a    addi r5,r5,0xa              
10008fe8  7c9e292e    stwx r4,r30,r5              
10008fec  38c0000f    li r6,0xf                   
10008ff0  38e7000e    addi r7,r7,0xe              
10008ff4  7cde3b2e    sthx r6,r30,r7              
10008ff8  39000000    li r8,0x0                   
10008ffc  39290014    addi r9,r9,0x14             
10009000  7d1e492e    stwx r8,r30,r9              
10009004  39400000    li r10,0x0                  
10009008  396b001e    addi r11,r11,0x1e           
1000900c  7d5e59ae    stbx r10,r30,r11            
10009010  a99f0008    lha r12,0x8(r31)            
10009014  3b180008    addi r24,r24,0x8            
10009018  7d9ec32e    sthx r12,r30,r24            
1000901c  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10009020  38210060    addi r1,r1,0x60             
10009024  7c0803a6    mtspr LR,r0                 
10009028  bb01ffe0    lmw r24,-0x20(r1)              ; -> Stack[-0x20]
1000902c  4e800020    blr                         
