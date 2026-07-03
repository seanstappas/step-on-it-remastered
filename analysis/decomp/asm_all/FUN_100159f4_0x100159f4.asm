; FUN_100159f4 @ 0x100159f4
100159f4  7c0802a6    mfspr r0,LR                 
100159f8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100159fc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10015a00  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10015a04  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10015a08  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10015a0c  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10015a10  7c7d1b78    or r29,r3,r3                
10015a14  7c9e2378    or r30,r4,r4                
10015a18  7fa30734    extsh r3,r29                
10015a1c  2c030003    cmpwi r3,0x3                
10015a20  3b826840    addi r28,r2,0x6840          
10015a24  408201ec    bne 0x10015c10                 ; -> 10015c10
10015a28  386003fc    li r3,0x3fc                 
10015a2c  4801c19d    bl 0x10031bc8                  ; -> 10031bc8
10015a30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015a34  7c7f1b78    or r31,r3,r3                
10015a38  281f0000    cmplwi r31,0x0              
10015a3c  40820010    bne 0x10015a4c                 ; -> 10015a4c
10015a40  38600005    li r3,0x5                   
10015a44  480038b5    bl 0x100192f8                  ; -> 100192f8
10015a48  60000000    ori r0,r0,0x0               
10015a4c  809f0000    lwz r4,0x0(r31)             
10015a50  394000f5    li r10,0xf5                 
10015a54  80a40002    lwz r5,0x2(r4)              
10015a58  80c40006    lwz r6,0x6(r4)              
10015a5c  7fe3fb78    or r3,r31,r31               
10015a60  90a10040    stw r5,0x40(r1)                ; -> Stack[-0x20]
10015a64  90c10044    stw r6,0x44(r1)                ; -> Stack[-0x1c]
10015a68  a8e10046    lha r7,0x46(r1)                ; -> Stack[-0x1a]
10015a6c  a9210046    lha r9,0x46(r1)                ; -> Stack[-0x1a]
10015a70  7ce70e70    srawi r7,r7,0x1             
10015a74  7ce70194    addze r7,r7                 
10015a78  7ce7f050    subf r7,r7,r30              
10015a7c  b0e1003a    sth r7,0x3a(r1)                ; -> Stack[-0x26]
10015a80  a901003a    lha r8,0x3a(r1)                ; -> Stack[-0x26]
10015a84  a9810044    lha r12,0x44(r1)               ; -> Stack[-0x1c]
10015a88  7d084a14    add r8,r8,r9                
10015a8c  b101003e    sth r8,0x3e(r1)                ; -> Stack[-0x22]
10015a90  b1410038    sth r10,0x38(r1)               ; -> Stack[-0x28]
10015a94  a9610038    lha r11,0x38(r1)               ; -> Stack[-0x28]
10015a98  38810038    addi r4,r1,0x38             
10015a9c  7d6b6214    add r11,r11,r12             
10015aa0  b161003c    sth r11,0x3c(r1)               ; -> Stack[-0x24]
10015aa4  4801c13d    bl 0x10031be0                  ; -> 10031be0
10015aa8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015aac  7fe3fb78    or r3,r31,r31               
10015ab0  4801bcb1    bl 0x10031760                  ; -> 10031760
10015ab4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015ab8  386003f2    li r3,0x3f2                 
10015abc  4801c10d    bl 0x10031bc8                  ; -> 10031bc8
10015ac0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015ac4  7c7f1b78    or r31,r3,r3                
10015ac8  281f0000    cmplwi r31,0x0              
10015acc  40820010    bne 0x10015adc                 ; -> 10015adc
10015ad0  38600005    li r3,0x5                   
10015ad4  48003825    bl 0x100192f8                  ; -> 100192f8
10015ad8  60000000    ori r0,r0,0x0               
10015adc  807f0000    lwz r3,0x0(r31)             
10015ae0  38feffca    subi r7,r30,0x36            
10015ae4  80830002    lwz r4,0x2(r3)              
10015ae8  80a30006    lwz r5,0x6(r3)              
10015aec  39400096    li r10,0x96                 
10015af0  90810040    stw r4,0x40(r1)                ; -> Stack[-0x20]
10015af4  90a10044    stw r5,0x44(r1)                ; -> Stack[-0x1c]
10015af8  a8c10046    lha r6,0x46(r1)                ; -> Stack[-0x1a]
10015afc  a9210046    lha r9,0x46(r1)                ; -> Stack[-0x1a]
10015b00  7cc60e70    srawi r6,r6,0x1             
10015b04  7cc60194    addze r6,r6                 
10015b08  7cc63850    subf r6,r6,r7               
10015b0c  b0c1003a    sth r6,0x3a(r1)                ; -> Stack[-0x26]
10015b10  a901003a    lha r8,0x3a(r1)                ; -> Stack[-0x26]
10015b14  a9810044    lha r12,0x44(r1)               ; -> Stack[-0x1c]
10015b18  7d084a14    add r8,r8,r9                
10015b1c  b101003e    sth r8,0x3e(r1)                ; -> Stack[-0x22]
10015b20  b1410038    sth r10,0x38(r1)               ; -> Stack[-0x28]
10015b24  a9610038    lha r11,0x38(r1)               ; -> Stack[-0x28]
10015b28  7fe3fb78    or r3,r31,r31               
10015b2c  7d6b6214    add r11,r11,r12             
10015b30  b161003c    sth r11,0x3c(r1)               ; -> Stack[-0x24]
10015b34  38810038    addi r4,r1,0x38             
10015b38  4801c0a9    bl 0x10031be0                  ; -> 10031be0
10015b3c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015b40  7fe3fb78    or r3,r31,r31               
10015b44  4801bc1d    bl 0x10031760                  ; -> 10031760
10015b48  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015b4c  386003f3    li r3,0x3f3                 
10015b50  4801c079    bl 0x10031bc8                  ; -> 10031bc8
10015b54  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015b58  7c7f1b78    or r31,r3,r3                
10015b5c  281f0000    cmplwi r31,0x0              
10015b60  40820010    bne 0x10015b70                 ; -> 10015b70
10015b64  38600005    li r3,0x5                   
10015b68  48003791    bl 0x100192f8                  ; -> 100192f8
10015b6c  60000000    ori r0,r0,0x0               
10015b70  807f0000    lwz r3,0x0(r31)             
10015b74  38fe0036    addi r7,r30,0x36            
10015b78  80830002    lwz r4,0x2(r3)              
10015b7c  80a30006    lwz r5,0x6(r3)              
10015b80  39400096    li r10,0x96                 
10015b84  90810040    stw r4,0x40(r1)                ; -> Stack[-0x20]
10015b88  90a10044    stw r5,0x44(r1)                ; -> Stack[-0x1c]
10015b8c  a8c10046    lha r6,0x46(r1)                ; -> Stack[-0x1a]
10015b90  a9210046    lha r9,0x46(r1)                ; -> Stack[-0x1a]
10015b94  7cc60e70    srawi r6,r6,0x1             
10015b98  7cc60194    addze r6,r6                 
10015b9c  7cc63850    subf r6,r6,r7               
10015ba0  b0c1003a    sth r6,0x3a(r1)                ; -> Stack[-0x26]
10015ba4  a901003a    lha r8,0x3a(r1)                ; -> Stack[-0x26]
10015ba8  a9810044    lha r12,0x44(r1)               ; -> Stack[-0x1c]
10015bac  7d084a14    add r8,r8,r9                
10015bb0  b101003e    sth r8,0x3e(r1)                ; -> Stack[-0x22]
10015bb4  b1410038    sth r10,0x38(r1)               ; -> Stack[-0x28]
10015bb8  a9610038    lha r11,0x38(r1)               ; -> Stack[-0x28]
10015bbc  7fe3fb78    or r3,r31,r31               
10015bc0  7d6b6214    add r11,r11,r12             
10015bc4  b161003c    sth r11,0x3c(r1)               ; -> Stack[-0x24]
10015bc8  38810038    addi r4,r1,0x38             
10015bcc  4801c015    bl 0x10031be0                  ; -> 10031be0
10015bd0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015bd4  7fe3fb78    or r3,r31,r31               
10015bd8  4801bb89    bl 0x10031760                  ; -> 10031760
10015bdc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015be0  a89c00a8    lha r4,0xa8(r28)            
10015be4  38a000ff    li r5,0xff                  
10015be8  3864ffff    subi r3,r4,0x1              
10015bec  389e006d    addi r4,r30,0x6d            
10015bf0  480002a1    bl 0x10015e90                  ; -> 10015e90
10015bf4  60000000    ori r0,r0,0x0               
10015bf8  807c00ac    lwz r3,0xac(r28)            
10015bfc  389e006d    addi r4,r30,0x6d            
10015c00  38a0017c    li r5,0x17c                 
10015c04  4800028d    bl 0x10015e90                  ; -> 10015e90
10015c08  60000000    ori r0,r0,0x0               
10015c0c  48000168    b 0x10015d74                   ; -> 10015d74
10015c10  387d03fb    addi r3,r29,0x3fb           
10015c14  4801bfb5    bl 0x10031bc8                  ; -> 10031bc8
10015c18  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015c1c  7c7f1b78    or r31,r3,r3                
10015c20  281f0000    cmplwi r31,0x0              
10015c24  40820010    bne 0x10015c34                 ; -> 10015c34
10015c28  38600005    li r3,0x5                   
10015c2c  480036cd    bl 0x100192f8                  ; -> 100192f8
10015c30  60000000    ori r0,r0,0x0               
10015c34  80bf0000    lwz r5,0x0(r31)             
10015c38  396000f5    li r11,0xf5                 
10015c3c  80c50002    lwz r6,0x2(r5)              
10015c40  80e50006    lwz r7,0x6(r5)              
10015c44  38810038    addi r4,r1,0x38             
10015c48  90c10040    stw r6,0x40(r1)                ; -> Stack[-0x20]
10015c4c  90e10044    stw r7,0x44(r1)                ; -> Stack[-0x1c]
10015c50  a9010046    lha r8,0x46(r1)                ; -> Stack[-0x1a]
10015c54  a9410046    lha r10,0x46(r1)               ; -> Stack[-0x1a]
10015c58  7d080e70    srawi r8,r8,0x1             
10015c5c  7d080194    addze r8,r8                 
10015c60  7d08f050    subf r8,r8,r30              
10015c64  b101003a    sth r8,0x3a(r1)                ; -> Stack[-0x26]
10015c68  a921003a    lha r9,0x3a(r1)                ; -> Stack[-0x26]
10015c6c  a8610044    lha r3,0x44(r1)                ; -> Stack[-0x1c]
10015c70  7d295214    add r9,r9,r10               
10015c74  b121003e    sth r9,0x3e(r1)                ; -> Stack[-0x22]
10015c78  b1610038    sth r11,0x38(r1)               ; -> Stack[-0x28]
10015c7c  a9810038    lha r12,0x38(r1)               ; -> Stack[-0x28]
10015c80  7d8c1a14    add r12,r12,r3              
10015c84  b181003c    sth r12,0x3c(r1)               ; -> Stack[-0x24]
10015c88  7fe3fb78    or r3,r31,r31               
10015c8c  4801bf55    bl 0x10031be0                  ; -> 10031be0
10015c90  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015c94  7fe3fb78    or r3,r31,r31               
10015c98  4801bac9    bl 0x10031760                  ; -> 10031760
10015c9c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015ca0  387d03f1    addi r3,r29,0x3f1           
10015ca4  4801bf25    bl 0x10031bc8                  ; -> 10031bc8
10015ca8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015cac  7c7f1b78    or r31,r3,r3                
10015cb0  281f0000    cmplwi r31,0x0              
10015cb4  40820010    bne 0x10015cc4                 ; -> 10015cc4
10015cb8  38600005    li r3,0x5                   
10015cbc  4800363d    bl 0x100192f8                  ; -> 100192f8
10015cc0  60000000    ori r0,r0,0x0               
10015cc4  809f0000    lwz r4,0x0(r31)             
10015cc8  39400096    li r10,0x96                 
10015ccc  80a40002    lwz r5,0x2(r4)              
10015cd0  80c40006    lwz r6,0x6(r4)              
10015cd4  7fe3fb78    or r3,r31,r31               
10015cd8  90a10040    stw r5,0x40(r1)                ; -> Stack[-0x20]
10015cdc  90c10044    stw r6,0x44(r1)                ; -> Stack[-0x1c]
10015ce0  a8e10046    lha r7,0x46(r1)                ; -> Stack[-0x1a]
10015ce4  a9210046    lha r9,0x46(r1)                ; -> Stack[-0x1a]
10015ce8  7ce70e70    srawi r7,r7,0x1             
10015cec  7ce70194    addze r7,r7                 
10015cf0  7ce7f050    subf r7,r7,r30              
10015cf4  b0e1003a    sth r7,0x3a(r1)                ; -> Stack[-0x26]
10015cf8  a901003a    lha r8,0x3a(r1)                ; -> Stack[-0x26]
10015cfc  a9810044    lha r12,0x44(r1)               ; -> Stack[-0x1c]
10015d00  7d084a14    add r8,r8,r9                
10015d04  b101003e    sth r8,0x3e(r1)                ; -> Stack[-0x22]
10015d08  b1410038    sth r10,0x38(r1)               ; -> Stack[-0x28]
10015d0c  a9610038    lha r11,0x38(r1)               ; -> Stack[-0x28]
10015d10  38810038    addi r4,r1,0x38             
10015d14  7d6b6214    add r11,r11,r12             
10015d18  b161003c    sth r11,0x3c(r1)               ; -> Stack[-0x24]
10015d1c  4801bec5    bl 0x10031be0                  ; -> 10031be0
10015d20  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015d24  7fe3fb78    or r3,r31,r31               
10015d28  4801ba39    bl 0x10031760                  ; -> 10031760
10015d2c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10015d30  7fa40734    extsh r4,r29                
10015d34  1c840070    mulli r4,r4,0x70            
10015d38  38840038    addi r4,r4,0x38             
10015d3c  7c9c22ae    lhax r4,r28,r4              
10015d40  38a000ff    li r5,0xff                  
10015d44  3864ffff    subi r3,r4,0x1              
10015d48  389e006d    addi r4,r30,0x6d            
10015d4c  48000145    bl 0x10015e90                  ; -> 10015e90
10015d50  60000000    ori r0,r0,0x0               
10015d54  7fa50734    extsh r5,r29                
10015d58  1ca50070    mulli r5,r5,0x70            
10015d5c  38a5003c    addi r5,r5,0x3c             
10015d60  7c7c282e    lwzx r3,r28,r5              
10015d64  389e006d    addi r4,r30,0x6d            
10015d68  38a0017c    li r5,0x17c                 
10015d6c  48000125    bl 0x10015e90                  ; -> 10015e90
10015d70  60000000    ori r0,r0,0x0               
10015d74  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10015d78  38210060    addi r1,r1,0x60             
10015d7c  7c0803a6    mtspr LR,r0                 
10015d80  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10015d84  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10015d88  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10015d8c  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10015d90  4e800020    blr                         
