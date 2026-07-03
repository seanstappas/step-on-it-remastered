; FUN_100049d8 @ 0x100049d8
100049d8  7c0802a6    mfspr r0,LR                 
100049dc  be61ffcc    stmw r19,-0x34(r1)             ; -> Stack[-0x34]
100049e0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100049e4  9421ff80    stwu r1,-0x80(r1)              ; -> Stack[-0x80]
100049e8  7c731b78    or r19,r3,r3                
100049ec  7e769b78    or r22,r19,r19              
100049f0  ab560000    lha r26,0x0(r22)            
100049f4  38627534    addi r3,r2,0x7534           
100049f8  3ad60002    addi r22,r22,0x2            
100049fc  aab60000    lha r21,0x0(r22)            
10004a00  80630000    lwz r3,0x0(r3)              
10004a04  3ad60002    addi r22,r22,0x2            
10004a08  aa960000    lha r20,0x0(r22)            
10004a0c  80630002    lwz r3,0x2(r3)              
10004a10  3ad60002    addi r22,r22,0x2            
10004a14  ab360000    lha r25,0x0(r22)            
10004a18  80630000    lwz r3,0x0(r3)              
10004a1c  3ad60002    addi r22,r22,0x2            
10004a20  7c95c850    subf r4,r21,r25             
10004a24  3ae26bd0    addi r23,r2,0x6bd0          
10004a28  83030000    lwz r24,0x0(r3)             
10004a2c  7fbaa050    subf r29,r26,r20            
10004a30  b0810038    sth r4,0x38(r1)                ; -> Stack[-0x48]
10004a34  7edcb378    or r28,r22,r22              
10004a38  48023f21    bl 0x10028958                  ; -> 10028958
10004a3c  60000000    ori r0,r0,0x0               
10004a40  7ebbab78    or r27,r21,r21              
10004a44  4800004c    b 0x10004a90                   ; -> 10004a90
10004a48  a8b70000    lha r5,0x0(r23)             
10004a4c  7f660734    extsh r6,r27                
10004a50  7ca629d6    mullw r5,r6,r5              
10004a54  7f470734    extsh r7,r26                
10004a58  7ca53a14    add r5,r5,r7                
10004a5c  7fd82a14    add r30,r24,r5              
10004a60  3be00000    li r31,0x0                  
10004a64  48000018    b 0x10004a7c                   ; -> 10004a7c
10004a68  891c0000    lbz r8,0x0(r28)             
10004a6c  3bff0001    addi r31,r31,0x1            
10004a70  991e0000    stb r8,0x0(r30)             
10004a74  3b9c0001    addi r28,r28,0x1            
10004a78  3bde0001    addi r30,r30,0x1            
10004a7c  7fe90734    extsh r9,r31                
10004a80  7faa0734    extsh r10,r29               
10004a84  7c095000    cmpw r9,r10                 
10004a88  4180ffe0    blt 0x10004a68                 ; -> 10004a68
10004a8c  3b7b0001    addi r27,r27,0x1            
10004a90  7f6b0734    extsh r11,r27               
10004a94  7f2c0734    extsh r12,r25               
10004a98  7c0b6000    cmpw r11,r12                
10004a9c  4180ffac    blt 0x10004a48                 ; -> 10004a48
10004aa0  48023f21    bl 0x100289c0                  ; -> 100289c0
10004aa4  60000000    ori r0,r0,0x0               
10004aa8  7e639b78    or r3,r19,r19               
10004aac  4802cb35    bl 0x100315e0                  ; -> 100315e0
10004ab0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
10004ab4  80010088    lwz r0,0x88(r1)                ; -> Stack[0x8]
10004ab8  38210080    addi r1,r1,0x80             
10004abc  7c0803a6    mtspr LR,r0                 
10004ac0  ba61ffcc    lmw r19,-0x34(r1)              ; -> Stack[-0x34]
10004ac4  4e800020    blr                         
