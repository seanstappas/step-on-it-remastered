; FUN_1002f7b4 @ 0x1002f7b4
1002f7b4  7c0802a6    mfspr r0,LR                 
1002f7b8  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
1002f7bc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002f7c0  9421fda0    stwu r1,-0x260(r1)             ; -> Stack[-0x260]
1002f7c4  7c7f1b78    or r31,r3,r3                
1002f7c8  7c9e2378    or r30,r4,r4                
1002f7cc  7cb92b78    or r25,r5,r5                
1002f7d0  281f0000    cmplwi r31,0x0              
1002f7d4  3ba00000    li r29,0x0                  
1002f7d8  418200b0    beq 0x1002f888                 ; -> 1002f888
1002f7dc  281e0000    cmplwi r30,0x0              
1002f7e0  418200a8    beq 0x1002f888                 ; -> 1002f888
1002f7e4  28190000    cmplwi r25,0x0              
1002f7e8  418200a0    beq 0x1002f888                 ; -> 1002f888
1002f7ec  887f0000    lbz r3,0x0(r31)             
1002f7f0  889e0000    lbz r4,0x0(r30)             
1002f7f4  8b9e0000    lbz r28,0x0(r30)            
1002f7f8  7f432214    add r26,r3,r4               
1002f7fc  7f450734    extsh r5,r26                
1002f800  2c0500ff    cmpwi r5,0xff               
1002f804  4081000c    ble 0x1002f810                 ; -> 1002f810
1002f808  88df0000    lbz r6,0x0(r31)             
1002f80c  238600ff    subfic r28,r6,0xff          
1002f810  88ff0000    lbz r7,0x0(r31)             
1002f814  7fe3fb78    or r3,r31,r31               
1002f818  38810138    addi r4,r1,0x138            
1002f81c  38a70001    addi r5,r7,0x1              
1002f820  48001c41    bl 0x10031460                  ; -> 10031460
1002f824  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x24c]
1002f828  7f880734    extsh r8,r28                
1002f82c  7fc3f378    or r3,r30,r30               
1002f830  38810038    addi r4,r1,0x38             
1002f834  38a80001    addi r5,r8,0x1              
1002f838  48001c29    bl 0x10031460                  ; -> 10031460
1002f83c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x24c]
1002f840  89210038    lbz r9,0x38(r1)                ; -> Stack[-0x228]
1002f844  89410138    lbz r10,0x138(r1)              ; -> Stack[-0x128]
1002f848  8b610138    lbz r27,0x138(r1)              ; -> Stack[-0x128]
1002f84c  7d4a4a14    add r10,r10,r9              
1002f850  38810139    addi r4,r1,0x139            
1002f854  88a10038    lbz r5,0x38(r1)                ; -> Stack[-0x228]
1002f858  99410138    stb r10,0x138(r1)              ; -> Stack[-0x128]
1002f85c  38610039    addi r3,r1,0x39             
1002f860  7c84da14    add r4,r4,r27               
1002f864  48001bfd    bl 0x10031460                  ; -> 10031460
1002f868  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x24c]
1002f86c  89610138    lbz r11,0x138(r1)              ; -> Stack[-0x128]
1002f870  38610138    addi r3,r1,0x138            
1002f874  7f24cb78    or r4,r25,r25               
1002f878  38ab0001    addi r5,r11,0x1             
1002f87c  48001be5    bl 0x10031460                  ; -> 10031460
1002f880  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x24c]
1002f884  48000008    b 0x1002f88c                   ; -> 1002f88c
1002f888  3ba0ffce    li r29,-0x32                
1002f88c  7fa3eb78    or r3,r29,r29               
1002f890  80010268    lwz r0,0x268(r1)               ; -> Stack[0x8]
1002f894  38210260    addi r1,r1,0x260            
1002f898  7c0803a6    mtspr LR,r0                 
1002f89c  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
1002f8a0  4e800020    blr                         
