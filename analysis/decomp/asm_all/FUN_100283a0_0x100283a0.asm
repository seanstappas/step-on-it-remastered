; FUN_100283a0 @ 0x100283a0
100283a0  7c0802a6    mfspr r0,LR                 
100283a4  bec1ffd8    stmw r22,-0x28(r1)             ; -> Stack[-0x28]
100283a8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100283ac  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
100283b0  3b226be8    addi r25,r2,0x6be8          
100283b4  3b026bf8    addi r24,r2,0x6bf8          
100283b8  3bc26200    addi r30,r2,0x6200          
100283bc  3b426bea    addi r26,r2,0x6bea          
100283c0  3b826bc0    addi r28,r2,0x6bc0          
100283c4  abf90000    lha r31,0x0(r25)            
100283c8  3b60ffff    li r27,-0x1                 
100283cc  48000284    b 0x10028650                   ; -> 10028650
100283d0  7fe30734    extsh r3,r31                
100283d4  7fe40734    extsh r4,r31                
100283d8  54632036    rlwinm r3,r3,0x4,0x0,0x1b   
100283dc  54842036    rlwinm r4,r4,0x4,0x0,0x1b   
100283e0  38630004    addi r3,r3,0x4              
100283e4  38840006    addi r4,r4,0x6              
100283e8  7c7e1aae    lhax r3,r30,r3              
100283ec  7c9e22ae    lhax r4,r30,r4              
100283f0  7fa32214    add r29,r3,r4               
100283f4  7fa50734    extsh r5,r29                
100283f8  2c050005    cmpwi r5,0x5                
100283fc  41810010    bgt 0x1002840c                 ; -> 1002840c
10028400  7fa60734    extsh r6,r29                
10028404  2c060001    cmpwi r6,0x1                
10028408  40800168    bge 0x10028570                 ; -> 10028570
1002840c  7fe70734    extsh r7,r31                
10028410  7fe90734    extsh r9,r31                
10028414  54e72036    rlwinm r7,r7,0x4,0x0,0x1b   
10028418  7fe80734    extsh r8,r31                
1002841c  55292036    rlwinm r9,r9,0x4,0x0,0x1b   
10028420  38e70004    addi r7,r7,0x4              
10028424  55082036    rlwinm r8,r8,0x4,0x0,0x1b   
10028428  39290002    addi r9,r9,0x2              
1002842c  807c0000    lwz r3,0x0(r28)             
10028430  7c9e3aae    lhax r4,r30,r7              
10028434  7cbe42ae    lhax r5,r30,r8              
10028438  7cde4aae    lhax r6,r30,r9              
1002843c  4bfdc875    bl 0x10004cb0                  ; -> 10004cb0
10028440  60000000    ori r0,r0,0x0               
10028444  7faa0734    extsh r10,r29               
10028448  2c0a0005    cmpwi r10,0x5               
1002844c  4081003c    ble 0x10028488                 ; -> 10028488
10028450  7feb0734    extsh r11,r31               
10028454  7fe70734    extsh r7,r31                
10028458  556b2036    rlwinm r11,r11,0x4,0x0,0x1b 
1002845c  7fec0734    extsh r12,r31               
10028460  54e72036    rlwinm r7,r7,0x4,0x0,0x1b   
10028464  396b0008    addi r11,r11,0x8            
10028468  558c2036    rlwinm r12,r12,0x4,0x0,0x1b 
1002846c  38e70002    addi r7,r7,0x2              
10028470  807c0000    lwz r3,0x0(r28)             
10028474  7c9e5aae    lhax r4,r30,r11             
10028478  7cbe62ae    lhax r5,r30,r12             
1002847c  7cde3aae    lhax r6,r30,r7              
10028480  4bfdbc89    bl 0x10004108                  ; -> 10004108
10028484  60000000    ori r0,r0,0x0               
10028488  7fe80734    extsh r8,r31                
1002848c  55082036    rlwinm r8,r8,0x4,0x0,0x1b   
10028490  7fe90734    extsh r9,r31                
10028494  3908000a    addi r8,r8,0xa              
10028498  55292036    rlwinm r9,r9,0x4,0x0,0x1b   
1002849c  7d1e402e    lwzx r8,r30,r8              
100284a0  39290002    addi r9,r9,0x2              
100284a4  7c7e4aae    lhax r3,r30,r9              
100284a8  7d174378    or r23,r8,r8                
100284ac  4800624d    bl 0x1002e6f8                  ; -> 1002e6f8
100284b0  60000000    ori r0,r0,0x0               
100284b4  7c630734    extsh r3,r3                 
100284b8  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100284bc  7fea0734    extsh r10,r31               
100284c0  7c761b78    or r22,r3,r3                
100284c4  554a2036    rlwinm r10,r10,0x4,0x0,0x1b 
100284c8  7c7e52ae    lhax r3,r30,r10             
100284cc  48006201    bl 0x1002e6cc                  ; -> 1002e6cc
100284d0  60000000    ori r0,r0,0x0               
100284d4  7c630734    extsh r3,r3                 
100284d8  1c63003c    mulli r3,r3,0x3c            
100284dc  7f6b0734    extsh r11,r27               
100284e0  7c63b214    add r3,r3,r22               
100284e4  2c0bffff    cmpwi r11,-0x1              
100284e8  7ef8192e    stwx r23,r24,r3             
100284ec  40820038    bne 0x10028524                 ; -> 10028524
100284f0  7fec0734    extsh r12,r31               
100284f4  558c2036    rlwinm r12,r12,0x4,0x0,0x1b 
100284f8  398c000e    addi r12,r12,0xe            
100284fc  7d9e62ae    lhax r12,r30,r12            
10028500  7ff70734    extsh r23,r31               
10028504  b1990000    sth r12,0x0(r25)            
10028508  56f72036    rlwinm r23,r23,0x4,0x0,0x1b 
1002850c  aada0000    lha r22,0x0(r26)            
10028510  3af7000e    addi r23,r23,0xe            
10028514  7edebb2e    sthx r22,r30,r23            
10028518  b3fa0000    sth r31,0x0(r26)            
1002851c  abf90000    lha r31,0x0(r25)            
10028520  48000130    b 0x10028650                   ; -> 10028650
10028524  7fe30734    extsh r3,r31                
10028528  54632036    rlwinm r3,r3,0x4,0x0,0x1b   
1002852c  3863000e    addi r3,r3,0xe              
10028530  7f640734    extsh r4,r27                
10028534  54842036    rlwinm r4,r4,0x4,0x0,0x1b   
10028538  7fe60734    extsh r6,r31                
1002853c  54c62036    rlwinm r6,r6,0x4,0x0,0x1b   
10028540  7f670734    extsh r7,r27                
10028544  54e72036    rlwinm r7,r7,0x4,0x0,0x1b   
10028548  7c7e1aae    lhax r3,r30,r3              
1002854c  3884000e    addi r4,r4,0xe              
10028550  7c7e232e    sthx r3,r30,r4              
10028554  a8ba0000    lha r5,0x0(r26)             
10028558  38c6000e    addi r6,r6,0xe              
1002855c  7cbe332e    sthx r5,r30,r6              
10028560  b3fa0000    sth r31,0x0(r26)            
10028564  38e7000e    addi r7,r7,0xe              
10028568  7ffe3aae    lhax r31,r30,r7             
1002856c  480000e4    b 0x10028650                   ; -> 10028650
10028570  7fe80734    extsh r8,r31                
10028574  55082036    rlwinm r8,r8,0x4,0x0,0x1b   
10028578  39080004    addi r8,r8,0x4              
1002857c  7d1e42ae    lhax r8,r30,r8              
10028580  2c080006    cmpwi r8,0x6                
10028584  4182001c    beq 0x100285a0                 ; -> 100285a0
10028588  7fe90734    extsh r9,r31                
1002858c  55292036    rlwinm r9,r9,0x4,0x0,0x1b   
10028590  39290004    addi r9,r9,0x4              
10028594  7d3e4aae    lhax r9,r30,r9              
10028598  2c090000    cmpwi r9,0x0                
1002859c  40820034    bne 0x100285d0                 ; -> 100285d0
100285a0  7feb0734    extsh r11,r31               
100285a4  7fea0734    extsh r10,r31               
100285a8  556b2036    rlwinm r11,r11,0x4,0x0,0x1b 
100285ac  554a2036    rlwinm r10,r10,0x4,0x0,0x1b 
100285b0  396b0002    addi r11,r11,0x2            
100285b4  807c0000    lwz r3,0x0(r28)             
100285b8  7cbe52ae    lhax r5,r30,r10             
100285bc  7cde5aae    lhax r6,r30,r11             
100285c0  7fa4eb78    or r4,r29,r29               
100285c4  4bfdc5f1    bl 0x10004bb4                  ; -> 10004bb4
100285c8  60000000    ori r0,r0,0x0               
100285cc  48000060    b 0x1002862c                   ; -> 1002862c
100285d0  7fea0734    extsh r10,r31               
100285d4  7fec0734    extsh r12,r31               
100285d8  7ff70734    extsh r23,r31               
100285dc  554a2036    rlwinm r10,r10,0x4,0x0,0x1b 
100285e0  7feb0734    extsh r11,r31               
100285e4  558c2036    rlwinm r12,r12,0x4,0x0,0x1b 
100285e8  7ff60734    extsh r22,r31               
100285ec  56f72036    rlwinm r23,r23,0x4,0x0,0x1b 
100285f0  556b2036    rlwinm r11,r11,0x4,0x0,0x1b 
100285f4  398c0004    addi r12,r12,0x4            
100285f8  56d62036    rlwinm r22,r22,0x4,0x0,0x1b 
100285fc  3af70002    addi r23,r23,0x2            
10028600  7d3e52ae    lhax r9,r30,r10             
10028604  396b0002    addi r11,r11,0x2            
10028608  807c0000    lwz r3,0x0(r28)             
1002860c  7c9e62ae    lhax r4,r30,r12             
10028610  7cbeb2ae    lhax r5,r30,r22             
10028614  7cdebaae    lhax r6,r30,r23             
10028618  80fc0000    lwz r7,0x0(r28)             
1002861c  7d5e5aae    lhax r10,r30,r11            
10028620  7fa8eb78    or r8,r29,r29               
10028624  4bfdbd7d    bl 0x100043a0                  ; -> 100043a0
10028628  60000000    ori r0,r0,0x0               
1002862c  7fec0734    extsh r12,r31               
10028630  558c2036    rlwinm r12,r12,0x4,0x0,0x1b 
10028634  7ff60734    extsh r22,r31               
10028638  398c0004    addi r12,r12,0x4            
1002863c  56d62036    rlwinm r22,r22,0x4,0x0,0x1b 
10028640  7fbe632e    sthx r29,r30,r12            
10028644  7ffbfb78    or r27,r31,r31              
10028648  3ad6000e    addi r22,r22,0xe            
1002864c  7ffeb2ae    lhax r31,r30,r22            
10028650  7ff70734    extsh r23,r31               
10028654  2c17ffff    cmpwi r23,-0x1              
10028658  4082fd78    bne 0x100283d0                 ; -> 100283d0
1002865c  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10028660  38210060    addi r1,r1,0x60             
10028664  7c0803a6    mtspr LR,r0                 
10028668  bac1ffd8    lmw r22,-0x28(r1)              ; -> Stack[-0x28]
1002866c  4e800020    blr                         
