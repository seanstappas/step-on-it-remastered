; FUN_10018bf8 @ 0x10018bf8
10018bf8  7c0802a6    mfspr r0,LR                 
10018bfc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10018c00  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10018c04  38624ed9    addi r3,r2,0x4ed9           
10018c08  88630000    lbz r3,0x0(r3)              
10018c0c  28030000    cmplwi r3,0x0               
10018c10  4182000c    beq 0x10018c1c                 ; -> 10018c1c
10018c14  38600002    li r3,0x2                   
10018c18  4bfff7fd    bl 0x10018414                  ; -> 10018414
10018c1c  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10018c20  38210040    addi r1,r1,0x40             
10018c24  7c0803a6    mtspr LR,r0                 
10018c28  4e800020    blr                         
