; FUN_10000ae8 @ 0x10000ae8
10000ae8  7c0802a6    mfspr r0,LR                 
10000aec  bf01ffe0    stmw r24,-0x20(r1)             ; -> Stack[-0x20]
10000af0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10000af4  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
10000af8  7c7a1b78    or r26,r3,r3                
10000afc  7c9d2378    or r29,r4,r4                
10000b00  7cbc2b78    or r28,r5,r5                
10000b04  90c10094    stw r6,0x94(r1)                ; -> Stack[0x24]
10000b08  90e10098    stw r7,0x98(r1)                ; -> Stack[0x28]
10000b0c  38600000    li r3,0x0                   
10000b10  281c0000    cmplwi r28,0x0              
10000b14  3be00000    li r31,0x0                  
10000b18  3b600000    li r27,0x0                  
10000b1c  90610040    stw r3,0x40(r1)                ; -> Stack[-0x30]
10000b20  3bc00000    li r30,0x0                  
10000b24  41820020    beq 0x10000b44                 ; -> 10000b44
10000b28  7f83e378    or r3,r28,r28               
10000b2c  48030ea5    bl 0x100319d0                  ; -> 100319d0
10000b30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000b34  7c781b78    or r24,r3,r3                
10000b38  7f83e378    or r3,r28,r28               
10000b3c  48030ead    bl 0x100319e8                  ; -> 100319e8
10000b40  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000b44  3c607164    lis r3,0x7164               
10000b48  a8ba0002    lha r5,0x2(r26)             
10000b4c  a8da0006    lha r6,0x6(r26)             
10000b50  7fa40734    extsh r4,r29                
10000b54  7ca53050    subf r5,r5,r6               
10000b58  7c8521d6    mullw r4,r5,r4              
10000b5c  3884001f    addi r4,r4,0x1f             
10000b60  7c842e70    srawi r4,r4,0x5             
10000b64  5499103a    rlwinm r25,r4,0x2,0x0,0x1d  
10000b68  38632020    addi r3,r3,0x2020           
10000b6c  3881003c    addi r4,r1,0x3c             
10000b70  480307e9    bl 0x10031358                  ; -> 10031358
10000b74  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000b78  7fa70734    extsh r7,r29                
10000b7c  2c070001    cmpwi r7,0x1                
10000b80  4182004c    beq 0x10000bcc                 ; -> 10000bcc
10000b84  7fa80734    extsh r8,r29                
10000b88  2c080002    cmpwi r8,0x2                
10000b8c  41820040    beq 0x10000bcc                 ; -> 10000bcc
10000b90  7fa90734    extsh r9,r29                
10000b94  2c090004    cmpwi r9,0x4                
10000b98  41820034    beq 0x10000bcc                 ; -> 10000bcc
10000b9c  7faa0734    extsh r10,r29               
10000ba0  2c0a0008    cmpwi r10,0x8               
10000ba4  41820028    beq 0x10000bcc                 ; -> 10000bcc
10000ba8  7fab0734    extsh r11,r29               
10000bac  2c0b0010    cmpwi r11,0x10              
10000bb0  41820010    beq 0x10000bc0                 ; -> 10000bc0
10000bb4  7fac0734    extsh r12,r29               
10000bb8  2c0c0020    cmpwi r12,0x20              
10000bbc  40820040    bne 0x10000bfc                 ; -> 10000bfc
10000bc0  8061003c    lwz r3,0x3c(r1)                ; -> Stack[-0x34]
10000bc4  28030200    cmplwi r3,0x200             
10000bc8  41800034    blt 0x10000bfc                 ; -> 10000bfc
10000bcc  7f240734    extsh r4,r25                
10000bd0  2c043ffe    cmpwi r4,0x3ffe             
10000bd4  41810020    bgt 0x10000bf4                 ; -> 10000bf4
10000bd8  7fa50734    extsh r5,r29                
10000bdc  2c050008    cmpwi r5,0x8                
10000be0  41810020    bgt 0x10000c00                 ; -> 10000c00
10000be4  281c0000    cmplwi r28,0x0              
10000be8  40820018    bne 0x10000c00                 ; -> 10000c00
10000bec  3bc0ffce    li r30,-0x32                
10000bf0  48000010    b 0x10000c00                   ; -> 10000c00
10000bf4  3bc0ffce    li r30,-0x32                
10000bf8  48000008    b 0x10000c00                   ; -> 10000c00
10000bfc  3bc0ffce    li r30,-0x32                
10000c00  7fc60734    extsh r6,r30                
10000c04  2c060000    cmpwi r6,0x0                
10000c08  408200c0    bne 0x10000cc8                 ; -> 10000cc8
10000c0c  3860006c    li r3,0x6c                  
10000c10  48030881    bl 0x10031490                  ; -> 10031490
10000c14  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000c18  7c7f1b78    or r31,r3,r3                
10000c1c  281f0000    cmplwi r31,0x0              
10000c20  4182009c    beq 0x10000cbc                 ; -> 10000cbc
10000c24  38610038    addi r3,r1,0x38             
10000c28  48030581    bl 0x100311a8                  ; -> 100311a8
10000c2c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000c30  7fe3fb78    or r3,r31,r31               
10000c34  48030dcd    bl 0x10031a00                  ; -> 10031a00
10000c38  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000c3c  80fa0000    lwz r7,0x0(r26)             
10000c40  811a0004    lwz r8,0x4(r26)             
10000c44  7f44d378    or r4,r26,r26               
10000c48  90ff0010    stw r7,0x10(r31)            
10000c4c  911f0014    stw r8,0x14(r31)            
10000c50  807f0018    lwz r3,0x18(r31)            
10000c54  48030dc5    bl 0x10031a18                  ; -> 10031a18
10000c58  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000c5c  7f43d378    or r3,r26,r26               
10000c60  48030dd1    bl 0x10031a30                  ; -> 10031a30
10000c64  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000c68  80ff0002    lwz r7,0x2(r31)             
10000c6c  7fa3eb78    or r3,r29,r29               
10000c70  7f44d378    or r4,r26,r26               
10000c74  7f85e378    or r5,r28,r28               
10000c78  7f26cb78    or r6,r25,r25               
10000c7c  48000115    bl 0x10000d90                  ; -> 10000d90
10000c80  60000000    ori r0,r0,0x0               
10000c84  7c7e1b78    or r30,r3,r3                
10000c88  7fc90734    extsh r9,r30                
10000c8c  2c090000    cmpwi r9,0x0                
10000c90  4082001c    bne 0x10000cac                 ; -> 10000cac
10000c94  837f0002    lwz r27,0x2(r31)            
10000c98  38810040    addi r4,r1,0x40             
10000c9c  7f63db78    or r3,r27,r27               
10000ca0  48000339    bl 0x10000fd8                  ; -> 10000fd8
10000ca4  60000000    ori r0,r0,0x0               
10000ca8  7c7e1b78    or r30,r3,r3                
10000cac  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x38]
10000cb0  48030511    bl 0x100311c0                  ; -> 100311c0
10000cb4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000cb8  48000010    b 0x10000cc8                   ; -> 10000cc8
10000cbc  480308f5    bl 0x100315b0                  ; -> 100315b0
10000cc0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000cc4  7c7e1b78    or r30,r3,r3                
10000cc8  281c0000    cmplwi r28,0x0              
10000ccc  41820014    beq 0x10000ce0                 ; -> 10000ce0
10000cd0  7f83e378    or r3,r28,r28               
10000cd4  7f04c378    or r4,r24,r24               
10000cd8  48030da1    bl 0x10031a78                  ; -> 10031a78
10000cdc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000ce0  7fca0734    extsh r10,r30               
10000ce4  2c0a0000    cmpwi r10,0x0               
10000ce8  4182007c    beq 0x10000d64                 ; -> 10000d64
10000cec  281b0000    cmplwi r27,0x0              
10000cf0  41820024    beq 0x10000d14                 ; -> 10000d14
10000cf4  817b0000    lwz r11,0x0(r27)            
10000cf8  806b002a    lwz r3,0x2a(r11)            
10000cfc  48030d4d    bl 0x10031a48                  ; -> 10031a48
10000d00  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000d04  819b0000    lwz r12,0x0(r27)            
10000d08  806c0000    lwz r3,0x0(r12)             
10000d0c  480308d5    bl 0x100315e0                  ; -> 100315e0
10000d10  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000d14  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x30]
10000d18  28030000    cmplwi r3,0x0               
10000d1c  41820024    beq 0x10000d40                 ; -> 10000d40
10000d20  80810040    lwz r4,0x40(r1)                ; -> Stack[-0x30]
10000d24  80840000    lwz r4,0x0(r4)              
10000d28  80640006    lwz r3,0x6(r4)              
10000d2c  4803032d    bl 0x10031058                  ; -> 10031058
10000d30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000d34  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x30]
10000d38  48030321    bl 0x10031058                  ; -> 10031058
10000d3c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000d40  281f0000    cmplwi r31,0x0              
10000d44  41820034    beq 0x10000d78                 ; -> 10000d78
10000d48  7fe3fb78    or r3,r31,r31               
10000d4c  48030d45    bl 0x10031a90                  ; -> 10031a90
10000d50  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000d54  7fe3fb78    or r3,r31,r31               
10000d58  48030889    bl 0x100315e0                  ; -> 100315e0
10000d5c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10000d60  48000018    b 0x10000d78                   ; -> 10000d78
10000d64  80a10094    lwz r5,0x94(r1)                ; -> Stack[0x24]
10000d68  80e10098    lwz r7,0x98(r1)                ; -> Stack[0x28]
10000d6c  93e50000    stw r31,0x0(r5)             
10000d70  80c10040    lwz r6,0x40(r1)                ; -> Stack[-0x30]
10000d74  90c70000    stw r6,0x0(r7)              
10000d78  7fc3f378    or r3,r30,r30               
10000d7c  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
10000d80  38210070    addi r1,r1,0x70             
10000d84  7c0803a6    mtspr LR,r0                 
10000d88  bb01ffe0    lmw r24,-0x20(r1)              ; -> Stack[-0x20]
10000d8c  4e800020    blr                         
