; FUN_1002edf0 @ 0x1002edf0
1002edf0  7c0802a6    mfspr r0,LR                 
1002edf4  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
1002edf8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002edfc  9421fea0    stwu r1,-0x160(r1)             ; -> Stack[-0x160]
1002ee00  7c7a1b78    or r26,r3,r3                
1002ee04  7c9b2378    or r27,r4,r4                
1002ee08  7cbd2b78    or r29,r5,r5                
1002ee0c  7cde3378    or r30,r6,r6                
1002ee10  7f430734    extsh r3,r26                
1002ee14  2c03ffff    cmpwi r3,-0x1               
1002ee18  3be00000    li r31,0x0                  
1002ee1c  4182010c    beq 0x1002ef28                 ; -> 1002ef28
1002ee20  281e0000    cmplwi r30,0x0              
1002ee24  41820104    beq 0x1002ef28                 ; -> 1002ef28
1002ee28  48002141    bl 0x10030f68                  ; -> 10030f68
1002ee2c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x14c]
1002ee30  7c7c1b78    or r28,r3,r3                
1002ee34  7f43d378    or r3,r26,r26               
1002ee38  48002851    bl 0x10031688                  ; -> 10031688
1002ee3c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x14c]
1002ee40  480027e9    bl 0x10031628                  ; -> 10031628
1002ee44  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x14c]
1002ee48  7c7f1b78    or r31,r3,r3                
1002ee4c  7fe40734    extsh r4,r31                
1002ee50  2c040000    cmpwi r4,0x0                
1002ee54  408200d0    bne 0x1002ef24                 ; -> 1002ef24
1002ee58  281d0000    cmplwi r29,0x0              
1002ee5c  41820028    beq 0x1002ee84                 ; -> 1002ee84
1002ee60  a8bd0000    lha r5,0x0(r29)             
1002ee64  2c050000    cmpwi r5,0x0                
1002ee68  4182001c    beq 0x1002ee84                 ; -> 1002ee84
1002ee6c  7f63db78    or r3,r27,r27               
1002ee70  a89d0000    lha r4,0x0(r29)             
1002ee74  4800285d    bl 0x100316d0                  ; -> 100316d0
1002ee78  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x14c]
1002ee7c  907e0000    stw r3,0x0(r30)             
1002ee80  48000044    b 0x1002eec4                   ; -> 1002eec4
1002ee84  7f63db78    or r3,r27,r27               
1002ee88  38800001    li r4,0x1                   
1002ee8c  48002935    bl 0x100317c0                  ; -> 100317c0
1002ee90  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x14c]
1002ee94  907e0000    stw r3,0x0(r30)             
1002ee98  80de0000    lwz r6,0x0(r30)             
1002ee9c  28060000    cmplwi r6,0x0               
1002eea0  41820024    beq 0x1002eec4                 ; -> 1002eec4
1002eea4  281d0000    cmplwi r29,0x0              
1002eea8  4182001c    beq 0x1002eec4                 ; -> 1002eec4
1002eeac  807e0000    lwz r3,0x0(r30)             
1002eeb0  7fa4eb78    or r4,r29,r29               
1002eeb4  38a10038    addi r5,r1,0x38             
1002eeb8  38c1003c    addi r6,r1,0x3c             
1002eebc  4800291d    bl 0x100317d8                  ; -> 100317d8
1002eec0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x14c]
1002eec4  48002765    bl 0x10031628                  ; -> 10031628
1002eec8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x14c]
1002eecc  7c7f1b78    or r31,r3,r3                
1002eed0  7fe70734    extsh r7,r31                
1002eed4  2c070000    cmpwi r7,0x0                
1002eed8  4082002c    bne 0x1002ef04                 ; -> 1002ef04
1002eedc  811e0000    lwz r8,0x0(r30)             
1002eee0  28080000    cmplwi r8,0x0               
1002eee4  41820020    beq 0x1002ef04                 ; -> 1002ef04
1002eee8  807e0000    lwz r3,0x0(r30)             
1002eeec  48002905    bl 0x100317f0                  ; -> 100317f0
1002eef0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x14c]
1002eef4  48002735    bl 0x10031628                  ; -> 10031628
1002eef8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x14c]
1002eefc  7c7f1b78    or r31,r3,r3                
1002ef00  48000008    b 0x1002ef08                   ; -> 1002ef08
1002ef04  3be0ff40    li r31,-0xc0                
1002ef08  7f83e378    or r3,r28,r28               
1002ef0c  4800277d    bl 0x10031688                  ; -> 10031688
1002ef10  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x14c]
1002ef14  48002715    bl 0x10031628                  ; -> 10031628
1002ef18  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x14c]
1002ef1c  7c7f1b78    or r31,r3,r3                
1002ef20  4800000c    b 0x1002ef2c                   ; -> 1002ef2c
1002ef24  48000008    b 0x1002ef2c                   ; -> 1002ef2c
1002ef28  3be0ffce    li r31,-0x32                
1002ef2c  7fe3fb78    or r3,r31,r31               
1002ef30  80010168    lwz r0,0x168(r1)               ; -> Stack[0x8]
1002ef34  38210160    addi r1,r1,0x160            
1002ef38  7c0803a6    mtspr LR,r0                 
1002ef3c  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
1002ef40  4e800020    blr                         
