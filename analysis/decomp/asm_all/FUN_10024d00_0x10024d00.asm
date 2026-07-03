; FUN_10024d00 @ 0x10024d00
10024d00  7c0802a6    mfspr r0,LR                 
10024d04  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10024d08  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10024d0c  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10024d10  7c7f1b78    or r31,r3,r3                
10024d14  7fe30734    extsh r3,r31                
10024d18  2c030000    cmpwi r3,0x0                
10024d1c  4180002c    blt 0x10024d48                 ; -> 10024d48
10024d20  7fe40734    extsh r4,r31                
10024d24  2c040008    cmpwi r4,0x8                
10024d28  40800020    bge 0x10024d48                 ; -> 10024d48
10024d2c  7fe3fb78    or r3,r31,r31               
10024d30  4bff5599    bl 0x1001a2c8                  ; -> 1001a2c8
10024d34  60000000    ori r0,r0,0x0               
10024d38  38600001    li r3,0x1                   
10024d3c  38800064    li r4,0x64                  
10024d40  480062e1    bl 0x1002b020                  ; -> 1002b020
10024d44  60000000    ori r0,r0,0x0               
10024d48  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10024d4c  38210040    addi r1,r1,0x40             
10024d50  7c0803a6    mtspr LR,r0                 
10024d54  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10024d58  4e800020    blr                         
