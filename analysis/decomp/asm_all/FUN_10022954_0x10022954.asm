; FUN_10022954 @ 0x10022954
10022954  7c0802a6    mfspr r0,LR                 
10022958  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002295c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10022960  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10022964  3be2539c    addi r31,r2,0x539c          
10022968  3860019e    li r3,0x19e                 
1002296c  b07f01cc    sth r3,0x1cc(r31)           
10022970  3880013b    li r4,0x13b                 
10022974  b09f01ce    sth r4,0x1ce(r31)           
10022978  38a00000    li r5,0x0                   
1002297c  98bf01d4    stb r5,0x1d4(r31)           
10022980  38c00000    li r6,0x0                   
10022984  98df01d5    stb r6,0x1d5(r31)           
10022988  38e00898    li r7,0x898                 
1002298c  b0ff01d6    sth r7,0x1d6(r31)           
10022990  38600017    li r3,0x17                  
10022994  4bfff641    bl 0x10021fd4                  ; -> 10021fd4
10022998  39000108    li r8,0x108                 
1002299c  b11f01e0    sth r8,0x1e0(r31)           
100229a0  3920013b    li r9,0x13b                 
100229a4  b13f01e2    sth r9,0x1e2(r31)           
100229a8  39400000    li r10,0x0                  
100229ac  995f01e8    stb r10,0x1e8(r31)          
100229b0  39600000    li r11,0x0                  
100229b4  997f01e9    stb r11,0x1e9(r31)          
100229b8  3980089a    li r12,0x89a                
100229bc  b19f01ea    sth r12,0x1ea(r31)          
100229c0  38600018    li r3,0x18                  
100229c4  4bfff611    bl 0x10021fd4                  ; -> 10021fd4
100229c8  38600108    li r3,0x108                 
100229cc  b07f01f4    sth r3,0x1f4(r31)           
100229d0  3880013b    li r4,0x13b                 
100229d4  b09f01f6    sth r4,0x1f6(r31)           
100229d8  38a00000    li r5,0x0                   
100229dc  98bf01fc    stb r5,0x1fc(r31)           
100229e0  38c00000    li r6,0x0                   
100229e4  98df01fd    stb r6,0x1fd(r31)           
100229e8  38e008a0    li r7,0x8a0                 
100229ec  b0ff01fe    sth r7,0x1fe(r31)           
100229f0  38600019    li r3,0x19                  
100229f4  4bfff5e1    bl 0x10021fd4                  ; -> 10021fd4
100229f8  39000153    li r8,0x153                 
100229fc  b11f0258    sth r8,0x258(r31)           
10022a00  3920013b    li r9,0x13b                 
10022a04  b13f025a    sth r9,0x25a(r31)           
10022a08  39400000    li r10,0x0                  
10022a0c  995f0260    stb r10,0x260(r31)          
10022a10  39600000    li r11,0x0                  
10022a14  997f0261    stb r11,0x261(r31)          
10022a18  3980089c    li r12,0x89c                
10022a1c  b19f0262    sth r12,0x262(r31)          
10022a20  3860001e    li r3,0x1e                  
10022a24  4bfff5b1    bl 0x10021fd4                  ; -> 10021fd4
10022a28  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10022a2c  38210040    addi r1,r1,0x40             
10022a30  7c0803a6    mtspr LR,r0                 
10022a34  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10022a38  4e800020    blr                         
