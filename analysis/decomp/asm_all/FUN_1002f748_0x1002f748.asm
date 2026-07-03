; FUN_1002f748 @ 0x1002f748
1002f748  7c0802a6    mfspr r0,LR                 
1002f74c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002f750  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002f754  9421ff40    stwu r1,-0xc0(r1)              ; -> Stack[-0xc0]
1002f758  b06100da    sth r3,0xda(r1)                ; -> Stack[0x1a]
1002f75c  38600000    li r3,0x0                   
1002f760  9061004a    stw r3,0x4a(r1)                ; -> Stack[-0x76]
1002f764  a88100da    lha r4,0xda(r1)                ; -> Stack[0x1a]
1002f768  38a00000    li r5,0x0                   
1002f76c  b081004e    sth r4,0x4e(r1)                ; -> Stack[-0x72]
1002f770  3be00000    li r31,0x0                  
1002f774  b0a10054    sth r5,0x54(r1)                ; -> Stack[-0x6c]
1002f778  38610038    addi r3,r1,0x38             
1002f77c  48001cfd    bl 0x10031478                  ; -> 10031478
1002f780  80410014    lwz r2,0x14(r1)                ; -> Stack[-0xac]
1002f784  7c7f1b78    or r31,r3,r3                
1002f788  7fe60734    extsh r6,r31                
1002f78c  2c060000    cmpwi r6,0x0                
1002f790  4082000c    bne 0x1002f79c                 ; -> 1002f79c
1002f794  80610068    lwz r3,0x68(r1)                ; -> Stack[-0x58]
1002f798  48000008    b 0x1002f7a0                   ; -> 1002f7a0
1002f79c  38600000    li r3,0x0                   
1002f7a0  800100c8    lwz r0,0xc8(r1)                ; -> Stack[0x8]
1002f7a4  382100c0    addi r1,r1,0xc0             
1002f7a8  7c0803a6    mtspr LR,r0                 
1002f7ac  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002f7b0  4e800020    blr                         
