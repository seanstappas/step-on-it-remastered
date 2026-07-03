; FUN_1000bf54 @ 0x1000bf54
1000bf54  7c0802a6    mfspr r0,LR                 
1000bf58  bf01ffe0    stmw r24,-0x20(r1)             ; -> Stack[-0x20]
1000bf5c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000bf60  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1000bf64  7c791b78    or r25,r3,r3                
1000bf68  7c9a2378    or r26,r4,r4                
1000bf6c  b0a10082    sth r5,0x82(r1)                ; -> Stack[0x22]
1000bf70  3bc23cd8    addi r30,r2,0x3cd8          
1000bf74  3861003a    addi r3,r1,0x3a             
1000bf78  38810038    addi r4,r1,0x38             
1000bf7c  48000219    bl 0x1000c194                  ; -> 1000c194
1000bf80  60000000    ori r0,r0,0x0               
1000bf84  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000bf88  28030000    cmplwi r3,0x0               
1000bf8c  40820058    bne 0x1000bfe4                 ; -> 1000bfe4
1000bf90  38823be6    addi r4,r2,0x3be6           
1000bf94  a8640000    lha r3,0x0(r4)              
1000bf98  48022735    bl 0x1002e6cc                  ; -> 1002e6cc
1000bf9c  60000000    ori r0,r0,0x0               
1000bfa0  7c781b78    or r24,r3,r3                
1000bfa4  7f03c378    or r3,r24,r24               
1000bfa8  48022705    bl 0x1002e6ac                  ; -> 1002e6ac
1000bfac  60000000    ori r0,r0,0x0               
1000bfb0  38630004    addi r3,r3,0x4              
1000bfb4  38a23be4    addi r5,r2,0x3be4           
1000bfb8  b061003a    sth r3,0x3a(r1)                ; -> Stack[-0x26]
1000bfbc  a8650000    lha r3,0x0(r5)              
1000bfc0  48022739    bl 0x1002e6f8                  ; -> 1002e6f8
1000bfc4  60000000    ori r0,r0,0x0               
1000bfc8  7c781b78    or r24,r3,r3                
1000bfcc  7f03c378    or r3,r24,r24               
1000bfd0  480226ed    bl 0x1002e6bc                  ; -> 1002e6bc
1000bfd4  60000000    ori r0,r0,0x0               
1000bfd8  38630004    addi r3,r3,0x4              
1000bfdc  b0610038    sth r3,0x38(r1)                ; -> Stack[-0x28]
1000bfe0  4800002c    b 0x1000c00c                   ; -> 1000c00c
1000bfe4  a861003a    lha r3,0x3a(r1)                ; -> Stack[-0x26]
1000bfe8  480226c5    bl 0x1002e6ac                  ; -> 1002e6ac
1000bfec  60000000    ori r0,r0,0x0               
1000bff0  38630004    addi r3,r3,0x4              
1000bff4  b061003a    sth r3,0x3a(r1)                ; -> Stack[-0x26]
1000bff8  a8610038    lha r3,0x38(r1)                ; -> Stack[-0x28]
1000bffc  480226c1    bl 0x1002e6bc                  ; -> 1002e6bc
1000c000  60000000    ori r0,r0,0x0               
1000c004  38630004    addi r3,r3,0x4              
1000c008  b0610038    sth r3,0x38(r1)                ; -> Stack[-0x28]
1000c00c  a8610082    lha r3,0x82(r1)                ; -> Stack[0x22]
1000c010  4bff9ab9    bl 0x10005ac8                  ; -> 10005ac8
1000c014  60000000    ori r0,r0,0x0               
1000c018  7c7f1b78    or r31,r3,r3                
1000c01c  7fe60734    extsh r6,r31                
1000c020  1cc60046    mulli r6,r6,0x46            
1000c024  7fe70734    extsh r7,r31                
1000c028  1ce70046    mulli r7,r7,0x46            
1000c02c  7fe90734    extsh r9,r31                
1000c030  1d290046    mulli r9,r9,0x46            
1000c034  38c60010    addi r6,r6,0x10             
1000c038  7feb0734    extsh r11,r31               
1000c03c  7f3e332e    sthx r25,r30,r6             
1000c040  38e70012    addi r7,r7,0x12             
1000c044  1d6b0046    mulli r11,r11,0x46          
1000c048  7ff80734    extsh r24,r31               
1000c04c  7f5e3b2e    sthx r26,r30,r7             
1000c050  1f180046    mulli r24,r24,0x46          
1000c054  7fe40734    extsh r4,r31                
1000c058  1c840046    mulli r4,r4,0x46            
1000c05c  7fe60734    extsh r6,r31                
1000c060  1cc60046    mulli r6,r6,0x46            
1000c064  390000c8    li r8,0xc8                  
1000c068  39290002    addi r9,r9,0x2              
1000c06c  7d1e4b2e    sthx r8,r30,r9              
1000c070  39426ba4    addi r10,r2,0x6ba4          
1000c074  7fe80734    extsh r8,r31                
1000c078  1d080046    mulli r8,r8,0x46            
1000c07c  814a0000    lwz r10,0x0(r10)            
1000c080  396b000a    addi r11,r11,0xa            
1000c084  7d5e592e    stwx r10,r30,r11            
1000c088  3980002e    li r12,0x2e                 
1000c08c  3b18000e    addi r24,r24,0xe            
1000c090  7d9ec32e    sthx r12,r30,r24            
1000c094  38600000    li r3,0x0                   
1000c098  38840014    addi r4,r4,0x14             
1000c09c  7c7e212e    stwx r3,r30,r4              
1000c0a0  38a00000    li r5,0x0                   
1000c0a4  38c6001e    addi r6,r6,0x1e             
1000c0a8  7cbe31ae    stbx r5,r30,r6              
1000c0ac  38e00001    li r7,0x1                   
1000c0b0  39080024    addi r8,r8,0x24             
1000c0b4  7cfe432e    sthx r7,r30,r8              
1000c0b8  a8610038    lha r3,0x38(r1)                ; -> Stack[-0x28]
1000c0bc  4802263d    bl 0x1002e6f8                  ; -> 1002e6f8
1000c0c0  60000000    ori r0,r0,0x0               
1000c0c4  7fe90734    extsh r9,r31                
1000c0c8  1d290046    mulli r9,r9,0x46            
1000c0cc  39290038    addi r9,r9,0x38             
1000c0d0  7c7e4b2e    sthx r3,r30,r9              
1000c0d4  a861003a    lha r3,0x3a(r1)                ; -> Stack[-0x26]
1000c0d8  480225f5    bl 0x1002e6cc                  ; -> 1002e6cc
1000c0dc  60000000    ori r0,r0,0x0               
1000c0e0  7fea0734    extsh r10,r31               
1000c0e4  1d4a0046    mulli r10,r10,0x46          
1000c0e8  394a003c    addi r10,r10,0x3c           
1000c0ec  7c7e532e    sthx r3,r30,r10             
1000c0f0  a981003a    lha r12,0x3a(r1)               ; -> Stack[-0x26]
1000c0f4  7f2b0734    extsh r11,r25               
1000c0f8  7fab6050    subf r29,r11,r12            
1000c0fc  a8610038    lha r3,0x38(r1)                ; -> Stack[-0x28]
1000c100  7f580734    extsh r24,r26               
1000c104  7f981850    subf r28,r24,r3             
1000c108  7c9de9d6    mullw r4,r29,r29            
1000c10c  7cbce1d6    mullw r5,r28,r28            
1000c110  7c642a14    add r3,r4,r5                
1000c114  4bff7661    bl 0x10003774                  ; -> 10003774
1000c118  60000000    ori r0,r0,0x0               
1000c11c  7fe70734    extsh r7,r31                
1000c120  1ce70046    mulli r7,r7,0x46            
1000c124  7fe90734    extsh r9,r31                
1000c128  1d290046    mulli r9,r9,0x46            
1000c12c  7c7b1b78    or r27,r3,r3                
1000c130  57a66026    rlwinm r6,r29,0xc,0x0,0x13  
1000c134  57886026    rlwinm r8,r28,0xc,0x0,0x13  
1000c138  7cc6dbd6    divw r6,r6,r27              
1000c13c  7feb0734    extsh r11,r31               
1000c140  1d6b0046    mulli r11,r11,0x46          
1000c144  7ff80734    extsh r24,r31               
1000c148  1f180046    mulli r24,r24,0x46          
1000c14c  38e70028    addi r7,r7,0x28             
1000c150  7f2a0734    extsh r10,r25               
1000c154  7f4c0734    extsh r12,r26               
1000c158  7d08dbd6    divw r8,r8,r27              
1000c15c  7cde3b2e    sthx r6,r30,r7              
1000c160  3929002a    addi r9,r9,0x2a             
1000c164  7d1e4b2e    sthx r8,r30,r9              
1000c168  554a2834    rlwinm r10,r10,0x5,0x0,0x1a 
1000c16c  396b002c    addi r11,r11,0x2c           
1000c170  7d5e5b2e    sthx r10,r30,r11            
1000c174  558c2834    rlwinm r12,r12,0x5,0x0,0x1a 
1000c178  3b18002e    addi r24,r24,0x2e           
1000c17c  7d9ec32e    sthx r12,r30,r24            
1000c180  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1000c184  38210060    addi r1,r1,0x60             
1000c188  7c0803a6    mtspr LR,r0                 
1000c18c  bb01ffe0    lmw r24,-0x20(r1)              ; -> Stack[-0x20]
1000c190  4e800020    blr                         
