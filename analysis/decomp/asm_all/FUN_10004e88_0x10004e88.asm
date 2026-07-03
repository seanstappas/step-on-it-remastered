; FUN_10004e88 @ 0x10004e88
10004e88  7c0802a6    mfspr r0,LR                 
10004e8c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10004e90  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10004e94  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10004e98  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10004e9c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10004ea0  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10004ea4  3b823cd8    addi r28,r2,0x3cd8          
10004ea8  4bffe93d    bl 0x100037e4                  ; -> 100037e4
10004eac  60000000    ori r0,r0,0x0               
10004eb0  386261fa    addi r3,r2,0x61fa           
10004eb4  abc30000    lha r30,0x0(r3)             
10004eb8  48000144    b 0x10004ffc                   ; -> 10004ffc
10004ebc  7fc40734    extsh r4,r30                
10004ec0  1c840046    mulli r4,r4,0x46            
10004ec4  7ffc2214    add r31,r28,r4              
10004ec8  88bf0021    lbz r5,0x21(r31)            
10004ecc  28050000    cmplwi r5,0x0               
10004ed0  41820068    beq 0x10004f38                 ; -> 10004f38
10004ed4  88df0020    lbz r6,0x20(r31)            
10004ed8  28060000    cmplwi r6,0x0               
10004edc  41820020    beq 0x10004efc                 ; -> 10004efc
10004ee0  807f0014    lwz r3,0x14(r31)            
10004ee4  a89f0018    lha r4,0x18(r31)            
10004ee8  a8bf001a    lha r5,0x1a(r31)            
10004eec  a8df001c    lha r6,0x1c(r31)            
10004ef0  4bfffdc1    bl 0x10004cb0                  ; -> 10004cb0
10004ef4  60000000    ori r0,r0,0x0               
10004ef8  4800001c    b 0x10004f14                   ; -> 10004f14
10004efc  807f000a    lwz r3,0xa(r31)             
10004f00  a89f000e    lha r4,0xe(r31)             
10004f04  a8bf0010    lha r5,0x10(r31)            
10004f08  a8df0012    lha r6,0x12(r31)            
10004f0c  4bfffd51    bl 0x10004c5c                  ; -> 10004c5c
10004f10  60000000    ori r0,r0,0x0               
10004f14  80ff000a    lwz r7,0xa(r31)             
10004f18  90ff0014    stw r7,0x14(r31)            
10004f1c  a91f000e    lha r8,0xe(r31)             
10004f20  b11f0018    sth r8,0x18(r31)            
10004f24  a93f0010    lha r9,0x10(r31)            
10004f28  b13f001a    sth r9,0x1a(r31)            
10004f2c  a95f0012    lha r10,0x12(r31)           
10004f30  b15f001c    sth r10,0x1c(r31)           
10004f34  480000a8    b 0x10004fdc                   ; -> 10004fdc
10004f38  897f001e    lbz r11,0x1e(r31)           
10004f3c  280b0000    cmplwi r11,0x0              
10004f40  4182009c    beq 0x10004fdc                 ; -> 10004fdc
10004f44  899f0020    lbz r12,0x20(r31)           
10004f48  280c0000    cmplwi r12,0x0              
10004f4c  41820020    beq 0x10004f6c                 ; -> 10004f6c
10004f50  807f0014    lwz r3,0x14(r31)            
10004f54  a89f0018    lha r4,0x18(r31)            
10004f58  a8bf001a    lha r5,0x1a(r31)            
10004f5c  a8df001c    lha r6,0x1c(r31)            
10004f60  4bfffd51    bl 0x10004cb0                  ; -> 10004cb0
10004f64  60000000    ori r0,r0,0x0               
10004f68  48000054    b 0x10004fbc                   ; -> 10004fbc
10004f6c  807f0014    lwz r3,0x14(r31)            
10004f70  28030000    cmplwi r3,0x0               
10004f74  41820030    beq 0x10004fa4                 ; -> 10004fa4
10004f78  807f0014    lwz r3,0x14(r31)            
10004f7c  a89f0018    lha r4,0x18(r31)            
10004f80  a8bf001a    lha r5,0x1a(r31)            
10004f84  a8df001c    lha r6,0x1c(r31)            
10004f88  80ff000a    lwz r7,0xa(r31)             
10004f8c  a91f000e    lha r8,0xe(r31)             
10004f90  a93f0010    lha r9,0x10(r31)            
10004f94  a95f0012    lha r10,0x12(r31)           
10004f98  4bfff409    bl 0x100043a0                  ; -> 100043a0
10004f9c  60000000    ori r0,r0,0x0               
10004fa0  4800001c    b 0x10004fbc                   ; -> 10004fbc
10004fa4  807f000a    lwz r3,0xa(r31)             
10004fa8  a89f000e    lha r4,0xe(r31)             
10004fac  a8bf0010    lha r5,0x10(r31)            
10004fb0  a8df0012    lha r6,0x12(r31)            
10004fb4  4bfffc01    bl 0x10004bb4                  ; -> 10004bb4
10004fb8  60000000    ori r0,r0,0x0               
10004fbc  809f000a    lwz r4,0xa(r31)             
10004fc0  909f0014    stw r4,0x14(r31)            
10004fc4  a8bf000e    lha r5,0xe(r31)             
10004fc8  b0bf0018    sth r5,0x18(r31)            
10004fcc  a8df0010    lha r6,0x10(r31)            
10004fd0  b0df001a    sth r6,0x1a(r31)            
10004fd4  a8ff0012    lha r7,0x12(r31)            
10004fd8  b0ff001c    sth r7,0x1c(r31)            
10004fdc  891f0020    lbz r8,0x20(r31)            
10004fe0  abbf003e    lha r29,0x3e(r31)           
10004fe4  28080000    cmplwi r8,0x0               
10004fe8  41820010    beq 0x10004ff8                 ; -> 10004ff8
10004fec  7fc3f378    or r3,r30,r30               
10004ff0  48000c75    bl 0x10005c64                  ; -> 10005c64
10004ff4  60000000    ori r0,r0,0x0               
10004ff8  7fbeeb78    or r30,r29,r29              
10004ffc  7fc90734    extsh r9,r30                
10005000  2c090000    cmpwi r9,0x0                
10005004  4082feb8    bne 0x10004ebc                 ; -> 10004ebc
10005008  4bffef75    bl 0x10003f7c                  ; -> 10003f7c
1000500c  60000000    ori r0,r0,0x0               
10005010  39623bde    addi r11,r2,0x3bde          
10005014  39400000    li r10,0x0                  
10005018  994b0000    stb r10,0x0(r11)            
1000501c  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10005020  38210050    addi r1,r1,0x50             
10005024  7c0803a6    mtspr LR,r0                 
10005028  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000502c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10005030  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10005034  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10005038  4e800020    blr                         
