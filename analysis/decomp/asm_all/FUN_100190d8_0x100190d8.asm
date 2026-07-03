; FUN_100190d8 @ 0x100190d8
100190d8  7c0802a6    mfspr r0,LR                 
100190dc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100190e0  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100190e4  b061005a    sth r3,0x5a(r1)                ; -> Stack[0x1a]
100190e8  38624ed9    addi r3,r2,0x4ed9           
100190ec  88630000    lbz r3,0x0(r3)              
100190f0  28030000    cmplwi r3,0x0               
100190f4  41820038    beq 0x1001912c                 ; -> 1001912c
100190f8  a881005a    lha r4,0x5a(r1)                ; -> Stack[0x1a]
100190fc  38a24edc    addi r5,r2,0x4edc           
10019100  38c24ede    addi r6,r2,0x4ede           
10019104  b0850000    sth r4,0x0(r5)              
10019108  a8c60000    lha r6,0x0(r6)              
1001910c  2c060000    cmpwi r6,0x0                
10019110  4182001c    beq 0x1001912c                 ; -> 1001912c
10019114  38e24ee4    addi r7,r2,0x4ee4           
10019118  39024edc    addi r8,r2,0x4edc           
1001911c  80670000    lwz r3,0x0(r7)              
10019120  a8880000    lha r4,0x0(r8)              
10019124  480189b5    bl 0x10031ad8                  ; -> 10031ad8
10019128  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1001912c  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10019130  38210040    addi r1,r1,0x40             
10019134  7c0803a6    mtspr LR,r0                 
10019138  4e800020    blr                         
