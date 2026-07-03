; FUN_10022a3c @ 0x10022a3c
10022a3c  7c0802a6    mfspr r0,LR                 
10022a40  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10022a44  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10022a48  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10022a4c  3be2539c    addi r31,r2,0x539c          
10022a50  3860019d    li r3,0x19d                 
10022a54  b07f00b4    sth r3,0xb4(r31)            
10022a58  38800139    li r4,0x139                 
10022a5c  b09f00b6    sth r4,0xb6(r31)            
10022a60  38a00000    li r5,0x0                   
10022a64  98bf00bc    stb r5,0xbc(r31)            
10022a68  38c00000    li r6,0x0                   
10022a6c  98df00bd    stb r6,0xbd(r31)            
10022a70  38e00898    li r7,0x898                 
10022a74  b0ff00be    sth r7,0xbe(r31)            
10022a78  38600009    li r3,0x9                   
10022a7c  4bfff559    bl 0x10021fd4                  ; -> 10021fd4
10022a80  39000152    li r8,0x152                 
10022a84  b11f0104    sth r8,0x104(r31)           
10022a88  3920013e    li r9,0x13e                 
10022a8c  b13f0106    sth r9,0x106(r31)           
10022a90  39400000    li r10,0x0                  
10022a94  995f010c    stb r10,0x10c(r31)          
10022a98  39600000    li r11,0x0                  
10022a9c  997f010d    stb r11,0x10d(r31)          
10022aa0  39800900    li r12,0x900                
10022aa4  b19f010e    sth r12,0x10e(r31)          
10022aa8  3860000d    li r3,0xd                   
10022aac  4bfff529    bl 0x10021fd4                  ; -> 10021fd4
10022ab0  38600040    li r3,0x40                  
10022ab4  b07f00c8    sth r3,0xc8(r31)            
10022ab8  3880013b    li r4,0x13b                 
10022abc  b09f00ca    sth r4,0xca(r31)            
10022ac0  38a00000    li r5,0x0                   
10022ac4  98bf00d0    stb r5,0xd0(r31)            
10022ac8  38c00000    li r6,0x0                   
10022acc  98df00d1    stb r6,0xd1(r31)            
10022ad0  38e008fc    li r7,0x8fc                 
10022ad4  b0ff00d2    sth r7,0xd2(r31)            
10022ad8  3860000a    li r3,0xa                   
10022adc  4bfff4f9    bl 0x10021fd4                  ; -> 10021fd4
10022ae0  390000dc    li r8,0xdc                  
10022ae4  b11f00dc    sth r8,0xdc(r31)            
10022ae8  3920013b    li r9,0x13b                 
10022aec  b13f00de    sth r9,0xde(r31)            
10022af0  39400000    li r10,0x0                  
10022af4  995f00e4    stb r10,0xe4(r31)           
10022af8  39600000    li r11,0x0                  
10022afc  997f00e5    stb r11,0xe5(r31)           
10022b00  398008fc    li r12,0x8fc                
10022b04  b19f00e6    sth r12,0xe6(r31)           
10022b08  3860000b    li r3,0xb                   
10022b0c  4bfff4c9    bl 0x10021fd4                  ; -> 10021fd4
10022b10  38600199    li r3,0x199                 
10022b14  b07f00f0    sth r3,0xf0(r31)            
10022b18  38800027    li r4,0x27                  
10022b1c  b09f00f2    sth r4,0xf2(r31)            
10022b20  38a00000    li r5,0x0                   
10022b24  98bf00f8    stb r5,0xf8(r31)            
10022b28  38c00000    li r6,0x0                   
10022b2c  98df00f9    stb r6,0xf9(r31)            
10022b30  38e008fe    li r7,0x8fe                 
10022b34  b0ff00fa    sth r7,0xfa(r31)            
10022b38  3860000c    li r3,0xc                   
10022b3c  4bfff499    bl 0x10021fd4                  ; -> 10021fd4
10022b40  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10022b44  38210040    addi r1,r1,0x40             
10022b48  7c0803a6    mtspr LR,r0                 
10022b4c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10022b50  4e800020    blr                         
