; FUN_1000efb4 @ 0x1000efb4
1000efb4  7c0802a6    mfspr r0,LR                 
1000efb8  bec1ffd8    stmw r22,-0x28(r1)             ; -> Stack[-0x28]
1000efbc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000efc0  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1000efc4  386269fe    addi r3,r2,0x69fe           
1000efc8  3b226a16    addi r25,r2,0x6a16          
1000efcc  88630000    lbz r3,0x0(r3)              
1000efd0  3ba26bb8    addi r29,r2,0x6bb8          
1000efd4  28030000    cmplwi r3,0x0               
1000efd8  3b626a52    addi r27,r2,0x6a52          
1000efdc  3b426a02    addi r26,r2,0x6a02          
1000efe0  3b826a3e    addi r28,r2,0x6a3e          
1000efe4  3ac26a01    addi r22,r2,0x6a01          
1000efe8  3ae26840    addi r23,r2,0x6840          
1000efec  3bc00050    li r30,0x50                 
1000eff0  3b000008    li r24,0x8                  
1000eff4  41820268    beq 0x1000f25c                 ; -> 1000f25c
1000eff8  38822f74    addi r4,r2,0x2f74           
1000effc  88840000    lbz r4,0x0(r4)              
1000f000  28040000    cmplwi r4,0x0               
1000f004  41820258    beq 0x1000f25c                 ; -> 1000f25c
1000f008  88b60000    lbz r5,0x0(r22)             
1000f00c  28050000    cmplwi r5,0x0               
1000f010  41820128    beq 0x1000f138                 ; -> 1000f138
1000f014  807700ac    lwz r3,0xac(r23)            
1000f018  7f84e378    or r4,r28,r28               
1000f01c  4801c8e5    bl 0x1002b900                  ; -> 1002b900
1000f020  60000000    ori r0,r0,0x0               
1000f024  8077011c    lwz r3,0x11c(r23)           
1000f028  7f44d378    or r4,r26,r26               
1000f02c  4801c8d5    bl 0x1002b900                  ; -> 1002b900
1000f030  60000000    ori r0,r0,0x0               
1000f034  3be00000    li r31,0x0                  
1000f038  480000f0    b 0x1000f128                   ; -> 1000f128
1000f03c  7fe60734    extsh r6,r31                
1000f040  54c6083c    rlwinm r6,r6,0x1,0x0,0x1e   
1000f044  7fe70734    extsh r7,r31                
1000f048  7cdc32ae    lhax r6,r28,r6              
1000f04c  54e7083c    rlwinm r7,r7,0x1,0x0,0x1e   
1000f050  7cfb3aae    lhax r7,r27,r7              
1000f054  7cc60734    extsh r6,r6                 
1000f058  7c063800    cmpw r6,r7                  
1000f05c  41820054    beq 0x1000f0b0                 ; -> 1000f0b0
1000f060  213f0009    subfic r9,r31,0x9           
1000f064  7fe80734    extsh r8,r31                
1000f068  5508083c    rlwinm r8,r8,0x1,0x0,0x1e   
1000f06c  7fea0734    extsh r10,r31               
1000f070  7d1b42ae    lhax r8,r27,r8              
1000f074  554a083c    rlwinm r10,r10,0x1,0x0,0x1e 
1000f078  55291838    rlwinm r9,r9,0x3,0x0,0x1c   
1000f07c  217f0009    subfic r11,r31,0x9          
1000f080  7d5c52ae    lhax r10,r28,r10            
1000f084  38880005    addi r4,r8,0x5              
1000f088  390a0005    addi r8,r10,0x5             
1000f08c  807d0000    lwz r3,0x0(r29)             
1000f090  7cbe4a14    add r5,r30,r9               
1000f094  556b1838    rlwinm r11,r11,0x3,0x0,0x1c 
1000f098  80fd0000    lwz r7,0x0(r29)             
1000f09c  38c00000    li r6,0x0                   
1000f0a0  7d3e5a14    add r9,r30,r11              
1000f0a4  39400000    li r10,0x0                  
1000f0a8  4bff52f9    bl 0x100043a0                  ; -> 100043a0
1000f0ac  60000000    ori r0,r0,0x0               
1000f0b0  7fec0734    extsh r12,r31               
1000f0b4  558c083c    rlwinm r12,r12,0x1,0x0,0x1e 
1000f0b8  7fe30734    extsh r3,r31                
1000f0bc  7d9a62ae    lhax r12,r26,r12            
1000f0c0  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
1000f0c4  7c791aae    lhax r3,r25,r3              
1000f0c8  7d8c0734    extsh r12,r12               
1000f0cc  7c0c1800    cmpw r12,r3                 
1000f0d0  41820054    beq 0x1000f124                 ; -> 1000f124
1000f0d4  20df0009    subfic r6,r31,0x9           
1000f0d8  7fe50734    extsh r5,r31                
1000f0dc  7fe90734    extsh r9,r31                
1000f0e0  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1000f0e4  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1000f0e8  7cb92aae    lhax r5,r25,r5              
1000f0ec  7d3a4aae    lhax r9,r26,r9              
1000f0f0  215f0009    subfic r10,r31,0x9          
1000f0f4  38850005    addi r4,r5,0x5              
1000f0f8  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
1000f0fc  7cbe3214    add r5,r30,r6               
1000f100  39090005    addi r8,r9,0x5              
1000f104  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
1000f108  7d3e5214    add r9,r30,r10              
1000f10c  807d0000    lwz r3,0x0(r29)             
1000f110  80fd0000    lwz r7,0x0(r29)             
1000f114  38c00010    li r6,0x10                  
1000f118  39400010    li r10,0x10                 
1000f11c  4bff5285    bl 0x100043a0                  ; -> 100043a0
1000f120  60000000    ori r0,r0,0x0               
1000f124  3bff0001    addi r31,r31,0x1            
1000f128  7feb0734    extsh r11,r31               
1000f12c  2c0b0009    cmpwi r11,0x9               
1000f130  4081ff0c    ble 0x1000f03c                 ; -> 1000f03c
1000f134  48000290    b 0x1000f3c4                   ; -> 1000f3c4
1000f138  807700ac    lwz r3,0xac(r23)            
1000f13c  7f64db78    or r4,r27,r27               
1000f140  4801c7c1    bl 0x1002b900                  ; -> 1002b900
1000f144  60000000    ori r0,r0,0x0               
1000f148  8077011c    lwz r3,0x11c(r23)           
1000f14c  7f24cb78    or r4,r25,r25               
1000f150  4801c7b1    bl 0x1002b900                  ; -> 1002b900
1000f154  60000000    ori r0,r0,0x0               
1000f158  3be00000    li r31,0x0                  
1000f15c  480000f0    b 0x1000f24c                   ; -> 1000f24c
1000f160  7fec0734    extsh r12,r31               
1000f164  558c083c    rlwinm r12,r12,0x1,0x0,0x1e 
1000f168  7fe30734    extsh r3,r31                
1000f16c  7d9c62ae    lhax r12,r28,r12            
1000f170  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
1000f174  7c7b1aae    lhax r3,r27,r3              
1000f178  7d8c0734    extsh r12,r12               
1000f17c  7c0c1800    cmpw r12,r3                 
1000f180  41820054    beq 0x1000f1d4                 ; -> 1000f1d4
1000f184  20df0009    subfic r6,r31,0x9           
1000f188  7fe50734    extsh r5,r31                
1000f18c  7fe90734    extsh r9,r31                
1000f190  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1000f194  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1000f198  7cbc2aae    lhax r5,r28,r5              
1000f19c  7d3b4aae    lhax r9,r27,r9              
1000f1a0  215f0009    subfic r10,r31,0x9          
1000f1a4  38850005    addi r4,r5,0x5              
1000f1a8  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
1000f1ac  7cbe3214    add r5,r30,r6               
1000f1b0  39090005    addi r8,r9,0x5              
1000f1b4  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
1000f1b8  7d3e5214    add r9,r30,r10              
1000f1bc  807d0000    lwz r3,0x0(r29)             
1000f1c0  80fd0000    lwz r7,0x0(r29)             
1000f1c4  38c00000    li r6,0x0                   
1000f1c8  39400000    li r10,0x0                  
1000f1cc  4bff51d5    bl 0x100043a0                  ; -> 100043a0
1000f1d0  60000000    ori r0,r0,0x0               
1000f1d4  7feb0734    extsh r11,r31               
1000f1d8  556b083c    rlwinm r11,r11,0x1,0x0,0x1e 
1000f1dc  7fec0734    extsh r12,r31               
1000f1e0  7d7a5aae    lhax r11,r26,r11            
1000f1e4  558c083c    rlwinm r12,r12,0x1,0x0,0x1e 
1000f1e8  7d9962ae    lhax r12,r25,r12            
1000f1ec  7d6b0734    extsh r11,r11               
1000f1f0  7c0b6000    cmpw r11,r12                
1000f1f4  41820054    beq 0x1000f248                 ; -> 1000f248
1000f1f8  20df0009    subfic r6,r31,0x9           
1000f1fc  7fe50734    extsh r5,r31                
1000f200  7fe90734    extsh r9,r31                
1000f204  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1000f208  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1000f20c  7cba2aae    lhax r5,r26,r5              
1000f210  7d394aae    lhax r9,r25,r9              
1000f214  215f0009    subfic r10,r31,0x9          
1000f218  38850005    addi r4,r5,0x5              
1000f21c  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
1000f220  7cbe3214    add r5,r30,r6               
1000f224  39090005    addi r8,r9,0x5              
1000f228  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
1000f22c  7d3e5214    add r9,r30,r10              
1000f230  807d0000    lwz r3,0x0(r29)             
1000f234  80fd0000    lwz r7,0x0(r29)             
1000f238  38c00010    li r6,0x10                  
1000f23c  39400010    li r10,0x10                 
1000f240  4bff5161    bl 0x100043a0                  ; -> 100043a0
1000f244  60000000    ori r0,r0,0x0               
1000f248  3bff0001    addi r31,r31,0x1            
1000f24c  7feb0734    extsh r11,r31               
1000f250  2c0b0009    cmpwi r11,0x9               
1000f254  4081ff0c    ble 0x1000f160                 ; -> 1000f160
1000f258  4800016c    b 0x1000f3c4                   ; -> 1000f3c4
1000f25c  89960000    lbz r12,0x0(r22)            
1000f260  280c0000    cmplwi r12,0x0              
1000f264  418200b4    beq 0x1000f318                 ; -> 1000f318
1000f268  38825332    addi r4,r2,0x5332           
1000f26c  a8840000    lha r4,0x0(r4)              
1000f270  1c840070    mulli r4,r4,0x70            
1000f274  3884003c    addi r4,r4,0x3c             
1000f278  7c77202e    lwzx r3,r23,r4              
1000f27c  7f84e378    or r4,r28,r28               
1000f280  4801c681    bl 0x1002b900                  ; -> 1002b900
1000f284  60000000    ori r0,r0,0x0               
1000f288  3be00000    li r31,0x0                  
1000f28c  4800007c    b 0x1000f308                   ; -> 1000f308
1000f290  7fe50734    extsh r5,r31                
1000f294  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1000f298  7fe60734    extsh r6,r31                
1000f29c  7cbc2aae    lhax r5,r28,r5              
1000f2a0  54c6083c    rlwinm r6,r6,0x1,0x0,0x1e   
1000f2a4  7cdb32ae    lhax r6,r27,r6              
1000f2a8  7ca50734    extsh r5,r5                 
1000f2ac  7c053000    cmpw r5,r6                  
1000f2b0  41820054    beq 0x1000f304                 ; -> 1000f304
1000f2b4  211f0009    subfic r8,r31,0x9           
1000f2b8  7fe70734    extsh r7,r31                
1000f2bc  7fe90734    extsh r9,r31                
1000f2c0  54e7083c    rlwinm r7,r7,0x1,0x0,0x1e   
1000f2c4  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1000f2c8  7cfb3aae    lhax r7,r27,r7              
1000f2cc  55081838    rlwinm r8,r8,0x3,0x0,0x1c   
1000f2d0  215f0009    subfic r10,r31,0x9          
1000f2d4  38870005    addi r4,r7,0x5              
1000f2d8  7d3c4aae    lhax r9,r28,r9              
1000f2dc  7cbe4214    add r5,r30,r8               
1000f2e0  39090005    addi r8,r9,0x5              
1000f2e4  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
1000f2e8  7d3e5214    add r9,r30,r10              
1000f2ec  807d0000    lwz r3,0x0(r29)             
1000f2f0  80fd0000    lwz r7,0x0(r29)             
1000f2f4  7f06c378    or r6,r24,r24               
1000f2f8  7f0ac378    or r10,r24,r24              
1000f2fc  4bff50a5    bl 0x100043a0                  ; -> 100043a0
1000f300  60000000    ori r0,r0,0x0               
1000f304  3bff0001    addi r31,r31,0x1            
1000f308  7feb0734    extsh r11,r31               
1000f30c  2c0b0009    cmpwi r11,0x9               
1000f310  4081ff80    ble 0x1000f290                 ; -> 1000f290
1000f314  480000b0    b 0x1000f3c4                   ; -> 1000f3c4
1000f318  39825332    addi r12,r2,0x5332          
1000f31c  7f64db78    or r4,r27,r27               
1000f320  a98c0000    lha r12,0x0(r12)            
1000f324  1d8c0070    mulli r12,r12,0x70          
1000f328  398c003c    addi r12,r12,0x3c           
1000f32c  7c77602e    lwzx r3,r23,r12             
1000f330  4801c5d1    bl 0x1002b900                  ; -> 1002b900
1000f334  60000000    ori r0,r0,0x0               
1000f338  3be00000    li r31,0x0                  
1000f33c  4800007c    b 0x1000f3b8                   ; -> 1000f3b8
1000f340  7fe30734    extsh r3,r31                
1000f344  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
1000f348  7fe40734    extsh r4,r31                
1000f34c  7c7c1aae    lhax r3,r28,r3              
1000f350  5484083c    rlwinm r4,r4,0x1,0x0,0x1e   
1000f354  7c9b22ae    lhax r4,r27,r4              
1000f358  7c630734    extsh r3,r3                 
1000f35c  7c032000    cmpw r3,r4                  
1000f360  41820054    beq 0x1000f3b4                 ; -> 1000f3b4
1000f364  20df0009    subfic r6,r31,0x9           
1000f368  7fe50734    extsh r5,r31                
1000f36c  7fe90734    extsh r9,r31                
1000f370  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1000f374  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1000f378  7cbc2aae    lhax r5,r28,r5              
1000f37c  7d3b4aae    lhax r9,r27,r9              
1000f380  215f0009    subfic r10,r31,0x9          
1000f384  38850005    addi r4,r5,0x5              
1000f388  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
1000f38c  7cbe3214    add r5,r30,r6               
1000f390  39090005    addi r8,r9,0x5              
1000f394  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
1000f398  7d3e5214    add r9,r30,r10              
1000f39c  807d0000    lwz r3,0x0(r29)             
1000f3a0  80fd0000    lwz r7,0x0(r29)             
1000f3a4  7f06c378    or r6,r24,r24               
1000f3a8  7f0ac378    or r10,r24,r24              
1000f3ac  4bff4ff5    bl 0x100043a0                  ; -> 100043a0
1000f3b0  60000000    ori r0,r0,0x0               
1000f3b4  3bff0001    addi r31,r31,0x1            
1000f3b8  7feb0734    extsh r11,r31               
1000f3bc  2c0b0009    cmpwi r11,0x9               
1000f3c0  4081ff80    ble 0x1000f340                 ; -> 1000f340
1000f3c4  88760000    lbz r3,0x0(r22)             
1000f3c8  39800000    li r12,0x0                  
1000f3cc  28030000    cmplwi r3,0x0               
1000f3d0  40820008    bne 0x1000f3d8                 ; -> 1000f3d8
1000f3d4  39800001    li r12,0x1                  
1000f3d8  99960000    stb r12,0x0(r22)            
1000f3dc  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1000f3e0  38210060    addi r1,r1,0x60             
1000f3e4  7c0803a6    mtspr LR,r0                 
1000f3e8  bac1ffd8    lmw r22,-0x28(r1)              ; -> Stack[-0x28]
1000f3ec  4e800020    blr                         
