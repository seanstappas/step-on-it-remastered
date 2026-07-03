; FUN_10024b1c @ 0x10024b1c
10024b1c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10024b20  38625260    addi r3,r2,0x5260           
10024b24  3be2539c    addi r31,r2,0x539c          
10024b28  88630000    lbz r3,0x0(r3)              
10024b2c  28030000    cmplwi r3,0x0               
10024b30  41820040    beq 0x10024b70                 ; -> 10024b70
10024b34  809f0240    lwz r4,0x240(r31)           
10024b38  909f0074    stw r4,0x74(r31)            
10024b3c  80bf023c    lwz r5,0x23c(r31)           
10024b40  90bf0070    stw r5,0x70(r31)            
10024b44  a8df0230    lha r6,0x230(r31)           
10024b48  b0df0064    sth r6,0x64(r31)            
10024b4c  a8ff0232    lha r7,0x232(r31)           
10024b50  b0ff0066    sth r7,0x66(r31)            
10024b54  a91f0234    lha r8,0x234(r31)           
10024b58  b11f0068    sth r8,0x68(r31)            
10024b5c  a93f0236    lha r9,0x236(r31)           
10024b60  b13f006a    sth r9,0x6a(r31)            
10024b64  895f0239    lbz r10,0x239(r31)          
10024b68  995f006d    stb r10,0x6d(r31)           
10024b6c  4800003c    b 0x10024ba8                   ; -> 10024ba8
10024b70  817f0254    lwz r11,0x254(r31)          
10024b74  917f0074    stw r11,0x74(r31)           
10024b78  819f0250    lwz r12,0x250(r31)          
10024b7c  919f0070    stw r12,0x70(r31)           
10024b80  a87f0244    lha r3,0x244(r31)           
10024b84  b07f0064    sth r3,0x64(r31)            
10024b88  a89f0246    lha r4,0x246(r31)           
10024b8c  b09f0066    sth r4,0x66(r31)            
10024b90  a8bf0248    lha r5,0x248(r31)           
10024b94  b0bf0068    sth r5,0x68(r31)            
10024b98  a8df024a    lha r6,0x24a(r31)           
10024b9c  b0df006a    sth r6,0x6a(r31)            
10024ba0  88ff024d    lbz r7,0x24d(r31)           
10024ba4  98ff006d    stb r7,0x6d(r31)            
10024ba8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10024bac  4e800020    blr                         
