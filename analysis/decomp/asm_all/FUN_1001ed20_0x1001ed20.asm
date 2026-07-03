; FUN_1001ed20 @ 0x1001ed20
1001ed20  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001ed24  28030000    cmplwi r3,0x0               
1001ed28  4082000c    bne 0x1001ed34                 ; -> 1001ed34
1001ed2c  38600000    li r3,0x0                   
1001ed30  4800002c    b 0x1001ed5c                   ; -> 1001ed5c
1001ed34  abe3006c    lha r31,0x6c(r3)            
1001ed38  38800000    li r4,0x0                   
1001ed3c  7fe50734    extsh r5,r31                
1001ed40  2c050008    cmpwi r5,0x8                
1001ed44  40800010    bge 0x1001ed54                 ; -> 1001ed54
1001ed48  7fe60734    extsh r6,r31                
1001ed4c  2c060002    cmpwi r6,0x2                
1001ed50  40820008    bne 0x1001ed58                 ; -> 1001ed58
1001ed54  38800001    li r4,0x1                   
1001ed58  7c832378    or r3,r4,r4                 
1001ed5c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001ed60  4e800020    blr                         
