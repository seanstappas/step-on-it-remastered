; FUN_1000c544 @ 0x1000c544
1000c544  7c0802a6    mfspr r0,LR                 
1000c548  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000c54c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000c550  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000c554  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000c558  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000c55c  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
1000c560  a881006a    lha r4,0x6a(r1)                ; -> Stack[0x1a]
1000c564  38623cd8    addi r3,r2,0x3cd8           
1000c568  1c840046    mulli r4,r4,0x46            
1000c56c  7fe32214    add r31,r3,r4               
1000c570  a8bf000e    lha r5,0xe(r31)             
1000c574  38a50001    addi r5,r5,0x1              
1000c578  b0bf000e    sth r5,0xe(r31)             
1000c57c  7ca50734    extsh r5,r5                 
1000c580  2c05001e    cmpwi r5,0x1e               
1000c584  4081000c    ble 0x1000c590                 ; -> 1000c590
1000c588  38c00010    li r6,0x10                  
1000c58c  b0df000e    sth r6,0xe(r31)             
1000c590  a8ff0028    lha r7,0x28(r31)            
1000c594  a91f002c    lha r8,0x2c(r31)            
1000c598  7d083a14    add r8,r8,r7                
1000c59c  b11f002c    sth r8,0x2c(r31)            
1000c5a0  a93f002a    lha r9,0x2a(r31)            
1000c5a4  a95f002e    lha r10,0x2e(r31)           
1000c5a8  7d4a4a14    add r10,r10,r9              
1000c5ac  b15f002e    sth r10,0x2e(r31)           
1000c5b0  a97f002c    lha r11,0x2c(r31)           
1000c5b4  7d6b2e70    srawi r11,r11,0x5           
1000c5b8  b17f0010    sth r11,0x10(r31)           
1000c5bc  a99f002e    lha r12,0x2e(r31)           
1000c5c0  7d8c2e70    srawi r12,r12,0x5           
1000c5c4  b19f0012    sth r12,0x12(r31)           
1000c5c8  a89f0010    lha r4,0x10(r31)            
1000c5cc  3864000c    addi r3,r4,0xc              
1000c5d0  480220fd    bl 0x1002e6cc                  ; -> 1002e6cc
1000c5d4  60000000    ori r0,r0,0x0               
1000c5d8  a8bf0012    lha r5,0x12(r31)            
1000c5dc  7c7e1b78    or r30,r3,r3                
1000c5e0  3865000c    addi r3,r5,0xc              
1000c5e4  48022115    bl 0x1002e6f8                  ; -> 1002e6f8
1000c5e8  60000000    ori r0,r0,0x0               
1000c5ec  7c7d1b78    or r29,r3,r3                
1000c5f0  7fc70734    extsh r7,r30                
1000c5f4  7fa80734    extsh r8,r29                
1000c5f8  a93f0038    lha r9,0x38(r31)            
1000c5fc  1ce7003c    mulli r7,r7,0x3c            
1000c600  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
1000c604  38c26bf8    addi r6,r2,0x6bf8           
1000c608  7ce74214    add r7,r7,r8                
1000c60c  7cc6382e    lwzx r6,r6,r7               
1000c610  7d290734    extsh r9,r9                 
1000c614  7faa0734    extsh r10,r29               
1000c618  54c6063e    rlwinm r6,r6,0x0,0x18,0x1f  
1000c61c  7c095000    cmpw r9,r10                 
1000c620  b0c10038    sth r6,0x38(r1)                ; -> Stack[-0x18]
1000c624  40820030    bne 0x1000c654                 ; -> 1000c654
1000c628  a97f003c    lha r11,0x3c(r31)           
1000c62c  7fcc0734    extsh r12,r30               
1000c630  7d6b0734    extsh r11,r11               
1000c634  7c0b6000    cmpw r11,r12                
1000c638  4082001c    bne 0x1000c654                 ; -> 1000c654
1000c63c  38600001    li r3,0x1                   
1000c640  987f0020    stb r3,0x20(r31)            
1000c644  7fc3f378    or r3,r30,r30               
1000c648  7fa4eb78    or r4,r29,r29               
1000c64c  48000035    bl 0x1000c680                  ; -> 1000c680
1000c650  60000000    ori r0,r0,0x0               
1000c654  38800001    li r4,0x1                   
1000c658  989f001e    stb r4,0x1e(r31)            
1000c65c  38a0ffff    li r5,-0x1                  
1000c660  b0bf0036    sth r5,0x36(r31)            
1000c664  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000c668  38210050    addi r1,r1,0x50             
1000c66c  7c0803a6    mtspr LR,r0                 
1000c670  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000c674  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000c678  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000c67c  4e800020    blr                         
