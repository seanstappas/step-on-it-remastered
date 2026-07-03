; FUN_1001f400 @ 0x1001f400
1001f400  7c0802a6    mfspr r0,LR                 
1001f404  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001f408  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001f40c  38825260    addi r4,r2,0x5260           
1001f410  38600000    li r3,0x0                   
1001f414  38c251ec    addi r6,r2,0x51ec           
1001f418  98640000    stb r3,0x0(r4)              
1001f41c  38a00000    li r5,0x0                   
1001f420  98a60000    stb r5,0x0(r6)              
1001f424  480000d5    bl 0x1001f4f8                  ; -> 1001f4f8
1001f428  60000000    ori r0,r0,0x0               
1001f42c  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001f430  38210040    addi r1,r1,0x40             
1001f434  7c0803a6    mtspr LR,r0                 
1001f438  4e800020    blr                         
