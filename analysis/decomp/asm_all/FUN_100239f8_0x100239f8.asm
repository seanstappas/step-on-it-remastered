; FUN_100239f8 @ 0x100239f8
100239f8  7c0802a6    mfspr r0,LR                 
100239fc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10023a00  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10023a04  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10023a08  7c7f1b78    or r31,r3,r3                
10023a0c  7fe40734    extsh r4,r31                
10023a10  3862539c    addi r3,r2,0x539c           
10023a14  1c840014    mulli r4,r4,0x14            
10023a18  38630008    addi r3,r3,0x8              
10023a1c  7c6320ae    lbzx r3,r3,r4               
10023a20  28030000    cmplwi r3,0x0               
10023a24  4082002c    bne 0x10023a50                 ; -> 10023a50
10023a28  7fe70734    extsh r7,r31                
10023a2c  38c2539c    addi r6,r2,0x539c           
10023a30  1ce70014    mulli r7,r7,0x14            
10023a34  38a00001    li r5,0x1                   
10023a38  38c60008    addi r6,r6,0x8              
10023a3c  7ca639ae    stbx r5,r6,r7               
10023a40  7fe3fb78    or r3,r31,r31               
10023a44  4bfffe71    bl 0x100238b4                  ; -> 100238b4
10023a48  7fe3fb78    or r3,r31,r31               
10023a4c  4bfffd25    bl 0x10023770                  ; -> 10023770
10023a50  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10023a54  38210040    addi r1,r1,0x40             
10023a58  7c0803a6    mtspr LR,r0                 
10023a5c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10023a60  4e800020    blr                         
