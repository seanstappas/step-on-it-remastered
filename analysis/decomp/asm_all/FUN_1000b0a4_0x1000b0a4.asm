; FUN_1000b0a4 @ 0x1000b0a4
1000b0a4  7c0802a6    mfspr r0,LR                 
1000b0a8  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1000b0ac  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000b0b0  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000b0b4  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
1000b0b8  a881006a    lha r4,0x6a(r1)                ; -> Stack[0x1a]
1000b0bc  38623cd8    addi r3,r2,0x3cd8           
1000b0c0  1c840046    mulli r4,r4,0x46            
1000b0c4  7fe32214    add r31,r3,r4               
1000b0c8  a8bf0042    lha r5,0x42(r31)            
1000b0cc  3b826bf8    addi r28,r2,0x6bf8          
1000b0d0  2c050001    cmpwi r5,0x1                
1000b0d4  40820028    bne 0x1000b0fc                 ; -> 1000b0fc
1000b0d8  a8df000e    lha r6,0xe(r31)             
1000b0dc  38c60001    addi r6,r6,0x1              
1000b0e0  b0df000e    sth r6,0xe(r31)             
1000b0e4  7cc60734    extsh r6,r6                 
1000b0e8  2c06002d    cmpwi r6,0x2d               
1000b0ec  40810030    ble 0x1000b11c                 ; -> 1000b11c
1000b0f0  38e0001f    li r7,0x1f                  
1000b0f4  b0ff000e    sth r7,0xe(r31)             
1000b0f8  48000024    b 0x1000b11c                   ; -> 1000b11c
1000b0fc  a91f000e    lha r8,0xe(r31)             
1000b100  39080001    addi r8,r8,0x1              
1000b104  b11f000e    sth r8,0xe(r31)             
1000b108  7d080734    extsh r8,r8                 
1000b10c  2c08000f    cmpwi r8,0xf                
1000b110  4081000c    ble 0x1000b11c                 ; -> 1000b11c
1000b114  39200001    li r9,0x1                   
1000b118  b13f000e    sth r9,0xe(r31)             
1000b11c  a95f0028    lha r10,0x28(r31)           
1000b120  a97f002c    lha r11,0x2c(r31)           
1000b124  7d6b5214    add r11,r11,r10             
1000b128  b17f002c    sth r11,0x2c(r31)           
1000b12c  a99f002a    lha r12,0x2a(r31)           
1000b130  a87f002e    lha r3,0x2e(r31)            
1000b134  7c636214    add r3,r3,r12               
1000b138  b07f002e    sth r3,0x2e(r31)            
1000b13c  a89f002c    lha r4,0x2c(r31)            
1000b140  7c842e70    srawi r4,r4,0x5             
1000b144  b09f0010    sth r4,0x10(r31)            
1000b148  a8bf002e    lha r5,0x2e(r31)            
1000b14c  7ca52e70    srawi r5,r5,0x5             
1000b150  b0bf0012    sth r5,0x12(r31)            
1000b154  a8df0010    lha r6,0x10(r31)            
1000b158  38660006    addi r3,r6,0x6              
1000b15c  48023571    bl 0x1002e6cc                  ; -> 1002e6cc
1000b160  60000000    ori r0,r0,0x0               
1000b164  a8ff0012    lha r7,0x12(r31)            
1000b168  7c7e1b78    or r30,r3,r3                
1000b16c  38670002    addi r3,r7,0x2              
1000b170  48023589    bl 0x1002e6f8                  ; -> 1002e6f8
1000b174  60000000    ori r0,r0,0x0               
1000b178  7c7d1b78    or r29,r3,r3                
1000b17c  7fca0734    extsh r10,r30               
1000b180  7fc80734    extsh r8,r30                
1000b184  7fab0734    extsh r11,r29               
1000b188  7fa90734    extsh r9,r29                
1000b18c  1d4a003c    mulli r10,r10,0x3c          
1000b190  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1000b194  7d4a5a14    add r10,r10,r11             
1000b198  7d5c502e    lwzx r10,r28,r10            
1000b19c  1d08003c    mulli r8,r8,0x3c            
1000b1a0  5529103a    rlwinm r9,r9,0x2,0x0,0x1d   
1000b1a4  7d084a14    add r8,r8,r9                
1000b1a8  554a05ac    rlwinm r10,r10,0x0,0x16,0x16
1000b1ac  7d1c402e    lwzx r8,r28,r8              
1000b1b0  2c0a0000    cmpwi r10,0x0               
1000b1b4  551b063e    rlwinm r27,r8,0x0,0x18,0x1f 
1000b1b8  4182007c    beq 0x1000b234                 ; -> 1000b234
1000b1bc  7fcc0734    extsh r12,r30               
1000b1c0  7fa30734    extsh r3,r29                
1000b1c4  1d8c003c    mulli r12,r12,0x3c          
1000b1c8  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1000b1cc  7d8c1a14    add r12,r12,r3              
1000b1d0  7d9c602e    lwzx r12,r28,r12            
1000b1d4  558c05ee    rlwinm r12,r12,0x0,0x17,0x17
1000b1d8  2c0c0000    cmpwi r12,0x0               
1000b1dc  4182001c    beq 0x1000b1f8                 ; -> 1000b1f8
1000b1e0  7f640734    extsh r4,r27                
1000b1e4  2c04008b    cmpwi r4,0x8b               
1000b1e8  4182004c    beq 0x1000b234                 ; -> 1000b234
1000b1ec  38a00001    li r5,0x1                   
1000b1f0  98bf0020    stb r5,0x20(r31)            
1000b1f4  48000040    b 0x1000b234                   ; -> 1000b234
1000b1f8  a8df0028    lha r6,0x28(r31)            
1000b1fc  a8ff002a    lha r7,0x2a(r31)            
1000b200  1cc6000a    mulli r6,r6,0xa             
1000b204  1ce7000a    mulli r7,r7,0xa             
1000b208  7cc52e70    srawi r5,r6,0x5             
1000b20c  7fc3f378    or r3,r30,r30               
1000b210  7fa4eb78    or r4,r29,r29               
1000b214  7ce62e70    srawi r6,r7,0x5             
1000b218  4801ca1d    bl 0x10027c34                  ; -> 10027c34
1000b21c  60000000    ori r0,r0,0x0               
1000b220  a91f0042    lha r8,0x42(r31)            
1000b224  2c080001    cmpwi r8,0x1                
1000b228  4082000c    bne 0x1000b234                 ; -> 1000b234
1000b22c  39200001    li r9,0x1                   
1000b230  993f0020    stb r9,0x20(r31)            
1000b234  a95f0010    lha r10,0x10(r31)           
1000b238  386a0013    addi r3,r10,0x13            
1000b23c  48023491    bl 0x1002e6cc                  ; -> 1002e6cc
1000b240  60000000    ori r0,r0,0x0               
1000b244  a97f0012    lha r11,0x12(r31)           
1000b248  7c7e1b78    or r30,r3,r3                
1000b24c  386b0013    addi r3,r11,0x13            
1000b250  480234a9    bl 0x1002e6f8                  ; -> 1002e6f8
1000b254  60000000    ori r0,r0,0x0               
1000b258  7c7d1b78    or r29,r3,r3                
1000b25c  7fc40734    extsh r4,r30                
1000b260  7fcc0734    extsh r12,r30               
1000b264  7fa50734    extsh r5,r29                
1000b268  7fa30734    extsh r3,r29                
1000b26c  1c84003c    mulli r4,r4,0x3c            
1000b270  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
1000b274  7c842a14    add r4,r4,r5                
1000b278  7c9c202e    lwzx r4,r28,r4              
1000b27c  1d8c003c    mulli r12,r12,0x3c          
1000b280  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1000b284  7d8c1a14    add r12,r12,r3              
1000b288  548405ac    rlwinm r4,r4,0x0,0x16,0x16  
1000b28c  7d9c602e    lwzx r12,r28,r12            
1000b290  2c040000    cmpwi r4,0x0                
1000b294  559b063e    rlwinm r27,r12,0x0,0x18,0x1f
1000b298  4182007c    beq 0x1000b314                 ; -> 1000b314
1000b29c  7fc60734    extsh r6,r30                
1000b2a0  7fa70734    extsh r7,r29                
1000b2a4  1cc6003c    mulli r6,r6,0x3c            
1000b2a8  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
1000b2ac  7cc63a14    add r6,r6,r7                
1000b2b0  7cdc302e    lwzx r6,r28,r6              
1000b2b4  54c605ee    rlwinm r6,r6,0x0,0x17,0x17  
1000b2b8  2c060000    cmpwi r6,0x0                
1000b2bc  4182001c    beq 0x1000b2d8                 ; -> 1000b2d8
1000b2c0  7f680734    extsh r8,r27                
1000b2c4  2c08008b    cmpwi r8,0x8b               
1000b2c8  4182004c    beq 0x1000b314                 ; -> 1000b314
1000b2cc  39200001    li r9,0x1                   
1000b2d0  993f0020    stb r9,0x20(r31)            
1000b2d4  48000040    b 0x1000b314                   ; -> 1000b314
1000b2d8  a95f0028    lha r10,0x28(r31)           
1000b2dc  a97f002a    lha r11,0x2a(r31)           
1000b2e0  1d4a000a    mulli r10,r10,0xa           
1000b2e4  1d6b000a    mulli r11,r11,0xa           
1000b2e8  7d452e70    srawi r5,r10,0x5            
1000b2ec  7fc3f378    or r3,r30,r30               
1000b2f0  7fa4eb78    or r4,r29,r29               
1000b2f4  7d662e70    srawi r6,r11,0x5            
1000b2f8  4801c93d    bl 0x10027c34                  ; -> 10027c34
1000b2fc  60000000    ori r0,r0,0x0               
1000b300  a99f0042    lha r12,0x42(r31)           
1000b304  2c0c0001    cmpwi r12,0x1               
1000b308  4082000c    bne 0x1000b314                 ; -> 1000b314
1000b30c  38600001    li r3,0x1                   
1000b310  987f0020    stb r3,0x20(r31)            
1000b314  a89f0010    lha r4,0x10(r31)            
1000b318  38640005    addi r3,r4,0x5              
1000b31c  480233b1    bl 0x1002e6cc                  ; -> 1002e6cc
1000b320  60000000    ori r0,r0,0x0               
1000b324  a8bf0012    lha r5,0x12(r31)            
1000b328  7c7e1b78    or r30,r3,r3                
1000b32c  38650013    addi r3,r5,0x13             
1000b330  480233c9    bl 0x1002e6f8                  ; -> 1002e6f8
1000b334  60000000    ori r0,r0,0x0               
1000b338  7c7d1b78    or r29,r3,r3                
1000b33c  7fc80734    extsh r8,r30                
1000b340  7fc60734    extsh r6,r30                
1000b344  7fa90734    extsh r9,r29                
1000b348  7fa70734    extsh r7,r29                
1000b34c  1d08003c    mulli r8,r8,0x3c            
1000b350  5529103a    rlwinm r9,r9,0x2,0x0,0x1d   
1000b354  7d084a14    add r8,r8,r9                
1000b358  7d1c402e    lwzx r8,r28,r8              
1000b35c  1cc6003c    mulli r6,r6,0x3c            
1000b360  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
1000b364  7cc63a14    add r6,r6,r7                
1000b368  550805ac    rlwinm r8,r8,0x0,0x16,0x16  
1000b36c  7cdc302e    lwzx r6,r28,r6              
1000b370  2c080000    cmpwi r8,0x0                
1000b374  54db063e    rlwinm r27,r6,0x0,0x18,0x1f 
1000b378  4182007c    beq 0x1000b3f4                 ; -> 1000b3f4
1000b37c  7fca0734    extsh r10,r30               
1000b380  7fab0734    extsh r11,r29               
1000b384  1d4a003c    mulli r10,r10,0x3c          
1000b388  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1000b38c  7d4a5a14    add r10,r10,r11             
1000b390  7d5c502e    lwzx r10,r28,r10            
1000b394  554a05ee    rlwinm r10,r10,0x0,0x17,0x17
1000b398  2c0a0000    cmpwi r10,0x0               
1000b39c  4182001c    beq 0x1000b3b8                 ; -> 1000b3b8
1000b3a0  7f6c0734    extsh r12,r27               
1000b3a4  2c0c008b    cmpwi r12,0x8b              
1000b3a8  4182004c    beq 0x1000b3f4                 ; -> 1000b3f4
1000b3ac  38600001    li r3,0x1                   
1000b3b0  987f0020    stb r3,0x20(r31)            
1000b3b4  48000040    b 0x1000b3f4                   ; -> 1000b3f4
1000b3b8  a8df0028    lha r6,0x28(r31)            
1000b3bc  a8ff002a    lha r7,0x2a(r31)            
1000b3c0  1cc6000a    mulli r6,r6,0xa             
1000b3c4  1ce7000a    mulli r7,r7,0xa             
1000b3c8  7cc52e70    srawi r5,r6,0x5             
1000b3cc  7fc3f378    or r3,r30,r30               
1000b3d0  7fa4eb78    or r4,r29,r29               
1000b3d4  7ce62e70    srawi r6,r7,0x5             
1000b3d8  4801c85d    bl 0x10027c34                  ; -> 10027c34
1000b3dc  60000000    ori r0,r0,0x0               
1000b3e0  a91f0042    lha r8,0x42(r31)            
1000b3e4  2c080001    cmpwi r8,0x1                
1000b3e8  4082000c    bne 0x1000b3f4                 ; -> 1000b3f4
1000b3ec  39200001    li r9,0x1                   
1000b3f0  993f0020    stb r9,0x20(r31)            
1000b3f4  895f0020    lbz r10,0x20(r31)           
1000b3f8  280a0000    cmplwi r10,0x0              
1000b3fc  4082003c    bne 0x1000b438                 ; -> 1000b438
1000b400  a97f0012    lha r11,0x12(r31)           
1000b404  38a00001    li r5,0x1                   
1000b408  396b0002    addi r11,r11,0x2            
1000b40c  b17f0038    sth r11,0x38(r31)           
1000b410  a99f0012    lha r12,0x12(r31)           
1000b414  398c0014    addi r12,r12,0x14           
1000b418  b19f0036    sth r12,0x36(r31)           
1000b41c  a87f0010    lha r3,0x10(r31)            
1000b420  38630002    addi r3,r3,0x2              
1000b424  b07f003a    sth r3,0x3a(r31)            
1000b428  a89f0010    lha r4,0x10(r31)            
1000b42c  38840014    addi r4,r4,0x14             
1000b430  b09f003c    sth r4,0x3c(r31)            
1000b434  98bf001e    stb r5,0x1e(r31)            
1000b438  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000b43c  38210050    addi r1,r1,0x50             
1000b440  7c0803a6    mtspr LR,r0                 
1000b444  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1000b448  4e800020    blr                         
