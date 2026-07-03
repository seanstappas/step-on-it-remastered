; FUN_1002eacc @ 0x1002eacc
1002eacc  7c0802a6    mfspr r0,LR                 
1002ead0  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002ead4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002ead8  9421ff70    stwu r1,-0x90(r1)              ; -> Stack[-0x90]
1002eadc  906100a8    stw r3,0xa8(r1)                ; -> Stack[0x18]
1002eae0  908100ac    stw r4,0xac(r1)                ; -> Stack[0x1c]
1002eae4  806100a8    lwz r3,0xa8(r1)                ; -> Stack[0x18]
1002eae8  808100ac    lwz r4,0xac(r1)                ; -> Stack[0x1c]
1002eaec  38a10038    addi r5,r1,0x38             
1002eaf0  48000849    bl 0x1002f338                  ; -> 1002f338
1002eaf4  7c7f1b78    or r31,r3,r3                
1002eaf8  7fe30734    extsh r3,r31                
1002eafc  2c030000    cmpwi r3,0x0                
1002eb00  40820014    bne 0x1002eb14                 ; -> 1002eb14
1002eb04  38610038    addi r3,r1,0x38             
1002eb08  48001081    bl 0x1002fb88                  ; -> 1002fb88
1002eb0c  60000000    ori r0,r0,0x0               
1002eb10  7c7f1b78    or r31,r3,r3                
1002eb14  7fe3fb78    or r3,r31,r31               
1002eb18  80010098    lwz r0,0x98(r1)                ; -> Stack[0x8]
1002eb1c  38210090    addi r1,r1,0x90             
1002eb20  7c0803a6    mtspr LR,r0                 
1002eb24  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002eb28  4e800020    blr                         
