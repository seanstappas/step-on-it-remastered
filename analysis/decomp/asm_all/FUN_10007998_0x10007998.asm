; FUN_10007998 @ 0x10007998
10007998  7c0802a6    mfspr r0,LR                 
1000799c  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
100079a0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100079a4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
100079a8  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
100079ac  a881006a    lha r4,0x6a(r1)                ; -> Stack[0x1a]
100079b0  38623cd8    addi r3,r2,0x3cd8           
100079b4  1c840046    mulli r4,r4,0x46            
100079b8  7fe32214    add r31,r3,r4               
100079bc  88bf001f    lbz r5,0x1f(r31)            
100079c0  3ba201c0    addi r29,r2,0x1c0           
100079c4  28050000    cmplwi r5,0x0               
100079c8  3bc20200    addi r30,r2,0x200           
100079cc  41820088    beq 0x10007a54                 ; -> 10007a54
100079d0  38c00000    li r6,0x0                   
100079d4  98df001f    stb r6,0x1f(r31)            
100079d8  38e00001    li r7,0x1                   
100079dc  b0ff0024    sth r7,0x24(r31)            
100079e0  39000000    li r8,0x0                   
100079e4  b11f002e    sth r8,0x2e(r31)            
100079e8  a93f0004    lha r9,0x4(r31)             
100079ec  2c090002    cmpwi r9,0x2                
100079f0  40820028    bne 0x10007a18                 ; -> 10007a18
100079f4  a95f0010    lha r10,0x10(r31)           
100079f8  7d4b2e70    srawi r11,r10,0x5           
100079fc  7d6b0194    addze r11,r11               
10007a00  556b2834    rlwinm r11,r11,0x5,0x0,0x1a 
10007a04  7d6b5010    subfc r11,r11,r10           
10007a08  556b083c    rlwinm r11,r11,0x1,0x0,0x1e 
10007a0c  7d7e5aae    lhax r11,r30,r11            
10007a10  b17f000e    sth r11,0xe(r31)            
10007a14  48000024    b 0x10007a38                   ; -> 10007a38
10007a18  a99f0010    lha r12,0x10(r31)           
10007a1c  7d832e70    srawi r3,r12,0x5            
10007a20  7c630194    addze r3,r3                 
10007a24  54632834    rlwinm r3,r3,0x5,0x0,0x1a   
10007a28  7c636010    subfc r3,r3,r12             
10007a2c  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
10007a30  7c7d1aae    lhax r3,r29,r3              
10007a34  b07f000e    sth r3,0xe(r31)             
10007a38  38800001    li r4,0x1                   
10007a3c  989f001e    stb r4,0x1e(r31)            
10007a40  38a00000    li r5,0x0                   
10007a44  b0bf0026    sth r5,0x26(r31)            
10007a48  38c001f4    li r6,0x1f4                 
10007a4c  b0df0042    sth r6,0x42(r31)            
10007a50  48000498    b 0x10007ee8                   ; -> 10007ee8
10007a54  a8ff0024    lha r7,0x24(r31)            
10007a58  7ce83b78    or r8,r7,r7                 
10007a5c  7d080734    extsh r8,r8                 
10007a60  38e7ffff    subi r7,r7,0x1              
10007a64  2c080000    cmpwi r8,0x0                
10007a68  b0ff0024    sth r7,0x24(r31)            
10007a6c  4082047c    bne 0x10007ee8                 ; -> 10007ee8
10007a70  39200001    li r9,0x1                   
10007a74  993f001e    stb r9,0x1e(r31)            
10007a78  a95f002c    lha r10,0x2c(r31)           
10007a7c  394affff    subi r10,r10,0x1            
10007a80  b15f002c    sth r10,0x2c(r31)           
10007a84  7d4a0734    extsh r10,r10               
10007a88  2c0a0000    cmpwi r10,0x0               
10007a8c  4080000c    bge 0x10007a98                 ; -> 10007a98
10007a90  39600001    li r11,0x1                  
10007a94  997f0020    stb r11,0x20(r31)           
10007a98  a99f0040    lha r12,0x40(r31)           
10007a9c  2c0c0000    cmpwi r12,0x0               
10007aa0  40810058    ble 0x10007af8                 ; -> 10007af8
10007aa4  38600005    li r3,0x5                   
10007aa8  38800005    li r4,0x5                   
10007aac  48023575    bl 0x1002b020                  ; -> 1002b020
10007ab0  60000000    ori r0,r0,0x0               
10007ab4  38600001    li r3,0x1                   
10007ab8  987f0020    stb r3,0x20(r31)            
10007abc  807f000a    lwz r3,0xa(r31)             
10007ac0  a89f000e    lha r4,0xe(r31)             
10007ac4  a8bf0010    lha r5,0x10(r31)            
10007ac8  a8df0012    lha r6,0x12(r31)            
10007acc  38e00001    li r7,0x1                   
10007ad0  48020545    bl 0x10028014                  ; -> 10028014
10007ad4  60000000    ori r0,r0,0x0               
10007ad8  a8df0040    lha r6,0x40(r31)            
10007adc  38a26840    addi r5,r2,0x6840           
10007ae0  1cc60070    mulli r6,r6,0x70            
10007ae4  38a5003c    addi r5,r5,0x3c             
10007ae8  a89f0042    lha r4,0x42(r31)            
10007aec  7ce5302e    lwzx r7,r5,r6               
10007af0  7ce72214    add r7,r7,r4                
10007af4  7ce5312e    stwx r7,r5,r6               
10007af8  39000001    li r8,0x1                   
10007afc  b11f0024    sth r8,0x24(r31)            
10007b00  a93f0026    lha r9,0x26(r31)            
10007b04  2c090000    cmpwi r9,0x0                
10007b08  4081017c    ble 0x10007c84                 ; -> 10007c84
10007b0c  a95f0004    lha r10,0x4(r31)            
10007b10  2c0a0002    cmpwi r10,0x2               
10007b14  408200b4    bne 0x10007bc8                 ; -> 10007bc8
10007b18  a97f0026    lha r11,0x26(r31)           
10007b1c  396b0001    addi r11,r11,0x1            
10007b20  b17f0026    sth r11,0x26(r31)           
10007b24  7d6b0734    extsh r11,r11               
10007b28  2c0b0050    cmpwi r11,0x50              
10007b2c  4081003c    ble 0x10007b68                 ; -> 10007b68
10007b30  39800000    li r12,0x0                  
10007b34  b19f0026    sth r12,0x26(r31)           
10007b38  a87f0010    lha r3,0x10(r31)            
10007b3c  7c642e70    srawi r4,r3,0x5             
10007b40  7c840194    addze r4,r4                 
10007b44  54842834    rlwinm r4,r4,0x5,0x0,0x1a   
10007b48  7c841810    subfc r4,r4,r3              
10007b4c  5484083c    rlwinm r4,r4,0x1,0x0,0x1e   
10007b50  7c9e22ae    lhax r4,r30,r4              
10007b54  b09f000e    sth r4,0xe(r31)             
10007b58  a8bf0012    lha r5,0x12(r31)            
10007b5c  38a5000b    addi r5,r5,0xb              
10007b60  b0bf0012    sth r5,0x12(r31)            
10007b64  48000354    b 0x10007eb8                   ; -> 10007eb8
10007b68  a8df0026    lha r6,0x26(r31)            
10007b6c  b0df000e    sth r6,0xe(r31)             
10007b70  a8ff000e    lha r7,0xe(r31)             
10007b74  2c07004b    cmpwi r7,0x4b               
10007b78  40820340    bne 0x10007eb8                 ; -> 10007eb8
10007b7c  a91f0012    lha r8,0x12(r31)            
10007b80  3868000a    addi r3,r8,0xa              
10007b84  48026b75    bl 0x1002e6f8                  ; -> 1002e6f8
10007b88  60000000    ori r0,r0,0x0               
10007b8c  a93f0010    lha r9,0x10(r31)            
10007b90  7c7c1b78    or r28,r3,r3                
10007b94  3869001a    addi r3,r9,0x1a             
10007b98  48026b35    bl 0x1002e6cc                  ; -> 1002e6cc
10007b9c  60000000    ori r0,r0,0x0               
10007ba0  7c7b1b78    or r27,r3,r3                
10007ba4  7f63db78    or r3,r27,r27               
10007ba8  7f84e378    or r4,r28,r28               
10007bac  4801ff41    bl 0x10027aec                  ; -> 10027aec
10007bb0  60000000    ori r0,r0,0x0               
10007bb4  38600011    li r3,0x11                  
10007bb8  38800004    li r4,0x4                   
10007bbc  48023465    bl 0x1002b020                  ; -> 1002b020
10007bc0  60000000    ori r0,r0,0x0               
10007bc4  480002f4    b 0x10007eb8                   ; -> 10007eb8
10007bc8  a95f0026    lha r10,0x26(r31)           
10007bcc  394a0001    addi r10,r10,0x1            
10007bd0  b15f0026    sth r10,0x26(r31)           
10007bd4  7d4a0734    extsh r10,r10               
10007bd8  2c0a0040    cmpwi r10,0x40              
10007bdc  40810048    ble 0x10007c24                 ; -> 10007c24
10007be0  39600000    li r11,0x0                  
10007be4  b17f0026    sth r11,0x26(r31)           
10007be8  a99f0010    lha r12,0x10(r31)           
10007bec  7d9b2e70    srawi r27,r12,0x5           
10007bf0  7f7b0194    addze r27,r27               
10007bf4  577b2834    rlwinm r27,r27,0x5,0x0,0x1a 
10007bf8  7f7b6010    subfc r27,r27,r12           
10007bfc  577b083c    rlwinm r27,r27,0x1,0x0,0x1e 
10007c00  7f7ddaae    lhax r27,r29,r27            
10007c04  b37f000e    sth r27,0xe(r31)            
10007c08  ab9f0012    lha r28,0x12(r31)           
10007c0c  3b9c000b    addi r28,r28,0xb            
10007c10  b39f0012    sth r28,0x12(r31)           
10007c14  a87f0010    lha r3,0x10(r31)            
10007c18  3863000c    addi r3,r3,0xc              
10007c1c  b07f0010    sth r3,0x10(r31)            
10007c20  48000298    b 0x10007eb8                   ; -> 10007eb8
10007c24  a89f0026    lha r4,0x26(r31)            
10007c28  b09f000e    sth r4,0xe(r31)             
10007c2c  a8bf000e    lha r5,0xe(r31)             
10007c30  2c05003b    cmpwi r5,0x3b               
10007c34  40820284    bne 0x10007eb8                 ; -> 10007eb8
10007c38  a8df0012    lha r6,0x12(r31)            
10007c3c  3866000a    addi r3,r6,0xa              
10007c40  48026ab9    bl 0x1002e6f8                  ; -> 1002e6f8
10007c44  60000000    ori r0,r0,0x0               
10007c48  a8ff0010    lha r7,0x10(r31)            
10007c4c  7c7c1b78    or r28,r3,r3                
10007c50  38670004    addi r3,r7,0x4              
10007c54  48026a79    bl 0x1002e6cc                  ; -> 1002e6cc
10007c58  60000000    ori r0,r0,0x0               
10007c5c  7c7b1b78    or r27,r3,r3                
10007c60  7f63db78    or r3,r27,r27               
10007c64  7f84e378    or r4,r28,r28               
10007c68  4801fe85    bl 0x10027aec                  ; -> 10027aec
10007c6c  60000000    ori r0,r0,0x0               
10007c70  38600011    li r3,0x11                  
10007c74  38800004    li r4,0x4                   
10007c78  480233a9    bl 0x1002b020                  ; -> 1002b020
10007c7c  60000000    ori r0,r0,0x0               
10007c80  48000238    b 0x10007eb8                   ; -> 10007eb8
10007c84  a91f0010    lha r8,0x10(r31)            
10007c88  a93f0010    lha r9,0x10(r31)            
10007c8c  a95f0012    lha r10,0x12(r31)           
10007c90  38680004    addi r3,r8,0x4              
10007c94  3889001a    addi r4,r9,0x1a             
10007c98  38aa001e    addi r5,r10,0x1e            
10007c9c  4bffdab5    bl 0x10005750                  ; -> 10005750
10007ca0  60000000    ori r0,r0,0x0               
10007ca4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10007ca8  28030000    cmplwi r3,0x0               
10007cac  41820034    beq 0x10007ce0                 ; -> 10007ce0
10007cb0  a97f0012    lha r11,0x12(r31)           
10007cb4  396b0004    addi r11,r11,0x4            
10007cb8  b17f0012    sth r11,0x12(r31)           
10007cbc  a99f0010    lha r12,0x10(r31)           
10007cc0  ab7f0010    lha r27,0x10(r31)           
10007cc4  ab9f0012    lha r28,0x12(r31)           
10007cc8  386c0004    addi r3,r12,0x4             
10007ccc  389b001a    addi r4,r27,0x1a            
10007cd0  38bc001e    addi r5,r28,0x1e            
10007cd4  4bffda7d    bl 0x10005750                  ; -> 10005750
10007cd8  60000000    ori r0,r0,0x0               
10007cdc  480001dc    b 0x10007eb8                   ; -> 10007eb8
10007ce0  a87f0004    lha r3,0x4(r31)             
10007ce4  2c030002    cmpwi r3,0x2                
10007ce8  408200b0    bne 0x10007d98                 ; -> 10007d98
10007cec  a89f0010    lha r4,0x10(r31)            
10007cf0  a8bf0012    lha r5,0x12(r31)            
10007cf4  3864001a    addi r3,r4,0x1a             
10007cf8  3885000a    addi r4,r5,0xa              
10007cfc  4bffd851    bl 0x1000554c                  ; -> 1000554c
10007d00  60000000    ori r0,r0,0x0               
10007d04  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10007d08  28030000    cmplwi r3,0x0               
10007d0c  4182005c    beq 0x10007d68                 ; -> 10007d68
10007d10  a8df0010    lha r6,0x10(r31)            
10007d14  a8ff0012    lha r7,0x12(r31)            
10007d18  3866001a    addi r3,r6,0x1a             
10007d1c  3887000a    addi r4,r7,0xa              
10007d20  4bffd9b5    bl 0x100056d4                  ; -> 100056d4
10007d24  60000000    ori r0,r0,0x0               
10007d28  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10007d2c  28030000    cmplwi r3,0x0               
10007d30  41820018    beq 0x10007d48                 ; -> 10007d48
10007d34  39000005    li r8,0x5                   
10007d38  b11f0004    sth r8,0x4(r31)             
10007d3c  39200020    li r9,0x20                  
10007d40  b13f000e    sth r9,0xe(r31)             
10007d44  48000174    b 0x10007eb8                   ; -> 10007eb8
10007d48  39400041    li r10,0x41                 
10007d4c  b15f0026    sth r10,0x26(r31)           
10007d50  a97f0012    lha r11,0x12(r31)           
10007d54  396bfff5    subi r11,r11,0xb            
10007d58  b17f0012    sth r11,0x12(r31)           
10007d5c  a99f0026    lha r12,0x26(r31)           
10007d60  b19f000e    sth r12,0xe(r31)            
10007d64  48000154    b 0x10007eb8                   ; -> 10007eb8
10007d68  ab7f0010    lha r27,0x10(r31)           
10007d6c  3b7b0002    addi r27,r27,0x2            
10007d70  b37f0010    sth r27,0x10(r31)           
10007d74  ab9f0010    lha r28,0x10(r31)           
10007d78  7f832e70    srawi r3,r28,0x5            
10007d7c  7c630194    addze r3,r3                 
10007d80  54632834    rlwinm r3,r3,0x5,0x0,0x1a   
10007d84  7c63e010    subfc r3,r3,r28             
10007d88  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
10007d8c  7c7e1aae    lhax r3,r30,r3              
10007d90  b07f000e    sth r3,0xe(r31)             
10007d94  48000124    b 0x10007eb8                   ; -> 10007eb8
10007d98  a89f0004    lha r4,0x4(r31)             
10007d9c  2c040001    cmpwi r4,0x1                
10007da0  408200bc    bne 0x10007e5c                 ; -> 10007e5c
10007da4  a8bf0010    lha r5,0x10(r31)            
10007da8  a8df0012    lha r6,0x12(r31)            
10007dac  38650004    addi r3,r5,0x4              
10007db0  3886000a    addi r4,r6,0xa              
10007db4  4bffd799    bl 0x1000554c                  ; -> 1000554c
10007db8  60000000    ori r0,r0,0x0               
10007dbc  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10007dc0  28030000    cmplwi r3,0x0               
10007dc4  41820068    beq 0x10007e2c                 ; -> 10007e2c
10007dc8  a8ff0010    lha r7,0x10(r31)            
10007dcc  a91f0012    lha r8,0x12(r31)            
10007dd0  38670004    addi r3,r7,0x4              
10007dd4  3888000a    addi r4,r8,0xa              
10007dd8  4bffd8fd    bl 0x100056d4                  ; -> 100056d4
10007ddc  60000000    ori r0,r0,0x0               
10007de0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10007de4  28030000    cmplwi r3,0x0               
10007de8  41820018    beq 0x10007e00                 ; -> 10007e00
10007dec  39200006    li r9,0x6                   
10007df0  b13f0004    sth r9,0x4(r31)             
10007df4  39400011    li r10,0x11                 
10007df8  b15f000e    sth r10,0xe(r31)            
10007dfc  480000bc    b 0x10007eb8                   ; -> 10007eb8
10007e00  39600031    li r11,0x31                 
10007e04  b17f0026    sth r11,0x26(r31)           
10007e08  a99f0012    lha r12,0x12(r31)           
10007e0c  398cfff5    subi r12,r12,0xb            
10007e10  b19f0012    sth r12,0x12(r31)           
10007e14  ab7f0010    lha r27,0x10(r31)           
10007e18  3b7bfff4    subi r27,r27,0xc            
10007e1c  b37f0010    sth r27,0x10(r31)           
10007e20  ab9f0026    lha r28,0x26(r31)           
10007e24  b39f000e    sth r28,0xe(r31)            
10007e28  48000090    b 0x10007eb8                   ; -> 10007eb8
10007e2c  a87f0010    lha r3,0x10(r31)            
10007e30  3863fffe    subi r3,r3,0x2              
10007e34  b07f0010    sth r3,0x10(r31)            
10007e38  a89f0010    lha r4,0x10(r31)            
10007e3c  7c852e70    srawi r5,r4,0x5             
10007e40  7ca50194    addze r5,r5                 
10007e44  54a52834    rlwinm r5,r5,0x5,0x0,0x1a   
10007e48  7ca52010    subfc r5,r5,r4              
10007e4c  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
10007e50  7cbd2aae    lhax r5,r29,r5              
10007e54  b0bf000e    sth r5,0xe(r31)             
10007e58  48000060    b 0x10007eb8                   ; -> 10007eb8
10007e5c  a8df0004    lha r6,0x4(r31)             
10007e60  2c060006    cmpwi r6,0x6                
10007e64  40820028    bne 0x10007e8c                 ; -> 10007e8c
10007e68  a8ff000e    lha r7,0xe(r31)             
10007e6c  38e70001    addi r7,r7,0x1              
10007e70  b0ff000e    sth r7,0xe(r31)             
10007e74  7ce70734    extsh r7,r7                 
10007e78  2c070020    cmpwi r7,0x20               
10007e7c  4081003c    ble 0x10007eb8                 ; -> 10007eb8
10007e80  39000002    li r8,0x2                   
10007e84  b11f0004    sth r8,0x4(r31)             
10007e88  48000030    b 0x10007eb8                   ; -> 10007eb8
10007e8c  a93f0004    lha r9,0x4(r31)             
10007e90  2c090005    cmpwi r9,0x5                
10007e94  40820024    bne 0x10007eb8                 ; -> 10007eb8
10007e98  a95f000e    lha r10,0xe(r31)            
10007e9c  394affff    subi r10,r10,0x1            
10007ea0  b15f000e    sth r10,0xe(r31)            
10007ea4  7d4a0734    extsh r10,r10               
10007ea8  2c0a0011    cmpwi r10,0x11              
10007eac  4080000c    bge 0x10007eb8                 ; -> 10007eb8
10007eb0  39600001    li r11,0x1                  
10007eb4  b17f0004    sth r11,0x4(r31)            
10007eb8  a99f0010    lha r12,0x10(r31)           
10007ebc  398c0006    addi r12,r12,0x6            
10007ec0  b19f003a    sth r12,0x3a(r31)           
10007ec4  ab7f0010    lha r27,0x10(r31)           
10007ec8  3b7b0018    addi r27,r27,0x18           
10007ecc  b37f003c    sth r27,0x3c(r31)           
10007ed0  ab9f0012    lha r28,0x12(r31)           
10007ed4  3b9c0006    addi r28,r28,0x6            
10007ed8  b39f0038    sth r28,0x38(r31)           
10007edc  a87f0012    lha r3,0x12(r31)            
10007ee0  3863001e    addi r3,r3,0x1e             
10007ee4  b07f0036    sth r3,0x36(r31)            
10007ee8  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10007eec  38210050    addi r1,r1,0x50             
10007ef0  7c0803a6    mtspr LR,r0                 
10007ef4  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10007ef8  4e800020    blr                         
