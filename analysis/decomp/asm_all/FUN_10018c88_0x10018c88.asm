; FUN_10018c88 @ 0x10018c88
10018c88  7c0802a6    mfspr r0,LR                 
10018c8c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10018c90  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10018c94  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10018c98  b061005a    sth r3,0x5a(r1)                ; -> Stack[0x1a]
10018c9c  38624ed9    addi r3,r2,0x4ed9           
10018ca0  88630000    lbz r3,0x0(r3)              
10018ca4  28030000    cmplwi r3,0x0               
10018ca8  4182004c    beq 0x10018cf4                 ; -> 10018cf4
10018cac  38824fe5    addi r4,r2,0x4fe5           
10018cb0  88840000    lbz r4,0x0(r4)              
10018cb4  28040000    cmplwi r4,0x0               
10018cb8  4182003c    beq 0x10018cf4                 ; -> 10018cf4
10018cbc  38a26b9e    addi r5,r2,0x6b9e           
10018cc0  88a50000    lbz r5,0x0(r5)              
10018cc4  28050000    cmplwi r5,0x0               
10018cc8  4182000c    beq 0x10018cd4                 ; -> 10018cd4
10018ccc  3be00004    li r31,0x4                  
10018cd0  4800001c    b 0x10018cec                   ; -> 10018cec
10018cd4  a8c1005a    lha r6,0x5a(r1)                ; -> Stack[0x1a]
10018cd8  38e00003    li r7,0x3                   
10018cdc  7d063bd6    divw r8,r6,r7               
10018ce0  7d0839d6    mullw r8,r8,r7              
10018ce4  7d083050    subf r8,r8,r6               
10018ce8  3be80001    addi r31,r8,0x1             
10018cec  7fe3fb78    or r3,r31,r31               
10018cf0  4bfff725    bl 0x10018414                  ; -> 10018414
10018cf4  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10018cf8  38210040    addi r1,r1,0x40             
10018cfc  7c0803a6    mtspr LR,r0                 
10018d00  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10018d04  4e800020    blr                         
