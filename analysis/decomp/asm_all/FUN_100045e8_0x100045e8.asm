; FUN_100045e8 @ 0x100045e8
100045e8  7c0802a6    mfspr r0,LR                 
100045ec  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100045f0  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100045f4  38600000    li r3,0x0                   
100045f8  b0610038    sth r3,0x38(r1)                ; -> Stack[-0x8]
100045fc  38800000    li r4,0x0                   
10004600  b081003a    sth r4,0x3a(r1)                ; -> Stack[-0x6]
10004604  38a0027f    li r5,0x27f                 
10004608  b0a1003e    sth r5,0x3e(r1)                ; -> Stack[-0x2]
1000460c  38c001df    li r6,0x1df                 
10004610  38e270e8    addi r7,r2,0x70e8           
10004614  b0c1003c    sth r6,0x3c(r1)                ; -> Stack[-0x4]
10004618  390270e4    addi r8,r2,0x70e4           
1000461c  39226bdc    addi r9,r2,0x6bdc           
10004620  80870000    lwz r4,0x0(r7)              
10004624  39426bd8    addi r10,r2,0x6bd8          
10004628  80a80000    lwz r5,0x0(r8)              
1000462c  80c90000    lwz r6,0x0(r9)              
10004630  80ea0000    lwz r7,0x0(r10)             
10004634  38610038    addi r3,r1,0x38             
10004638  4bffd265    bl 0x1000189c                  ; -> 1000189c
1000463c  60000000    ori r0,r0,0x0               
10004640  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10004644  38210040    addi r1,r1,0x40             
10004648  7c0803a6    mtspr LR,r0                 
1000464c  4e800020    blr                         
