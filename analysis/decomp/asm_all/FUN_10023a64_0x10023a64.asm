; FUN_10023a64 @ 0x10023a64
10023a64  7c0802a6    mfspr r0,LR                 
10023a68  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10023a6c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10023a70  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10023a74  7c7f1b78    or r31,r3,r3                
10023a78  7fe40734    extsh r4,r31                
10023a7c  3862539c    addi r3,r2,0x539c           
10023a80  1c840014    mulli r4,r4,0x14            
10023a84  38630008    addi r3,r3,0x8              
10023a88  7c6320ae    lbzx r3,r3,r4               
10023a8c  28030000    cmplwi r3,0x0               
10023a90  4182002c    beq 0x10023abc                 ; -> 10023abc
10023a94  7fe70734    extsh r7,r31                
10023a98  38c2539c    addi r6,r2,0x539c           
10023a9c  1ce70014    mulli r7,r7,0x14            
10023aa0  38a00000    li r5,0x0                   
10023aa4  38c60008    addi r6,r6,0x8              
10023aa8  7ca639ae    stbx r5,r6,r7               
10023aac  7fe3fb78    or r3,r31,r31               
10023ab0  4bfffe05    bl 0x100238b4                  ; -> 100238b4
10023ab4  7fe3fb78    or r3,r31,r31               
10023ab8  4bfffcb9    bl 0x10023770                  ; -> 10023770
10023abc  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10023ac0  38210040    addi r1,r1,0x40             
10023ac4  7c0803a6    mtspr LR,r0                 
10023ac8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10023acc  4e800020    blr                         
