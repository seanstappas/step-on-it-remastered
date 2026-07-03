; FUN_10018b98 @ 0x10018b98
10018b98  7c0802a6    mfspr r0,LR                 
10018b9c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10018ba0  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10018ba4  38624eda    addi r3,r2,0x4eda           
10018ba8  88630000    lbz r3,0x0(r3)              
10018bac  28030000    cmplwi r3,0x0               
10018bb0  41820038    beq 0x10018be8                 ; -> 10018be8
10018bb4  38824ed8    addi r4,r2,0x4ed8           
10018bb8  88840000    lbz r4,0x0(r4)              
10018bbc  28040000    cmplwi r4,0x0               
10018bc0  41820028    beq 0x10018be8                 ; -> 10018be8
10018bc4  38a24ede    addi r5,r2,0x4ede           
10018bc8  a8a50000    lha r5,0x0(r5)              
10018bcc  2c050000    cmpwi r5,0x0                
10018bd0  41820018    beq 0x10018be8                 ; -> 10018be8
10018bd4  38c24ee4    addi r6,r2,0x4ee4           
10018bd8  38800000    li r4,0x0                   
10018bdc  80660000    lwz r3,0x0(r6)              
10018be0  480195a1    bl 0x10032180                  ; -> 10032180
10018be4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
10018be8  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10018bec  38210040    addi r1,r1,0x40             
10018bf0  7c0803a6    mtspr LR,r0                 
10018bf4  4e800020    blr                         
