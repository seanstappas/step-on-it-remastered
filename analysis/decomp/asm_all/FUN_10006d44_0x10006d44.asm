; FUN_10006d44 @ 0x10006d44
10006d44  7c0802a6    mfspr r0,LR                 
10006d48  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10006d4c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10006d50  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10006d54  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10006d58  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10006d5c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10006d60  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
10006d64  a861006a    lha r3,0x6a(r1)                ; -> Stack[0x1a]
10006d68  3bc23cd8    addi r30,r2,0x3cd8          
10006d6c  1c630046    mulli r3,r3,0x46            
10006d70  7ffe1a14    add r31,r30,r3              
10006d74  889f001f    lbz r4,0x1f(r31)            
10006d78  28040000    cmplwi r4,0x0               
10006d7c  41820048    beq 0x10006dc4                 ; -> 10006dc4
10006d80  38a00000    li r5,0x0                   
10006d84  98bf001f    stb r5,0x1f(r31)            
10006d88  38c00000    li r6,0x0                   
10006d8c  38e261a4    addi r7,r2,0x61a4           
10006d90  98df001e    stb r6,0x1e(r31)            
10006d94  80e7001c    lwz r7,0x1c(r7)             
10006d98  39000000    li r8,0x0                   
10006d9c  90ff000a    stw r7,0xa(r31)             
10006da0  911f0014    stw r8,0x14(r31)            
10006da4  39200001    li r9,0x1                   
10006da8  b13f0024    sth r9,0x24(r31)            
10006dac  39400001    li r10,0x1                  
10006db0  b15f0026    sth r10,0x26(r31)           
10006db4  38600012    li r3,0x12                  
10006db8  38800004    li r4,0x4                   
10006dbc  48024265    bl 0x1002b020                  ; -> 1002b020
10006dc0  60000000    ori r0,r0,0x0               
10006dc4  a97f0024    lha r11,0x24(r31)           
10006dc8  7d6c5b78    or r12,r11,r11              
10006dcc  7d8c0734    extsh r12,r12               
10006dd0  396bffff    subi r11,r11,0x1            
10006dd4  2c0c0000    cmpwi r12,0x0               
10006dd8  b17f0024    sth r11,0x24(r31)           
10006ddc  40820170    bne 0x10006f4c                 ; -> 10006f4c
10006de0  38600001    li r3,0x1                   
10006de4  b07f0024    sth r3,0x24(r31)            
10006de8  38800001    li r4,0x1                   
10006dec  989f001e    stb r4,0x1e(r31)            
10006df0  a8bf0004    lha r5,0x4(r31)             
10006df4  2c050002    cmpwi r5,0x2                
10006df8  40820098    bne 0x10006e90                 ; -> 10006e90
10006dfc  a8df0026    lha r6,0x26(r31)            
10006e00  a8ff000e    lha r7,0xe(r31)             
10006e04  7ce73214    add r7,r7,r6                
10006e08  b0ff000e    sth r7,0xe(r31)             
10006e0c  a91f000e    lha r8,0xe(r31)             
10006e10  2c080010    cmpwi r8,0x10               
10006e14  40810048    ble 0x10006e5c                 ; -> 10006e5c
10006e18  3920000f    li r9,0xf                   
10006e1c  b13f000e    sth r9,0xe(r31)             
10006e20  3940ffff    li r10,-0x1                 
10006e24  b15f0026    sth r10,0x26(r31)           
10006e28  a87f0012    lha r3,0x12(r31)            
10006e2c  480278cd    bl 0x1002e6f8                  ; -> 1002e6f8
10006e30  60000000    ori r0,r0,0x0               
10006e34  a97f0010    lha r11,0x10(r31)           
10006e38  7c7d1b78    or r29,r3,r3                
10006e3c  386b0010    addi r3,r11,0x10            
10006e40  4802788d    bl 0x1002e6cc                  ; -> 1002e6cc
10006e44  60000000    ori r0,r0,0x0               
10006e48  7c7c1b78    or r28,r3,r3                
10006e4c  7f83e378    or r3,r28,r28               
10006e50  7fa4eb78    or r4,r29,r29               
10006e54  48020b71    bl 0x100279c4                  ; -> 100279c4
10006e58  60000000    ori r0,r0,0x0               
10006e5c  a99f000e    lha r12,0xe(r31)            
10006e60  2c0c0001    cmpwi r12,0x1               
10006e64  408000b8    bge 0x10006f1c                 ; -> 10006f1c
10006e68  3b800001    li r28,0x1                  
10006e6c  b39f000e    sth r28,0xe(r31)            
10006e70  3ba00001    li r29,0x1                  
10006e74  9bbf0020    stb r29,0x20(r31)           
10006e78  a89f0030    lha r4,0x30(r31)            
10006e7c  38600000    li r3,0x0                   
10006e80  1c840046    mulli r4,r4,0x46            
10006e84  38840032    addi r4,r4,0x32             
10006e88  7c7e232e    sthx r3,r30,r4              
10006e8c  48000090    b 0x10006f1c                   ; -> 10006f1c
10006e90  a8bf0026    lha r5,0x26(r31)            
10006e94  a8df000e    lha r6,0xe(r31)             
10006e98  7cc62a14    add r6,r6,r5                
10006e9c  b0df000e    sth r6,0xe(r31)             
10006ea0  a8ff000e    lha r7,0xe(r31)             
10006ea4  2c070030    cmpwi r7,0x30               
10006ea8  40810044    ble 0x10006eec                 ; -> 10006eec
10006eac  3900002f    li r8,0x2f                  
10006eb0  b11f000e    sth r8,0xe(r31)             
10006eb4  3920ffff    li r9,-0x1                  
10006eb8  b13f0026    sth r9,0x26(r31)            
10006ebc  a87f0012    lha r3,0x12(r31)            
10006ec0  48027839    bl 0x1002e6f8                  ; -> 1002e6f8
10006ec4  60000000    ori r0,r0,0x0               
10006ec8  7c7d1b78    or r29,r3,r3                
10006ecc  a87f0010    lha r3,0x10(r31)            
10006ed0  480277fd    bl 0x1002e6cc                  ; -> 1002e6cc
10006ed4  60000000    ori r0,r0,0x0               
10006ed8  7c7c1b78    or r28,r3,r3                
10006edc  7f83e378    or r3,r28,r28               
10006ee0  7fa4eb78    or r4,r29,r29               
10006ee4  48020ae1    bl 0x100279c4                  ; -> 100279c4
10006ee8  60000000    ori r0,r0,0x0               
10006eec  a95f000e    lha r10,0xe(r31)            
10006ef0  2c0a0021    cmpwi r10,0x21              
10006ef4  40800028    bge 0x10006f1c                 ; -> 10006f1c
10006ef8  39600021    li r11,0x21                 
10006efc  b17f000e    sth r11,0xe(r31)            
10006f00  39800001    li r12,0x1                  
10006f04  999f0020    stb r12,0x20(r31)           
10006f08  abbf0030    lha r29,0x30(r31)           
10006f0c  3b800000    li r28,0x0                  
10006f10  1fbd0046    mulli r29,r29,0x46          
10006f14  3bbd0032    addi r29,r29,0x32           
10006f18  7f9eeb2e    sthx r28,r30,r29            
10006f1c  a87f0010    lha r3,0x10(r31)            
10006f20  38630004    addi r3,r3,0x4              
10006f24  b07f003a    sth r3,0x3a(r31)            
10006f28  a89f0010    lha r4,0x10(r31)            
10006f2c  3884001c    addi r4,r4,0x1c             
10006f30  b09f003c    sth r4,0x3c(r31)            
10006f34  a8bf0012    lha r5,0x12(r31)            
10006f38  38a50005    addi r5,r5,0x5              
10006f3c  b0bf0038    sth r5,0x38(r31)            
10006f40  a8df0012    lha r6,0x12(r31)            
10006f44  38c6000f    addi r6,r6,0xf              
10006f48  b0df0036    sth r6,0x36(r31)            
10006f4c  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10006f50  38210050    addi r1,r1,0x50             
10006f54  7c0803a6    mtspr LR,r0                 
10006f58  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10006f5c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10006f60  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10006f64  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10006f68  4e800020    blr                         
