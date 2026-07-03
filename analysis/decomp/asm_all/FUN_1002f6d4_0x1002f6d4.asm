; FUN_1002f6d4 @ 0x1002f6d4
1002f6d4  7c0802a6    mfspr r0,LR                 
1002f6d8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002f6dc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002f6e0  9421ff40    stwu r1,-0xc0(r1)              ; -> Stack[-0xc0]
1002f6e4  b06100da    sth r3,0xda(r1)                ; -> Stack[0x1a]
1002f6e8  38600000    li r3,0x0                   
1002f6ec  9061004a    stw r3,0x4a(r1)                ; -> Stack[-0x76]
1002f6f0  a88100da    lha r4,0xda(r1)                ; -> Stack[0x1a]
1002f6f4  38a00000    li r5,0x0                   
1002f6f8  b081004e    sth r4,0x4e(r1)                ; -> Stack[-0x72]
1002f6fc  3be00000    li r31,0x0                  
1002f700  b0a10054    sth r5,0x54(r1)                ; -> Stack[-0x6c]
1002f704  38610038    addi r3,r1,0x38             
1002f708  48001d71    bl 0x10031478                  ; -> 10031478
1002f70c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0xac]
1002f710  7c7f1b78    or r31,r3,r3                
1002f714  7fe60734    extsh r6,r31                
1002f718  2c060000    cmpwi r6,0x0                
1002f71c  40820014    bne 0x1002f730                 ; -> 1002f730
1002f720  a0e10076    lhz r7,0x76(r1)                ; -> Stack[-0x4a]
1002f724  81010068    lwz r8,0x68(r1)                ; -> Stack[-0x58]
1002f728  7c6741d6    mullw r3,r7,r8              
1002f72c  48000008    b 0x1002f734                   ; -> 1002f734
1002f730  38600000    li r3,0x0                   
1002f734  800100c8    lwz r0,0xc8(r1)                ; -> Stack[0x8]
1002f738  382100c0    addi r1,r1,0xc0             
1002f73c  7c0803a6    mtspr LR,r0                 
1002f740  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002f744  4e800020    blr                         
