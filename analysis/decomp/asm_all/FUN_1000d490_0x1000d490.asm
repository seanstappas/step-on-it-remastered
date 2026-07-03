; FUN_1000d490 @ 0x1000d490
1000d490  7c0802a6    mfspr r0,LR                 
1000d494  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000d498  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000d49c  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1000d4a0  b061005a    sth r3,0x5a(r1)                ; -> Stack[0x1a]
1000d4a4  a881005a    lha r4,0x5a(r1)                ; -> Stack[0x1a]
1000d4a8  38623cd8    addi r3,r2,0x3cd8           
1000d4ac  1c840046    mulli r4,r4,0x46            
1000d4b0  7fe32214    add r31,r3,r4               
1000d4b4  88bf001f    lbz r5,0x1f(r31)            
1000d4b8  28050000    cmplwi r5,0x0               
1000d4bc  41820050    beq 0x1000d50c                 ; -> 1000d50c
1000d4c0  38c00000    li r6,0x0                   
1000d4c4  98df001f    stb r6,0x1f(r31)            
1000d4c8  38e00000    li r7,0x0                   
1000d4cc  390261a4    addi r8,r2,0x61a4           
1000d4d0  98ff001e    stb r7,0x1e(r31)            
1000d4d4  81080024    lwz r8,0x24(r8)             
1000d4d8  39200000    li r9,0x0                   
1000d4dc  911f000a    stw r8,0xa(r31)             
1000d4e0  913f0014    stw r9,0x14(r31)            
1000d4e4  39400001    li r10,0x1                  
1000d4e8  b15f000e    sth r10,0xe(r31)            
1000d4ec  39600001    li r11,0x1                  
1000d4f0  b17f0024    sth r11,0x24(r31)           
1000d4f4  a99f0010    lha r12,0x10(r31)           
1000d4f8  398c0004    addi r12,r12,0x4            
1000d4fc  b19f0010    sth r12,0x10(r31)           
1000d500  a87f0012    lha r3,0x12(r31)            
1000d504  38630006    addi r3,r3,0x6              
1000d508  b07f0012    sth r3,0x12(r31)            
1000d50c  a89f0024    lha r4,0x24(r31)            
1000d510  7c852378    or r5,r4,r4                 
1000d514  7ca50734    extsh r5,r5                 
1000d518  3884ffff    subi r4,r4,0x1              
1000d51c  2c050000    cmpwi r5,0x0                
1000d520  b09f0024    sth r4,0x24(r31)            
1000d524  4082009c    bne 0x1000d5c0                 ; -> 1000d5c0
1000d528  38c00001    li r6,0x1                   
1000d52c  b0df0024    sth r6,0x24(r31)            
1000d530  38e00001    li r7,0x1                   
1000d534  98ff001e    stb r7,0x1e(r31)            
1000d538  a91f000e    lha r8,0xe(r31)             
1000d53c  39080001    addi r8,r8,0x1              
1000d540  b11f000e    sth r8,0xe(r31)             
1000d544  7d080734    extsh r8,r8                 
1000d548  2c080010    cmpwi r8,0x10               
1000d54c  4081000c    ble 0x1000d558                 ; -> 1000d558
1000d550  39200001    li r9,0x1                   
1000d554  b13f000e    sth r9,0xe(r31)             
1000d558  a95f0010    lha r10,0x10(r31)           
1000d55c  a97f0010    lha r11,0x10(r31)           
1000d560  a99f0012    lha r12,0x12(r31)           
1000d564  386a0004    addi r3,r10,0x4             
1000d568  388b0014    addi r4,r11,0x14            
1000d56c  38ac001b    addi r5,r12,0x1b            
1000d570  4bff81e1    bl 0x10005750                  ; -> 10005750
1000d574  60000000    ori r0,r0,0x0               
1000d578  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000d57c  28030000    cmplwi r3,0x0               
1000d580  41820010    beq 0x1000d590                 ; -> 1000d590
1000d584  a87f0012    lha r3,0x12(r31)            
1000d588  38630004    addi r3,r3,0x4              
1000d58c  b07f0012    sth r3,0x12(r31)            
1000d590  a89f0010    lha r4,0x10(r31)            
1000d594  38840001    addi r4,r4,0x1              
1000d598  b09f003a    sth r4,0x3a(r31)            
1000d59c  a8bf0010    lha r5,0x10(r31)            
1000d5a0  38a50017    addi r5,r5,0x17             
1000d5a4  b0bf003c    sth r5,0x3c(r31)            
1000d5a8  a8df0012    lha r6,0x12(r31)            
1000d5ac  38c6000c    addi r6,r6,0xc              
1000d5b0  b0df0038    sth r6,0x38(r31)            
1000d5b4  a8ff0012    lha r7,0x12(r31)            
1000d5b8  38e7001a    addi r7,r7,0x1a             
1000d5bc  b0ff0036    sth r7,0x36(r31)            
1000d5c0  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1000d5c4  38210040    addi r1,r1,0x40             
1000d5c8  7c0803a6    mtspr LR,r0                 
1000d5cc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000d5d0  4e800020    blr                         
