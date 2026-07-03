; FUN_10022b54 @ 0x10022b54
10022b54  7c0802a6    mfspr r0,LR                 
10022b58  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10022b5c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10022b60  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10022b64  3be2539c    addi r31,r2,0x539c          
10022b68  38600186    li r3,0x186                 
10022b6c  b07f0168    sth r3,0x168(r31)           
10022b70  38800140    li r4,0x140                 
10022b74  b09f016a    sth r4,0x16a(r31)           
10022b78  38a00000    li r5,0x0                   
10022b7c  98bf0170    stb r5,0x170(r31)           
10022b80  38c00000    li r6,0x0                   
10022b84  98df0171    stb r6,0x171(r31)           
10022b88  38e00898    li r7,0x898                 
10022b8c  b0ff0172    sth r7,0x172(r31)           
10022b90  38600012    li r3,0x12                  
10022b94  4bfff441    bl 0x10021fd4                  ; -> 10021fd4
10022b98  39000124    li r8,0x124                 
10022b9c  b11f017c    sth r8,0x17c(r31)           
10022ba0  39200144    li r9,0x144                 
10022ba4  b13f017e    sth r9,0x17e(r31)           
10022ba8  39400000    li r10,0x0                  
10022bac  995f0184    stb r10,0x184(r31)          
10022bb0  39600000    li r11,0x0                  
10022bb4  997f0185    stb r11,0x185(r31)          
10022bb8  39800900    li r12,0x900                
10022bbc  b19f0186    sth r12,0x186(r31)          
10022bc0  38600013    li r3,0x13                  
10022bc4  4bfff411    bl 0x10021fd4                  ; -> 10021fd4
10022bc8  38600032    li r3,0x32                  
10022bcc  b07f0118    sth r3,0x118(r31)           
10022bd0  3880012c    li r4,0x12c                 
10022bd4  b09f011a    sth r4,0x11a(r31)           
10022bd8  38a00000    li r5,0x0                   
10022bdc  98bf0120    stb r5,0x120(r31)           
10022be0  38c00000    li r6,0x0                   
10022be4  98df0121    stb r6,0x121(r31)           
10022be8  38e00902    li r7,0x902                 
10022bec  b0ff0122    sth r7,0x122(r31)           
10022bf0  3860000e    li r3,0xe                   
10022bf4  4bfff3e1    bl 0x10021fd4                  ; -> 10021fd4
10022bf8  390000a0    li r8,0xa0                  
10022bfc  b11f012c    sth r8,0x12c(r31)           
10022c00  3920012c    li r9,0x12c                 
10022c04  b13f012e    sth r9,0x12e(r31)           
10022c08  39400000    li r10,0x0                  
10022c0c  995f0134    stb r10,0x134(r31)          
10022c10  39600000    li r11,0x0                  
10022c14  997f0135    stb r11,0x135(r31)          
10022c18  39800904    li r12,0x904                
10022c1c  b19f0136    sth r12,0x136(r31)          
10022c20  3860000f    li r3,0xf                   
10022c24  4bfff3b1    bl 0x10021fd4                  ; -> 10021fd4
10022c28  38600124    li r3,0x124                 
10022c2c  b07f0140    sth r3,0x140(r31)           
10022c30  388000fa    li r4,0xfa                  
10022c34  b09f0142    sth r4,0x142(r31)           
10022c38  38a00000    li r5,0x0                   
10022c3c  98bf0148    stb r5,0x148(r31)           
10022c40  38c00000    li r6,0x0                   
10022c44  98df0149    stb r6,0x149(r31)           
10022c48  38e00906    li r7,0x906                 
10022c4c  b0ff014a    sth r7,0x14a(r31)           
10022c50  38600010    li r3,0x10                  
10022c54  4bfff381    bl 0x10021fd4                  ; -> 10021fd4
10022c58  39000186    li r8,0x186                 
10022c5c  b11f0154    sth r8,0x154(r31)           
10022c60  392000fa    li r9,0xfa                  
10022c64  b13f0156    sth r9,0x156(r31)           
10022c68  39400000    li r10,0x0                  
10022c6c  995f015c    stb r10,0x15c(r31)          
10022c70  39600000    li r11,0x0                  
10022c74  997f015d    stb r11,0x15d(r31)          
10022c78  3980090c    li r12,0x90c                
10022c7c  b19f015e    sth r12,0x15e(r31)          
10022c80  38600011    li r3,0x11                  
10022c84  4bfff351    bl 0x10021fd4                  ; -> 10021fd4
10022c88  38624fe5    addi r3,r2,0x4fe5           
10022c8c  88630000    lbz r3,0x0(r3)              
10022c90  28030000    cmplwi r3,0x0               
10022c94  41820010    beq 0x10022ca4                 ; -> 10022ca4
10022c98  38800001    li r4,0x1                   
10022c9c  989f0148    stb r4,0x148(r31)           
10022ca0  4800000c    b 0x10022cac                   ; -> 10022cac
10022ca4  38a00001    li r5,0x1                   
10022ca8  98bf015c    stb r5,0x15c(r31)           
10022cac  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10022cb0  38210040    addi r1,r1,0x40             
10022cb4  7c0803a6    mtspr LR,r0                 
10022cb8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10022cbc  4e800020    blr                         
