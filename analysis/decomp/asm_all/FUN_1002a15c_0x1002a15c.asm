; FUN_1002a15c @ 0x1002a15c
1002a15c  7c0802a6    mfspr r0,LR                 
1002a160  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1002a164  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002a168  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002a16c  38625260    addi r3,r2,0x5260           
1002a170  3be2755c    addi r31,r2,0x755c          
1002a174  88630000    lbz r3,0x0(r3)              
1002a178  3b626840    addi r27,r2,0x6840          
1002a17c  28030000    cmplwi r3,0x0               
1002a180  41820080    beq 0x1002a200                 ; -> 1002a200
1002a184  809f0000    lwz r4,0x0(r31)             
1002a188  38a00000    li r5,0x0                   
1002a18c  38840002    addi r4,r4,0x2              
1002a190  909f0000    stw r4,0x0(r31)             
1002a194  80df0000    lwz r6,0x0(r31)             
1002a198  38e00000    li r7,0x0                   
1002a19c  98a60000    stb r5,0x0(r6)              
1002a1a0  811f0000    lwz r8,0x0(r31)             
1002a1a4  39400001    li r10,0x1                  
1002a1a8  98e80001    stb r7,0x1(r8)              
1002a1ac  813f0000    lwz r9,0x0(r31)             
1002a1b0  39800000    li r12,0x0                  
1002a1b4  39290002    addi r9,r9,0x2              
1002a1b8  913f0000    stw r9,0x0(r31)             
1002a1bc  817f0000    lwz r11,0x0(r31)            
1002a1c0  38a25260    addi r5,r2,0x5260           
1002a1c4  994b0000    stb r10,0x0(r11)            
1002a1c8  807f0000    lwz r3,0x0(r31)             
1002a1cc  38800000    li r4,0x0                   
1002a1d0  99830001    stb r12,0x1(r3)             
1002a1d4  98850000    stb r4,0x0(r5)              
1002a1d8  48006df1    bl 0x10030fc8                  ; -> 10030fc8
1002a1dc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1002a1e0  3ba30078    addi r29,r3,0x78            
1002a1e4  48000008    b 0x1002a1ec                   ; -> 1002a1ec
1002a1e8  3b800000    li r28,0x0                  
1002a1ec  48006ddd    bl 0x10030fc8                  ; -> 10030fc8
1002a1f0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1002a1f4  7c1d1840    cmplw r29,r3                
1002a1f8  4181fff0    bgt 0x1002a1e8                 ; -> 1002a1e8
1002a1fc  480000f8    b 0x1002a2f4                   ; -> 1002a2f4
1002a200  88db008e    lbz r6,0x8e(r27)            
1002a204  3bc00000    li r30,0x0                  
1002a208  28060000    cmplwi r6,0x0               
1002a20c  41820008    beq 0x1002a214                 ; -> 1002a214
1002a210  3bde0002    addi r30,r30,0x2            
1002a214  88fb008f    lbz r7,0x8f(r27)            
1002a218  28070000    cmplwi r7,0x0               
1002a21c  41820008    beq 0x1002a224                 ; -> 1002a224
1002a220  3bde0001    addi r30,r30,0x1            
1002a224  891b0090    lbz r8,0x90(r27)            
1002a228  28080000    cmplwi r8,0x0               
1002a22c  41820008    beq 0x1002a234                 ; -> 1002a234
1002a230  3bde0004    addi r30,r30,0x4            
1002a234  893b0091    lbz r9,0x91(r27)            
1002a238  28090000    cmplwi r9,0x0               
1002a23c  41820008    beq 0x1002a244                 ; -> 1002a244
1002a240  3bde0008    addi r30,r30,0x8            
1002a244  895b0092    lbz r10,0x92(r27)           
1002a248  280a0000    cmplwi r10,0x0              
1002a24c  41820008    beq 0x1002a254                 ; -> 1002a254
1002a250  3bde0010    addi r30,r30,0x10           
1002a254  897b0093    lbz r11,0x93(r27)           
1002a258  280b0000    cmplwi r11,0x0              
1002a25c  41820008    beq 0x1002a264                 ; -> 1002a264
1002a260  3bde0040    addi r30,r30,0x40           
1002a264  899b0094    lbz r12,0x94(r27)           
1002a268  280c0000    cmplwi r12,0x0              
1002a26c  41820008    beq 0x1002a274                 ; -> 1002a274
1002a270  3bde0020    addi r30,r30,0x20           
1002a274  807f0000    lwz r3,0x0(r31)             
1002a278  88630000    lbz r3,0x0(r3)              
1002a27c  280300ff    cmplwi r3,0xff              
1002a280  40820028    bne 0x1002a2a8                 ; -> 1002a2a8
1002a284  809f0000    lwz r4,0x0(r31)             
1002a288  38a00001    li r5,0x1                   
1002a28c  38840002    addi r4,r4,0x2              
1002a290  909f0000    stw r4,0x0(r31)             
1002a294  80df0000    lwz r6,0x0(r31)             
1002a298  98a60000    stb r5,0x0(r6)              
1002a29c  80ff0000    lwz r7,0x0(r31)             
1002a2a0  9bc70001    stb r30,0x1(r7)             
1002a2a4  48000050    b 0x1002a2f4                   ; -> 1002a2f4
1002a2a8  811f0000    lwz r8,0x0(r31)             
1002a2ac  57c9063e    rlwinm r9,r30,0x0,0x18,0x1f 
1002a2b0  89080001    lbz r8,0x1(r8)              
1002a2b4  5508063e    rlwinm r8,r8,0x0,0x18,0x1f  
1002a2b8  7c084840    cmplw r8,r9                 
1002a2bc  40820018    bne 0x1002a2d4                 ; -> 1002a2d4
1002a2c0  815f0000    lwz r10,0x0(r31)            
1002a2c4  896a0000    lbz r11,0x0(r10)            
1002a2c8  396b0001    addi r11,r11,0x1            
1002a2cc  996a0000    stb r11,0x0(r10)            
1002a2d0  48000024    b 0x1002a2f4                   ; -> 1002a2f4
1002a2d4  819f0000    lwz r12,0x0(r31)            
1002a2d8  38600001    li r3,0x1                   
1002a2dc  398c0002    addi r12,r12,0x2            
1002a2e0  919f0000    stw r12,0x0(r31)            
1002a2e4  809f0000    lwz r4,0x0(r31)             
1002a2e8  98640000    stb r3,0x0(r4)              
1002a2ec  80bf0000    lwz r5,0x0(r31)             
1002a2f0  9bc50001    stb r30,0x1(r5)             
1002a2f4  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002a2f8  38210050    addi r1,r1,0x50             
1002a2fc  7c0803a6    mtspr LR,r0                 
1002a300  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1002a304  4e800020    blr                         
