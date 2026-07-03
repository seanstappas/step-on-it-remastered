; .PBCatSearchSyncCompat @ 0x1003098c
1003098c  7c0802a6    mfspr r0,LR                 
10030990  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10030994  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10030998  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1003099c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100309a0  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
100309a4  7c7e1b78    or r30,r3,r3                
100309a8  3be00000    li r31,0x0                  
100309ac  8862fff2    lbz r3,-0xe(r2)                ; -> 10034162
100309b0  28030000    cmplwi r3,0x0               
100309b4  40820040    bne 0x100309f4                 ; -> 100309f4
100309b8  38800001    li r4,0x1                   
100309bc  9882fff2    stb r4,-0xe(r2)                ; -> 10034162
100309c0  3c606673    lis r3,0x6673               
100309c4  38632020    addi r3,r3,0x2020           
100309c8  38810050    addi r4,r1,0x50             
100309cc  4800098d    bl 0x10031358                  ; -> 10031358
100309d0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
100309d4  7c630735    extsh. r3,r3                
100309d8  4082001c    bne 0x100309f4                 ; -> 100309f4
100309dc  80a10050    lwz r5,0x50(r1)                ; -> Stack[-0x20]
100309e0  54a507ff    rlwinm. r5,r5,0x0,0x1f,0x1f 
100309e4  7cc00026    mfcr r6                     
100309e8  54c61ffe    rlwinm r6,r6,0x3,0x1f,0x1f  
100309ec  68c60001    xori r6,r6,0x1              
100309f0  98c2fff0    stb r6,-0x10(r2)               ; -> 10034160
100309f4  3ba00000    li r29,0x0                  
100309f8  88e2fff0    lbz r7,-0x10(r2)               ; -> 10034160
100309fc  28070000    cmplwi r7,0x0               
10030a00  41820044    beq 0x10030a44                 ; -> 10030a44
10030a04  39000014    li r8,0x14                  
10030a08  91010038    stw r8,0x38(r1)                ; -> Stack[-0x38]
10030a0c  807e0012    lwz r3,0x12(r30)            
10030a10  a89e0016    lha r4,0x16(r30)            
10030a14  38a1003c    addi r5,r1,0x3c             
10030a18  38c10038    addi r6,r1,0x38             
10030a1c  4bffee89    bl 0x1002f8a4                  ; -> 1002f8a4
10030a20  60000000    ori r0,r0,0x0               
10030a24  7c7f1b78    or r31,r3,r3                
10030a28  7fe90735    extsh. r9,r31               
10030a2c  40820018    bne 0x10030a44                 ; -> 10030a44
10030a30  8141003e    lwz r10,0x3e(r1)               ; -> Stack[-0x32]
10030a34  554a0631    rlwinm. r10,r10,0x0,0x18,0x18
10030a38  7d600026    mfcr r11                    
10030a3c  556b1ffe    rlwinm r11,r11,0x3,0x1f,0x1f
10030a40  697d0001    xori r29,r11,0x1            
10030a44  7fec0735    extsh. r12,r31              
10030a48  41820010    beq 0x10030a58                 ; -> 10030a58
10030a4c  7fe30734    extsh r3,r31                
10030a50  2c03ffce    cmpwi r3,-0x32              
10030a54  40820030    bne 0x10030a84                 ; -> 10030a84
10030a58  57a4063f    rlwinm. r4,r29,0x0,0x18,0x1f
10030a5c  41820018    beq 0x10030a74                 ; -> 10030a74
10030a60  7fc3f378    or r3,r30,r30               
10030a64  48000a75    bl 0x100314d8                  ; -> 100314d8
10030a68  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10030a6c  7c7f1b78    or r31,r3,r3                
10030a70  48000014    b 0x10030a84                   ; -> 10030a84
10030a74  7fc3f378    or r3,r30,r30               
10030a78  38800002    li r4,0x2                   
10030a7c  4bfffa6d    bl 0x100304e8                  ; -> 100304e8
10030a80  7c7f1b78    or r31,r3,r3                
10030a84  7fe3fb78    or r3,r31,r31               
10030a88  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
10030a8c  38210070    addi r1,r1,0x70             
10030a90  7c0803a6    mtspr LR,r0                 
10030a94  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10030a98  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10030a9c  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10030aa0  4e800020    blr                         
