; FUN_10004580 @ 0x10004580
10004580  7c0802a6    mfspr r0,LR                 
10004584  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10004588  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1000458c  38600000    li r3,0x0                   
10004590  b0610038    sth r3,0x38(r1)                ; -> Stack[-0x8]
10004594  38800000    li r4,0x0                   
10004598  b081003a    sth r4,0x3a(r1)                ; -> Stack[-0x6]
1000459c  38a0027f    li r5,0x27f                 
100045a0  b0a1003e    sth r5,0x3e(r1)                ; -> Stack[-0x2]
100045a4  38c001df    li r6,0x1df                 
100045a8  38e26bd4    addi r7,r2,0x6bd4           
100045ac  b0c1003c    sth r6,0x3c(r1)                ; -> Stack[-0x4]
100045b0  39026bd0    addi r8,r2,0x6bd0           
100045b4  39226bdc    addi r9,r2,0x6bdc           
100045b8  80870000    lwz r4,0x0(r7)              
100045bc  39426bd8    addi r10,r2,0x6bd8          
100045c0  a8a80000    lha r5,0x0(r8)              
100045c4  80c90000    lwz r6,0x0(r9)              
100045c8  80ea0000    lwz r7,0x0(r10)             
100045cc  38610038    addi r3,r1,0x38             
100045d0  4bffd2cd    bl 0x1000189c                  ; -> 1000189c
100045d4  60000000    ori r0,r0,0x0               
100045d8  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
100045dc  38210040    addi r1,r1,0x40             
100045e0  7c0803a6    mtspr LR,r0                 
100045e4  4e800020    blr                         
