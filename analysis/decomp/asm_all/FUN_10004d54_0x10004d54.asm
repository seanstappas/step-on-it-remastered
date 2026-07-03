; FUN_10004d54 @ 0x10004d54
10004d54  7c0802a6    mfspr r0,LR                 
10004d58  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10004d5c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10004d60  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10004d64  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10004d68  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10004d6c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10004d70  386261fa    addi r3,r2,0x61fa           
10004d74  3b823cd8    addi r28,r2,0x3cd8          
10004d78  abc30000    lha r30,0x0(r3)             
10004d7c  480000d4    b 0x10004e50                   ; -> 10004e50
10004d80  7fc40734    extsh r4,r30                
10004d84  1c840046    mulli r4,r4,0x46            
10004d88  7ffc2214    add r31,r28,r4              
10004d8c  88bf001e    lbz r5,0x1e(r31)            
10004d90  28050000    cmplwi r5,0x0               
10004d94  4182009c    beq 0x10004e30                 ; -> 10004e30
10004d98  88df0020    lbz r6,0x20(r31)            
10004d9c  28060000    cmplwi r6,0x0               
10004da0  41820020    beq 0x10004dc0                 ; -> 10004dc0
10004da4  807f0014    lwz r3,0x14(r31)            
10004da8  a89f0018    lha r4,0x18(r31)            
10004dac  a8bf001a    lha r5,0x1a(r31)            
10004db0  a8df001c    lha r6,0x1c(r31)            
10004db4  4bfffefd    bl 0x10004cb0                  ; -> 10004cb0
10004db8  60000000    ori r0,r0,0x0               
10004dbc  48000054    b 0x10004e10                   ; -> 10004e10
10004dc0  80ff0014    lwz r7,0x14(r31)            
10004dc4  28070000    cmplwi r7,0x0               
10004dc8  41820030    beq 0x10004df8                 ; -> 10004df8
10004dcc  807f0014    lwz r3,0x14(r31)            
10004dd0  a89f0018    lha r4,0x18(r31)            
10004dd4  a8bf001a    lha r5,0x1a(r31)            
10004dd8  a8df001c    lha r6,0x1c(r31)            
10004ddc  80ff000a    lwz r7,0xa(r31)             
10004de0  a91f000e    lha r8,0xe(r31)             
10004de4  a93f0010    lha r9,0x10(r31)            
10004de8  a95f0012    lha r10,0x12(r31)           
10004dec  4bfff5b5    bl 0x100043a0                  ; -> 100043a0
10004df0  60000000    ori r0,r0,0x0               
10004df4  4800001c    b 0x10004e10                   ; -> 10004e10
10004df8  807f000a    lwz r3,0xa(r31)             
10004dfc  a89f000e    lha r4,0xe(r31)             
10004e00  a8bf0010    lha r5,0x10(r31)            
10004e04  a8df0012    lha r6,0x12(r31)            
10004e08  4bfffdad    bl 0x10004bb4                  ; -> 10004bb4
10004e0c  60000000    ori r0,r0,0x0               
10004e10  811f000a    lwz r8,0xa(r31)             
10004e14  911f0014    stw r8,0x14(r31)            
10004e18  a93f000e    lha r9,0xe(r31)             
10004e1c  b13f0018    sth r9,0x18(r31)            
10004e20  a95f0010    lha r10,0x10(r31)           
10004e24  b15f001a    sth r10,0x1a(r31)           
10004e28  a97f0012    lha r11,0x12(r31)           
10004e2c  b17f001c    sth r11,0x1c(r31)           
10004e30  899f0020    lbz r12,0x20(r31)           
10004e34  abbf003e    lha r29,0x3e(r31)           
10004e38  280c0000    cmplwi r12,0x0              
10004e3c  41820010    beq 0x10004e4c                 ; -> 10004e4c
10004e40  7fc3f378    or r3,r30,r30               
10004e44  48000e21    bl 0x10005c64                  ; -> 10005c64
10004e48  60000000    ori r0,r0,0x0               
10004e4c  7fbeeb78    or r30,r29,r29              
10004e50  7fc30734    extsh r3,r30                
10004e54  2c030000    cmpwi r3,0x0                
10004e58  4082ff28    bne 0x10004d80                 ; -> 10004d80
10004e5c  38a23bde    addi r5,r2,0x3bde           
10004e60  38800000    li r4,0x0                   
10004e64  98850000    stb r4,0x0(r5)              
10004e68  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10004e6c  38210050    addi r1,r1,0x50             
10004e70  7c0803a6    mtspr LR,r0                 
10004e74  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10004e78  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10004e7c  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10004e80  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10004e84  4e800020    blr                         
