; FUN_1001f3c0 @ 0x1001f3c0
1001f3c0  7c0802a6    mfspr r0,LR                 
1001f3c4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001f3c8  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001f3cc  38625260    addi r3,r2,0x5260           
1001f3d0  88630000    lbz r3,0x0(r3)              
1001f3d4  28030000    cmplwi r3,0x0               
1001f3d8  41820010    beq 0x1001f3e8                 ; -> 1001f3e8
1001f3dc  480007c9    bl 0x1001fba4                  ; -> 1001fba4
1001f3e0  60000000    ori r0,r0,0x0               
1001f3e4  4800000c    b 0x1001f3f0                   ; -> 1001f3f0
1001f3e8  48000019    bl 0x1001f400                  ; -> 1001f400
1001f3ec  60000000    ori r0,r0,0x0               
1001f3f0  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001f3f4  38210040    addi r1,r1,0x40             
1001f3f8  7c0803a6    mtspr LR,r0                 
1001f3fc  4e800020    blr                         
