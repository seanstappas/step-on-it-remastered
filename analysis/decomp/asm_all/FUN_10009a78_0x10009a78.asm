; FUN_10009a78 @ 0x10009a78
10009a78  7c0802a6    mfspr r0,LR                 
10009a7c  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
10009a80  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10009a84  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10009a88  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
10009a8c  a881006a    lha r4,0x6a(r1)                ; -> Stack[0x1a]
10009a90  38623cd8    addi r3,r2,0x3cd8           
10009a94  1c840046    mulli r4,r4,0x46            
10009a98  7fe32214    add r31,r3,r4               
10009a9c  88bf001f    lbz r5,0x1f(r31)            
10009aa0  3b80001b    li r28,0x1b                 
10009aa4  28050000    cmplwi r5,0x0               
10009aa8  3bc00009    li r30,0x9                  
10009aac  3ba00018    li r29,0x18                 
10009ab0  41820080    beq 0x10009b30                 ; -> 10009b30
10009ab4  38c00000    li r6,0x0                   
10009ab8  98df001f    stb r6,0x1f(r31)            
10009abc  38e00001    li r7,0x1                   
10009ac0  b0ff0024    sth r7,0x24(r31)            
10009ac4  a91f0004    lha r8,0x4(r31)             
10009ac8  2c080002    cmpwi r8,0x2                
10009acc  4082002c    bne 0x10009af8                 ; -> 10009af8
10009ad0  a95f0010    lha r10,0x10(r31)           
10009ad4  39220340    addi r9,r2,0x340            
10009ad8  7d4b2e70    srawi r11,r10,0x5           
10009adc  7d6b0194    addze r11,r11               
10009ae0  556b2834    rlwinm r11,r11,0x5,0x0,0x1a 
10009ae4  7d6b5010    subfc r11,r11,r10           
10009ae8  556b083c    rlwinm r11,r11,0x1,0x0,0x1e 
10009aec  7d295aae    lhax r9,r9,r11              
10009af0  b13f000e    sth r9,0xe(r31)             
10009af4  48000028    b 0x10009b1c                   ; -> 10009b1c
10009af8  a87f0010    lha r3,0x10(r31)            
10009afc  39820380    addi r12,r2,0x380           
10009b00  7c642e70    srawi r4,r3,0x5             
10009b04  7c840194    addze r4,r4                 
10009b08  54842834    rlwinm r4,r4,0x5,0x0,0x1a   
10009b0c  7c841810    subfc r4,r4,r3              
10009b10  5484083c    rlwinm r4,r4,0x1,0x0,0x1e   
10009b14  7d8c22ae    lhax r12,r12,r4             
10009b18  b19f000e    sth r12,0xe(r31)            
10009b1c  38a00001    li r5,0x1                   
10009b20  98bf001e    stb r5,0x1e(r31)            
10009b24  38c000fa    li r6,0xfa                  
10009b28  b0df0042    sth r6,0x42(r31)            
10009b2c  48000358    b 0x10009e84                   ; -> 10009e84
10009b30  a8ff0024    lha r7,0x24(r31)            
10009b34  7ce83b78    or r8,r7,r7                 
10009b38  7d080734    extsh r8,r8                 
10009b3c  38e7ffff    subi r7,r7,0x1              
10009b40  2c080000    cmpwi r8,0x0                
10009b44  b0ff0024    sth r7,0x24(r31)            
10009b48  4082033c    bne 0x10009e84                 ; -> 10009e84
10009b4c  39200001    li r9,0x1                   
10009b50  993f001e    stb r9,0x1e(r31)            
10009b54  a95f002c    lha r10,0x2c(r31)           
10009b58  7d4b5378    or r11,r10,r10              
10009b5c  7d6b0734    extsh r11,r11               
10009b60  394affff    subi r10,r10,0x1            
10009b64  2c0b0000    cmpwi r11,0x0               
10009b68  b15f002c    sth r10,0x2c(r31)           
10009b6c  4181000c    bgt 0x10009b78                 ; -> 10009b78
10009b70  39800001    li r12,0x1                  
10009b74  999f0020    stb r12,0x20(r31)           
10009b78  a87f0040    lha r3,0x40(r31)            
10009b7c  2c030000    cmpwi r3,0x0                
10009b80  40810058    ble 0x10009bd8                 ; -> 10009bd8
10009b84  3860000d    li r3,0xd                   
10009b88  38800005    li r4,0x5                   
10009b8c  48021495    bl 0x1002b020                  ; -> 1002b020
10009b90  60000000    ori r0,r0,0x0               
10009b94  38800001    li r4,0x1                   
10009b98  989f0020    stb r4,0x20(r31)            
10009b9c  807f000a    lwz r3,0xa(r31)             
10009ba0  a89f000e    lha r4,0xe(r31)             
10009ba4  a8bf0010    lha r5,0x10(r31)            
10009ba8  a8df0012    lha r6,0x12(r31)            
10009bac  38e00001    li r7,0x1                   
10009bb0  4801e465    bl 0x10028014                  ; -> 10028014
10009bb4  60000000    ori r0,r0,0x0               
10009bb8  a8ff0040    lha r7,0x40(r31)            
10009bbc  38c26840    addi r6,r2,0x6840           
10009bc0  1ce70070    mulli r7,r7,0x70            
10009bc4  38c6003c    addi r6,r6,0x3c             
10009bc8  a8bf0042    lha r5,0x42(r31)            
10009bcc  7d06382e    lwzx r8,r6,r7               
10009bd0  7d082a14    add r8,r8,r5                
10009bd4  7d06392e    stwx r8,r6,r7               
10009bd8  39200001    li r9,0x1                   
10009bdc  b13f0024    sth r9,0x24(r31)            
10009be0  a95f0010    lha r10,0x10(r31)           
10009be4  a97f0010    lha r11,0x10(r31)           
10009be8  a99f0012    lha r12,0x12(r31)           
10009bec  386a0004    addi r3,r10,0x4             
10009bf0  388b0020    addi r4,r11,0x20            
10009bf4  7cace214    add r5,r12,r28              
10009bf8  4bffbb59    bl 0x10005750                  ; -> 10005750
10009bfc  60000000    ori r0,r0,0x0               
10009c00  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10009c04  28030000    cmplwi r3,0x0               
10009c08  41820034    beq 0x10009c3c                 ; -> 10009c3c
10009c0c  a87f0012    lha r3,0x12(r31)            
10009c10  38630004    addi r3,r3,0x4              
10009c14  b07f0012    sth r3,0x12(r31)            
10009c18  a89f0010    lha r4,0x10(r31)            
10009c1c  a8bf0010    lha r5,0x10(r31)            
10009c20  38640004    addi r3,r4,0x4              
10009c24  a8df0012    lha r6,0x12(r31)            
10009c28  38850020    addi r4,r5,0x20             
10009c2c  7ca6e214    add r5,r6,r28               
10009c30  4bffbb21    bl 0x10005750                  ; -> 10005750
10009c34  60000000    ori r0,r0,0x0               
10009c38  4800021c    b 0x10009e54                   ; -> 10009e54
10009c3c  a8ff0004    lha r7,0x4(r31)             
10009c40  2c070002    cmpwi r7,0x2                
10009c44  408200d8    bne 0x10009d1c                 ; -> 10009d1c
10009c48  a91f0010    lha r8,0x10(r31)            
10009c4c  a93f0012    lha r9,0x12(r31)            
10009c50  38680024    addi r3,r8,0x24             
10009c54  3889000a    addi r4,r9,0xa              
10009c58  4bffb8f5    bl 0x1000554c                  ; -> 1000554c
10009c5c  60000000    ori r0,r0,0x0               
10009c60  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10009c64  28030000    cmplwi r3,0x0               
10009c68  41820080    beq 0x10009ce8                 ; -> 10009ce8
10009c6c  a95f0010    lha r10,0x10(r31)           
10009c70  a97f0012    lha r11,0x12(r31)           
10009c74  386a0024    addi r3,r10,0x24            
10009c78  388b000a    addi r4,r11,0xa             
10009c7c  4bffba59    bl 0x100056d4                  ; -> 100056d4
10009c80  60000000    ori r0,r0,0x0               
10009c84  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10009c88  28030000    cmplwi r3,0x0               
10009c8c  41820014    beq 0x10009ca0                 ; -> 10009ca0
10009c90  39800005    li r12,0x5                  
10009c94  b19f0004    sth r12,0x4(r31)            
10009c98  b3bf000e    sth r29,0xe(r31)            
10009c9c  480001b8    b 0x10009e54                   ; -> 10009e54
10009ca0  a89f0012    lha r4,0x12(r31)            
10009ca4  3864000a    addi r3,r4,0xa              
10009ca8  48024a51    bl 0x1002e6f8                  ; -> 1002e6f8
10009cac  60000000    ori r0,r0,0x0               
10009cb0  a8bf0010    lha r5,0x10(r31)            
10009cb4  7c7b1b78    or r27,r3,r3                
10009cb8  38650024    addi r3,r5,0x24             
10009cbc  48024a11    bl 0x1002e6cc                  ; -> 1002e6cc
10009cc0  60000000    ori r0,r0,0x0               
10009cc4  7c7a1b78    or r26,r3,r3                
10009cc8  7f43d378    or r3,r26,r26               
10009ccc  7f64db78    or r4,r27,r27               
10009cd0  4801dcf5    bl 0x100279c4                  ; -> 100279c4
10009cd4  60000000    ori r0,r0,0x0               
10009cd8  38c00005    li r6,0x5                   
10009cdc  b0df0004    sth r6,0x4(r31)             
10009ce0  b3bf000e    sth r29,0xe(r31)            
10009ce4  48000170    b 0x10009e54                   ; -> 10009e54
10009ce8  a8ff0010    lha r7,0x10(r31)            
10009cec  39020340    addi r8,r2,0x340            
10009cf0  38e70002    addi r7,r7,0x2              
10009cf4  b0ff0010    sth r7,0x10(r31)            
10009cf8  a93f0010    lha r9,0x10(r31)            
10009cfc  7d2a2e70    srawi r10,r9,0x5            
10009d00  7d4a0194    addze r10,r10               
10009d04  554a2834    rlwinm r10,r10,0x5,0x0,0x1a 
10009d08  7d4a4810    subfc r10,r10,r9            
10009d0c  554a083c    rlwinm r10,r10,0x1,0x0,0x1e 
10009d10  7d0852ae    lhax r8,r8,r10              
10009d14  b11f000e    sth r8,0xe(r31)             
10009d18  4800013c    b 0x10009e54                   ; -> 10009e54
10009d1c  a97f0004    lha r11,0x4(r31)            
10009d20  2c0b0001    cmpwi r11,0x1               
10009d24  408200cc    bne 0x10009df0                 ; -> 10009df0
10009d28  a99f0012    lha r12,0x12(r31)           
10009d2c  a87f0010    lha r3,0x10(r31)            
10009d30  388c000a    addi r4,r12,0xa             
10009d34  4bffb819    bl 0x1000554c                  ; -> 1000554c
10009d38  60000000    ori r0,r0,0x0               
10009d3c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10009d40  28030000    cmplwi r3,0x0               
10009d44  41820078    beq 0x10009dbc                 ; -> 10009dbc
10009d48  ab5f0012    lha r26,0x12(r31)           
10009d4c  a87f0010    lha r3,0x10(r31)            
10009d50  389a000a    addi r4,r26,0xa             
10009d54  4bffb981    bl 0x100056d4                  ; -> 100056d4
10009d58  60000000    ori r0,r0,0x0               
10009d5c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10009d60  28030000    cmplwi r3,0x0               
10009d64  41820014    beq 0x10009d78                 ; -> 10009d78
10009d68  3b600006    li r27,0x6                  
10009d6c  b37f0004    sth r27,0x4(r31)            
10009d70  b3df000e    sth r30,0xe(r31)            
10009d74  480000e0    b 0x10009e54                   ; -> 10009e54
10009d78  a89f0012    lha r4,0x12(r31)            
10009d7c  3864000a    addi r3,r4,0xa              
10009d80  48024979    bl 0x1002e6f8                  ; -> 1002e6f8
10009d84  60000000    ori r0,r0,0x0               
10009d88  7c7b1b78    or r27,r3,r3                
10009d8c  a87f0010    lha r3,0x10(r31)            
10009d90  4802493d    bl 0x1002e6cc                  ; -> 1002e6cc
10009d94  60000000    ori r0,r0,0x0               
10009d98  7c7a1b78    or r26,r3,r3                
10009d9c  7f43d378    or r3,r26,r26               
10009da0  7f64db78    or r4,r27,r27               
10009da4  4801dc21    bl 0x100279c4                  ; -> 100279c4
10009da8  60000000    ori r0,r0,0x0               
10009dac  38a00006    li r5,0x6                   
10009db0  b0bf0004    sth r5,0x4(r31)             
10009db4  b3df000e    sth r30,0xe(r31)            
10009db8  4800009c    b 0x10009e54                   ; -> 10009e54
10009dbc  a8df0010    lha r6,0x10(r31)            
10009dc0  38e20380    addi r7,r2,0x380            
10009dc4  38c6fffe    subi r6,r6,0x2              
10009dc8  b0df0010    sth r6,0x10(r31)            
10009dcc  a91f0010    lha r8,0x10(r31)            
10009dd0  7d092e70    srawi r9,r8,0x5             
10009dd4  7d290194    addze r9,r9                 
10009dd8  55292834    rlwinm r9,r9,0x5,0x0,0x1a   
10009ddc  7d294010    subfc r9,r9,r8              
10009de0  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
10009de4  7ce74aae    lhax r7,r7,r9               
10009de8  b0ff000e    sth r7,0xe(r31)             
10009dec  48000068    b 0x10009e54                   ; -> 10009e54
10009df0  a95f0004    lha r10,0x4(r31)            
10009df4  2c0a0006    cmpwi r10,0x6               
10009df8  4082002c    bne 0x10009e24                 ; -> 10009e24
10009dfc  a97f000e    lha r11,0xe(r31)            
10009e00  7fac0734    extsh r12,r29               
10009e04  396b0001    addi r11,r11,0x1            
10009e08  b17f000e    sth r11,0xe(r31)            
10009e0c  7d6b0734    extsh r11,r11               
10009e10  7c0b6000    cmpw r11,r12                
10009e14  40810040    ble 0x10009e54                 ; -> 10009e54
10009e18  3b400002    li r26,0x2                  
10009e1c  b35f0004    sth r26,0x4(r31)            
10009e20  48000034    b 0x10009e54                   ; -> 10009e54
10009e24  ab7f0004    lha r27,0x4(r31)            
10009e28  2c1b0005    cmpwi r27,0x5               
10009e2c  40820028    bne 0x10009e54                 ; -> 10009e54
10009e30  a87f000e    lha r3,0xe(r31)             
10009e34  7fc40734    extsh r4,r30                
10009e38  3863ffff    subi r3,r3,0x1              
10009e3c  b07f000e    sth r3,0xe(r31)             
10009e40  7c630734    extsh r3,r3                 
10009e44  7c032000    cmpw r3,r4                  
10009e48  4080000c    bge 0x10009e54                 ; -> 10009e54
10009e4c  38a00001    li r5,0x1                   
10009e50  b0bf0004    sth r5,0x4(r31)             
10009e54  a8df0010    lha r6,0x10(r31)            
10009e58  38c60007    addi r6,r6,0x7              
10009e5c  b0df003a    sth r6,0x3a(r31)            
10009e60  a8ff0010    lha r7,0x10(r31)            
10009e64  38e7001e    addi r7,r7,0x1e             
10009e68  b0ff003c    sth r7,0x3c(r31)            
10009e6c  a91f0012    lha r8,0x12(r31)            
10009e70  39080004    addi r8,r8,0x4              
10009e74  b11f0038    sth r8,0x38(r31)            
10009e78  a93f0012    lha r9,0x12(r31)            
10009e7c  3929001b    addi r9,r9,0x1b             
10009e80  b13f0036    sth r9,0x36(r31)            
10009e84  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10009e88  38210050    addi r1,r1,0x50             
10009e8c  7c0803a6    mtspr LR,r0                 
10009e90  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
10009e94  4e800020    blr                         
