; FUN_10025c98 @ 0x10025c98
10025c98  7c0802a6    mfspr r0,LR                 
10025c9c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10025ca0  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10025ca4  38600001    li r3,0x1                   
10025ca8  4bffdac9    bl 0x10023770                  ; -> 10023770
10025cac  38600002    li r3,0x2                   
10025cb0  4bffdac1    bl 0x10023770                  ; -> 10023770
10025cb4  38600003    li r3,0x3                   
10025cb8  4bffdab9    bl 0x10023770                  ; -> 10023770
10025cbc  38600004    li r3,0x4                   
10025cc0  4bffdab1    bl 0x10023770                  ; -> 10023770
10025cc4  38600005    li r3,0x5                   
10025cc8  4bffdaa9    bl 0x10023770                  ; -> 10023770
10025ccc  38600006    li r3,0x6                   
10025cd0  4bffdaa1    bl 0x10023770                  ; -> 10023770
10025cd4  38600007    li r3,0x7                   
10025cd8  4bffda99    bl 0x10023770                  ; -> 10023770
10025cdc  38600008    li r3,0x8                   
10025ce0  4bffda91    bl 0x10023770                  ; -> 10023770
10025ce4  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10025ce8  38210040    addi r1,r1,0x40             
10025cec  7c0803a6    mtspr LR,r0                 
10025cf0  4e800020    blr                         
