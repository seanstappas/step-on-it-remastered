; FUN_100289c0 @ 0x100289c0
100289c0  7c0802a6    mfspr r0,LR                 
100289c4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100289c8  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100289cc  38627528    addi r3,r2,0x7528           
100289d0  a8830000    lha r4,0x0(r3)              
100289d4  3884ffff    subi r4,r4,0x1              
100289d8  b0830000    sth r4,0x0(r3)              
100289dc  7c840734    extsh r4,r4                 
100289e0  2c040000    cmpwi r4,0x0                
100289e4  40820018    bne 0x100289fc                 ; -> 100289fc
100289e8  38c2752a    addi r6,r2,0x752a           
100289ec  38a00001    li r5,0x1                   
100289f0  98a60000    stb r5,0x0(r6)              
100289f4  4800870d    bl 0x10031100                  ; -> 10031100
100289f8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
100289fc  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10028a00  38210040    addi r1,r1,0x40             
10028a04  7c0803a6    mtspr LR,r0                 
10028a08  4e800020    blr                         
