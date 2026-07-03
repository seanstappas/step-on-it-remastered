; FUN_10017a70 @ 0x10017a70  (62 instructions)
10017a70  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
10017a74  3b823cd8    addi r28,r2,0x3cd8          
10017a78  3b620900    addi r27,r2,0x900           
10017a7c  3ba24e88    addi r29,r2,0x4e88          
10017a80  3bc00001    li r30,0x1                  
10017a84  48000018    b 0x10017a9c                   ; -> 10017a9c
10017a88  7fc40734    extsh r4,r30                
10017a8c  38600000    li r3,0x0                   
10017a90  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10017a94  7c7d21ae    stbx r3,r29,r4              
10017a98  3bde0001    addi r30,r30,0x1            
10017a9c  7fc50734    extsh r5,r30                
10017aa0  2c050013    cmpwi r5,0x13               
10017aa4  4081ffe4    ble 0x10017a88                 ; -> 10017a88
10017aa8  38c261fa    addi r6,r2,0x61fa           
10017aac  abe60000    lha r31,0x0(r6)             
10017ab0  48000038    b 0x10017ae8                   ; -> 10017ae8
10017ab4  7fe80734    extsh r8,r31                
10017ab8  1d080046    mulli r8,r8,0x46            
10017abc  39080002    addi r8,r8,0x2              
10017ac0  7d1c42ae    lhax r8,r28,r8              
10017ac4  7fe90734    extsh r9,r31                
10017ac8  1d290046    mulli r9,r9,0x46            
10017acc  5508083c    rlwinm r8,r8,0x1,0x0,0x1e   
10017ad0  7d1b42ae    lhax r8,r27,r8              
10017ad4  38e00001    li r7,0x1                   
10017ad8  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
10017adc  7cfd41ae    stbx r7,r29,r8              
10017ae0  3929003e    addi r9,r9,0x3e             
10017ae4  7ffc4aae    lhax r31,r28,r9             
10017ae8  7fea0734    extsh r10,r31               
10017aec  2c0a0000    cmpwi r10,0x0               
10017af0  4082ffc4    bne 0x10017ab4                 ; -> 10017ab4
10017af4  3962711e    addi r11,r2,0x711e          
10017af8  a96b0000    lha r11,0x0(r11)            
10017afc  2c0b0000    cmpwi r11,0x0               
10017b00  41820020    beq 0x10017b20                 ; -> 10017b20
10017b04  3862711e    addi r3,r2,0x711e           
10017b08  39800001    li r12,0x1                  
10017b0c  a8630000    lha r3,0x0(r3)              
10017b10  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
10017b14  7c7b1aae    lhax r3,r27,r3              
10017b18  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10017b1c  7d9d19ae    stbx r12,r29,r3             
10017b20  38a26b9e    addi r5,r2,0x6b9e           
10017b24  38800000    li r4,0x0                   
10017b28  98850000    stb r4,0x0(r5)              
10017b2c  a8db001c    lha r6,0x1c(r27)            
10017b30  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
10017b34  7cdd30ae    lbzx r6,r29,r6              
10017b38  28060000    cmplwi r6,0x0               
10017b3c  40820018    bne 0x10017b54                 ; -> 10017b54
10017b40  a8fb001a    lha r7,0x1a(r27)            
10017b44  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
10017b48  7cfd38ae    lbzx r7,r29,r7              
10017b4c  28070000    cmplwi r7,0x0               
10017b50  41820010    beq 0x10017b60                 ; -> 10017b60
10017b54  39226b9e    addi r9,r2,0x6b9e           
10017b58  39000001    li r8,0x1                   
10017b5c  99090000    stb r8,0x0(r9)              
10017b60  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10017b64  4e800020    blr                         
