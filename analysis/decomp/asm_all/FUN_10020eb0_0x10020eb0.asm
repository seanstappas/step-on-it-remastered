; FUN_10020eb0 @ 0x10020eb0
10020eb0  7c0802a6    mfspr r0,LR                 
10020eb4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10020eb8  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10020ebc  38625260    addi r3,r2,0x5260           
10020ec0  88630000    lbz r3,0x0(r3)              
10020ec4  28030000    cmplwi r3,0x0               
10020ec8  41820028    beq 0x10020ef0                 ; -> 10020ef0
10020ecc  388252dd    addi r4,r2,0x52dd           
10020ed0  88840000    lbz r4,0x0(r4)              
10020ed4  28040000    cmplwi r4,0x0               
10020ed8  40820010    bne 0x10020ee8                 ; -> 10020ee8
10020edc  480002a1    bl 0x1002117c                  ; -> 1002117c
10020ee0  60000000    ori r0,r0,0x0               
10020ee4  4800000c    b 0x10020ef0                   ; -> 10020ef0
10020ee8  48000111    bl 0x10020ff8                  ; -> 10020ff8
10020eec  60000000    ori r0,r0,0x0               
10020ef0  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10020ef4  38210040    addi r1,r1,0x40             
10020ef8  7c0803a6    mtspr LR,r0                 
10020efc  4e800020    blr                         
