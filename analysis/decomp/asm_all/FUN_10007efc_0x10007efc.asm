; FUN_10007efc @ 0x10007efc
10007efc  7c0802a6    mfspr r0,LR                 
10007f00  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
10007f04  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10007f08  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10007f0c  b061007a    sth r3,0x7a(r1)                ; -> Stack[0x1a]
10007f10  a861007a    lha r3,0x7a(r1)                ; -> Stack[0x1a]
10007f14  3bc23cd8    addi r30,r2,0x3cd8          
10007f18  1c630046    mulli r3,r3,0x46            
10007f1c  7ffe1a14    add r31,r30,r3              
10007f20  889f001f    lbz r4,0x1f(r31)            
10007f24  3b8261a4    addi r28,r2,0x61a4          
10007f28  28040000    cmplwi r4,0x0               
10007f2c  3b600012    li r27,0x12                 
10007f30  41820094    beq 0x10007fc4                 ; -> 10007fc4
10007f34  38a00000    li r5,0x0                   
10007f38  98bf001f    stb r5,0x1f(r31)            
10007f3c  38c00001    li r6,0x1                   
10007f40  98df0035    stb r6,0x35(r31)            
10007f44  a8ff0006    lha r7,0x6(r31)             
10007f48  38800021    li r4,0x21                  
10007f4c  1ce70006    mulli r7,r7,0x6             
10007f50  b0ff0024    sth r7,0x24(r31)            
10007f54  807c0014    lwz r3,0x14(r28)            
10007f58  a8bf0010    lha r5,0x10(r31)            
10007f5c  a8df0012    lha r6,0x12(r31)            
10007f60  4bffc1a9    bl 0x10004108                  ; -> 10004108
10007f64  60000000    ori r0,r0,0x0               
10007f68  a93f0012    lha r9,0x12(r31)            
10007f6c  39000100    li r8,0x100                 
10007f70  7d1a4378    or r26,r8,r8                
10007f74  3869000a    addi r3,r9,0xa              
10007f78  48026781    bl 0x1002e6f8                  ; -> 1002e6f8
10007f7c  60000000    ori r0,r0,0x0               
10007f80  7c630734    extsh r3,r3                 
10007f84  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10007f88  a95f0010    lha r10,0x10(r31)           
10007f8c  7c791b78    or r25,r3,r3                
10007f90  386a000a    addi r3,r10,0xa             
10007f94  48026739    bl 0x1002e6cc                  ; -> 1002e6cc
10007f98  60000000    ori r0,r0,0x0               
10007f9c  7c630734    extsh r3,r3                 
10007fa0  1c63003c    mulli r3,r3,0x3c            
10007fa4  7c63ca14    add r3,r3,r25               
10007fa8  39626bf8    addi r11,r2,0x6bf8          
10007fac  398003e8    li r12,0x3e8                
10007fb0  7f4b192e    stwx r26,r11,r3             
10007fb4  b19f0038    sth r12,0x38(r31)           
10007fb8  3b200000    li r25,0x0                  
10007fbc  9b3f001e    stb r25,0x1e(r31)           
10007fc0  4800002c    b 0x10007fec                   ; -> 10007fec
10007fc4  3b423bde    addi r26,r2,0x3bde          
10007fc8  8b5a0000    lbz r26,0x0(r26)            
10007fcc  281a0000    cmplwi r26,0x0              
10007fd0  4182001c    beq 0x10007fec                 ; -> 10007fec
10007fd4  807c0014    lwz r3,0x14(r28)            
10007fd8  a8bf0010    lha r5,0x10(r31)            
10007fdc  a8df0012    lha r6,0x12(r31)            
10007fe0  38800021    li r4,0x21                  
10007fe4  4bffc125    bl 0x10004108                  ; -> 10004108
10007fe8  60000000    ori r0,r0,0x0               
10007fec  a87f0024    lha r3,0x24(r31)            
10007ff0  7c641b78    or r4,r3,r3                 
10007ff4  7c840734    extsh r4,r4                 
10007ff8  3863ffff    subi r3,r3,0x1              
10007ffc  2c040000    cmpwi r4,0x0                
10008000  b07f0024    sth r3,0x24(r31)            
10008004  408201e0    bne 0x100081e4                 ; -> 100081e4
10008008  4bffd941    bl 0x10005948                  ; -> 10005948
1000800c  60000000    ori r0,r0,0x0               
10008010  a8bf0004    lha r5,0x4(r31)             
10008014  7c7d1b78    or r29,r3,r3                
10008018  2c050004    cmpwi r5,0x4                
1000801c  40820024    bne 0x10008040                 ; -> 10008040
10008020  a87f0010    lha r3,0x10(r31)            
10008024  4bffd481    bl 0x100054a4                  ; -> 100054a4
10008028  60000000    ori r0,r0,0x0               
1000802c  7fa60734    extsh r6,r29                
10008030  1cc60046    mulli r6,r6,0x46            
10008034  38c60004    addi r6,r6,0x4              
10008038  7c7e332e    sthx r3,r30,r6              
1000803c  480000a0    b 0x100080dc                   ; -> 100080dc
10008040  a8ff0004    lha r7,0x4(r31)             
10008044  2c070003    cmpwi r7,0x3                
10008048  40820050    bne 0x10008098                 ; -> 10008098
1000804c  891f0034    lbz r8,0x34(r31)            
10008050  28080000    cmplwi r8,0x0               
10008054  41820024    beq 0x10008078                 ; -> 10008078
10008058  7faa0734    extsh r10,r29               
1000805c  1d4a0046    mulli r10,r10,0x46          
10008060  39200001    li r9,0x1                   
10008064  394a0004    addi r10,r10,0x4            
10008068  7d3e532e    sthx r9,r30,r10             
1000806c  39600000    li r11,0x0                  
10008070  997f0034    stb r11,0x34(r31)           
10008074  48000068    b 0x100080dc                   ; -> 100080dc
10008078  7fb90734    extsh r25,r29               
1000807c  1f390046    mulli r25,r25,0x46          
10008080  39800002    li r12,0x2                  
10008084  3b390004    addi r25,r25,0x4            
10008088  7d9ecb2e    sthx r12,r30,r25            
1000808c  3b400001    li r26,0x1                  
10008090  9b5f0034    stb r26,0x34(r31)           
10008094  48000048    b 0x100080dc                   ; -> 100080dc
10008098  a87f0004    lha r3,0x4(r31)             
1000809c  2c030002    cmpwi r3,0x2                
100080a0  4082001c    bne 0x100080bc                 ; -> 100080bc
100080a4  7fa50734    extsh r5,r29                
100080a8  1ca50046    mulli r5,r5,0x46            
100080ac  38800002    li r4,0x2                   
100080b0  38a50004    addi r5,r5,0x4              
100080b4  7c9e2b2e    sthx r4,r30,r5              
100080b8  48000024    b 0x100080dc                   ; -> 100080dc
100080bc  a8df0004    lha r6,0x4(r31)             
100080c0  2c060001    cmpwi r6,0x1                
100080c4  40820018    bne 0x100080dc                 ; -> 100080dc
100080c8  7fa80734    extsh r8,r29                
100080cc  1d080046    mulli r8,r8,0x46            
100080d0  38e00001    li r7,0x1                   
100080d4  39080004    addi r8,r8,0x4              
100080d8  7cfe432e    sthx r7,r30,r8              
100080dc  7fa90734    extsh r9,r29                
100080e0  1d290046    mulli r9,r9,0x46            
100080e4  39290004    addi r9,r9,0x4              
100080e8  7d3e4aae    lhax r9,r30,r9              
100080ec  2c090002    cmpwi r9,0x2                
100080f0  40820038    bne 0x10008128                 ; -> 10008128
100080f4  7fab0734    extsh r11,r29               
100080f8  1d6b0046    mulli r11,r11,0x46          
100080fc  7fb90734    extsh r25,r29               
10008100  1f390046    mulli r25,r25,0x46          
10008104  a95f0010    lha r10,0x10(r31)           
10008108  396b0010    addi r11,r11,0x10           
1000810c  7d5e5b2e    sthx r10,r30,r11            
10008110  a99f0012    lha r12,0x12(r31)           
10008114  3b390012    addi r25,r25,0x12           
10008118  398c0020    addi r12,r12,0x20           
1000811c  7d9b6050    subf r12,r27,r12            
10008120  7d9ecb2e    sthx r12,r30,r25            
10008124  4800004c    b 0x10008170                   ; -> 10008170
10008128  7fba0734    extsh r26,r29               
1000812c  1f5a0046    mulli r26,r26,0x46          
10008130  3b5a0004    addi r26,r26,0x4            
10008134  7f5ed2ae    lhax r26,r30,r26            
10008138  2c1a0001    cmpwi r26,0x1               
1000813c  40820034    bne 0x10008170                 ; -> 10008170
10008140  7fa40734    extsh r4,r29                
10008144  1c840046    mulli r4,r4,0x46            
10008148  7fa60734    extsh r6,r29                
1000814c  1cc60046    mulli r6,r6,0x46            
10008150  a87f0010    lha r3,0x10(r31)            
10008154  38840010    addi r4,r4,0x10             
10008158  7c7e232e    sthx r3,r30,r4              
1000815c  a8bf0012    lha r5,0x12(r31)            
10008160  38c60012    addi r6,r6,0x12             
10008164  38a50020    addi r5,r5,0x20             
10008168  7cbb2850    subf r5,r27,r5              
1000816c  7cbe332e    sthx r5,r30,r6              
10008170  7fa80734    extsh r8,r29                
10008174  1d080046    mulli r8,r8,0x46            
10008178  7faa0734    extsh r10,r29               
1000817c  1d4a0046    mulli r10,r10,0x46          
10008180  7fac0734    extsh r12,r29               
10008184  1d8c0046    mulli r12,r12,0x46          
10008188  7fba0734    extsh r26,r29               
1000818c  1f5a0046    mulli r26,r26,0x46          
10008190  7fa40734    extsh r4,r29                
10008194  1c840046    mulli r4,r4,0x46            
10008198  38e00069    li r7,0x69                  
1000819c  39080002    addi r8,r8,0x2              
100081a0  7cfe432e    sthx r7,r30,r8              
100081a4  813c0014    lwz r9,0x14(r28)            
100081a8  394a000a    addi r10,r10,0xa            
100081ac  7d3e512e    stwx r9,r30,r10             
100081b0  39600000    li r11,0x0                  
100081b4  398c0014    addi r12,r12,0x14           
100081b8  7d7e612e    stwx r11,r30,r12            
100081bc  3b200000    li r25,0x0                  
100081c0  3b5a001e    addi r26,r26,0x1e           
100081c4  7f3ed1ae    stbx r25,r30,r26            
100081c8  a87f0008    lha r3,0x8(r31)             
100081cc  3884002c    addi r4,r4,0x2c             
100081d0  54631838    rlwinm r3,r3,0x3,0x0,0x1c   
100081d4  7c7e232e    sthx r3,r30,r4              
100081d8  a8bf0008    lha r5,0x8(r31)             
100081dc  1ca50006    mulli r5,r5,0x6             
100081e0  b0bf0024    sth r5,0x24(r31)            
100081e4  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
100081e8  38210060    addi r1,r1,0x60             
100081ec  7c0803a6    mtspr LR,r0                 
100081f0  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
100081f4  4e800020    blr                         
