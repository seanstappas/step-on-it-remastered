; FUN_10023ad0 @ 0x10023ad0
10023ad0  7c0802a6    mfspr r0,LR                 
10023ad4  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
10023ad8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10023adc  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10023ae0  7c791b78    or r25,r3,r3                
10023ae4  7c9a2378    or r26,r4,r4                
10023ae8  3b8270ec    addi r28,r2,0x70ec          
10023aec  38610038    addi r3,r1,0x38             
10023af0  38990046    addi r4,r25,0x46            
10023af4  38bafff6    subi r5,r26,0xa             
10023af8  38d90079    addi r6,r25,0x79            
10023afc  38fa0003    addi r7,r26,0x3             
10023b00  4800e039    bl 0x10031b38                  ; -> 10031b38
10023b04  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023b08  38625608    addi r3,r2,0x5608           
10023b0c  4800e08d    bl 0x10031b98                  ; -> 10031b98
10023b10  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023b14  38610038    addi r3,r1,0x38             
10023b18  4800e099    bl 0x10031bb0                  ; -> 10031bb0
10023b1c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023b20  38600000    li r3,0x0                   
10023b24  b07c0002    sth r3,0x2(r28)             
10023b28  3c800001    lis r4,0x1                  
10023b2c  b07c0004    sth r3,0x4(r28)             
10023b30  3884ffff    subi r4,r4,0x1              
10023b34  b09c0000    sth r4,0x0(r28)             
10023b38  7f83e378    or r3,r28,r28               
10023b3c  4800e05d    bl 0x10031b98                  ; -> 10031b98
10023b40  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023b44  38790046    addi r3,r25,0x46            
10023b48  7f44d378    or r4,r26,r26               
10023b4c  4800e0ad    bl 0x10031bf8                  ; -> 10031bf8
10023b50  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023b54  3860000c    li r3,0xc                   
10023b58  4800e0b9    bl 0x10031c10                  ; -> 10031c10
10023b5c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023b60  38600001    li r3,0x1                   
10023b64  4800e0c5    bl 0x10031c28                  ; -> 10031c28
10023b68  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023b6c  38600014    li r3,0x14                  
10023b70  4800e0d1    bl 0x10031c40                  ; -> 10031c40
10023b74  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023b78  38622e93    addi r3,r2,0x2e93           
10023b7c  4800e6f5    bl 0x10032270                  ; -> 10032270
10023b80  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023b84  3ba0ffff    li r29,-0x1                 
10023b88  3bc00000    li r30,0x0                  
10023b8c  48000058    b 0x10023be4                   ; -> 10023be4
10023b90  48009745    bl 0x1002d2d4                  ; -> 1002d2d4
10023b94  60000000    ori r0,r0,0x0               
10023b98  7c7f1b78    or r31,r3,r3                
10023b9c  7fe50734    extsh r5,r31                
10023ba0  2c05ffff    cmpwi r5,-0x1               
10023ba4  41820040    beq 0x10023be4                 ; -> 10023be4
10023ba8  7fe60734    extsh r6,r31                
10023bac  7fa70734    extsh r7,r29                
10023bb0  7c063800    cmpw r6,r7                  
10023bb4  41820030    beq 0x10023be4                 ; -> 10023be4
10023bb8  7fe3fb78    or r3,r31,r31               
10023bbc  480000d5    bl 0x10023c90                  ; -> 10023c90
10023bc0  60000000    ori r0,r0,0x0               
10023bc4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10023bc8  28030000    cmplwi r3,0x0               
10023bcc  4182000c    beq 0x10023bd8                 ; -> 10023bd8
10023bd0  3bc00001    li r30,0x1                  
10023bd4  48000010    b 0x10023be4                   ; -> 10023be4
10023bd8  38600001    li r3,0x1                   
10023bdc  4800d68d    bl 0x10031268                  ; -> 10031268
10023be0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023be4  57c8063e    rlwinm r8,r30,0x0,0x18,0x1f 
10023be8  28080000    cmplwi r8,0x0               
10023bec  4182ffa4    beq 0x10023b90                 ; -> 10023b90
10023bf0  48000008    b 0x10023bf8                   ; -> 10023bf8
10023bf4  3b600000    li r27,0x0                  
10023bf8  480096dd    bl 0x1002d2d4                  ; -> 1002d2d4
10023bfc  60000000    ori r0,r0,0x0               
10023c00  2c030000    cmpwi r3,0x0                
10023c04  4080fff0    bge 0x10023bf4                 ; -> 10023bf4
10023c08  38625608    addi r3,r2,0x5608           
10023c0c  4800df8d    bl 0x10031b98                  ; -> 10031b98
10023c10  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023c14  38610038    addi r3,r1,0x38             
10023c18  4800df99    bl 0x10031bb0                  ; -> 10031bb0
10023c1c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023c20  39200000    li r9,0x0                   
10023c24  b13c0002    sth r9,0x2(r28)             
10023c28  b13c0000    sth r9,0x0(r28)             
10023c2c  b13c0004    sth r9,0x4(r28)             
10023c30  7f83e378    or r3,r28,r28               
10023c34  4800df65    bl 0x10031b98                  ; -> 10031b98
10023c38  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023c3c  38600000    li r3,0x0                   
10023c40  4800dfe9    bl 0x10031c28                  ; -> 10031c28
10023c44  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023c48  38790046    addi r3,r25,0x46            
10023c4c  7f44d378    or r4,r26,r26               
10023c50  4800dfa9    bl 0x10031bf8                  ; -> 10031bf8
10023c54  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023c58  7feb0734    extsh r11,r31               
10023c5c  7d6b4670    srawi r11,r11,0x8           
10023c60  7d6b0194    addze r11,r11               
10023c64  39420df2    addi r10,r2,0xdf2           
10023c68  556b3032    rlwinm r11,r11,0x6,0x0,0x19 
10023c6c  7c6a5a14    add r3,r10,r11              
10023c70  4800e601    bl 0x10032270                  ; -> 10032270
10023c74  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023c78  7fe3fb78    or r3,r31,r31               
10023c7c  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10023c80  38210060    addi r1,r1,0x60             
10023c84  7c0803a6    mtspr LR,r0                 
10023c88  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
10023c8c  4e800020    blr                         
