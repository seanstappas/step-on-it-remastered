; FUN_1000e5c8 @ 0x1000e5c8
1000e5c8  7c0802a6    mfspr r0,LR                 
1000e5cc  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
1000e5d0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000e5d4  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1000e5d8  b061007a    sth r3,0x7a(r1)                ; -> Stack[0x1a]
1000e5dc  a881007a    lha r4,0x7a(r1)                ; -> Stack[0x1a]
1000e5e0  38623cd8    addi r3,r2,0x3cd8           
1000e5e4  1c840046    mulli r4,r4,0x46            
1000e5e8  7fe32214    add r31,r3,r4               
1000e5ec  a8bf0026    lha r5,0x26(r31)            
1000e5f0  3b226bf8    addi r25,r2,0x6bf8          
1000e5f4  2c050000    cmpwi r5,0x0                
1000e5f8  4081000c    ble 0x1000e604                 ; -> 1000e604
1000e5fc  38600000    li r3,0x0                   
1000e600  480001b4    b 0x1000e7b4                   ; -> 1000e7b4
1000e604  38c23be4    addi r6,r2,0x3be4           
1000e608  a8ff0012    lha r7,0x12(r31)            
1000e60c  a8c60000    lha r6,0x0(r6)              
1000e610  7f863850    subf r28,r6,r7              
1000e614  7f880734    extsh r8,r28                
1000e618  2c080000    cmpwi r8,0x0                
1000e61c  40800008    bge 0x1000e624                 ; -> 1000e624
1000e620  7f9c00d0    neg r28,r28                 
1000e624  39223be0    addi r9,r2,0x3be0           
1000e628  a95f0012    lha r10,0x12(r31)           
1000e62c  a9290000    lha r9,0x0(r9)              
1000e630  7f695050    subf r27,r9,r10             
1000e634  7f6b0734    extsh r11,r27               
1000e638  2c0b0000    cmpwi r11,0x0               
1000e63c  40800008    bge 0x1000e644                 ; -> 1000e644
1000e640  7f7b00d0    neg r27,r27                 
1000e644  7f6c0734    extsh r12,r27               
1000e648  2c0c0020    cmpwi r12,0x20              
1000e64c  41800010    blt 0x1000e65c                 ; -> 1000e65c
1000e650  7f830734    extsh r3,r28                
1000e654  2c030020    cmpwi r3,0x20               
1000e658  4080000c    bge 0x1000e664                 ; -> 1000e664
1000e65c  38600001    li r3,0x1                   
1000e660  48000154    b 0x1000e7b4                   ; -> 1000e7b4
1000e664  a89f0010    lha r4,0x10(r31)            
1000e668  38640024    addi r3,r4,0x24             
1000e66c  48020061    bl 0x1002e6cc                  ; -> 1002e6cc
1000e670  60000000    ori r0,r0,0x0               
1000e674  7c7d1b78    or r29,r3,r3                
1000e678  a87f0012    lha r3,0x12(r31)            
1000e67c  4802007d    bl 0x1002e6f8                  ; -> 1002e6f8
1000e680  60000000    ori r0,r0,0x0               
1000e684  7fa50734    extsh r5,r29                
1000e688  7c7a1b78    or r26,r3,r3                
1000e68c  7f460734    extsh r6,r26                
1000e690  7fa70734    extsh r7,r29                
1000e694  1ca5003c    mulli r5,r5,0x3c            
1000e698  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1000e69c  7ca53214    add r5,r5,r6                
1000e6a0  2c070013    cmpwi r7,0x13               
1000e6a4  7fd9282e    lwzx r30,r25,r5             
1000e6a8  41810024    bgt 0x1000e6cc                 ; -> 1000e6cc
1000e6ac  57c805ee    rlwinm r8,r30,0x0,0x17,0x17 
1000e6b0  2c080000    cmpwi r8,0x0                
1000e6b4  40820018    bne 0x1000e6cc                 ; -> 1000e6cc
1000e6b8  57c905ac    rlwinm r9,r30,0x0,0x16,0x16 
1000e6bc  2c090000    cmpwi r9,0x0                
1000e6c0  4182000c    beq 0x1000e6cc                 ; -> 1000e6cc
1000e6c4  38600001    li r3,0x1                   
1000e6c8  480000ec    b 0x1000e7b4                   ; -> 1000e7b4
1000e6cc  7faa0734    extsh r10,r29               
1000e6d0  394a0001    addi r10,r10,0x1            
1000e6d4  7f4b0734    extsh r11,r26               
1000e6d8  7fac0734    extsh r12,r29               
1000e6dc  398c0001    addi r12,r12,0x1            
1000e6e0  1d4a003c    mulli r10,r10,0x3c          
1000e6e4  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1000e6e8  7d4a5a14    add r10,r10,r11             
1000e6ec  2c0c0013    cmpwi r12,0x13              
1000e6f0  7fd9502e    lwzx r30,r25,r10            
1000e6f4  41810024    bgt 0x1000e718                 ; -> 1000e718
1000e6f8  57c305ee    rlwinm r3,r30,0x0,0x17,0x17 
1000e6fc  2c030000    cmpwi r3,0x0                
1000e700  40820018    bne 0x1000e718                 ; -> 1000e718
1000e704  57c405ac    rlwinm r4,r30,0x0,0x16,0x16 
1000e708  2c040000    cmpwi r4,0x0                
1000e70c  4182000c    beq 0x1000e718                 ; -> 1000e718
1000e710  38600001    li r3,0x1                   
1000e714  480000a0    b 0x1000e7b4                   ; -> 1000e7b4
1000e718  7fa50734    extsh r5,r29                
1000e71c  38a50002    addi r5,r5,0x2              
1000e720  7f460734    extsh r6,r26                
1000e724  7fa70734    extsh r7,r29                
1000e728  38e70003    addi r7,r7,0x3              
1000e72c  1ca5003c    mulli r5,r5,0x3c            
1000e730  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1000e734  7ca53214    add r5,r5,r6                
1000e738  2c070013    cmpwi r7,0x13               
1000e73c  7fd9282e    lwzx r30,r25,r5             
1000e740  41810024    bgt 0x1000e764                 ; -> 1000e764
1000e744  57c805ee    rlwinm r8,r30,0x0,0x17,0x17 
1000e748  2c080000    cmpwi r8,0x0                
1000e74c  40820018    bne 0x1000e764                 ; -> 1000e764
1000e750  57c905ac    rlwinm r9,r30,0x0,0x16,0x16 
1000e754  2c090000    cmpwi r9,0x0                
1000e758  4182000c    beq 0x1000e764                 ; -> 1000e764
1000e75c  38600001    li r3,0x1                   
1000e760  48000054    b 0x1000e7b4                   ; -> 1000e7b4
1000e764  7faa0734    extsh r10,r29               
1000e768  394a0003    addi r10,r10,0x3            
1000e76c  7f4b0734    extsh r11,r26               
1000e770  7fac0734    extsh r12,r29               
1000e774  398c0003    addi r12,r12,0x3            
1000e778  1d4a003c    mulli r10,r10,0x3c          
1000e77c  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1000e780  7d4a5a14    add r10,r10,r11             
1000e784  2c0c0013    cmpwi r12,0x13              
1000e788  7fd9502e    lwzx r30,r25,r10            
1000e78c  41810024    bgt 0x1000e7b0                 ; -> 1000e7b0
1000e790  57c305ee    rlwinm r3,r30,0x0,0x17,0x17 
1000e794  2c030000    cmpwi r3,0x0                
1000e798  40820018    bne 0x1000e7b0                 ; -> 1000e7b0
1000e79c  57c405ac    rlwinm r4,r30,0x0,0x16,0x16 
1000e7a0  2c040000    cmpwi r4,0x0                
1000e7a4  4182000c    beq 0x1000e7b0                 ; -> 1000e7b0
1000e7a8  38600001    li r3,0x1                   
1000e7ac  48000008    b 0x1000e7b4                   ; -> 1000e7b4
1000e7b0  38600000    li r3,0x0                   
1000e7b4  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1000e7b8  38210060    addi r1,r1,0x60             
1000e7bc  7c0803a6    mtspr LR,r0                 
1000e7c0  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
1000e7c4  4e800020    blr                         
