; FUN_1002707c @ 0x1002707c
1002707c  7c0802a6    mfspr r0,LR                 
10027080  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10027084  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10027088  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1002708c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10027090  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10027094  38827534    addi r4,r2,0x7534           
10027098  3ba2757c    addi r29,r2,0x757c          
1002709c  80640000    lwz r3,0x0(r4)              
100270a0  4800a121    bl 0x100311c0                  ; -> 100311c0
100270a4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
100270a8  38a27130    addi r5,r2,0x7130           
100270ac  39400000    li r10,0x0                  
100270b0  80a50000    lwz r5,0x0(r5)              
100270b4  38600000    li r3,0x0                   
100270b8  80a50000    lwz r5,0x0(r5)              
100270bc  80c50002    lwz r6,0x2(r5)              
100270c0  80e50006    lwz r7,0x6(r5)              
100270c4  90c10040    stw r6,0x40(r1)                ; -> Stack[-0x20]
100270c8  90e10044    stw r7,0x44(r1)                ; -> Stack[-0x1c]
100270cc  a9010040    lha r8,0x40(r1)                ; -> Stack[-0x20]
100270d0  a9210044    lha r9,0x44(r1)                ; -> Stack[-0x1c]
100270d4  7d284850    subf r9,r8,r9               
100270d8  b1210044    sth r9,0x44(r1)                ; -> Stack[-0x1c]
100270dc  b1410040    sth r10,0x40(r1)               ; -> Stack[-0x20]
100270e0  a9610042    lha r11,0x42(r1)               ; -> Stack[-0x1e]
100270e4  a9810046    lha r12,0x46(r1)               ; -> Stack[-0x1a]
100270e8  7d8b6050    subf r12,r11,r12            
100270ec  b1810046    sth r12,0x46(r1)               ; -> Stack[-0x1a]
100270f0  b0610042    sth r3,0x42(r1)                ; -> Stack[-0x1e]
100270f4  a8bd0006    lha r5,0x6(r29)             
100270f8  a8dd0002    lha r6,0x2(r29)             
100270fc  a8810046    lha r4,0x46(r1)                ; -> Stack[-0x1a]
10027100  7ca53214    add r5,r5,r6                
10027104  7c842850    subf r4,r4,r5               
10027108  7c840e70    srawi r4,r4,0x1             
1002710c  7c840194    addze r4,r4                 
10027110  b081003a    sth r4,0x3a(r1)                ; -> Stack[-0x26]
10027114  a8e1003a    lha r7,0x3a(r1)                ; -> Stack[-0x26]
10027118  a9010046    lha r8,0x46(r1)                ; -> Stack[-0x1a]
1002711c  a9210044    lha r9,0x44(r1)                ; -> Stack[-0x1c]
10027120  7ce74214    add r7,r7,r8                
10027124  b0e1003e    sth r7,0x3e(r1)                ; -> Stack[-0x22]
10027128  a95d0000    lha r10,0x0(r29)            
1002712c  a97d0004    lha r11,0x4(r29)            
10027130  a8610044    lha r3,0x44(r1)                ; -> Stack[-0x1c]
10027134  7d4a5a14    add r10,r10,r11             
10027138  7d295050    subf r9,r9,r10              
1002713c  7d290e70    srawi r9,r9,0x1             
10027140  7d290194    addze r9,r9                 
10027144  39290010    addi r9,r9,0x10             
10027148  b1210038    sth r9,0x38(r1)                ; -> Stack[-0x28]
1002714c  a9810038    lha r12,0x38(r1)               ; -> Stack[-0x28]
10027150  38827130    addi r4,r2,0x7130           
10027154  7d8c1a14    add r12,r12,r3              
10027158  b181003c    sth r12,0x3c(r1)               ; -> Stack[-0x24]
1002715c  80640000    lwz r3,0x0(r4)              
10027160  38810038    addi r4,r1,0x38             
10027164  4800aa7d    bl 0x10031be0                  ; -> 10031be0
10027168  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002716c  48009e5d    bl 0x10030fc8                  ; -> 10030fc8
10027170  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10027174  3be300b4    addi r31,r3,0xb4            
10027178  48000008    b 0x10027180                   ; -> 10027180
1002717c  3bc00000    li r30,0x0                  
10027180  48009e49    bl 0x10030fc8                  ; -> 10030fc8
10027184  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10027188  7c1f1840    cmplw r31,r3                
1002718c  4181fff0    bgt 0x1002717c                 ; -> 1002717c
10027190  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10027194  38210060    addi r1,r1,0x60             
10027198  7c0803a6    mtspr LR,r0                 
1002719c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100271a0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100271a4  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100271a8  4e800020    blr                         
