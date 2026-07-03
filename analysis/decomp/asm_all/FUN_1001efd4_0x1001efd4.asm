; FUN_1001efd4 @ 0x1001efd4
1001efd4  7c0802a6    mfspr r0,LR                 
1001efd8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001efdc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001efe0  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001efe4  90610058    stw r3,0x58(r1)                ; -> Stack[0x18]
1001efe8  80610058    lwz r3,0x58(r1)                ; -> Stack[0x18]
1001efec  8063000a    lwz r3,0xa(r3)              
1001eff0  48003321    bl 0x10022310                  ; -> 10022310
1001eff4  60000000    ori r0,r0,0x0               
1001eff8  7c7f1b78    or r31,r3,r3                
1001effc  7fe40734    extsh r4,r31                
1001f000  2c040000    cmpwi r4,0x0                
1001f004  41820010    beq 0x1001f014                 ; -> 1001f014
1001f008  7fe3fb78    or r3,r31,r31               
1001f00c  4800001d    bl 0x1001f028                  ; -> 1001f028
1001f010  60000000    ori r0,r0,0x0               
1001f014  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001f018  38210040    addi r1,r1,0x40             
1001f01c  7c0803a6    mtspr LR,r0                 
1001f020  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001f024  4e800020    blr                         
