; FUN_1001a348 @ 0x1001a348
1001a348  7c0802a6    mfspr r0,LR                 
1001a34c  bee1ffdc    stmw r23,-0x24(r1)             ; -> Stack[-0x24]
1001a350  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001a354  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1001a358  7c791b78    or r25,r3,r3                
1001a35c  7c9c2378    or r28,r4,r4                
1001a360  7f23cb78    or r3,r25,r25               
1001a364  48017445    bl 0x100317a8                  ; -> 100317a8
1001a368  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001a36c  7f23cb78    or r3,r25,r25               
1001a370  48016c89    bl 0x10030ff8                  ; -> 10030ff8
1001a374  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001a378  83190000    lwz r24,0x0(r25)            
1001a37c  7f97e378    or r23,r28,r28              
1001a380  80780000    lwz r3,0x0(r24)             
1001a384  80980004    lwz r4,0x4(r24)             
1001a388  3b580018    addi r26,r24,0x18           
1001a38c  90770000    stw r3,0x0(r23)             
1001a390  90970004    stw r4,0x4(r23)             
1001a394  80b80008    lwz r5,0x8(r24)             
1001a398  80d8000c    lwz r6,0xc(r24)             
1001a39c  3bc00000    li r30,0x0                  
1001a3a0  90b70008    stw r5,0x8(r23)             
1001a3a4  90d7000c    stw r6,0xc(r23)             
1001a3a8  80f80010    lwz r7,0x10(r24)            
1001a3ac  81180014    lwz r8,0x14(r24)            
1001a3b0  90f70010    stw r7,0x10(r23)            
1001a3b4  91170014    stw r8,0x14(r23)            
1001a3b8  a1380018    lhz r9,0x18(r24)            
1001a3bc  b1370018    sth r9,0x18(r23)            
1001a3c0  837a0000    lwz r27,0x0(r26)            
1001a3c4  3b5a0004    addi r26,r26,0x4            
1001a3c8  48000040    b 0x1001a408                   ; -> 1001a408
1001a3cc  3be00000    li r31,0x0                  
1001a3d0  48000028    b 0x1001a3f8                   ; -> 1001a3f8
1001a3d4  7fec0734    extsh r12,r31               
1001a3d8  7fcb0734    extsh r11,r30               
1001a3dc  1d6b0034    mulli r11,r11,0x34          
1001a3e0  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
1001a3e4  7d6b6214    add r11,r11,r12             
1001a3e8  39400000    li r10,0x0                  
1001a3ec  396b0018    addi r11,r11,0x18           
1001a3f0  7d5c592e    stwx r10,r28,r11            
1001a3f4  3bff0001    addi r31,r31,0x1            
1001a3f8  7fe30734    extsh r3,r31                
1001a3fc  2c03000d    cmpwi r3,0xd                
1001a400  4180ffd4    blt 0x1001a3d4                 ; -> 1001a3d4
1001a404  3bde0001    addi r30,r30,0x1            
1001a408  7fc40734    extsh r4,r30                
1001a40c  2c040013    cmpwi r4,0x13               
1001a410  4180ffbc    blt 0x1001a3cc                 ; -> 1001a3cc
1001a414  4800007c    b 0x1001a490                   ; -> 1001a490
1001a418  7f5dd378    or r29,r26,r26              
1001a41c  88bd0000    lbz r5,0x0(r29)             
1001a420  3bbd0001    addi r29,r29,0x1            
1001a424  88dd0000    lbz r6,0x0(r29)             
1001a428  7cbe0774    extsb r30,r5                
1001a42c  3bbd0001    addi r29,r29,0x1            
1001a430  7cdf0774    extsb r31,r6                
1001a434  48000038    b 0x1001a46c                   ; -> 1001a46c
1001a438  7fc70734    extsh r7,r30                
1001a43c  7fe80734    extsh r8,r31                
1001a440  1ce70034    mulli r7,r7,0x34            
1001a444  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
1001a448  7ce74214    add r7,r7,r8                
1001a44c  38e70018    addi r7,r7,0x18             
1001a450  7f7c392e    stwx r27,r28,r7             
1001a454  893d0000    lbz r9,0x0(r29)             
1001a458  3bbd0001    addi r29,r29,0x1            
1001a45c  895d0000    lbz r10,0x0(r29)            
1001a460  7d3e0774    extsb r30,r9                
1001a464  3bbd0001    addi r29,r29,0x1            
1001a468  7d5f0774    extsb r31,r10               
1001a46c  7fcb0734    extsh r11,r30               
1001a470  2c0b0064    cmpwi r11,0x64              
1001a474  41820010    beq 0x1001a484                 ; -> 1001a484
1001a478  7fec0734    extsh r12,r31               
1001a47c  2c0c0064    cmpwi r12,0x64              
1001a480  4082ffb8    bne 0x1001a438                 ; -> 1001a438
1001a484  7fbaeb78    or r26,r29,r29              
1001a488  837a0000    lwz r27,0x0(r26)            
1001a48c  3b5a0004    addi r26,r26,0x4            
1001a490  2c1b0000    cmpwi r27,0x0               
1001a494  4082ff84    bne 0x1001a418                 ; -> 1001a418
1001a498  7f23cb78    or r3,r25,r25               
1001a49c  48016b75    bl 0x10031010                  ; -> 10031010
1001a4a0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001a4a4  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1001a4a8  38210060    addi r1,r1,0x60             
1001a4ac  7c0803a6    mtspr LR,r0                 
1001a4b0  bae1ffdc    lmw r23,-0x24(r1)              ; -> Stack[-0x24]
1001a4b4  4e800020    blr                         
