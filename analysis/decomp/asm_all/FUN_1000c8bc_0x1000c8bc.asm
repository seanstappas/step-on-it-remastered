; FUN_1000c8bc @ 0x1000c8bc
1000c8bc  7c0802a6    mfspr r0,LR                 
1000c8c0  bf01ffe0    stmw r24,-0x20(r1)             ; -> Stack[-0x20]
1000c8c4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000c8c8  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1000c8cc  7c791b78    or r25,r3,r3                
1000c8d0  7c9a2378    or r26,r4,r4                
1000c8d4  b0c10086    sth r6,0x86(r1)                ; -> Stack[0x26]
1000c8d8  3bc23cd8    addi r30,r2,0x3cd8          
1000c8dc  3861003a    addi r3,r1,0x3a             
1000c8e0  38810038    addi r4,r1,0x38             
1000c8e4  48000219    bl 0x1000cafc                  ; -> 1000cafc
1000c8e8  60000000    ori r0,r0,0x0               
1000c8ec  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000c8f0  28030000    cmplwi r3,0x0               
1000c8f4  40820058    bne 0x1000c94c                 ; -> 1000c94c
1000c8f8  38823be6    addi r4,r2,0x3be6           
1000c8fc  a8640000    lha r3,0x0(r4)              
1000c900  48021dcd    bl 0x1002e6cc                  ; -> 1002e6cc
1000c904  60000000    ori r0,r0,0x0               
1000c908  7c781b78    or r24,r3,r3                
1000c90c  7f03c378    or r3,r24,r24               
1000c910  48021d9d    bl 0x1002e6ac                  ; -> 1002e6ac
1000c914  60000000    ori r0,r0,0x0               
1000c918  38630004    addi r3,r3,0x4              
1000c91c  38a23be4    addi r5,r2,0x3be4           
1000c920  b061003a    sth r3,0x3a(r1)                ; -> Stack[-0x26]
1000c924  a8650000    lha r3,0x0(r5)              
1000c928  48021dd1    bl 0x1002e6f8                  ; -> 1002e6f8
1000c92c  60000000    ori r0,r0,0x0               
1000c930  7c781b78    or r24,r3,r3                
1000c934  7f03c378    or r3,r24,r24               
1000c938  48021d85    bl 0x1002e6bc                  ; -> 1002e6bc
1000c93c  60000000    ori r0,r0,0x0               
1000c940  38630004    addi r3,r3,0x4              
1000c944  b0610038    sth r3,0x38(r1)                ; -> Stack[-0x28]
1000c948  4800002c    b 0x1000c974                   ; -> 1000c974
1000c94c  a861003a    lha r3,0x3a(r1)                ; -> Stack[-0x26]
1000c950  48021d5d    bl 0x1002e6ac                  ; -> 1002e6ac
1000c954  60000000    ori r0,r0,0x0               
1000c958  38630004    addi r3,r3,0x4              
1000c95c  b061003a    sth r3,0x3a(r1)                ; -> Stack[-0x26]
1000c960  a8610038    lha r3,0x38(r1)                ; -> Stack[-0x28]
1000c964  48021d59    bl 0x1002e6bc                  ; -> 1002e6bc
1000c968  60000000    ori r0,r0,0x0               
1000c96c  38630004    addi r3,r3,0x4              
1000c970  b0610038    sth r3,0x38(r1)                ; -> Stack[-0x28]
1000c974  a8610086    lha r3,0x86(r1)                ; -> Stack[0x26]
1000c978  4bff9151    bl 0x10005ac8                  ; -> 10005ac8
1000c97c  60000000    ori r0,r0,0x0               
1000c980  7c7f1b78    or r31,r3,r3                
1000c984  7fe60734    extsh r6,r31                
1000c988  1cc60046    mulli r6,r6,0x46            
1000c98c  7fe70734    extsh r7,r31                
1000c990  1ce70046    mulli r7,r7,0x46            
1000c994  7fe90734    extsh r9,r31                
1000c998  1d290046    mulli r9,r9,0x46            
1000c99c  38c60010    addi r6,r6,0x10             
1000c9a0  7feb0734    extsh r11,r31               
1000c9a4  7f3e332e    sthx r25,r30,r6             
1000c9a8  38e70012    addi r7,r7,0x12             
1000c9ac  1d6b0046    mulli r11,r11,0x46          
1000c9b0  7ff80734    extsh r24,r31               
1000c9b4  7f5e3b2e    sthx r26,r30,r7             
1000c9b8  1f180046    mulli r24,r24,0x46          
1000c9bc  7fe40734    extsh r4,r31                
1000c9c0  1c840046    mulli r4,r4,0x46            
1000c9c4  7fe60734    extsh r6,r31                
1000c9c8  1cc60046    mulli r6,r6,0x46            
1000c9cc  39000071    li r8,0x71                  
1000c9d0  39290002    addi r9,r9,0x2              
1000c9d4  7d1e4b2e    sthx r8,r30,r9              
1000c9d8  39426ba4    addi r10,r2,0x6ba4          
1000c9dc  7fe80734    extsh r8,r31                
1000c9e0  1d080046    mulli r8,r8,0x46            
1000c9e4  814a0000    lwz r10,0x0(r10)            
1000c9e8  396b000a    addi r11,r11,0xa            
1000c9ec  7d5e592e    stwx r10,r30,r11            
1000c9f0  39800010    li r12,0x10                 
1000c9f4  3b18000e    addi r24,r24,0xe            
1000c9f8  7d9ec32e    sthx r12,r30,r24            
1000c9fc  38600000    li r3,0x0                   
1000ca00  38840014    addi r4,r4,0x14             
1000ca04  7c7e212e    stwx r3,r30,r4              
1000ca08  38a00000    li r5,0x0                   
1000ca0c  38c6001e    addi r6,r6,0x1e             
1000ca10  7cbe31ae    stbx r5,r30,r6              
1000ca14  38e00001    li r7,0x1                   
1000ca18  39080024    addi r8,r8,0x24             
1000ca1c  7cfe432e    sthx r7,r30,r8              
1000ca20  a8610038    lha r3,0x38(r1)                ; -> Stack[-0x28]
1000ca24  48021cd5    bl 0x1002e6f8                  ; -> 1002e6f8
1000ca28  60000000    ori r0,r0,0x0               
1000ca2c  7fe90734    extsh r9,r31                
1000ca30  1d290046    mulli r9,r9,0x46            
1000ca34  39290038    addi r9,r9,0x38             
1000ca38  7c7e4b2e    sthx r3,r30,r9              
1000ca3c  a861003a    lha r3,0x3a(r1)                ; -> Stack[-0x26]
1000ca40  48021c8d    bl 0x1002e6cc                  ; -> 1002e6cc
1000ca44  60000000    ori r0,r0,0x0               
1000ca48  7fea0734    extsh r10,r31               
1000ca4c  1d4a0046    mulli r10,r10,0x46          
1000ca50  394a003c    addi r10,r10,0x3c           
1000ca54  7c7e532e    sthx r3,r30,r10             
1000ca58  a981003a    lha r12,0x3a(r1)               ; -> Stack[-0x26]
1000ca5c  7f2b0734    extsh r11,r25               
1000ca60  7fab6050    subf r29,r11,r12            
1000ca64  a8610038    lha r3,0x38(r1)                ; -> Stack[-0x28]
1000ca68  7f580734    extsh r24,r26               
1000ca6c  7f981850    subf r28,r24,r3             
1000ca70  7c9de9d6    mullw r4,r29,r29            
1000ca74  7cbce1d6    mullw r5,r28,r28            
1000ca78  7c642a14    add r3,r4,r5                
1000ca7c  4bff6cf9    bl 0x10003774                  ; -> 10003774
1000ca80  60000000    ori r0,r0,0x0               
1000ca84  7fe70734    extsh r7,r31                
1000ca88  1ce70046    mulli r7,r7,0x46            
1000ca8c  7fe90734    extsh r9,r31                
1000ca90  1d290046    mulli r9,r9,0x46            
1000ca94  7feb0734    extsh r11,r31               
1000ca98  1d6b0046    mulli r11,r11,0x46          
1000ca9c  7ff80734    extsh r24,r31               
1000caa0  1f180046    mulli r24,r24,0x46          
1000caa4  7f2a0734    extsh r10,r25               
1000caa8  7f4c0734    extsh r12,r26               
1000caac  7c7b1b78    or r27,r3,r3                
1000cab0  57a66026    rlwinm r6,r29,0xc,0x0,0x13  
1000cab4  57886026    rlwinm r8,r28,0xc,0x0,0x13  
1000cab8  7cc6dbd6    divw r6,r6,r27              
1000cabc  7d08dbd6    divw r8,r8,r27              
1000cac0  38e70028    addi r7,r7,0x28             
1000cac4  7cde3b2e    sthx r6,r30,r7              
1000cac8  3929002a    addi r9,r9,0x2a             
1000cacc  7d1e4b2e    sthx r8,r30,r9              
1000cad0  554a2834    rlwinm r10,r10,0x5,0x0,0x1a 
1000cad4  396b002c    addi r11,r11,0x2c           
1000cad8  7d5e5b2e    sthx r10,r30,r11            
1000cadc  558c2834    rlwinm r12,r12,0x5,0x0,0x1a 
1000cae0  3b18002e    addi r24,r24,0x2e           
1000cae4  7d9ec32e    sthx r12,r30,r24            
1000cae8  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1000caec  38210060    addi r1,r1,0x60             
1000caf0  7c0803a6    mtspr LR,r0                 
1000caf4  bb01ffe0    lmw r24,-0x20(r1)              ; -> Stack[-0x20]
1000caf8  4e800020    blr                         
