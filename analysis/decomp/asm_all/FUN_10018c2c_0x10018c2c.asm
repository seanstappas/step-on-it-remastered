; FUN_10018c2c @ 0x10018c2c
10018c2c  7c0802a6    mfspr r0,LR                 
10018c30  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10018c34  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10018c38  38624ed9    addi r3,r2,0x4ed9           
10018c3c  88630000    lbz r3,0x0(r3)              
10018c40  28030000    cmplwi r3,0x0               
10018c44  41820034    beq 0x10018c78                 ; -> 10018c78
10018c48  38824fe5    addi r4,r2,0x4fe5           
10018c4c  88840000    lbz r4,0x0(r4)              
10018c50  28040000    cmplwi r4,0x0               
10018c54  41820024    beq 0x10018c78                 ; -> 10018c78
10018c58  38a24ede    addi r5,r2,0x4ede           
10018c5c  a8a50000    lha r5,0x0(r5)              
10018c60  2c050000    cmpwi r5,0x0                
10018c64  41820014    beq 0x10018c78                 ; -> 10018c78
10018c68  38600005    li r3,0x5                   
10018c6c  4bfff7a9    bl 0x10018414                  ; -> 10018414
10018c70  38600001    li r3,0x1                   
10018c74  4bfffbb9    bl 0x1001882c                  ; -> 1001882c
10018c78  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10018c7c  38210040    addi r1,r1,0x40             
10018c80  7c0803a6    mtspr LR,r0                 
10018c84  4e800020    blr                         
