; FUN_10004ac8 @ 0x10004ac8
10004ac8  7c0802a6    mfspr r0,LR                 
10004acc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10004ad0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10004ad4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10004ad8  3861003e    addi r3,r1,0x3e             
10004adc  4802c6cd    bl 0x100311a8                  ; -> 100311a8
10004ae0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10004ae4  38827570    addi r4,r2,0x7570           
10004ae8  80640000    lwz r3,0x0(r4)              
10004aec  4802c6d5    bl 0x100311c0                  ; -> 100311c0
10004af0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10004af4  38a2756c    addi r5,r2,0x756c           
10004af8  80650000    lwz r3,0x0(r5)              
10004afc  4802cfc5    bl 0x10031ac0                  ; -> 10031ac0
10004b00  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10004b04  4802c53d    bl 0x10031040                  ; -> 10031040
10004b08  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10004b0c  7c7f1b78    or r31,r3,r3                
10004b10  7fe60734    extsh r6,r31                
10004b14  2c060000    cmpwi r6,0x0                
10004b18  41820008    beq 0x10004b20                 ; -> 10004b20
10004b1c  3be00000    li r31,0x0                  
10004b20  38e00000    li r7,0x0                   
10004b24  b0e1003c    sth r7,0x3c(r1)                ; -> Stack[-0x14]
10004b28  b0e1003a    sth r7,0x3a(r1)                ; -> Stack[-0x16]
10004b2c  b0e10038    sth r7,0x38(r1)                ; -> Stack[-0x18]
10004b30  38610038    addi r3,r1,0x38             
10004b34  4802d065    bl 0x10031b98                  ; -> 10031b98
10004b38  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10004b3c  38627584    addi r3,r2,0x7584           
10004b40  4802d071    bl 0x10031bb0                  ; -> 10031bb0
10004b44  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10004b48  3902342e    addi r8,r2,0x342e           
10004b4c  89080000    lbz r8,0x0(r8)              
10004b50  28080000    cmplwi r8,0x0               
10004b54  41820030    beq 0x10004b84                 ; -> 10004b84
10004b58  39226be4    addi r9,r2,0x6be4           
10004b5c  80690000    lwz r3,0x0(r9)              
10004b60  4802c661    bl 0x100311c0                  ; -> 100311c0
10004b64  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10004b68  39426be0    addi r10,r2,0x6be0          
10004b6c  806a0000    lwz r3,0x0(r10)             
10004b70  4802cf51    bl 0x10031ac0                  ; -> 10031ac0
10004b74  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10004b78  38627584    addi r3,r2,0x7584           
10004b7c  4802d035    bl 0x10031bb0                  ; -> 10031bb0
10004b80  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10004b84  8061003e    lwz r3,0x3e(r1)                ; -> Stack[-0x12]
10004b88  4802c639    bl 0x100311c0                  ; -> 100311c0
10004b8c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10004b90  39627564    addi r11,r2,0x7564          
10004b94  806b0000    lwz r3,0x0(r11)             
10004b98  4802cf29    bl 0x10031ac0                  ; -> 10031ac0
10004b9c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10004ba0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10004ba4  38210050    addi r1,r1,0x50             
10004ba8  7c0803a6    mtspr LR,r0                 
10004bac  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10004bb0  4e800020    blr                         
