; FUN_1000b6a0 @ 0x1000b6a0
1000b6a0  7c0802a6    mfspr r0,LR                 
1000b6a4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000b6a8  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000b6ac  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000b6b0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000b6b4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000b6b8  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
1000b6bc  a881006a    lha r4,0x6a(r1)                ; -> Stack[0x1a]
1000b6c0  38623cd8    addi r3,r2,0x3cd8           
1000b6c4  1c840046    mulli r4,r4,0x46            
1000b6c8  7fe32214    add r31,r3,r4               
1000b6cc  a8bf000e    lha r5,0xe(r31)             
1000b6d0  38a50001    addi r5,r5,0x1              
1000b6d4  b0bf000e    sth r5,0xe(r31)             
1000b6d8  7ca50734    extsh r5,r5                 
1000b6dc  2c05003c    cmpwi r5,0x3c               
1000b6e0  4081000c    ble 0x1000b6ec                 ; -> 1000b6ec
1000b6e4  38c0002e    li r6,0x2e                  
1000b6e8  b0df000e    sth r6,0xe(r31)             
1000b6ec  a8ff0028    lha r7,0x28(r31)            
1000b6f0  a91f002c    lha r8,0x2c(r31)            
1000b6f4  7d083a14    add r8,r8,r7                
1000b6f8  b11f002c    sth r8,0x2c(r31)            
1000b6fc  a93f002a    lha r9,0x2a(r31)            
1000b700  a95f002e    lha r10,0x2e(r31)           
1000b704  7d4a4a14    add r10,r10,r9              
1000b708  b15f002e    sth r10,0x2e(r31)           
1000b70c  a97f002c    lha r11,0x2c(r31)           
1000b710  7d6b2e70    srawi r11,r11,0x5           
1000b714  b17f0010    sth r11,0x10(r31)           
1000b718  a99f002e    lha r12,0x2e(r31)           
1000b71c  7d8c2e70    srawi r12,r12,0x5           
1000b720  b19f0012    sth r12,0x12(r31)           
1000b724  a89f0010    lha r4,0x10(r31)            
1000b728  3864000c    addi r3,r4,0xc              
1000b72c  48022fa1    bl 0x1002e6cc                  ; -> 1002e6cc
1000b730  60000000    ori r0,r0,0x0               
1000b734  a8bf0012    lha r5,0x12(r31)            
1000b738  7c7e1b78    or r30,r3,r3                
1000b73c  3865000c    addi r3,r5,0xc              
1000b740  48022fb9    bl 0x1002e6f8                  ; -> 1002e6f8
1000b744  60000000    ori r0,r0,0x0               
1000b748  7c7d1b78    or r29,r3,r3                
1000b74c  7fc70734    extsh r7,r30                
1000b750  7fa80734    extsh r8,r29                
1000b754  a93f0038    lha r9,0x38(r31)            
1000b758  1ce7003c    mulli r7,r7,0x3c            
1000b75c  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
1000b760  38c26bf8    addi r6,r2,0x6bf8           
1000b764  7ce74214    add r7,r7,r8                
1000b768  7cc6382e    lwzx r6,r6,r7               
1000b76c  7d290734    extsh r9,r9                 
1000b770  7faa0734    extsh r10,r29               
1000b774  54c6063e    rlwinm r6,r6,0x0,0x18,0x1f  
1000b778  7c095000    cmpw r9,r10                 
1000b77c  b0c10038    sth r6,0x38(r1)                ; -> Stack[-0x18]
1000b780  40820030    bne 0x1000b7b0                 ; -> 1000b7b0
1000b784  a97f003c    lha r11,0x3c(r31)           
1000b788  7fcc0734    extsh r12,r30               
1000b78c  7d6b0734    extsh r11,r11               
1000b790  7c0b6000    cmpw r11,r12                
1000b794  4082001c    bne 0x1000b7b0                 ; -> 1000b7b0
1000b798  38600001    li r3,0x1                   
1000b79c  987f0020    stb r3,0x20(r31)            
1000b7a0  7fc3f378    or r3,r30,r30               
1000b7a4  7fa4eb78    or r4,r29,r29               
1000b7a8  48000035    bl 0x1000b7dc                  ; -> 1000b7dc
1000b7ac  60000000    ori r0,r0,0x0               
1000b7b0  38800001    li r4,0x1                   
1000b7b4  989f001e    stb r4,0x1e(r31)            
1000b7b8  38a0ffff    li r5,-0x1                  
1000b7bc  b0bf0036    sth r5,0x36(r31)            
1000b7c0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000b7c4  38210050    addi r1,r1,0x50             
1000b7c8  7c0803a6    mtspr LR,r0                 
1000b7cc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000b7d0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000b7d4  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000b7d8  4e800020    blr                         
