; .CreatorTypeFileSearch @ 0x10030acc
10030acc  7c0802a6    mfspr r0,LR                 
10030ad0  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
10030ad4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10030ad8  9421fe50    stwu r1,-0x1b0(r1)             ; -> Stack[-0x1b0]
10030adc  906101c8    stw r3,0x1c8(r1)               ; -> Stack[0x18]
10030ae0  b08101ce    sth r4,0x1ce(r1)               ; -> Stack[0x1e]
10030ae4  7cbb2b78    or r27,r5,r5                
10030ae8  7cdc3378    or r28,r6,r6                
10030aec  90e101d8    stw r7,0x1d8(r1)               ; -> Stack[0x28]
10030af0  910101dc    stw r8,0x1dc(r1)               ; -> Stack[0x2c]
10030af4  7d3d4b78    or r29,r9,r9                
10030af8  994101e7    stb r10,0x1e7(r1)              ; -> Stack[0x37]
10030afc  3bc275a0    addi r30,r2,0x75a0          
10030b00  806101c8    lwz r3,0x1c8(r1)               ; -> Stack[0x18]
10030b04  a88101ce    lha r4,0x1ce(r1)               ; -> Stack[0x1e]
10030b08  38a101ce    addi r5,r1,0x1ce            
10030b0c  4bfff005    bl 0x1002fb10                  ; -> 1002fb10
10030b10  60000000    ori r0,r0,0x0               
10030b14  7c7f1b78    or r31,r3,r3                
10030b18  7fe30735    extsh. r3,r31               
10030b1c  4182000c    beq 0x10030b28                 ; -> 10030b28
10030b20  7fe3fb78    or r3,r31,r31               
10030b24  480001d0    b 0x10030cf4                   ; -> 10030cf4
10030b28  38800000    li r4,0x0                   
10030b2c  9081004a    stw r4,0x4a(r1)                ; -> Stack[-0x166]
10030b30  a8a101ce    lha r5,0x1ce(r1)               ; -> Stack[0x1e]
10030b34  b0a1004e    sth r5,0x4e(r1)                ; -> Stack[-0x162]
10030b38  80c101d8    lwz r6,0x1d8(r1)               ; -> Stack[0x28]
10030b3c  90c10050    stw r6,0x50(r1)                ; -> Stack[-0x160]
10030b40  80e101dc    lwz r7,0x1dc(r1)               ; -> Stack[0x2c]
10030b44  90e10054    stw r7,0x54(r1)                ; -> Stack[-0x15c]
10030b48  3900000c    li r8,0xc                   
10030b4c  9101005c    stw r8,0x5c(r1)                ; -> Stack[-0x154]
10030b50  3921011e    addi r9,r1,0x11e            
10030b54  91210060    stw r9,0x60(r1)                ; -> Stack[-0x150]
10030b58  394100b2    addi r10,r1,0xb2            
10030b5c  91410064    stw r10,0x64(r1)               ; -> Stack[-0x14c]
10030b60  39600000    li r11,0x0                  
10030b64  91610068    stw r11,0x68(r1)               ; -> Stack[-0x148]
10030b68  898101e7    lbz r12,0x1e7(r1)              ; -> Stack[0x37]
10030b6c  280c0000    cmplwi r12,0x0              
10030b70  40820018    bne 0x10030b88                 ; -> 10030b88
10030b74  a862ffee    lha r3,-0x12(r2)               ; -> 1003415e
10030b78  7c630734    extsh r3,r3                 
10030b7c  a88101ce    lha r4,0x1ce(r1)               ; -> Stack[0x1e]
10030b80  7c032000    cmpw r3,r4                  
10030b84  4182000c    beq 0x10030b90                 ; -> 10030b90
10030b88  38a00000    li r5,0x0                   
10030b8c  90be0000    stw r5,0x0(r30)             
10030b90  80de0000    lwz r6,0x0(r30)             
10030b94  80fe0004    lwz r7,0x4(r30)             
10030b98  90c1006c    stw r6,0x6c(r1)                ; -> Stack[-0x144]
10030b9c  90e10070    stw r7,0x70(r1)                ; -> Stack[-0x140]
10030ba0  811e0008    lwz r8,0x8(r30)             
10030ba4  813e000c    lwz r9,0xc(r30)             
10030ba8  91010074    stw r8,0x74(r1)                ; -> Stack[-0x13c]
10030bac  91210078    stw r9,0x78(r1)                ; -> Stack[-0x138]
10030bb0  38604000    li r3,0x4000                
10030bb4  38810080    addi r4,r1,0x80             
10030bb8  4bffed85    bl 0x1002f93c                  ; -> 1002f93c
10030bbc  60000000    ori r0,r0,0x0               
10030bc0  9061007c    stw r3,0x7c(r1)                ; -> Stack[-0x134]
10030bc4  39400000    li r10,0x0                  
10030bc8  91410130    stw r10,0x130(r1)              ; -> Stack[-0x80]
10030bcc  39600000    li r11,0x0                  
10030bd0  916100c4    stw r11,0xc4(r1)               ; -> Stack[-0xec]
10030bd4  39800000    li r12,0x0                  
10030bd8  9981013c    stb r12,0x13c(r1)              ; -> Stack[-0x74]
10030bdc  38600010    li r3,0x10                  
10030be0  986100d0    stb r3,0xd0(r1)                ; -> Stack[-0xe0]
10030be4  93610142    stw r27,0x142(r1)              ; -> Stack[-0x6e]
10030be8  281b0000    cmplwi r27,0x0              
10030bec  4082000c    bne 0x10030bf8                 ; -> 10030bf8
10030bf0  38800000    li r4,0x0                   
10030bf4  48000008    b 0x10030bfc                   ; -> 10030bfc
10030bf8  3880ffff    li r4,-0x1                  
10030bfc  908100d6    stw r4,0xd6(r1)                ; -> Stack[-0xda]
10030c00  9381013e    stw r28,0x13e(r1)              ; -> Stack[-0x72]
10030c04  281c0000    cmplwi r28,0x0              
10030c08  4082000c    bne 0x10030c14                 ; -> 10030c14
10030c0c  38a00000    li r5,0x0                   
10030c10  48000008    b 0x10030c18                   ; -> 10030c18
10030c14  38a0ffff    li r5,-0x1                  
10030c18  90a100d2    stw r5,0xd2(r1)                ; -> Stack[-0xde]
10030c1c  38c00000    li r6,0x0                   
10030c20  b0c10146    sth r6,0x146(r1)               ; -> Stack[-0x6a]
10030c24  38e00000    li r7,0x0                   
10030c28  b0e10148    sth r7,0x148(r1)               ; -> Stack[-0x68]
10030c2c  39000000    li r8,0x0                   
10030c30  b101014a    sth r8,0x14a(r1)               ; -> Stack[-0x66]
10030c34  39200000    li r9,0x0                   
10030c38  b121014c    sth r9,0x14c(r1)               ; -> Stack[-0x64]
10030c3c  39400000    li r10,0x0                  
10030c40  b14100da    sth r10,0xda(r1)               ; -> Stack[-0xd6]
10030c44  39600000    li r11,0x0                  
10030c48  b16100dc    sth r11,0xdc(r1)               ; -> Stack[-0xd4]
10030c4c  39800000    li r12,0x0                  
10030c50  b18100de    sth r12,0xde(r1)               ; -> Stack[-0xd2]
10030c54  38600000    li r3,0x0                   
10030c58  b06100e0    sth r3,0xe0(r1)                ; -> Stack[-0xd0]
10030c5c  38610038    addi r3,r1,0x38             
10030c60  4bfffd2d    bl 0x1003098c                  ; -> 1003098c
10030c64  7c7f1b78    or r31,r3,r3                
10030c68  7fe40735    extsh. r4,r31               
10030c6c  41820010    beq 0x10030c7c                 ; -> 10030c7c
10030c70  7fe50734    extsh r5,r31                
10030c74  2c05ffd9    cmpwi r5,-0x27              
10030c78  40820010    bne 0x10030c88                 ; -> 10030c88
10030c7c  80c10058    lwz r6,0x58(r1)                ; -> Stack[-0x158]
10030c80  90dd0000    stw r6,0x0(r29)             
10030c84  4800000c    b 0x10030c90                   ; -> 10030c90
10030c88  38e00000    li r7,0x0                   
10030c8c  90fd0000    stw r7,0x0(r29)             
10030c90  7fe80735    extsh. r8,r31               
10030c94  41820010    beq 0x10030ca4                 ; -> 10030ca4
10030c98  7fe90734    extsh r9,r31                
10030c9c  2c09fae8    cmpwi r9,-0x518             
10030ca0  40820030    bne 0x10030cd0                 ; -> 10030cd0
10030ca4  8141006c    lwz r10,0x6c(r1)               ; -> Stack[-0x144]
10030ca8  81610070    lwz r11,0x70(r1)               ; -> Stack[-0x140]
10030cac  915e0000    stw r10,0x0(r30)            
10030cb0  917e0004    stw r11,0x4(r30)            
10030cb4  81810074    lwz r12,0x74(r1)               ; -> Stack[-0x13c]
10030cb8  80610078    lwz r3,0x78(r1)                ; -> Stack[-0x138]
10030cbc  919e0008    stw r12,0x8(r30)            
10030cc0  907e000c    stw r3,0xc(r30)             
10030cc4  a88101ce    lha r4,0x1ce(r1)               ; -> Stack[0x1e]
10030cc8  b082ffee    sth r4,-0x12(r2)               ; -> 1003415e
10030ccc  4800000c    b 0x10030cd8                   ; -> 10030cd8
10030cd0  38a00000    li r5,0x0                   
10030cd4  90be0000    stw r5,0x0(r30)             
10030cd8  80c1007c    lwz r6,0x7c(r1)                ; -> Stack[-0x134]
10030cdc  28060000    cmplwi r6,0x0               
10030ce0  41820010    beq 0x10030cf0                 ; -> 10030cf0
10030ce4  8061007c    lwz r3,0x7c(r1)                ; -> Stack[-0x134]
10030ce8  480008f9    bl 0x100315e0                  ; -> 100315e0
10030cec  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x19c]
10030cf0  7fe3fb78    or r3,r31,r31               
10030cf4  800101b8    lwz r0,0x1b8(r1)               ; -> Stack[0x8]
10030cf8  382101b0    addi r1,r1,0x1b0            
10030cfc  7c0803a6    mtspr LR,r0                 
10030d00  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10030d04  4e800020    blr                         
