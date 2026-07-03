; FUN_1000d130 @ 0x1000d130
1000d130  7c0802a6    mfspr r0,LR                 
1000d134  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000d138  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000d13c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000d140  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1000d144  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000d148  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000d14c  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
1000d150  a881006a    lha r4,0x6a(r1)                ; -> Stack[0x1a]
1000d154  38623cd8    addi r3,r2,0x3cd8           
1000d158  1c840046    mulli r4,r4,0x46            
1000d15c  7fe32214    add r31,r3,r4               
1000d160  88bf001f    lbz r5,0x1f(r31)            
1000d164  3bc0001e    li r30,0x1e                 
1000d168  28050000    cmplwi r5,0x0               
1000d16c  41820030    beq 0x1000d19c                 ; -> 1000d19c
1000d170  38c00000    li r6,0x0                   
1000d174  98df001f    stb r6,0x1f(r31)            
1000d178  38e00001    li r7,0x1                   
1000d17c  b0ff0024    sth r7,0x24(r31)            
1000d180  39000001    li r8,0x1                   
1000d184  b11f000e    sth r8,0xe(r31)             
1000d188  39200001    li r9,0x1                   
1000d18c  993f001e    stb r9,0x1e(r31)            
1000d190  39400190    li r10,0x190                
1000d194  b15f0042    sth r10,0x42(r31)           
1000d198  480002d8    b 0x1000d470                   ; -> 1000d470
1000d19c  a97f0024    lha r11,0x24(r31)           
1000d1a0  7d6c5b78    or r12,r11,r11              
1000d1a4  7d8c0734    extsh r12,r12               
1000d1a8  396bffff    subi r11,r11,0x1            
1000d1ac  2c0c0000    cmpwi r12,0x0               
1000d1b0  b17f0024    sth r11,0x24(r31)           
1000d1b4  408202bc    bne 0x1000d470                 ; -> 1000d470
1000d1b8  38600001    li r3,0x1                   
1000d1bc  987f001e    stb r3,0x1e(r31)            
1000d1c0  a89f002c    lha r4,0x2c(r31)            
1000d1c4  7c852378    or r5,r4,r4                 
1000d1c8  7ca50734    extsh r5,r5                 
1000d1cc  3884ffff    subi r4,r4,0x1              
1000d1d0  2c050000    cmpwi r5,0x0                
1000d1d4  b09f002c    sth r4,0x2c(r31)            
1000d1d8  4181000c    bgt 0x1000d1e4                 ; -> 1000d1e4
1000d1dc  38c00001    li r6,0x1                   
1000d1e0  98df0020    stb r6,0x20(r31)            
1000d1e4  a8ff0040    lha r7,0x40(r31)            
1000d1e8  2c070000    cmpwi r7,0x0                
1000d1ec  40810058    ble 0x1000d244                 ; -> 1000d244
1000d1f0  38600006    li r3,0x6                   
1000d1f4  38800005    li r4,0x5                   
1000d1f8  4801de29    bl 0x1002b020                  ; -> 1002b020
1000d1fc  60000000    ori r0,r0,0x0               
1000d200  39000001    li r8,0x1                   
1000d204  991f0020    stb r8,0x20(r31)            
1000d208  807f000a    lwz r3,0xa(r31)             
1000d20c  a89f000e    lha r4,0xe(r31)             
1000d210  a8bf0010    lha r5,0x10(r31)            
1000d214  a8df0012    lha r6,0x12(r31)            
1000d218  38e00001    li r7,0x1                   
1000d21c  4801adf9    bl 0x10028014                  ; -> 10028014
1000d220  60000000    ori r0,r0,0x0               
1000d224  a97f0040    lha r11,0x40(r31)           
1000d228  39426840    addi r10,r2,0x6840          
1000d22c  1d6b0070    mulli r11,r11,0x70          
1000d230  394a003c    addi r10,r10,0x3c           
1000d234  a93f0042    lha r9,0x42(r31)            
1000d238  7d8a582e    lwzx r12,r10,r11            
1000d23c  7d8c4a14    add r12,r12,r9              
1000d240  7d8a592e    stwx r12,r10,r11            
1000d244  38600001    li r3,0x1                   
1000d248  b07f0024    sth r3,0x24(r31)            
1000d24c  a89f0010    lha r4,0x10(r31)            
1000d250  a8bf0010    lha r5,0x10(r31)            
1000d254  38640002    addi r3,r4,0x2              
1000d258  a8df0012    lha r6,0x12(r31)            
1000d25c  3885001e    addi r4,r5,0x1e             
1000d260  7ca6f214    add r5,r6,r30               
1000d264  4bff84ed    bl 0x10005750                  ; -> 10005750
1000d268  60000000    ori r0,r0,0x0               
1000d26c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000d270  28030000    cmplwi r3,0x0               
1000d274  41820034    beq 0x1000d2a8                 ; -> 1000d2a8
1000d278  a8ff0012    lha r7,0x12(r31)            
1000d27c  38e70004    addi r7,r7,0x4              
1000d280  b0ff0012    sth r7,0x12(r31)            
1000d284  a91f0010    lha r8,0x10(r31)            
1000d288  a93f0010    lha r9,0x10(r31)            
1000d28c  a95f0012    lha r10,0x12(r31)           
1000d290  38680002    addi r3,r8,0x2              
1000d294  3889001e    addi r4,r9,0x1e             
1000d298  7caaf214    add r5,r10,r30              
1000d29c  4bff84b5    bl 0x10005750                  ; -> 10005750
1000d2a0  60000000    ori r0,r0,0x0               
1000d2a4  4800019c    b 0x1000d440                   ; -> 1000d440
1000d2a8  a97f0004    lha r11,0x4(r31)            
1000d2ac  2c0b0002    cmpwi r11,0x2               
1000d2b0  408200cc    bne 0x1000d37c                 ; -> 1000d37c
1000d2b4  a99f0010    lha r12,0x10(r31)           
1000d2b8  a8bf0012    lha r5,0x12(r31)            
1000d2bc  386c0020    addi r3,r12,0x20            
1000d2c0  3885000a    addi r4,r5,0xa              
1000d2c4  4bff8289    bl 0x1000554c                  ; -> 1000554c
1000d2c8  60000000    ori r0,r0,0x0               
1000d2cc  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000d2d0  28030000    cmplwi r3,0x0               
1000d2d4  41820078    beq 0x1000d34c                 ; -> 1000d34c
1000d2d8  a8df0010    lha r6,0x10(r31)            
1000d2dc  a8ff0012    lha r7,0x12(r31)            
1000d2e0  38660020    addi r3,r6,0x20             
1000d2e4  3887000a    addi r4,r7,0xa              
1000d2e8  4bff83ed    bl 0x100056d4                  ; -> 100056d4
1000d2ec  60000000    ori r0,r0,0x0               
1000d2f0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000d2f4  28030000    cmplwi r3,0x0               
1000d2f8  41820010    beq 0x1000d308                 ; -> 1000d308
1000d2fc  39000001    li r8,0x1                   
1000d300  b11f0004    sth r8,0x4(r31)             
1000d304  4800013c    b 0x1000d440                   ; -> 1000d440
1000d308  a93f0012    lha r9,0x12(r31)            
1000d30c  3869000a    addi r3,r9,0xa              
1000d310  480213e9    bl 0x1002e6f8                  ; -> 1002e6f8
1000d314  60000000    ori r0,r0,0x0               
1000d318  a95f0010    lha r10,0x10(r31)           
1000d31c  7c7d1b78    or r29,r3,r3                
1000d320  386a0020    addi r3,r10,0x20            
1000d324  480213a9    bl 0x1002e6cc                  ; -> 1002e6cc
1000d328  60000000    ori r0,r0,0x0               
1000d32c  7c7c1b78    or r28,r3,r3                
1000d330  7f83e378    or r3,r28,r28               
1000d334  7fa4eb78    or r4,r29,r29               
1000d338  4801a68d    bl 0x100279c4                  ; -> 100279c4
1000d33c  60000000    ori r0,r0,0x0               
1000d340  39600001    li r11,0x1                  
1000d344  b17f0004    sth r11,0x4(r31)            
1000d348  480000f8    b 0x1000d440                   ; -> 1000d440
1000d34c  a99f0010    lha r12,0x10(r31)           
1000d350  398c0002    addi r12,r12,0x2            
1000d354  b19f0010    sth r12,0x10(r31)           
1000d358  ab9f000e    lha r28,0xe(r31)            
1000d35c  3b9cffff    subi r28,r28,0x1            
1000d360  b39f000e    sth r28,0xe(r31)            
1000d364  7f9c0734    extsh r28,r28               
1000d368  2c1c0001    cmpwi r28,0x1               
1000d36c  408000d4    bge 0x1000d440                 ; -> 1000d440
1000d370  3ba00030    li r29,0x30                 
1000d374  b3bf000e    sth r29,0xe(r31)            
1000d378  480000c8    b 0x1000d440                   ; -> 1000d440
1000d37c  a87f0004    lha r3,0x4(r31)             
1000d380  2c030001    cmpwi r3,0x1                
1000d384  408200bc    bne 0x1000d440                 ; -> 1000d440
1000d388  a8bf0012    lha r5,0x12(r31)            
1000d38c  a87f0010    lha r3,0x10(r31)            
1000d390  3885000a    addi r4,r5,0xa              
1000d394  4bff81b9    bl 0x1000554c                  ; -> 1000554c
1000d398  60000000    ori r0,r0,0x0               
1000d39c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000d3a0  28030000    cmplwi r3,0x0               
1000d3a4  41820070    beq 0x1000d414                 ; -> 1000d414
1000d3a8  a8df0012    lha r6,0x12(r31)            
1000d3ac  a87f0010    lha r3,0x10(r31)            
1000d3b0  3886000a    addi r4,r6,0xa              
1000d3b4  4bff8321    bl 0x100056d4                  ; -> 100056d4
1000d3b8  60000000    ori r0,r0,0x0               
1000d3bc  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000d3c0  28030000    cmplwi r3,0x0               
1000d3c4  41820010    beq 0x1000d3d4                 ; -> 1000d3d4
1000d3c8  38e00002    li r7,0x2                   
1000d3cc  b0ff0004    sth r7,0x4(r31)             
1000d3d0  48000070    b 0x1000d440                   ; -> 1000d440
1000d3d4  a91f0012    lha r8,0x12(r31)            
1000d3d8  3868000a    addi r3,r8,0xa              
1000d3dc  4802131d    bl 0x1002e6f8                  ; -> 1002e6f8
1000d3e0  60000000    ori r0,r0,0x0               
1000d3e4  7c7d1b78    or r29,r3,r3                
1000d3e8  a87f0010    lha r3,0x10(r31)            
1000d3ec  480212e1    bl 0x1002e6cc                  ; -> 1002e6cc
1000d3f0  60000000    ori r0,r0,0x0               
1000d3f4  7c7c1b78    or r28,r3,r3                
1000d3f8  7f83e378    or r3,r28,r28               
1000d3fc  7fa4eb78    or r4,r29,r29               
1000d400  4801a5c5    bl 0x100279c4                  ; -> 100279c4
1000d404  60000000    ori r0,r0,0x0               
1000d408  39200002    li r9,0x2                   
1000d40c  b13f0004    sth r9,0x4(r31)             
1000d410  48000030    b 0x1000d440                   ; -> 1000d440
1000d414  a95f0010    lha r10,0x10(r31)           
1000d418  394afffe    subi r10,r10,0x2            
1000d41c  b15f0010    sth r10,0x10(r31)           
1000d420  a97f000e    lha r11,0xe(r31)            
1000d424  396b0001    addi r11,r11,0x1            
1000d428  b17f000e    sth r11,0xe(r31)            
1000d42c  7d6b0734    extsh r11,r11               
1000d430  2c0b0030    cmpwi r11,0x30              
1000d434  4081000c    ble 0x1000d440                 ; -> 1000d440
1000d438  39800001    li r12,0x1                  
1000d43c  b19f000e    sth r12,0xe(r31)            
1000d440  ab9f0010    lha r28,0x10(r31)           
1000d444  3b9c0004    addi r28,r28,0x4            
1000d448  b39f003a    sth r28,0x3a(r31)           
1000d44c  abbf0010    lha r29,0x10(r31)           
1000d450  3bbd001e    addi r29,r29,0x1e           
1000d454  b3bf003c    sth r29,0x3c(r31)           
1000d458  a87f0012    lha r3,0x12(r31)            
1000d45c  38630004    addi r3,r3,0x4              
1000d460  b07f0038    sth r3,0x38(r31)            
1000d464  a89f0012    lha r4,0x12(r31)            
1000d468  3884001c    addi r4,r4,0x1c             
1000d46c  b09f0036    sth r4,0x36(r31)            
1000d470  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000d474  38210050    addi r1,r1,0x50             
1000d478  7c0803a6    mtspr LR,r0                 
1000d47c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000d480  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000d484  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000d488  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1000d48c  4e800020    blr                         
