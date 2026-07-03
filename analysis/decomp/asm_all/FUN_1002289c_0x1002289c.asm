; FUN_1002289c @ 0x1002289c
1002289c  7c0802a6    mfspr r0,LR                 
100228a0  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100228a4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100228a8  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100228ac  3be2539c    addi r31,r2,0x539c          
100228b0  3860019e    li r3,0x19e                 
100228b4  b07f0190    sth r3,0x190(r31)           
100228b8  3880013a    li r4,0x13a                 
100228bc  b09f0192    sth r4,0x192(r31)           
100228c0  38a00000    li r5,0x0                   
100228c4  98bf0198    stb r5,0x198(r31)           
100228c8  38c00000    li r6,0x0                   
100228cc  98df0199    stb r6,0x199(r31)           
100228d0  38e00898    li r7,0x898                 
100228d4  b0ff019a    sth r7,0x19a(r31)           
100228d8  38600014    li r3,0x14                  
100228dc  4bfff6f9    bl 0x10021fd4                  ; -> 10021fd4
100228e0  39000153    li r8,0x153                 
100228e4  b11f01a4    sth r8,0x1a4(r31)           
100228e8  3920013a    li r9,0x13a                 
100228ec  b13f01a6    sth r9,0x1a6(r31)           
100228f0  39400000    li r10,0x0                  
100228f4  995f01ac    stb r10,0x1ac(r31)          
100228f8  39600000    li r11,0x0                  
100228fc  997f01ad    stb r11,0x1ad(r31)          
10022900  3980089c    li r12,0x89c                
10022904  b19f01ae    sth r12,0x1ae(r31)          
10022908  38600015    li r3,0x15                  
1002290c  4bfff6c9    bl 0x10021fd4                  ; -> 10021fd4
10022910  38600108    li r3,0x108                 
10022914  b07f01b8    sth r3,0x1b8(r31)           
10022918  3880013a    li r4,0x13a                 
1002291c  b09f01ba    sth r4,0x1ba(r31)           
10022920  38a00000    li r5,0x0                   
10022924  98bf01c0    stb r5,0x1c0(r31)           
10022928  38c00000    li r6,0x0                   
1002292c  98df01c1    stb r6,0x1c1(r31)           
10022930  38e0089e    li r7,0x89e                 
10022934  b0ff01c2    sth r7,0x1c2(r31)           
10022938  38600016    li r3,0x16                  
1002293c  4bfff699    bl 0x10021fd4                  ; -> 10021fd4
10022940  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10022944  38210040    addi r1,r1,0x40             
10022948  7c0803a6    mtspr LR,r0                 
1002294c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10022950  4e800020    blr                         
