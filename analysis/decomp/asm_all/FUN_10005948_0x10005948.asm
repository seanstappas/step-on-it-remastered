; FUN_10005948 @ 0x10005948
10005948  7c0802a6    mfspr r0,LR                 
1000594c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10005950  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10005954  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10005958  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1000595c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10005960  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10005964  3b8261f8    addi r28,r2,0x61f8          
10005968  3bc23cd8    addi r30,r2,0x3cd8          
1000596c  a87c0000    lha r3,0x0(r28)             
10005970  3ba261fa    addi r29,r2,0x61fa          
10005974  2c030000    cmpwi r3,0x0                
10005978  3be00000    li r31,0x0                  
1000597c  40820014    bne 0x10005990                 ; -> 10005990
10005980  38600008    li r3,0x8                   
10005984  48013975    bl 0x100192f8                  ; -> 100192f8
10005988  60000000    ori r0,r0,0x0               
1000598c  48000078    b 0x10005a04                   ; -> 10005a04
10005990  a89c0000    lha r4,0x0(r28)             
10005994  abfc0000    lha r31,0x0(r28)            
10005998  1c840046    mulli r4,r4,0x46            
1000599c  3884003e    addi r4,r4,0x3e             
100059a0  7c9e22ae    lhax r4,r30,r4              
100059a4  38a00000    li r5,0x0                   
100059a8  b09c0000    sth r4,0x0(r28)             
100059ac  a8dc0000    lha r6,0x0(r28)             
100059b0  1cc60046    mulli r6,r6,0x46            
100059b4  7cbe332e    sthx r5,r30,r6              
100059b8  a8fd0000    lha r7,0x0(r29)             
100059bc  2c070000    cmpwi r7,0x0                
100059c0  40820020    bne 0x100059e0                 ; -> 100059e0
100059c4  b3fd0000    sth r31,0x0(r29)            
100059c8  a93d0000    lha r9,0x0(r29)             
100059cc  39000000    li r8,0x0                   
100059d0  1d290046    mulli r9,r9,0x46            
100059d4  3929003e    addi r9,r9,0x3e             
100059d8  7d1e4b2e    sthx r8,r30,r9              
100059dc  48000028    b 0x10005a04                   ; -> 10005a04
100059e0  7feb0734    extsh r11,r31               
100059e4  1d6b0046    mulli r11,r11,0x46          
100059e8  a95d0000    lha r10,0x0(r29)            
100059ec  396b003e    addi r11,r11,0x3e           
100059f0  7d5e5b2e    sthx r10,r30,r11            
100059f4  a99d0000    lha r12,0x0(r29)            
100059f8  1d8c0046    mulli r12,r12,0x46          
100059fc  7ffe632e    sthx r31,r30,r12            
10005a00  b3fd0000    sth r31,0x0(r29)            
10005a04  7fe40734    extsh r4,r31                
10005a08  1c840046    mulli r4,r4,0x46            
10005a0c  7fe60734    extsh r6,r31                
10005a10  1cc60046    mulli r6,r6,0x46            
10005a14  7fe80734    extsh r8,r31                
10005a18  1d080046    mulli r8,r8,0x46            
10005a1c  7fea0734    extsh r10,r31               
10005a20  1d4a0046    mulli r10,r10,0x46          
10005a24  7fec0734    extsh r12,r31               
10005a28  1d8c0046    mulli r12,r12,0x46          
10005a2c  38600001    li r3,0x1                   
10005a30  3884001f    addi r4,r4,0x1f             
10005a34  7c7e21ae    stbx r3,r30,r4              
10005a38  7fe40734    extsh r4,r31                
10005a3c  1c840046    mulli r4,r4,0x46            
10005a40  38a00000    li r5,0x0                   
10005a44  38c60020    addi r6,r6,0x20             
10005a48  7cbe31ae    stbx r5,r30,r6              
10005a4c  7fe60734    extsh r6,r31                
10005a50  1cc60046    mulli r6,r6,0x46            
10005a54  38e00000    li r7,0x0                   
10005a58  39080040    addi r8,r8,0x40             
10005a5c  7cfe432e    sthx r7,r30,r8              
10005a60  7fe80734    extsh r8,r31                
10005a64  1d080046    mulli r8,r8,0x46            
10005a68  39200000    li r9,0x0                   
10005a6c  394a003a    addi r10,r10,0x3a           
10005a70  7d3e532e    sthx r9,r30,r10             
10005a74  39600000    li r11,0x0                  
10005a78  398c0038    addi r12,r12,0x38           
10005a7c  7d7e632e    sthx r11,r30,r12            
10005a80  38600000    li r3,0x0                   
10005a84  3884003c    addi r4,r4,0x3c             
10005a88  7c7e232e    sthx r3,r30,r4              
10005a8c  38a00000    li r5,0x0                   
10005a90  38c60036    addi r6,r6,0x36             
10005a94  7cbe332e    sthx r5,r30,r6              
10005a98  38e00000    li r7,0x0                   
10005a9c  39080035    addi r8,r8,0x35             
10005aa0  7cfe41ae    stbx r7,r30,r8              
10005aa4  7fe3fb78    or r3,r31,r31               
10005aa8  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10005aac  38210050    addi r1,r1,0x50             
10005ab0  7c0803a6    mtspr LR,r0                 
10005ab4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10005ab8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10005abc  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10005ac0  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10005ac4  4e800020    blr                         
