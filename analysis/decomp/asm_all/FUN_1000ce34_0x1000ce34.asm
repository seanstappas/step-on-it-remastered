; FUN_1000ce34 @ 0x1000ce34
1000ce34  7c0802a6    mfspr r0,LR                 
1000ce38  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
1000ce3c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000ce40  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1000ce44  b061007a    sth r3,0x7a(r1)                ; -> Stack[0x1a]
1000ce48  a861007a    lha r3,0x7a(r1)                ; -> Stack[0x1a]
1000ce4c  3bc23cd8    addi r30,r2,0x3cd8          
1000ce50  1c630046    mulli r3,r3,0x46            
1000ce54  7ffe1a14    add r31,r30,r3              
1000ce58  889f001f    lbz r4,0x1f(r31)            
1000ce5c  3b8261a4    addi r28,r2,0x61a4          
1000ce60  28040000    cmplwi r4,0x0               
1000ce64  3b60001e    li r27,0x1e                 
1000ce68  41820094    beq 0x1000cefc                 ; -> 1000cefc
1000ce6c  38a00000    li r5,0x0                   
1000ce70  98bf001f    stb r5,0x1f(r31)            
1000ce74  38c00001    li r6,0x1                   
1000ce78  98df0035    stb r6,0x35(r31)            
1000ce7c  a8ff0006    lha r7,0x6(r31)             
1000ce80  38800031    li r4,0x31                  
1000ce84  1ce70006    mulli r7,r7,0x6             
1000ce88  b0ff0024    sth r7,0x24(r31)            
1000ce8c  807c002c    lwz r3,0x2c(r28)            
1000ce90  a8bf0010    lha r5,0x10(r31)            
1000ce94  a8df0012    lha r6,0x12(r31)            
1000ce98  4bff7271    bl 0x10004108                  ; -> 10004108
1000ce9c  60000000    ori r0,r0,0x0               
1000cea0  a93f0012    lha r9,0x12(r31)            
1000cea4  39000100    li r8,0x100                 
1000cea8  7d1a4378    or r26,r8,r8                
1000ceac  3869000a    addi r3,r9,0xa              
1000ceb0  48021849    bl 0x1002e6f8                  ; -> 1002e6f8
1000ceb4  60000000    ori r0,r0,0x0               
1000ceb8  7c630734    extsh r3,r3                 
1000cebc  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1000cec0  a95f0010    lha r10,0x10(r31)           
1000cec4  7c791b78    or r25,r3,r3                
1000cec8  386a000a    addi r3,r10,0xa             
1000cecc  48021801    bl 0x1002e6cc                  ; -> 1002e6cc
1000ced0  60000000    ori r0,r0,0x0               
1000ced4  7c630734    extsh r3,r3                 
1000ced8  1c63003c    mulli r3,r3,0x3c            
1000cedc  7c63ca14    add r3,r3,r25               
1000cee0  39626bf8    addi r11,r2,0x6bf8          
1000cee4  398003e8    li r12,0x3e8                
1000cee8  7f4b192e    stwx r26,r11,r3             
1000ceec  b19f0038    sth r12,0x38(r31)           
1000cef0  3b200000    li r25,0x0                  
1000cef4  9b3f001e    stb r25,0x1e(r31)           
1000cef8  4800002c    b 0x1000cf24                   ; -> 1000cf24
1000cefc  3b423bde    addi r26,r2,0x3bde          
1000cf00  8b5a0000    lbz r26,0x0(r26)            
1000cf04  281a0000    cmplwi r26,0x0              
1000cf08  4182001c    beq 0x1000cf24                 ; -> 1000cf24
1000cf0c  807c002c    lwz r3,0x2c(r28)            
1000cf10  a8bf0010    lha r5,0x10(r31)            
1000cf14  a8df0012    lha r6,0x12(r31)            
1000cf18  38800031    li r4,0x31                  
1000cf1c  4bff71ed    bl 0x10004108                  ; -> 10004108
1000cf20  60000000    ori r0,r0,0x0               
1000cf24  a87f0024    lha r3,0x24(r31)            
1000cf28  7c641b78    or r4,r3,r3                 
1000cf2c  7c840734    extsh r4,r4                 
1000cf30  3863ffff    subi r3,r3,0x1              
1000cf34  2c040000    cmpwi r4,0x0                
1000cf38  b07f0024    sth r3,0x24(r31)            
1000cf3c  408201e0    bne 0x1000d11c                 ; -> 1000d11c
1000cf40  4bff8a09    bl 0x10005948                  ; -> 10005948
1000cf44  60000000    ori r0,r0,0x0               
1000cf48  a8bf0004    lha r5,0x4(r31)             
1000cf4c  7c7d1b78    or r29,r3,r3                
1000cf50  2c050004    cmpwi r5,0x4                
1000cf54  40820024    bne 0x1000cf78                 ; -> 1000cf78
1000cf58  a87f0010    lha r3,0x10(r31)            
1000cf5c  4bff8549    bl 0x100054a4                  ; -> 100054a4
1000cf60  60000000    ori r0,r0,0x0               
1000cf64  7fa60734    extsh r6,r29                
1000cf68  1cc60046    mulli r6,r6,0x46            
1000cf6c  38c60004    addi r6,r6,0x4              
1000cf70  7c7e332e    sthx r3,r30,r6              
1000cf74  480000a0    b 0x1000d014                   ; -> 1000d014
1000cf78  a8ff0004    lha r7,0x4(r31)             
1000cf7c  2c070003    cmpwi r7,0x3                
1000cf80  40820050    bne 0x1000cfd0                 ; -> 1000cfd0
1000cf84  891f0034    lbz r8,0x34(r31)            
1000cf88  28080000    cmplwi r8,0x0               
1000cf8c  41820024    beq 0x1000cfb0                 ; -> 1000cfb0
1000cf90  7faa0734    extsh r10,r29               
1000cf94  1d4a0046    mulli r10,r10,0x46          
1000cf98  39200001    li r9,0x1                   
1000cf9c  394a0004    addi r10,r10,0x4            
1000cfa0  7d3e532e    sthx r9,r30,r10             
1000cfa4  39600000    li r11,0x0                  
1000cfa8  997f0034    stb r11,0x34(r31)           
1000cfac  48000068    b 0x1000d014                   ; -> 1000d014
1000cfb0  7fb90734    extsh r25,r29               
1000cfb4  1f390046    mulli r25,r25,0x46          
1000cfb8  39800002    li r12,0x2                  
1000cfbc  3b390004    addi r25,r25,0x4            
1000cfc0  7d9ecb2e    sthx r12,r30,r25            
1000cfc4  3b400001    li r26,0x1                  
1000cfc8  9b5f0034    stb r26,0x34(r31)           
1000cfcc  48000048    b 0x1000d014                   ; -> 1000d014
1000cfd0  a87f0004    lha r3,0x4(r31)             
1000cfd4  2c030002    cmpwi r3,0x2                
1000cfd8  4082001c    bne 0x1000cff4                 ; -> 1000cff4
1000cfdc  7fa50734    extsh r5,r29                
1000cfe0  1ca50046    mulli r5,r5,0x46            
1000cfe4  38800002    li r4,0x2                   
1000cfe8  38a50004    addi r5,r5,0x4              
1000cfec  7c9e2b2e    sthx r4,r30,r5              
1000cff0  48000024    b 0x1000d014                   ; -> 1000d014
1000cff4  a8df0004    lha r6,0x4(r31)             
1000cff8  2c060001    cmpwi r6,0x1                
1000cffc  40820018    bne 0x1000d014                 ; -> 1000d014
1000d000  7fa80734    extsh r8,r29                
1000d004  1d080046    mulli r8,r8,0x46            
1000d008  38e00001    li r7,0x1                   
1000d00c  39080004    addi r8,r8,0x4              
1000d010  7cfe432e    sthx r7,r30,r8              
1000d014  7fa90734    extsh r9,r29                
1000d018  1d290046    mulli r9,r9,0x46            
1000d01c  39290004    addi r9,r9,0x4              
1000d020  7d3e4aae    lhax r9,r30,r9              
1000d024  2c090002    cmpwi r9,0x2                
1000d028  40820038    bne 0x1000d060                 ; -> 1000d060
1000d02c  7fab0734    extsh r11,r29               
1000d030  1d6b0046    mulli r11,r11,0x46          
1000d034  7fb90734    extsh r25,r29               
1000d038  1f390046    mulli r25,r25,0x46          
1000d03c  a95f0010    lha r10,0x10(r31)           
1000d040  396b0010    addi r11,r11,0x10           
1000d044  7d5e5b2e    sthx r10,r30,r11            
1000d048  a99f0012    lha r12,0x12(r31)           
1000d04c  3b390012    addi r25,r25,0x12           
1000d050  398c0020    addi r12,r12,0x20           
1000d054  7d9b6050    subf r12,r27,r12            
1000d058  7d9ecb2e    sthx r12,r30,r25            
1000d05c  4800004c    b 0x1000d0a8                   ; -> 1000d0a8
1000d060  7fba0734    extsh r26,r29               
1000d064  1f5a0046    mulli r26,r26,0x46          
1000d068  3b5a0004    addi r26,r26,0x4            
1000d06c  7f5ed2ae    lhax r26,r30,r26            
1000d070  2c1a0001    cmpwi r26,0x1               
1000d074  40820034    bne 0x1000d0a8                 ; -> 1000d0a8
1000d078  7fa40734    extsh r4,r29                
1000d07c  1c840046    mulli r4,r4,0x46            
1000d080  7fa60734    extsh r6,r29                
1000d084  1cc60046    mulli r6,r6,0x46            
1000d088  a87f0010    lha r3,0x10(r31)            
1000d08c  38840010    addi r4,r4,0x10             
1000d090  7c7e232e    sthx r3,r30,r4              
1000d094  a8bf0012    lha r5,0x12(r31)            
1000d098  38c60012    addi r6,r6,0x12             
1000d09c  38a50020    addi r5,r5,0x20             
1000d0a0  7cbb2850    subf r5,r27,r5              
1000d0a4  7cbe332e    sthx r5,r30,r6              
1000d0a8  7fa80734    extsh r8,r29                
1000d0ac  1d080046    mulli r8,r8,0x46            
1000d0b0  7faa0734    extsh r10,r29               
1000d0b4  1d4a0046    mulli r10,r10,0x46          
1000d0b8  7fac0734    extsh r12,r29               
1000d0bc  1d8c0046    mulli r12,r12,0x46          
1000d0c0  7fba0734    extsh r26,r29               
1000d0c4  1f5a0046    mulli r26,r26,0x46          
1000d0c8  7fa40734    extsh r4,r29                
1000d0cc  1c840046    mulli r4,r4,0x46            
1000d0d0  38e0006f    li r7,0x6f                  
1000d0d4  39080002    addi r8,r8,0x2              
1000d0d8  7cfe432e    sthx r7,r30,r8              
1000d0dc  813c002c    lwz r9,0x2c(r28)            
1000d0e0  394a000a    addi r10,r10,0xa            
1000d0e4  7d3e512e    stwx r9,r30,r10             
1000d0e8  39600000    li r11,0x0                  
1000d0ec  398c0014    addi r12,r12,0x14           
1000d0f0  7d7e612e    stwx r11,r30,r12            
1000d0f4  3b200000    li r25,0x0                  
1000d0f8  3b5a001e    addi r26,r26,0x1e           
1000d0fc  7f3ed1ae    stbx r25,r30,r26            
1000d100  a87f0008    lha r3,0x8(r31)             
1000d104  3884002c    addi r4,r4,0x2c             
1000d108  54631838    rlwinm r3,r3,0x3,0x0,0x1c   
1000d10c  7c7e232e    sthx r3,r30,r4              
1000d110  a8bf0008    lha r5,0x8(r31)             
1000d114  1ca50006    mulli r5,r5,0x6             
1000d118  b0bf0024    sth r5,0x24(r31)            
1000d11c  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1000d120  38210060    addi r1,r1,0x60             
1000d124  7c0803a6    mtspr LR,r0                 
1000d128  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
1000d12c  4e800020    blr                         
