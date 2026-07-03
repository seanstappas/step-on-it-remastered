; FUN_10005d30 @ 0x10005d30
10005d30  7c0802a6    mfspr r0,LR                 
10005d34  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
10005d38  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10005d3c  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10005d40  b061007a    sth r3,0x7a(r1)                ; -> Stack[0x1a]
10005d44  a861007a    lha r3,0x7a(r1)                ; -> Stack[0x1a]
10005d48  3bc23cd8    addi r30,r2,0x3cd8          
10005d4c  1c630046    mulli r3,r3,0x46            
10005d50  7ffe1a14    add r31,r30,r3              
10005d54  889f001f    lbz r4,0x1f(r31)            
10005d58  3b8261a4    addi r28,r2,0x61a4          
10005d5c  28040000    cmplwi r4,0x0               
10005d60  3b600010    li r27,0x10                 
10005d64  41820094    beq 0x10005df8                 ; -> 10005df8
10005d68  38a00000    li r5,0x0                   
10005d6c  98bf001f    stb r5,0x1f(r31)            
10005d70  38c00001    li r6,0x1                   
10005d74  98df0035    stb r6,0x35(r31)            
10005d78  a8ff0006    lha r7,0x6(r31)             
10005d7c  38800032    li r4,0x32                  
10005d80  1ce70006    mulli r7,r7,0x6             
10005d84  b0ff0024    sth r7,0x24(r31)            
10005d88  807c0030    lwz r3,0x30(r28)            
10005d8c  a8bf0010    lha r5,0x10(r31)            
10005d90  a8df0012    lha r6,0x12(r31)            
10005d94  4bffe375    bl 0x10004108                  ; -> 10004108
10005d98  60000000    ori r0,r0,0x0               
10005d9c  a93f0012    lha r9,0x12(r31)            
10005da0  39000100    li r8,0x100                 
10005da4  7d1a4378    or r26,r8,r8                
10005da8  3869000a    addi r3,r9,0xa              
10005dac  4802894d    bl 0x1002e6f8                  ; -> 1002e6f8
10005db0  60000000    ori r0,r0,0x0               
10005db4  7c630734    extsh r3,r3                 
10005db8  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10005dbc  a95f0010    lha r10,0x10(r31)           
10005dc0  7c791b78    or r25,r3,r3                
10005dc4  386a000a    addi r3,r10,0xa             
10005dc8  48028905    bl 0x1002e6cc                  ; -> 1002e6cc
10005dcc  60000000    ori r0,r0,0x0               
10005dd0  7c630734    extsh r3,r3                 
10005dd4  1c63003c    mulli r3,r3,0x3c            
10005dd8  7c63ca14    add r3,r3,r25               
10005ddc  39626bf8    addi r11,r2,0x6bf8          
10005de0  398003e8    li r12,0x3e8                
10005de4  7f4b192e    stwx r26,r11,r3             
10005de8  b19f0038    sth r12,0x38(r31)           
10005dec  3b200000    li r25,0x0                  
10005df0  9b3f001e    stb r25,0x1e(r31)           
10005df4  4800002c    b 0x10005e20                   ; -> 10005e20
10005df8  3b423bde    addi r26,r2,0x3bde          
10005dfc  8b5a0000    lbz r26,0x0(r26)            
10005e00  281a0000    cmplwi r26,0x0              
10005e04  4182001c    beq 0x10005e20                 ; -> 10005e20
10005e08  807c0030    lwz r3,0x30(r28)            
10005e0c  a8bf0010    lha r5,0x10(r31)            
10005e10  a8df0012    lha r6,0x12(r31)            
10005e14  38800032    li r4,0x32                  
10005e18  4bffe2f1    bl 0x10004108                  ; -> 10004108
10005e1c  60000000    ori r0,r0,0x0               
10005e20  a87f0024    lha r3,0x24(r31)            
10005e24  7c641b78    or r4,r3,r3                 
10005e28  7c840734    extsh r4,r4                 
10005e2c  3863ffff    subi r3,r3,0x1              
10005e30  2c040000    cmpwi r4,0x0                
10005e34  b07f0024    sth r3,0x24(r31)            
10005e38  408201e0    bne 0x10006018                 ; -> 10006018
10005e3c  4bfffb0d    bl 0x10005948                  ; -> 10005948
10005e40  60000000    ori r0,r0,0x0               
10005e44  a8bf0004    lha r5,0x4(r31)             
10005e48  7c7d1b78    or r29,r3,r3                
10005e4c  2c050004    cmpwi r5,0x4                
10005e50  40820024    bne 0x10005e74                 ; -> 10005e74
10005e54  a87f0010    lha r3,0x10(r31)            
10005e58  4bfff64d    bl 0x100054a4                  ; -> 100054a4
10005e5c  60000000    ori r0,r0,0x0               
10005e60  7fa60734    extsh r6,r29                
10005e64  1cc60046    mulli r6,r6,0x46            
10005e68  38c60004    addi r6,r6,0x4              
10005e6c  7c7e332e    sthx r3,r30,r6              
10005e70  480000a0    b 0x10005f10                   ; -> 10005f10
10005e74  a8ff0004    lha r7,0x4(r31)             
10005e78  2c070003    cmpwi r7,0x3                
10005e7c  40820050    bne 0x10005ecc                 ; -> 10005ecc
10005e80  891f0034    lbz r8,0x34(r31)            
10005e84  28080000    cmplwi r8,0x0               
10005e88  41820024    beq 0x10005eac                 ; -> 10005eac
10005e8c  7faa0734    extsh r10,r29               
10005e90  1d4a0046    mulli r10,r10,0x46          
10005e94  39200001    li r9,0x1                   
10005e98  394a0004    addi r10,r10,0x4            
10005e9c  7d3e532e    sthx r9,r30,r10             
10005ea0  39600000    li r11,0x0                  
10005ea4  997f0034    stb r11,0x34(r31)           
10005ea8  48000068    b 0x10005f10                   ; -> 10005f10
10005eac  7fb90734    extsh r25,r29               
10005eb0  1f390046    mulli r25,r25,0x46          
10005eb4  39800002    li r12,0x2                  
10005eb8  3b390004    addi r25,r25,0x4            
10005ebc  7d9ecb2e    sthx r12,r30,r25            
10005ec0  3b400001    li r26,0x1                  
10005ec4  9b5f0034    stb r26,0x34(r31)           
10005ec8  48000048    b 0x10005f10                   ; -> 10005f10
10005ecc  a87f0004    lha r3,0x4(r31)             
10005ed0  2c030002    cmpwi r3,0x2                
10005ed4  4082001c    bne 0x10005ef0                 ; -> 10005ef0
10005ed8  7fa50734    extsh r5,r29                
10005edc  1ca50046    mulli r5,r5,0x46            
10005ee0  38800002    li r4,0x2                   
10005ee4  38a50004    addi r5,r5,0x4              
10005ee8  7c9e2b2e    sthx r4,r30,r5              
10005eec  48000024    b 0x10005f10                   ; -> 10005f10
10005ef0  a8df0004    lha r6,0x4(r31)             
10005ef4  2c060001    cmpwi r6,0x1                
10005ef8  40820018    bne 0x10005f10                 ; -> 10005f10
10005efc  7fa80734    extsh r8,r29                
10005f00  1d080046    mulli r8,r8,0x46            
10005f04  38e00001    li r7,0x1                   
10005f08  39080004    addi r8,r8,0x4              
10005f0c  7cfe432e    sthx r7,r30,r8              
10005f10  7fa90734    extsh r9,r29                
10005f14  1d290046    mulli r9,r9,0x46            
10005f18  39290004    addi r9,r9,0x4              
10005f1c  7d3e4aae    lhax r9,r30,r9              
10005f20  2c090002    cmpwi r9,0x2                
10005f24  40820038    bne 0x10005f5c                 ; -> 10005f5c
10005f28  7fab0734    extsh r11,r29               
10005f2c  1d6b0046    mulli r11,r11,0x46          
10005f30  7fb90734    extsh r25,r29               
10005f34  1f390046    mulli r25,r25,0x46          
10005f38  a95f0010    lha r10,0x10(r31)           
10005f3c  396b0010    addi r11,r11,0x10           
10005f40  7d5e5b2e    sthx r10,r30,r11            
10005f44  a99f0012    lha r12,0x12(r31)           
10005f48  3b390012    addi r25,r25,0x12           
10005f4c  398c0020    addi r12,r12,0x20           
10005f50  7d9b6050    subf r12,r27,r12            
10005f54  7d9ecb2e    sthx r12,r30,r25            
10005f58  4800004c    b 0x10005fa4                   ; -> 10005fa4
10005f5c  7fba0734    extsh r26,r29               
10005f60  1f5a0046    mulli r26,r26,0x46          
10005f64  3b5a0004    addi r26,r26,0x4            
10005f68  7f5ed2ae    lhax r26,r30,r26            
10005f6c  2c1a0001    cmpwi r26,0x1               
10005f70  40820034    bne 0x10005fa4                 ; -> 10005fa4
10005f74  7fa40734    extsh r4,r29                
10005f78  1c840046    mulli r4,r4,0x46            
10005f7c  7fa60734    extsh r6,r29                
10005f80  1cc60046    mulli r6,r6,0x46            
10005f84  a87f0010    lha r3,0x10(r31)            
10005f88  38840010    addi r4,r4,0x10             
10005f8c  7c7e232e    sthx r3,r30,r4              
10005f90  a8bf0012    lha r5,0x12(r31)            
10005f94  38c60012    addi r6,r6,0x12             
10005f98  38a50020    addi r5,r5,0x20             
10005f9c  7cbb2850    subf r5,r27,r5              
10005fa0  7cbe332e    sthx r5,r30,r6              
10005fa4  7fa80734    extsh r8,r29                
10005fa8  1d080046    mulli r8,r8,0x46            
10005fac  7faa0734    extsh r10,r29               
10005fb0  1d4a0046    mulli r10,r10,0x46          
10005fb4  7fac0734    extsh r12,r29               
10005fb8  1d8c0046    mulli r12,r12,0x46          
10005fbc  7fba0734    extsh r26,r29               
10005fc0  1f5a0046    mulli r26,r26,0x46          
10005fc4  7fa40734    extsh r4,r29                
10005fc8  1c840046    mulli r4,r4,0x46            
10005fcc  38e00070    li r7,0x70                  
10005fd0  39080002    addi r8,r8,0x2              
10005fd4  7cfe432e    sthx r7,r30,r8              
10005fd8  813c0030    lwz r9,0x30(r28)            
10005fdc  394a000a    addi r10,r10,0xa            
10005fe0  7d3e512e    stwx r9,r30,r10             
10005fe4  39600000    li r11,0x0                  
10005fe8  398c0014    addi r12,r12,0x14           
10005fec  7d7e612e    stwx r11,r30,r12            
10005ff0  3b200000    li r25,0x0                  
10005ff4  3b5a001e    addi r26,r26,0x1e           
10005ff8  7f3ed1ae    stbx r25,r30,r26            
10005ffc  a87f0008    lha r3,0x8(r31)             
10006000  3884002c    addi r4,r4,0x2c             
10006004  54631838    rlwinm r3,r3,0x3,0x0,0x1c   
10006008  7c7e232e    sthx r3,r30,r4              
1000600c  a8bf0008    lha r5,0x8(r31)             
10006010  1ca50006    mulli r5,r5,0x6             
10006014  b0bf0024    sth r5,0x24(r31)            
10006018  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1000601c  38210060    addi r1,r1,0x60             
10006020  7c0803a6    mtspr LR,r0                 
10006024  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
10006028  4e800020    blr                         
