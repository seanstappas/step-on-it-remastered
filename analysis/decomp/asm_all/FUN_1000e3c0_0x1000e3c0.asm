; FUN_1000e3c0 @ 0x1000e3c0
1000e3c0  7c0802a6    mfspr r0,LR                 
1000e3c4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000e3c8  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000e3cc  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000e3d0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000e3d4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000e3d8  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
1000e3dc  a881006a    lha r4,0x6a(r1)                ; -> Stack[0x1a]
1000e3e0  38623cd8    addi r3,r2,0x3cd8           
1000e3e4  1c840046    mulli r4,r4,0x46            
1000e3e8  7fe32214    add r31,r3,r4               
1000e3ec  a8bf0004    lha r5,0x4(r31)             
1000e3f0  2c050002    cmpwi r5,0x2                
1000e3f4  40820028    bne 0x1000e41c                 ; -> 1000e41c
1000e3f8  a8df000e    lha r6,0xe(r31)             
1000e3fc  38c60001    addi r6,r6,0x1              
1000e400  b0df000e    sth r6,0xe(r31)             
1000e404  7cc60734    extsh r6,r6                 
1000e408  2c060040    cmpwi r6,0x40               
1000e40c  40810030    ble 0x1000e43c                 ; -> 1000e43c
1000e410  38e00031    li r7,0x31                  
1000e414  b0ff000e    sth r7,0xe(r31)             
1000e418  48000024    b 0x1000e43c                   ; -> 1000e43c
1000e41c  a91f000e    lha r8,0xe(r31)             
1000e420  3908ffff    subi r8,r8,0x1              
1000e424  b11f000e    sth r8,0xe(r31)             
1000e428  7d080734    extsh r8,r8                 
1000e42c  2c080031    cmpwi r8,0x31               
1000e430  4080000c    bge 0x1000e43c                 ; -> 1000e43c
1000e434  39200040    li r9,0x40                  
1000e438  b13f000e    sth r9,0xe(r31)             
1000e43c  a95f0004    lha r10,0x4(r31)            
1000e440  2c0a0002    cmpwi r10,0x2               
1000e444  4082009c    bne 0x1000e4e0                 ; -> 1000e4e0
1000e448  a97f0010    lha r11,0x10(r31)           
1000e44c  396b0004    addi r11,r11,0x4            
1000e450  b17f0010    sth r11,0x10(r31)           
1000e454  a99f0010    lha r12,0x10(r31)           
1000e458  386c0010    addi r3,r12,0x10            
1000e45c  48020271    bl 0x1002e6cc                  ; -> 1002e6cc
1000e460  60000000    ori r0,r0,0x0               
1000e464  a89f0012    lha r4,0x12(r31)            
1000e468  7c7e1b78    or r30,r3,r3                
1000e46c  38640008    addi r3,r4,0x8              
1000e470  48020289    bl 0x1002e6f8                  ; -> 1002e6f8
1000e474  60000000    ori r0,r0,0x0               
1000e478  7fc60734    extsh r6,r30                
1000e47c  7c7d1b78    or r29,r3,r3                
1000e480  7fa70734    extsh r7,r29                
1000e484  1cc6003c    mulli r6,r6,0x3c            
1000e488  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
1000e48c  38a26bf8    addi r5,r2,0x6bf8           
1000e490  7cc63a14    add r6,r6,r7                
1000e494  7ca5302e    lwzx r5,r5,r6               
1000e498  54a505ac    rlwinm r5,r5,0x0,0x16,0x16  
1000e49c  2c050000    cmpwi r5,0x0                
1000e4a0  41820020    beq 0x1000e4c0                 ; -> 1000e4c0
1000e4a4  39000001    li r8,0x1                   
1000e4a8  991f0020    stb r8,0x20(r31)            
1000e4ac  7fc3f378    or r3,r30,r30               
1000e4b0  7fa4eb78    or r4,r29,r29               
1000e4b4  480198d1    bl 0x10027d84                  ; -> 10027d84
1000e4b8  60000000    ori r0,r0,0x0               
1000e4bc  480000c0    b 0x1000e57c                   ; -> 1000e57c
1000e4c0  a93f0010    lha r9,0x10(r31)            
1000e4c4  39600001    li r11,0x1                  
1000e4c8  b13f003a    sth r9,0x3a(r31)            
1000e4cc  a95f0010    lha r10,0x10(r31)           
1000e4d0  394a0008    addi r10,r10,0x8            
1000e4d4  b15f003c    sth r10,0x3c(r31)           
1000e4d8  997f001e    stb r11,0x1e(r31)           
1000e4dc  480000a0    b 0x1000e57c                   ; -> 1000e57c
1000e4e0  a99f0010    lha r12,0x10(r31)           
1000e4e4  38600000    li r3,0x0                   
1000e4e8  398cfffc    subi r12,r12,0x4            
1000e4ec  b19f0010    sth r12,0x10(r31)           
1000e4f0  987f001f    stb r3,0x1f(r31)            
1000e4f4  a89f0010    lha r4,0x10(r31)            
1000e4f8  3864ffff    subi r3,r4,0x1              
1000e4fc  480201d1    bl 0x1002e6cc                  ; -> 1002e6cc
1000e500  60000000    ori r0,r0,0x0               
1000e504  a8bf0012    lha r5,0x12(r31)            
1000e508  7c7e1b78    or r30,r3,r3                
1000e50c  38650008    addi r3,r5,0x8              
1000e510  480201e9    bl 0x1002e6f8                  ; -> 1002e6f8
1000e514  60000000    ori r0,r0,0x0               
1000e518  7fc70734    extsh r7,r30                
1000e51c  7c7d1b78    or r29,r3,r3                
1000e520  7fa80734    extsh r8,r29                
1000e524  1ce7003c    mulli r7,r7,0x3c            
1000e528  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
1000e52c  38c26bf8    addi r6,r2,0x6bf8           
1000e530  7ce74214    add r7,r7,r8                
1000e534  7cc6382e    lwzx r6,r6,r7               
1000e538  54c605ac    rlwinm r6,r6,0x0,0x16,0x16  
1000e53c  2c060000    cmpwi r6,0x0                
1000e540  41820020    beq 0x1000e560                 ; -> 1000e560
1000e544  39200001    li r9,0x1                   
1000e548  993f0020    stb r9,0x20(r31)            
1000e54c  7fc3f378    or r3,r30,r30               
1000e550  7fa4eb78    or r4,r29,r29               
1000e554  48019979    bl 0x10027ecc                  ; -> 10027ecc
1000e558  60000000    ori r0,r0,0x0               
1000e55c  48000020    b 0x1000e57c                   ; -> 1000e57c
1000e560  a95f0010    lha r10,0x10(r31)           
1000e564  39800001    li r12,0x1                  
1000e568  b15f003a    sth r10,0x3a(r31)           
1000e56c  a97f0010    lha r11,0x10(r31)           
1000e570  396b0008    addi r11,r11,0x8            
1000e574  b17f003c    sth r11,0x3c(r31)           
1000e578  999f001e    stb r12,0x1e(r31)           
1000e57c  a87f0010    lha r3,0x10(r31)            
1000e580  38630004    addi r3,r3,0x4              
1000e584  b07f003a    sth r3,0x3a(r31)            
1000e588  a89f0010    lha r4,0x10(r31)            
1000e58c  38840010    addi r4,r4,0x10             
1000e590  b09f003c    sth r4,0x3c(r31)            
1000e594  a8bf0012    lha r5,0x12(r31)            
1000e598  38a50002    addi r5,r5,0x2              
1000e59c  b0bf0038    sth r5,0x38(r31)            
1000e5a0  a8df0012    lha r6,0x12(r31)            
1000e5a4  38c6000e    addi r6,r6,0xe              
1000e5a8  b0df0036    sth r6,0x36(r31)            
1000e5ac  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000e5b0  38210050    addi r1,r1,0x50             
1000e5b4  7c0803a6    mtspr LR,r0                 
1000e5b8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000e5bc  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000e5c0  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000e5c4  4e800020    blr                         
