; FUN_10009e98 @ 0x10009e98
10009e98  7c0802a6    mfspr r0,LR                 
10009e9c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10009ea0  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10009ea4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10009ea8  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10009eac  b061005a    sth r3,0x5a(r1)                ; -> Stack[0x1a]
10009eb0  a881005a    lha r4,0x5a(r1)                ; -> Stack[0x1a]
10009eb4  38623cd8    addi r3,r2,0x3cd8           
10009eb8  1c840046    mulli r4,r4,0x46            
10009ebc  7fe32214    add r31,r3,r4               
10009ec0  88bf001f    lbz r5,0x1f(r31)            
10009ec4  3bc00002    li r30,0x2                  
10009ec8  28050000    cmplwi r5,0x0               
10009ecc  41820060    beq 0x10009f2c                 ; -> 10009f2c
10009ed0  38c00000    li r6,0x0                   
10009ed4  98df001f    stb r6,0x1f(r31)            
10009ed8  38e00001    li r7,0x1                   
10009edc  b0ff0024    sth r7,0x24(r31)            
10009ee0  39000000    li r8,0x0                   
10009ee4  392261a4    addi r9,r2,0x61a4           
10009ee8  b11f002e    sth r8,0x2e(r31)            
10009eec  81290008    lwz r9,0x8(r9)              
10009ef0  39400000    li r10,0x0                  
10009ef4  913f000a    stw r9,0xa(r31)             
10009ef8  915f0014    stw r10,0x14(r31)           
10009efc  39600001    li r11,0x1                  
10009f00  b17f000e    sth r11,0xe(r31)            
10009f04  a99f0012    lha r12,0x12(r31)           
10009f08  38600001    li r3,0x1                   
10009f0c  398c0002    addi r12,r12,0x2            
10009f10  b19f0012    sth r12,0x12(r31)           
10009f14  987f001e    stb r3,0x1e(r31)            
10009f18  a89f0004    lha r4,0x4(r31)             
10009f1c  38a0012c    li r5,0x12c                 
10009f20  b09f0026    sth r4,0x26(r31)            
10009f24  b0bf0042    sth r5,0x42(r31)            
10009f28  48000840    b 0x1000a768                   ; -> 1000a768
10009f2c  a8df0024    lha r6,0x24(r31)            
10009f30  7cc73378    or r7,r6,r6                 
10009f34  7ce70734    extsh r7,r7                 
10009f38  38c6ffff    subi r6,r6,0x1              
10009f3c  2c070000    cmpwi r7,0x0                
10009f40  b0df0024    sth r6,0x24(r31)            
10009f44  41810824    bgt 0x1000a768                 ; -> 1000a768
10009f48  39000001    li r8,0x1                   
10009f4c  991f001e    stb r8,0x1e(r31)            
10009f50  a93f0040    lha r9,0x40(r31)            
10009f54  2c090000    cmpwi r9,0x0                
10009f58  40810058    ble 0x10009fb0                 ; -> 10009fb0
10009f5c  3860000b    li r3,0xb                   
10009f60  38800005    li r4,0x5                   
10009f64  480210bd    bl 0x1002b020                  ; -> 1002b020
10009f68  60000000    ori r0,r0,0x0               
10009f6c  39400001    li r10,0x1                  
10009f70  995f0020    stb r10,0x20(r31)           
10009f74  807f000a    lwz r3,0xa(r31)             
10009f78  a89f000e    lha r4,0xe(r31)             
10009f7c  a8bf0010    lha r5,0x10(r31)            
10009f80  a8df0012    lha r6,0x12(r31)            
10009f84  38e00001    li r7,0x1                   
10009f88  4801e08d    bl 0x10028014                  ; -> 10028014
10009f8c  60000000    ori r0,r0,0x0               
10009f90  a87f0040    lha r3,0x40(r31)            
10009f94  39826840    addi r12,r2,0x6840          
10009f98  1c630070    mulli r3,r3,0x70            
10009f9c  398c003c    addi r12,r12,0x3c           
10009fa0  a97f0042    lha r11,0x42(r31)           
10009fa4  7c8c182e    lwzx r4,r12,r3              
10009fa8  7c845a14    add r4,r4,r11               
10009fac  7c8c192e    stwx r4,r12,r3              
10009fb0  a8bf0002    lha r5,0x2(r31)             
10009fb4  2c050002    cmpwi r5,0x2                
10009fb8  40820014    bne 0x10009fcc                 ; -> 10009fcc
10009fbc  38c00000    li r6,0x0                   
10009fc0  b0df0024    sth r6,0x24(r31)            
10009fc4  3bc00002    li r30,0x2                  
10009fc8  48000010    b 0x10009fd8                   ; -> 10009fd8
10009fcc  38e00001    li r7,0x1                   
10009fd0  b0ff0024    sth r7,0x24(r31)            
10009fd4  3bc00001    li r30,0x1                  
10009fd8  a91f0026    lha r8,0x26(r31)            
10009fdc  2c080002    cmpwi r8,0x2                
10009fe0  408203a8    bne 0x1000a388                 ; -> 1000a388
10009fe4  a93f000e    lha r9,0xe(r31)             
10009fe8  7d29f214    add r9,r9,r30               
10009fec  b13f000e    sth r9,0xe(r31)             
10009ff0  a95f000e    lha r10,0xe(r31)            
10009ff4  2c0a0018    cmpwi r10,0x18              
10009ff8  4081000c    ble 0x1000a004                 ; -> 1000a004
10009ffc  39600001    li r11,0x1                  
1000a000  b17f000e    sth r11,0xe(r31)            
1000a004  a99f0004    lha r12,0x4(r31)            
1000a008  2c0c0001    cmpwi r12,0x1               
1000a00c  408200dc    bne 0x1000a0e8                 ; -> 1000a0e8
1000a010  a89f0010    lha r4,0x10(r31)            
1000a014  a8bf0012    lha r5,0x12(r31)            
1000a018  3864ffff    subi r3,r4,0x1              
1000a01c  38850010    addi r4,r5,0x10             
1000a020  4bffb52d    bl 0x1000554c                  ; -> 1000554c
1000a024  60000000    ori r0,r0,0x0               
1000a028  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a02c  28030000    cmplwi r3,0x0               
1000a030  41820010    beq 0x1000a040                 ; -> 1000a040
1000a034  38c00009    li r6,0x9                   
1000a038  b0df0004    sth r6,0x4(r31)             
1000a03c  4800034c    b 0x1000a388                   ; -> 1000a388
1000a040  a8ff0010    lha r7,0x10(r31)            
1000a044  a91f0012    lha r8,0x12(r31)            
1000a048  3867001d    addi r3,r7,0x1d             
1000a04c  3888ffff    subi r4,r8,0x1              
1000a050  4bffb4fd    bl 0x1000554c                  ; -> 1000554c
1000a054  60000000    ori r0,r0,0x0               
1000a058  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a05c  28030000    cmplwi r3,0x0               
1000a060  41820014    beq 0x1000a074                 ; -> 1000a074
1000a064  a93f0010    lha r9,0x10(r31)            
1000a068  7d3e4850    subf r9,r30,r9              
1000a06c  b13f0010    sth r9,0x10(r31)            
1000a070  48000318    b 0x1000a388                   ; -> 1000a388
1000a074  a95f0010    lha r10,0x10(r31)           
1000a078  a97f0012    lha r11,0x12(r31)           
1000a07c  386affff    subi r3,r10,0x1             
1000a080  388bffff    subi r4,r11,0x1             
1000a084  4bffb4c9    bl 0x1000554c                  ; -> 1000554c
1000a088  60000000    ori r0,r0,0x0               
1000a08c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a090  28030000    cmplwi r3,0x0               
1000a094  41820014    beq 0x1000a0a8                 ; -> 1000a0a8
1000a098  a99f0010    lha r12,0x10(r31)           
1000a09c  7d9e6050    subf r12,r30,r12            
1000a0a0  b19f0010    sth r12,0x10(r31)           
1000a0a4  480002e4    b 0x1000a388                   ; -> 1000a388
1000a0a8  a89f0010    lha r4,0x10(r31)            
1000a0ac  a8bf0012    lha r5,0x12(r31)            
1000a0b0  3864001e    addi r3,r4,0x1e             
1000a0b4  3885ffff    subi r4,r5,0x1              
1000a0b8  4bffb495    bl 0x1000554c                  ; -> 1000554c
1000a0bc  60000000    ori r0,r0,0x0               
1000a0c0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a0c4  28030000    cmplwi r3,0x0               
1000a0c8  40820014    bne 0x1000a0dc                 ; -> 1000a0dc
1000a0cc  a8df0010    lha r6,0x10(r31)            
1000a0d0  7cde3050    subf r6,r30,r6              
1000a0d4  b0df0010    sth r6,0x10(r31)            
1000a0d8  480002b0    b 0x1000a388                   ; -> 1000a388
1000a0dc  38e00008    li r7,0x8                   
1000a0e0  b0ff0004    sth r7,0x4(r31)             
1000a0e4  480002a4    b 0x1000a388                   ; -> 1000a388
1000a0e8  a91f0004    lha r8,0x4(r31)             
1000a0ec  2c080008    cmpwi r8,0x8                
1000a0f0  408200dc    bne 0x1000a1cc                 ; -> 1000a1cc
1000a0f4  a93f0010    lha r9,0x10(r31)            
1000a0f8  a95f0012    lha r10,0x12(r31)           
1000a0fc  38690010    addi r3,r9,0x10             
1000a100  388affff    subi r4,r10,0x1             
1000a104  4bffb449    bl 0x1000554c                  ; -> 1000554c
1000a108  60000000    ori r0,r0,0x0               
1000a10c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a110  28030000    cmplwi r3,0x0               
1000a114  41820010    beq 0x1000a124                 ; -> 1000a124
1000a118  39600001    li r11,0x1                  
1000a11c  b17f0004    sth r11,0x4(r31)            
1000a120  48000268    b 0x1000a388                   ; -> 1000a388
1000a124  a99f0010    lha r12,0x10(r31)           
1000a128  a8bf0012    lha r5,0x12(r31)            
1000a12c  386c001e    addi r3,r12,0x1e            
1000a130  3885001d    addi r4,r5,0x1d             
1000a134  4bffb419    bl 0x1000554c                  ; -> 1000554c
1000a138  60000000    ori r0,r0,0x0               
1000a13c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a140  28030000    cmplwi r3,0x0               
1000a144  41820014    beq 0x1000a158                 ; -> 1000a158
1000a148  a8df0012    lha r6,0x12(r31)            
1000a14c  7cde3050    subf r6,r30,r6              
1000a150  b0df0012    sth r6,0x12(r31)            
1000a154  48000234    b 0x1000a388                   ; -> 1000a388
1000a158  a8ff0010    lha r7,0x10(r31)            
1000a15c  a91f0012    lha r8,0x12(r31)            
1000a160  3867001e    addi r3,r7,0x1e             
1000a164  3888ffff    subi r4,r8,0x1              
1000a168  4bffb3e5    bl 0x1000554c                  ; -> 1000554c
1000a16c  60000000    ori r0,r0,0x0               
1000a170  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a174  28030000    cmplwi r3,0x0               
1000a178  41820014    beq 0x1000a18c                 ; -> 1000a18c
1000a17c  a93f0012    lha r9,0x12(r31)            
1000a180  7d3e4850    subf r9,r30,r9              
1000a184  b13f0012    sth r9,0x12(r31)            
1000a188  48000200    b 0x1000a388                   ; -> 1000a388
1000a18c  a95f0010    lha r10,0x10(r31)           
1000a190  a97f0012    lha r11,0x12(r31)           
1000a194  386a001e    addi r3,r10,0x1e            
1000a198  388b001e    addi r4,r11,0x1e            
1000a19c  4bffb3b1    bl 0x1000554c                  ; -> 1000554c
1000a1a0  60000000    ori r0,r0,0x0               
1000a1a4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a1a8  28030000    cmplwi r3,0x0               
1000a1ac  40820014    bne 0x1000a1c0                 ; -> 1000a1c0
1000a1b0  a99f0012    lha r12,0x12(r31)           
1000a1b4  7d9e6050    subf r12,r30,r12            
1000a1b8  b19f0012    sth r12,0x12(r31)           
1000a1bc  480001cc    b 0x1000a388                   ; -> 1000a388
1000a1c0  38600002    li r3,0x2                   
1000a1c4  b07f0004    sth r3,0x4(r31)             
1000a1c8  480001c0    b 0x1000a388                   ; -> 1000a388
1000a1cc  a89f0004    lha r4,0x4(r31)             
1000a1d0  2c040002    cmpwi r4,0x2                
1000a1d4  408200d8    bne 0x1000a2ac                 ; -> 1000a2ac
1000a1d8  a8bf0010    lha r5,0x10(r31)            
1000a1dc  a8df0012    lha r6,0x12(r31)            
1000a1e0  3865001e    addi r3,r5,0x1e             
1000a1e4  38860010    addi r4,r6,0x10             
1000a1e8  4bffb365    bl 0x1000554c                  ; -> 1000554c
1000a1ec  60000000    ori r0,r0,0x0               
1000a1f0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a1f4  28030000    cmplwi r3,0x0               
1000a1f8  41820010    beq 0x1000a208                 ; -> 1000a208
1000a1fc  38e00008    li r7,0x8                   
1000a200  b0ff0004    sth r7,0x4(r31)             
1000a204  48000184    b 0x1000a388                   ; -> 1000a388
1000a208  a91f0012    lha r8,0x12(r31)            
1000a20c  a87f0010    lha r3,0x10(r31)            
1000a210  3888001e    addi r4,r8,0x1e             
1000a214  4bffb339    bl 0x1000554c                  ; -> 1000554c
1000a218  60000000    ori r0,r0,0x0               
1000a21c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a220  28030000    cmplwi r3,0x0               
1000a224  41820014    beq 0x1000a238                 ; -> 1000a238
1000a228  a93f0010    lha r9,0x10(r31)            
1000a22c  7d29f214    add r9,r9,r30               
1000a230  b13f0010    sth r9,0x10(r31)            
1000a234  48000154    b 0x1000a388                   ; -> 1000a388
1000a238  a95f0010    lha r10,0x10(r31)           
1000a23c  a97f0012    lha r11,0x12(r31)           
1000a240  386a001e    addi r3,r10,0x1e            
1000a244  388b001e    addi r4,r11,0x1e            
1000a248  4bffb305    bl 0x1000554c                  ; -> 1000554c
1000a24c  60000000    ori r0,r0,0x0               
1000a250  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a254  28030000    cmplwi r3,0x0               
1000a258  41820014    beq 0x1000a26c                 ; -> 1000a26c
1000a25c  a99f0010    lha r12,0x10(r31)           
1000a260  7d8cf214    add r12,r12,r30             
1000a264  b19f0010    sth r12,0x10(r31)           
1000a268  48000120    b 0x1000a388                   ; -> 1000a388
1000a26c  a89f0010    lha r4,0x10(r31)            
1000a270  a8bf0012    lha r5,0x12(r31)            
1000a274  3864ffff    subi r3,r4,0x1              
1000a278  3885001e    addi r4,r5,0x1e             
1000a27c  4bffb2d1    bl 0x1000554c                  ; -> 1000554c
1000a280  60000000    ori r0,r0,0x0               
1000a284  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a288  28030000    cmplwi r3,0x0               
1000a28c  40820014    bne 0x1000a2a0                 ; -> 1000a2a0
1000a290  a8df0010    lha r6,0x10(r31)            
1000a294  7cc6f214    add r6,r6,r30               
1000a298  b0df0010    sth r6,0x10(r31)            
1000a29c  480000ec    b 0x1000a388                   ; -> 1000a388
1000a2a0  38e00009    li r7,0x9                   
1000a2a4  b0ff0004    sth r7,0x4(r31)             
1000a2a8  480000e0    b 0x1000a388                   ; -> 1000a388
1000a2ac  a91f0004    lha r8,0x4(r31)             
1000a2b0  2c080009    cmpwi r8,0x9                
1000a2b4  408200d4    bne 0x1000a388                 ; -> 1000a388
1000a2b8  a93f0010    lha r9,0x10(r31)            
1000a2bc  a95f0012    lha r10,0x12(r31)           
1000a2c0  38690010    addi r3,r9,0x10             
1000a2c4  388a001e    addi r4,r10,0x1e            
1000a2c8  4bffb285    bl 0x1000554c                  ; -> 1000554c
1000a2cc  60000000    ori r0,r0,0x0               
1000a2d0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a2d4  28030000    cmplwi r3,0x0               
1000a2d8  41820010    beq 0x1000a2e8                 ; -> 1000a2e8
1000a2dc  39600002    li r11,0x2                  
1000a2e0  b17f0004    sth r11,0x4(r31)            
1000a2e4  480000a4    b 0x1000a388                   ; -> 1000a388
1000a2e8  a99f0010    lha r12,0x10(r31)           
1000a2ec  a89f0012    lha r4,0x12(r31)            
1000a2f0  386cffff    subi r3,r12,0x1             
1000a2f4  4bffb259    bl 0x1000554c                  ; -> 1000554c
1000a2f8  60000000    ori r0,r0,0x0               
1000a2fc  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a300  28030000    cmplwi r3,0x0               
1000a304  41820014    beq 0x1000a318                 ; -> 1000a318
1000a308  a87f0012    lha r3,0x12(r31)            
1000a30c  7c63f214    add r3,r3,r30               
1000a310  b07f0012    sth r3,0x12(r31)            
1000a314  48000074    b 0x1000a388                   ; -> 1000a388
1000a318  a89f0010    lha r4,0x10(r31)            
1000a31c  a8bf0012    lha r5,0x12(r31)            
1000a320  3864ffff    subi r3,r4,0x1              
1000a324  3885001e    addi r4,r5,0x1e             
1000a328  4bffb225    bl 0x1000554c                  ; -> 1000554c
1000a32c  60000000    ori r0,r0,0x0               
1000a330  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a334  28030000    cmplwi r3,0x0               
1000a338  41820014    beq 0x1000a34c                 ; -> 1000a34c
1000a33c  a8df0012    lha r6,0x12(r31)            
1000a340  7cc6f214    add r6,r6,r30               
1000a344  b0df0012    sth r6,0x12(r31)            
1000a348  48000040    b 0x1000a388                   ; -> 1000a388
1000a34c  a8ff0010    lha r7,0x10(r31)            
1000a350  a91f0012    lha r8,0x12(r31)            
1000a354  3867ffff    subi r3,r7,0x1              
1000a358  3888ffff    subi r4,r8,0x1              
1000a35c  4bffb1f1    bl 0x1000554c                  ; -> 1000554c
1000a360  60000000    ori r0,r0,0x0               
1000a364  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a368  28030000    cmplwi r3,0x0               
1000a36c  40820014    bne 0x1000a380                 ; -> 1000a380
1000a370  a93f0012    lha r9,0x12(r31)            
1000a374  7d29f214    add r9,r9,r30               
1000a378  b13f0012    sth r9,0x12(r31)            
1000a37c  4800000c    b 0x1000a388                   ; -> 1000a388
1000a380  39400001    li r10,0x1                  
1000a384  b15f0004    sth r10,0x4(r31)            
1000a388  a97f0026    lha r11,0x26(r31)           
1000a38c  2c0b0001    cmpwi r11,0x1               
1000a390  408203a8    bne 0x1000a738                 ; -> 1000a738
1000a394  a99f000e    lha r12,0xe(r31)            
1000a398  7d9e6050    subf r12,r30,r12            
1000a39c  b19f000e    sth r12,0xe(r31)            
1000a3a0  a87f000e    lha r3,0xe(r31)             
1000a3a4  2c030001    cmpwi r3,0x1                
1000a3a8  4080000c    bge 0x1000a3b4                 ; -> 1000a3b4
1000a3ac  38800018    li r4,0x18                  
1000a3b0  b09f000e    sth r4,0xe(r31)             
1000a3b4  a8bf0004    lha r5,0x4(r31)             
1000a3b8  2c050001    cmpwi r5,0x1                
1000a3bc  408200dc    bne 0x1000a498                 ; -> 1000a498
1000a3c0  a8df0010    lha r6,0x10(r31)            
1000a3c4  a8ff0012    lha r7,0x12(r31)            
1000a3c8  3866ffff    subi r3,r6,0x1              
1000a3cc  38870010    addi r4,r7,0x10             
1000a3d0  4bffb17d    bl 0x1000554c                  ; -> 1000554c
1000a3d4  60000000    ori r0,r0,0x0               
1000a3d8  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a3dc  28030000    cmplwi r3,0x0               
1000a3e0  41820010    beq 0x1000a3f0                 ; -> 1000a3f0
1000a3e4  39000008    li r8,0x8                   
1000a3e8  b11f0004    sth r8,0x4(r31)             
1000a3ec  4800034c    b 0x1000a738                   ; -> 1000a738
1000a3f0  a93f0010    lha r9,0x10(r31)            
1000a3f4  a95f0012    lha r10,0x12(r31)           
1000a3f8  3869001d    addi r3,r9,0x1d             
1000a3fc  388a001e    addi r4,r10,0x1e            
1000a400  4bffb14d    bl 0x1000554c                  ; -> 1000554c
1000a404  60000000    ori r0,r0,0x0               
1000a408  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a40c  28030000    cmplwi r3,0x0               
1000a410  41820014    beq 0x1000a424                 ; -> 1000a424
1000a414  a97f0010    lha r11,0x10(r31)           
1000a418  7d7e5850    subf r11,r30,r11            
1000a41c  b17f0010    sth r11,0x10(r31)           
1000a420  48000318    b 0x1000a738                   ; -> 1000a738
1000a424  a99f0010    lha r12,0x10(r31)           
1000a428  a8bf0012    lha r5,0x12(r31)            
1000a42c  386cffff    subi r3,r12,0x1             
1000a430  3885001e    addi r4,r5,0x1e             
1000a434  4bffb119    bl 0x1000554c                  ; -> 1000554c
1000a438  60000000    ori r0,r0,0x0               
1000a43c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a440  28030000    cmplwi r3,0x0               
1000a444  41820014    beq 0x1000a458                 ; -> 1000a458
1000a448  a8df0010    lha r6,0x10(r31)            
1000a44c  7cde3050    subf r6,r30,r6              
1000a450  b0df0010    sth r6,0x10(r31)            
1000a454  480002e4    b 0x1000a738                   ; -> 1000a738
1000a458  a8ff0010    lha r7,0x10(r31)            
1000a45c  a91f0012    lha r8,0x12(r31)            
1000a460  3867001e    addi r3,r7,0x1e             
1000a464  3888001e    addi r4,r8,0x1e             
1000a468  4bffb0e5    bl 0x1000554c                  ; -> 1000554c
1000a46c  60000000    ori r0,r0,0x0               
1000a470  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a474  28030000    cmplwi r3,0x0               
1000a478  40820014    bne 0x1000a48c                 ; -> 1000a48c
1000a47c  a93f0010    lha r9,0x10(r31)            
1000a480  7d3e4850    subf r9,r30,r9              
1000a484  b13f0010    sth r9,0x10(r31)            
1000a488  480002b0    b 0x1000a738                   ; -> 1000a738
1000a48c  39400009    li r10,0x9                  
1000a490  b15f0004    sth r10,0x4(r31)            
1000a494  480002a4    b 0x1000a738                   ; -> 1000a738
1000a498  a97f0004    lha r11,0x4(r31)            
1000a49c  2c0b0008    cmpwi r11,0x8               
1000a4a0  408200dc    bne 0x1000a57c                 ; -> 1000a57c
1000a4a4  a99f0010    lha r12,0x10(r31)           
1000a4a8  a8bf0012    lha r5,0x12(r31)            
1000a4ac  386c0010    addi r3,r12,0x10            
1000a4b0  3885ffff    subi r4,r5,0x1              
1000a4b4  4bffb099    bl 0x1000554c                  ; -> 1000554c
1000a4b8  60000000    ori r0,r0,0x0               
1000a4bc  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a4c0  28030000    cmplwi r3,0x0               
1000a4c4  41820010    beq 0x1000a4d4                 ; -> 1000a4d4
1000a4c8  38c00002    li r6,0x2                   
1000a4cc  b0df0004    sth r6,0x4(r31)             
1000a4d0  48000268    b 0x1000a738                   ; -> 1000a738
1000a4d4  a8ff0010    lha r7,0x10(r31)            
1000a4d8  a91f0012    lha r8,0x12(r31)            
1000a4dc  3867ffff    subi r3,r7,0x1              
1000a4e0  3888001d    addi r4,r8,0x1d             
1000a4e4  4bffb069    bl 0x1000554c                  ; -> 1000554c
1000a4e8  60000000    ori r0,r0,0x0               
1000a4ec  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a4f0  28030000    cmplwi r3,0x0               
1000a4f4  41820014    beq 0x1000a508                 ; -> 1000a508
1000a4f8  a93f0012    lha r9,0x12(r31)            
1000a4fc  7d3e4850    subf r9,r30,r9              
1000a500  b13f0012    sth r9,0x12(r31)            
1000a504  48000234    b 0x1000a738                   ; -> 1000a738
1000a508  a95f0010    lha r10,0x10(r31)           
1000a50c  a97f0012    lha r11,0x12(r31)           
1000a510  386affff    subi r3,r10,0x1             
1000a514  388bffff    subi r4,r11,0x1             
1000a518  4bffb035    bl 0x1000554c                  ; -> 1000554c
1000a51c  60000000    ori r0,r0,0x0               
1000a520  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a524  28030000    cmplwi r3,0x0               
1000a528  41820014    beq 0x1000a53c                 ; -> 1000a53c
1000a52c  a99f0012    lha r12,0x12(r31)           
1000a530  7d9e6050    subf r12,r30,r12            
1000a534  b19f0012    sth r12,0x12(r31)           
1000a538  48000200    b 0x1000a738                   ; -> 1000a738
1000a53c  a89f0010    lha r4,0x10(r31)            
1000a540  a8bf0012    lha r5,0x12(r31)            
1000a544  3864ffff    subi r3,r4,0x1              
1000a548  3885001e    addi r4,r5,0x1e             
1000a54c  4bffb001    bl 0x1000554c                  ; -> 1000554c
1000a550  60000000    ori r0,r0,0x0               
1000a554  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a558  28030000    cmplwi r3,0x0               
1000a55c  40820014    bne 0x1000a570                 ; -> 1000a570
1000a560  a8df0012    lha r6,0x12(r31)            
1000a564  7cde3050    subf r6,r30,r6              
1000a568  b0df0012    sth r6,0x12(r31)            
1000a56c  480001cc    b 0x1000a738                   ; -> 1000a738
1000a570  38e00001    li r7,0x1                   
1000a574  b0ff0004    sth r7,0x4(r31)             
1000a578  480001c0    b 0x1000a738                   ; -> 1000a738
1000a57c  a91f0004    lha r8,0x4(r31)             
1000a580  2c080002    cmpwi r8,0x2                
1000a584  408200d8    bne 0x1000a65c                 ; -> 1000a65c
1000a588  a93f0010    lha r9,0x10(r31)            
1000a58c  a95f0012    lha r10,0x12(r31)           
1000a590  3869001e    addi r3,r9,0x1e             
1000a594  388a0010    addi r4,r10,0x10            
1000a598  4bffafb5    bl 0x1000554c                  ; -> 1000554c
1000a59c  60000000    ori r0,r0,0x0               
1000a5a0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a5a4  28030000    cmplwi r3,0x0               
1000a5a8  41820010    beq 0x1000a5b8                 ; -> 1000a5b8
1000a5ac  39600009    li r11,0x9                  
1000a5b0  b17f0004    sth r11,0x4(r31)            
1000a5b4  48000184    b 0x1000a738                   ; -> 1000a738
1000a5b8  a99f0012    lha r12,0x12(r31)           
1000a5bc  a87f0010    lha r3,0x10(r31)            
1000a5c0  388cffff    subi r4,r12,0x1             
1000a5c4  4bffaf89    bl 0x1000554c                  ; -> 1000554c
1000a5c8  60000000    ori r0,r0,0x0               
1000a5cc  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a5d0  28030000    cmplwi r3,0x0               
1000a5d4  41820014    beq 0x1000a5e8                 ; -> 1000a5e8
1000a5d8  a87f0010    lha r3,0x10(r31)            
1000a5dc  7c63f214    add r3,r3,r30               
1000a5e0  b07f0010    sth r3,0x10(r31)            
1000a5e4  48000154    b 0x1000a738                   ; -> 1000a738
1000a5e8  a89f0010    lha r4,0x10(r31)            
1000a5ec  a8bf0012    lha r5,0x12(r31)            
1000a5f0  3864001e    addi r3,r4,0x1e             
1000a5f4  3885ffff    subi r4,r5,0x1              
1000a5f8  4bffaf55    bl 0x1000554c                  ; -> 1000554c
1000a5fc  60000000    ori r0,r0,0x0               
1000a600  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a604  28030000    cmplwi r3,0x0               
1000a608  41820014    beq 0x1000a61c                 ; -> 1000a61c
1000a60c  a8df0010    lha r6,0x10(r31)            
1000a610  7cc6f214    add r6,r6,r30               
1000a614  b0df0010    sth r6,0x10(r31)            
1000a618  48000120    b 0x1000a738                   ; -> 1000a738
1000a61c  a8ff0010    lha r7,0x10(r31)            
1000a620  a91f0012    lha r8,0x12(r31)            
1000a624  3867ffff    subi r3,r7,0x1              
1000a628  3888ffff    subi r4,r8,0x1              
1000a62c  4bffaf21    bl 0x1000554c                  ; -> 1000554c
1000a630  60000000    ori r0,r0,0x0               
1000a634  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a638  28030000    cmplwi r3,0x0               
1000a63c  40820014    bne 0x1000a650                 ; -> 1000a650
1000a640  a93f0010    lha r9,0x10(r31)            
1000a644  7d29f214    add r9,r9,r30               
1000a648  b13f0010    sth r9,0x10(r31)            
1000a64c  480000ec    b 0x1000a738                   ; -> 1000a738
1000a650  39400008    li r10,0x8                  
1000a654  b15f0004    sth r10,0x4(r31)            
1000a658  480000e0    b 0x1000a738                   ; -> 1000a738
1000a65c  a97f0004    lha r11,0x4(r31)            
1000a660  2c0b0009    cmpwi r11,0x9               
1000a664  408200d4    bne 0x1000a738                 ; -> 1000a738
1000a668  a99f0010    lha r12,0x10(r31)           
1000a66c  a8bf0012    lha r5,0x12(r31)            
1000a670  386c000c    addi r3,r12,0xc             
1000a674  3885001e    addi r4,r5,0x1e             
1000a678  4bffaed5    bl 0x1000554c                  ; -> 1000554c
1000a67c  60000000    ori r0,r0,0x0               
1000a680  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a684  28030000    cmplwi r3,0x0               
1000a688  41820010    beq 0x1000a698                 ; -> 1000a698
1000a68c  38c00001    li r6,0x1                   
1000a690  b0df0004    sth r6,0x4(r31)             
1000a694  480000a4    b 0x1000a738                   ; -> 1000a738
1000a698  a8ff0010    lha r7,0x10(r31)            
1000a69c  a89f0012    lha r4,0x12(r31)            
1000a6a0  3867001e    addi r3,r7,0x1e             
1000a6a4  4bffaea9    bl 0x1000554c                  ; -> 1000554c
1000a6a8  60000000    ori r0,r0,0x0               
1000a6ac  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a6b0  28030000    cmplwi r3,0x0               
1000a6b4  41820014    beq 0x1000a6c8                 ; -> 1000a6c8
1000a6b8  a91f0012    lha r8,0x12(r31)            
1000a6bc  7d08f214    add r8,r8,r30               
1000a6c0  b11f0012    sth r8,0x12(r31)            
1000a6c4  48000074    b 0x1000a738                   ; -> 1000a738
1000a6c8  a93f0010    lha r9,0x10(r31)            
1000a6cc  a95f0012    lha r10,0x12(r31)           
1000a6d0  3869001e    addi r3,r9,0x1e             
1000a6d4  388a001e    addi r4,r10,0x1e            
1000a6d8  4bffae75    bl 0x1000554c                  ; -> 1000554c
1000a6dc  60000000    ori r0,r0,0x0               
1000a6e0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a6e4  28030000    cmplwi r3,0x0               
1000a6e8  41820014    beq 0x1000a6fc                 ; -> 1000a6fc
1000a6ec  a97f0012    lha r11,0x12(r31)           
1000a6f0  7d6bf214    add r11,r11,r30             
1000a6f4  b17f0012    sth r11,0x12(r31)           
1000a6f8  48000040    b 0x1000a738                   ; -> 1000a738
1000a6fc  a99f0010    lha r12,0x10(r31)           
1000a700  a8bf0012    lha r5,0x12(r31)            
1000a704  386c001e    addi r3,r12,0x1e            
1000a708  3885ffff    subi r4,r5,0x1              
1000a70c  4bffae41    bl 0x1000554c                  ; -> 1000554c
1000a710  60000000    ori r0,r0,0x0               
1000a714  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a718  28030000    cmplwi r3,0x0               
1000a71c  40820014    bne 0x1000a730                 ; -> 1000a730
1000a720  a8df0012    lha r6,0x12(r31)            
1000a724  7cc6f214    add r6,r6,r30               
1000a728  b0df0012    sth r6,0x12(r31)            
1000a72c  4800000c    b 0x1000a738                   ; -> 1000a738
1000a730  38e00002    li r7,0x2                   
1000a734  b0ff0004    sth r7,0x4(r31)             
1000a738  a91f0010    lha r8,0x10(r31)            
1000a73c  39080004    addi r8,r8,0x4              
1000a740  b11f003a    sth r8,0x3a(r31)            
1000a744  a93f0010    lha r9,0x10(r31)            
1000a748  3929001a    addi r9,r9,0x1a             
1000a74c  b13f003c    sth r9,0x3c(r31)            
1000a750  a95f0012    lha r10,0x12(r31)           
1000a754  394a0004    addi r10,r10,0x4            
1000a758  b15f0038    sth r10,0x38(r31)           
1000a75c  a97f0012    lha r11,0x12(r31)           
1000a760  396b001a    addi r11,r11,0x1a           
1000a764  b17f0036    sth r11,0x36(r31)           
1000a768  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1000a76c  38210040    addi r1,r1,0x40             
1000a770  7c0803a6    mtspr LR,r0                 
1000a774  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000a778  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000a77c  4e800020    blr                         
