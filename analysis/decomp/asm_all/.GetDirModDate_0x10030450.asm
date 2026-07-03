; .GetDirModDate @ 0x10030450
10030450  7c0802a6    mfspr r0,LR                 
10030454  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10030458  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1003045c  9421ff30    stwu r1,-0xd0(r1)              ; -> Stack[-0xd0]
10030460  b06100ea    sth r3,0xea(r1)                ; -> Stack[0x1a]
10030464  908100ec    stw r4,0xec(r1)                ; -> Stack[0x1c]
10030468  38600000    li r3,0x0                   
1003046c  98610038    stb r3,0x38(r1)                ; -> Stack[-0x98]
10030470  38810038    addi r4,r1,0x38             
10030474  9081006a    stw r4,0x6a(r1)                ; -> Stack[-0x66]
10030478  a8a100ea    lha r5,0xea(r1)                ; -> Stack[0x1a]
1003047c  b0a1006e    sth r5,0x6e(r1)                ; -> Stack[-0x62]
10030480  80c100ec    lwz r6,0xec(r1)                ; -> Stack[0x1c]
10030484  90c10088    stw r6,0x88(r1)                ; -> Stack[-0x48]
10030488  38e0ffff    li r7,-0x1                  
1003048c  b0e10074    sth r7,0x74(r1)                ; -> Stack[-0x5c]
10030490  38610058    addi r3,r1,0x58             
10030494  480010d5    bl 0x10031568                  ; -> 10031568
10030498  80410014    lwz r2,0x14(r1)                ; -> Stack[-0xbc]
1003049c  7c630735    extsh. r3,r3                
100304a0  4082000c    bne 0x100304ac                 ; -> 100304ac
100304a4  83e100a4    lwz r31,0xa4(r1)               ; -> Stack[-0x2c]
100304a8  48000008    b 0x100304b0                   ; -> 100304b0
100304ac  3be0ffff    li r31,-0x1                 
100304b0  7fe3fb78    or r3,r31,r31               
100304b4  800100d8    lwz r0,0xd8(r1)                ; -> Stack[0x8]
100304b8  382100d0    addi r1,r1,0xd0             
100304bc  7c0803a6    mtspr LR,r0                 
100304c0  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100304c4  4e800020    blr                         
