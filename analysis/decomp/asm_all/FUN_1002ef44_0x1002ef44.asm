; FUN_1002ef44 @ 0x1002ef44
1002ef44  7c0802a6    mfspr r0,LR                 
1002ef48  be61ffcc    stmw r19,-0x34(r1)             ; -> Stack[-0x34]
1002ef4c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002ef50  9421ff80    stwu r1,-0x80(r1)              ; -> Stack[-0x80]
1002ef54  7c7c1b78    or r28,r3,r3                
1002ef58  7c992378    or r25,r4,r4                
1002ef5c  7cbe2b78    or r30,r5,r5                
1002ef60  7cd43378    or r20,r6,r6                
1002ef64  7f830734    extsh r3,r28                
1002ef68  2c03ffff    cmpwi r3,-0x1               
1002ef6c  3be00000    li r31,0x0                  
1002ef70  4182023c    beq 0x1002f1ac                 ; -> 1002f1ac
1002ef74  28140000    cmplwi r20,0x0              
1002ef78  41820234    beq 0x1002f1ac                 ; -> 1002f1ac
1002ef7c  92810038    stw r20,0x38(r1)               ; -> Stack[-0x48]
1002ef80  38610038    addi r3,r1,0x38             
1002ef84  4800205d    bl 0x10030fe0                  ; -> 10030fe0
1002ef88  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002ef8c  7c7f1b78    or r31,r3,r3                
1002ef90  7fe40734    extsh r4,r31                
1002ef94  2c040000    cmpwi r4,0x0                
1002ef98  40820210    bne 0x1002f1a8                 ; -> 1002f1a8
1002ef9c  3ba00000    li r29,0x0                  
1002efa0  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x48]
1002efa4  480025ad    bl 0x10031550                  ; -> 10031550
1002efa8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002efac  7c7b1b78    or r27,r3,r3                
1002efb0  7f78db78    or r24,r27,r27              
1002efb4  7f83e378    or r3,r28,r28               
1002efb8  48000689    bl 0x1002f640                  ; -> 1002f640
1002efbc  7c761b78    or r22,r3,r3                
1002efc0  48001fa9    bl 0x10030f68                  ; -> 10030f68
1002efc4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002efc8  7c751b78    or r21,r3,r3                
1002efcc  7ec3b378    or r3,r22,r22               
1002efd0  48000705    bl 0x1002f6d4                  ; -> 1002f6d4
1002efd4  7c771b78    or r23,r3,r3                
1002efd8  7f83e378    or r3,r28,r28               
1002efdc  480026ad    bl 0x10031688                  ; -> 10031688
1002efe0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002efe4  48002645    bl 0x10031628                  ; -> 10031628
1002efe8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002efec  7c7f1b78    or r31,r3,r3                
1002eff0  7fe50734    extsh r5,r31                
1002eff4  2c050000    cmpwi r5,0x0                
1002eff8  408201ac    bne 0x1002f1a4                 ; -> 1002f1a4
1002effc  281e0000    cmplwi r30,0x0              
1002f000  41820024    beq 0x1002f024                 ; -> 1002f024
1002f004  a8de0000    lha r6,0x0(r30)             
1002f008  2c060000    cmpwi r6,0x0                
1002f00c  41820018    beq 0x1002f024                 ; -> 1002f024
1002f010  7f23cb78    or r3,r25,r25               
1002f014  a89e0000    lha r4,0x0(r30)             
1002f018  480026b9    bl 0x100316d0                  ; -> 100316d0
1002f01c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f020  7c7d1b78    or r29,r3,r3                
1002f024  281d0000    cmplwi r29,0x0              
1002f028  4182009c    beq 0x1002f0c4                 ; -> 1002f0c4
1002f02c  7fa3eb78    or r3,r29,r29               
1002f030  48002521    bl 0x10031550                  ; -> 10031550
1002f034  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f038  7c781b78    or r24,r3,r3                
1002f03c  7c1bc000    cmpw r27,r24                
1002f040  4081002c    ble 0x1002f06c                 ; -> 1002f06c
1002f044  7f83e378    or r3,r28,r28               
1002f048  480005f9    bl 0x1002f640                  ; -> 1002f640
1002f04c  7c731b78    or r19,r3,r3                
1002f050  7e639b78    or r3,r19,r19               
1002f054  480006f5    bl 0x1002f748                  ; -> 1002f748
1002f058  7c7b1a14    add r3,r27,r3               
1002f05c  7c03b840    cmplw r3,r23                
1002f060  4081000c    ble 0x1002f06c                 ; -> 1002f06c
1002f064  3be0ffde    li r31,-0x22                
1002f068  4800005c    b 0x1002f0c4                   ; -> 1002f0c4
1002f06c  7fa3eb78    or r3,r29,r29               
1002f070  48002679    bl 0x100316e8                  ; -> 100316e8
1002f074  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f078  480025b1    bl 0x10031628                  ; -> 10031628
1002f07c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f080  7c7f1b78    or r31,r3,r3                
1002f084  7fe70734    extsh r7,r31                
1002f088  2c070000    cmpwi r7,0x0                
1002f08c  40820020    bne 0x1002f0ac                 ; -> 1002f0ac
1002f090  7f83e378    or r3,r28,r28               
1002f094  4800266d    bl 0x10031700                  ; -> 10031700
1002f098  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f09c  4800258d    bl 0x10031628                  ; -> 10031628
1002f0a0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f0a4  7c7f1b78    or r31,r3,r3                
1002f0a8  48000004    b 0x1002f0ac                   ; -> 1002f0ac
1002f0ac  7fa3eb78    or r3,r29,r29               
1002f0b0  48001fa9    bl 0x10031058                  ; -> 10031058
1002f0b4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f0b8  480024f9    bl 0x100315b0                  ; -> 100315b0
1002f0bc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f0c0  7c7f1b78    or r31,r3,r3                
1002f0c4  7fe80734    extsh r8,r31                
1002f0c8  2c080000    cmpwi r8,0x0                
1002f0cc  408200bc    bne 0x1002f188                 ; -> 1002f188
1002f0d0  7f83e378    or r3,r28,r28               
1002f0d4  4800056d    bl 0x1002f640                  ; -> 1002f640
1002f0d8  7c731b78    or r19,r3,r3                
1002f0dc  7e639b78    or r3,r19,r19               
1002f0e0  48000669    bl 0x1002f748                  ; -> 1002f748
1002f0e4  7c7b1a14    add r3,r27,r3               
1002f0e8  7c03b840    cmplw r3,r23                
1002f0ec  4081000c    ble 0x1002f0f8                 ; -> 1002f0f8
1002f0f0  3be0ffde    li r31,-0x22                
1002f0f4  48000094    b 0x1002f188                   ; -> 1002f188
1002f0f8  281e0000    cmplwi r30,0x0              
1002f0fc  41820030    beq 0x1002f12c                 ; -> 1002f12c
1002f100  a93e0000    lha r9,0x0(r30)             
1002f104  2c090000    cmpwi r9,0x0                
1002f108  4082001c    bne 0x1002f124                 ; -> 1002f124
1002f10c  7f23cb78    or r3,r25,r25               
1002f110  48002609    bl 0x10031718                  ; -> 10031718
1002f114  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f118  7c7a1b78    or r26,r3,r3                
1002f11c  b35e0000    sth r26,0x0(r30)            
1002f120  4800001c    b 0x1002f13c                   ; -> 1002f13c
1002f124  ab5e0000    lha r26,0x0(r30)            
1002f128  48000014    b 0x1002f13c                   ; -> 1002f13c
1002f12c  7f23cb78    or r3,r25,r25               
1002f130  480025e9    bl 0x10031718                  ; -> 10031718
1002f134  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f138  7c7a1b78    or r26,r3,r3                
1002f13c  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x48]
1002f140  7f24cb78    or r4,r25,r25               
1002f144  7f45d378    or r5,r26,r26               
1002f148  38c2ffea    subi r6,r2,0x16             
1002f14c  480025e5    bl 0x10031730                  ; -> 10031730
1002f150  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f154  480024d5    bl 0x10031628                  ; -> 10031628
1002f158  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f15c  7c7f1b78    or r31,r3,r3                
1002f160  7fea0734    extsh r10,r31               
1002f164  2c0a0000    cmpwi r10,0x0               
1002f168  40820020    bne 0x1002f188                 ; -> 1002f188
1002f16c  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x48]
1002f170  480025d9    bl 0x10031748                  ; -> 10031748
1002f174  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f178  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x48]
1002f17c  480025e5    bl 0x10031760                  ; -> 10031760
1002f180  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f184  48000004    b 0x1002f188                   ; -> 1002f188
1002f188  7ea3ab78    or r3,r21,r21               
1002f18c  480024fd    bl 0x10031688                  ; -> 10031688
1002f190  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f194  48002495    bl 0x10031628                  ; -> 10031628
1002f198  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002f19c  7c7f1b78    or r31,r3,r3                
1002f1a0  48000010    b 0x1002f1b0                   ; -> 1002f1b0
1002f1a4  4800000c    b 0x1002f1b0                   ; -> 1002f1b0
1002f1a8  48000008    b 0x1002f1b0                   ; -> 1002f1b0
1002f1ac  3be0ffce    li r31,-0x32                
1002f1b0  7fe3fb78    or r3,r31,r31               
1002f1b4  80010088    lwz r0,0x88(r1)                ; -> Stack[0x8]
1002f1b8  38210080    addi r1,r1,0x80             
1002f1bc  7c0803a6    mtspr LR,r0                 
1002f1c0  ba61ffcc    lmw r19,-0x34(r1)              ; -> Stack[-0x34]
1002f1c4  4e800020    blr                         
