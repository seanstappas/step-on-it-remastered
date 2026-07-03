; FUN_10028a0c @ 0x10028a0c
10028a0c  7c0802a6    mfspr r0,LR                 
10028a10  be01ffc0    stmw r16,-0x40(r1)             ; -> Stack[-0x40]
10028a14  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10028a18  9421ff70    stwu r1,-0x90(r1)              ; -> Stack[-0x90]
10028a1c  7c7f1b78    or r31,r3,r3                
10028a20  38600000    li r3,0x0                   
10028a24  3a026b9e    addi r16,r2,0x6b9e          
10028a28  3a225260    addi r17,r2,0x5260          
10028a2c  3ac27124    addi r22,r2,0x7124          
10028a30  3a826bf4    addi r20,r2,0x6bf4          
10028a34  3aa26bf0    addi r21,r2,0x6bf0          
10028a38  3bc26840    addi r30,r2,0x6840          
10028a3c  3ae26992    addi r23,r2,0x6992          
10028a40  3b026993    addi r24,r2,0x6993          
10028a44  b061003e    sth r3,0x3e(r1)                ; -> Stack[-0x52]
10028a48  4bff8515    bl 0x10020f5c                  ; -> 10020f5c
10028a4c  60000000    ori r0,r0,0x0               
10028a50  38800000    li r4,0x0                   
10028a54  98970000    stb r4,0x0(r23)             
10028a58  39200000    li r9,0x0                   
10028a5c  38c26991    addi r6,r2,0x6991           
10028a60  98980000    stb r4,0x0(r24)             
10028a64  38a00000    li r5,0x0                   
10028a68  39026990    addi r8,r2,0x6990           
10028a6c  98a60000    stb r5,0x0(r6)              
10028a70  38e00000    li r7,0x0                   
10028a74  39626994    addi r11,r2,0x6994          
10028a78  98e80000    stb r7,0x0(r8)              
10028a7c  39400000    li r10,0x0                  
10028a80  994b0000    stb r10,0x0(r11)            
10028a84  39800000    li r12,0x0                  
10028a88  91960000    stw r12,0x0(r22)            
10028a8c  88710000    lbz r3,0x0(r17)             
10028a90  99210044    stb r9,0x44(r1)                ; -> Stack[-0x4c]
10028a94  28030000    cmplwi r3,0x0               
10028a98  4182000c    beq 0x10028aa4                 ; -> 10028aa4
10028a9c  4bfef0cd    bl 0x10017b68                  ; -> 10017b68
10028aa0  60000000    ori r0,r0,0x0               
10028aa4  88900000    lbz r4,0x0(r16)             
10028aa8  28040000    cmplwi r4,0x0               
10028aac  4182001c    beq 0x10028ac8                 ; -> 10028ac8
10028ab0  88b10000    lbz r5,0x0(r17)             
10028ab4  28050000    cmplwi r5,0x0               
10028ab8  40820010    bne 0x10028ac8                 ; -> 10028ac8
10028abc  7fe3fb78    or r3,r31,r31               
10028ac0  4bfee1d1    bl 0x10016c90                  ; -> 10016c90
10028ac4  60000000    ori r0,r0,0x0               
10028ac8  38c00000    li r6,0x0                   
10028acc  98d10000    stb r6,0x0(r17)             
10028ad0  48005331    bl 0x1002de00                  ; -> 1002de00
10028ad4  60000000    ori r0,r0,0x0               
10028ad8  38e25332    addi r7,r2,0x5332           
10028adc  a8e70000    lha r7,0x0(r7)              
10028ae0  1ce70070    mulli r7,r7,0x70            
10028ae4  38e70038    addi r7,r7,0x38             
10028ae8  7c7e3aae    lhax r3,r30,r7              
10028aec  4bff019d    bl 0x10018c88                  ; -> 10018c88
10028af0  60000000    ori r0,r0,0x0               
10028af4  480088dd    bl 0x100313d0                  ; -> 100313d0
10028af8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10028afc  7c635670    srawi r3,r3,0xa             
10028b00  7c630194    addze r3,r3                 
10028b04  90610038    stw r3,0x38(r1)                ; -> Stack[-0x58]
10028b08  38600001    li r3,0x1                   
10028b0c  4bfefd21    bl 0x1001882c                  ; -> 1001882c
10028b10  60000000    ori r0,r0,0x0               
10028b14  480088bd    bl 0x100313d0                  ; -> 100313d0
10028b18  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10028b1c  7c635670    srawi r3,r3,0xa             
10028b20  7c630194    addze r3,r3                 
10028b24  39000000    li r8,0x0                   
10028b28  90610038    stw r3,0x38(r1)                ; -> Stack[-0x58]
10028b2c  91010040    stw r8,0x40(r1)                ; -> Stack[-0x50]
10028b30  4bfed4b5    bl 0x10015fe4                  ; -> 10015fe4
10028b34  60000000    ori r0,r0,0x0               
10028b38  7c7d1b78    or r29,r3,r3                
10028b3c  48000008    b 0x10028b44                   ; -> 10028b44
10028b40  3b600000    li r27,0x0                  
10028b44  4bfed4a1    bl 0x10015fe4                  ; -> 10015fe4
10028b48  60000000    ori r0,r0,0x0               
10028b4c  7c1d1800    cmpw r29,r3                 
10028b50  4182fff0    beq 0x10028b40                 ; -> 10028b40
10028b54  4bfed491    bl 0x10015fe4                  ; -> 10015fe4
10028b58  60000000    ori r0,r0,0x0               
10028b5c  7c7d1b78    or r29,r3,r3                
10028b60  48000010    b 0x10028b70                   ; -> 10028b70
10028b64  81210040    lwz r9,0x40(r1)                ; -> Stack[-0x50]
10028b68  39290001    addi r9,r9,0x1              
10028b6c  91210040    stw r9,0x40(r1)                ; -> Stack[-0x50]
10028b70  4bfed475    bl 0x10015fe4                  ; -> 10015fe4
10028b74  60000000    ori r0,r0,0x0               
10028b78  7c1d1800    cmpw r29,r3                 
10028b7c  4182ffe8    beq 0x10028b64                 ; -> 10028b64
10028b80  39400258    li r10,0x258                
10028b84  b141003c    sth r10,0x3c(r1)               ; -> Stack[-0x54]
10028b88  4bfed45d    bl 0x10015fe4                  ; -> 10015fe4
10028b8c  60000000    ori r0,r0,0x0               
10028b90  7c7d1b78    or r29,r3,r3                
10028b94  3c600001    lis r3,0x1                  
10028b98  3b200002    li r25,0x2                  
10028b9c  3863ffff    subi r3,r3,0x1              
10028ba0  38800000    li r4,0x0                   
10028ba4  480095c5    bl 0x10032168                  ; -> 10032168
10028ba8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10028bac  3b400000    li r26,0x0                  
10028bb0  7fe3fb78    or r3,r31,r31               
10028bb4  4bfe8ab9    bl 0x1001166c                  ; -> 1001166c
10028bb8  60000000    ori r0,r0,0x0               
10028bbc  7fe3fb78    or r3,r31,r31               
10028bc0  4bfe8a01    bl 0x100115c0                  ; -> 100115c0
10028bc4  60000000    ori r0,r0,0x0               
10028bc8  39823bde    addi r12,r2,0x3bde          
10028bcc  39600001    li r11,0x1                  
10028bd0  996c0000    stb r11,0x0(r12)            
10028bd4  480005c8    b 0x1002919c                   ; -> 1002919c
10028bd8  80760000    lwz r3,0x0(r22)             
10028bdc  3863ffff    subi r3,r3,0x1              
10028be0  2c030000    cmpwi r3,0x0                
10028be4  90760000    stw r3,0x0(r22)             
10028be8  40800048    bge 0x10028c30                 ; -> 10028c30
10028bec  7fe40734    extsh r4,r31                
10028bf0  2c040001    cmpwi r4,0x1                
10028bf4  40820020    bne 0x10028c14                 ; -> 10028c14
10028bf8  a87e0070    lha r3,0x70(r30)            
10028bfc  a89e0074    lha r4,0x74(r30)            
10028c00  38a007d0    li r5,0x7d0                 
10028c04  38c007d0    li r6,0x7d0                 
10028c08  4bfdc435    bl 0x1000503c                  ; -> 1000503c
10028c0c  60000000    ori r0,r0,0x0               
10028c10  48000070    b 0x10028c80                   ; -> 10028c80
10028c14  a8be00e0    lha r5,0xe0(r30)            
10028c18  a8de00e4    lha r6,0xe4(r30)            
10028c1c  386007d0    li r3,0x7d0                 
10028c20  388007d0    li r4,0x7d0                 
10028c24  4bfdc419    bl 0x1000503c                  ; -> 1000503c
10028c28  60000000    ori r0,r0,0x0               
10028c2c  48000054    b 0x10028c80                   ; -> 10028c80
10028c30  80b60000    lwz r5,0x0(r22)             
10028c34  54a507fe    rlwinm r5,r5,0x0,0x1f,0x1f  
10028c38  2c050000    cmpwi r5,0x0                
10028c3c  41820044    beq 0x10028c80                 ; -> 10028c80
10028c40  7fe60734    extsh r6,r31                
10028c44  2c060001    cmpwi r6,0x1                
10028c48  40820020    bne 0x10028c68                 ; -> 10028c68
10028c4c  a87e0070    lha r3,0x70(r30)            
10028c50  a89e0074    lha r4,0x74(r30)            
10028c54  38a007d0    li r5,0x7d0                 
10028c58  38c007d0    li r6,0x7d0                 
10028c5c  4bfdc3e1    bl 0x1000503c                  ; -> 1000503c
10028c60  60000000    ori r0,r0,0x0               
10028c64  4800001c    b 0x10028c80                   ; -> 10028c80
10028c68  a8be00e0    lha r5,0xe0(r30)            
10028c6c  a8de00e4    lha r6,0xe4(r30)            
10028c70  386007d0    li r3,0x7d0                 
10028c74  388007d0    li r4,0x7d0                 
10028c78  4bfdc3c5    bl 0x1000503c                  ; -> 1000503c
10028c7c  60000000    ori r0,r0,0x0               
10028c80  3b39ffff    subi r25,r25,0x1            
10028c84  7f270734    extsh r7,r25                
10028c88  2c070000    cmpwi r7,0x0                
10028c8c  41810060    bgt 0x10028cec                 ; -> 10028cec
10028c90  7fe80734    extsh r8,r31                
10028c94  1d080070    mulli r8,r8,0x70            
10028c98  3908005c    addi r8,r8,0x5c             
10028c9c  7d1e42ae    lhax r8,r30,r8              
10028ca0  3b200002    li r25,0x2                  
10028ca4  2c080001    cmpwi r8,0x1                
10028ca8  40820008    bne 0x10028cb0                 ; -> 10028cb0
10028cac  3b39ffff    subi r25,r25,0x1            
10028cb0  48004791    bl 0x1002d440                  ; -> 1002d440
10028cb4  60000000    ori r0,r0,0x0               
10028cb8  7fe3fb78    or r3,r31,r31               
10028cbc  4bfe89b1    bl 0x1001166c                  ; -> 1001166c
10028cc0  60000000    ori r0,r0,0x0               
10028cc4  7fe90734    extsh r9,r31                
10028cc8  1d290070    mulli r9,r9,0x70            
10028ccc  39290028    addi r9,r9,0x28             
10028cd0  7d3e48ae    lbzx r9,r30,r9              
10028cd4  28090000    cmplwi r9,0x0               
10028cd8  40820038    bne 0x10028d10                 ; -> 10028d10
10028cdc  7fe3fb78    or r3,r31,r31               
10028ce0  48002f85    bl 0x1002bc64                  ; -> 1002bc64
10028ce4  60000000    ori r0,r0,0x0               
10028ce8  48000028    b 0x10028d10                   ; -> 10028d10
10028cec  7fea0734    extsh r10,r31               
10028cf0  1d4a0070    mulli r10,r10,0x70          
10028cf4  394a0028    addi r10,r10,0x28           
10028cf8  7d5e50ae    lbzx r10,r30,r10            
10028cfc  280a0000    cmplwi r10,0x0              
10028d00  41820010    beq 0x10028d10                 ; -> 10028d10
10028d04  7fe3fb78    or r3,r31,r31               
10028d08  4bfe8965    bl 0x1001166c                  ; -> 1001166c
10028d0c  60000000    ori r0,r0,0x0               
10028d10  4bfefe89    bl 0x10018b98                  ; -> 10018b98
10028d14  60000000    ori r0,r0,0x0               
10028d18  3b800000    li r28,0x0                  
10028d1c  48000008    b 0x10028d24                   ; -> 10028d24
10028d20  3b9c0001    addi r28,r28,0x1            
10028d24  4bff0685    bl 0x100193a8                  ; -> 100193a8
10028d28  60000000    ori r0,r0,0x0               
10028d2c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10028d30  28030000    cmplwi r3,0x0               
10028d34  4182ffec    beq 0x10028d20                 ; -> 10028d20
10028d38  4bff0691    bl 0x100193c8                  ; -> 100193c8
10028d3c  60000000    ori r0,r0,0x0               
10028d40  39626994    addi r11,r2,0x6994          
10028d44  896b0000    lbz r11,0x0(r11)            
10028d48  280b0000    cmplwi r11,0x0              
10028d4c  41820028    beq 0x10028d74                 ; -> 10028d74
10028d50  48008279    bl 0x10030fc8                  ; -> 10030fc8
10028d54  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10028d58  3ba3000a    addi r29,r3,0xa             
10028d5c  48000008    b 0x10028d64                   ; -> 10028d64
10028d60  3b600000    li r27,0x0                  
10028d64  48008265    bl 0x10030fc8                  ; -> 10030fc8
10028d68  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10028d6c  7c1d1840    cmplw r29,r3                
10028d70  4181fff0    bgt 0x10028d60                 ; -> 10028d60
10028d74  81950000    lwz r12,0x0(r21)            
10028d78  38626bec    addi r3,r2,0x6bec           
10028d7c  91830000    stw r12,0x0(r3)             
10028d80  80940000    lwz r4,0x0(r20)             
10028d84  90950000    stw r4,0x0(r21)             
10028d88  93940000    stw r28,0x0(r20)            
10028d8c  4bfed9f9    bl 0x10016784                  ; -> 10016784
10028d90  60000000    ori r0,r0,0x0               
10028d94  4bfffbc5    bl 0x10028958                  ; -> 10028958
10028d98  4bfdb3e9    bl 0x10004180                  ; -> 10004180
10028d9c  60000000    ori r0,r0,0x0               
10028da0  4bfe6761    bl 0x1000f500                  ; -> 1000f500
10028da4  60000000    ori r0,r0,0x0               
10028da8  7fe50734    extsh r5,r31                
10028dac  1ca50070    mulli r5,r5,0x70            
10028db0  7c7e2a14    add r3,r30,r5               
10028db4  7fe4fb78    or r4,r31,r31               
10028db8  4bfe6fa5    bl 0x1000fd5c                  ; -> 1000fd5c
10028dbc  60000000    ori r0,r0,0x0               
10028dc0  4bfff2a1    bl 0x10028060                  ; -> 10028060
10028dc4  4bfff5dd    bl 0x100283a0                  ; -> 100283a0
10028dc8  4bfe61ed    bl 0x1000efb4                  ; -> 1000efb4
10028dcc  60000000    ori r0,r0,0x0               
10028dd0  4bfdbf45    bl 0x10004d14                  ; -> 10004d14
10028dd4  60000000    ori r0,r0,0x0               
10028dd8  7fe60734    extsh r6,r31                
10028ddc  1cc60070    mulli r6,r6,0x70            
10028de0  38c6003a    addi r6,r6,0x3a             
10028de4  7cde30ae    lbzx r6,r30,r6              
10028de8  28060000    cmplwi r6,0x0               
10028dec  408200a4    bne 0x10028e90                 ; -> 10028e90
10028df0  7fe70734    extsh r7,r31                
10028df4  7fea0734    extsh r10,r31               
10028df8  1ce70070    mulli r7,r7,0x70            
10028dfc  1d4a0070    mulli r10,r10,0x70          
10028e00  7feb0734    extsh r11,r31               
10028e04  1d6b0070    mulli r11,r11,0x70          
10028e08  38e7000a    addi r7,r7,0xa              
10028e0c  394a0016    addi r10,r10,0x16           
10028e10  7fe90734    extsh r9,r31                
10028e14  7cde52ae    lhax r6,r30,r10             
10028e18  1d290070    mulli r9,r9,0x70            
10028e1c  7fe80734    extsh r8,r31                
10028e20  7fea0734    extsh r10,r31               
10028e24  1d080070    mulli r8,r8,0x70            
10028e28  1d4a0070    mulli r10,r10,0x70          
10028e2c  7fec0734    extsh r12,r31               
10028e30  1d8c0070    mulli r12,r12,0x70          
10028e34  39290014    addi r9,r9,0x14             
10028e38  39080018    addi r8,r8,0x18             
10028e3c  7c7e382e    lwzx r3,r30,r7              
10028e40  396b0006    addi r11,r11,0x6            
10028e44  7cfe582e    lwzx r7,r30,r11             
10028e48  7cbe4aae    lhax r5,r30,r9              
10028e4c  7feb0734    extsh r11,r31               
10028e50  1d6b0070    mulli r11,r11,0x70          
10028e54  394a0002    addi r10,r10,0x2            
10028e58  7c9e42ae    lhax r4,r30,r8              
10028e5c  398c000e    addi r12,r12,0xe            
10028e60  7d3e52ae    lhax r9,r30,r10             
10028e64  396b0004    addi r11,r11,0x4            
10028e68  7d1e62ae    lhax r8,r30,r12             
10028e6c  7d5e5aae    lhax r10,r30,r11            
10028e70  4bfdb531    bl 0x100043a0                  ; -> 100043a0
10028e74  60000000    ori r0,r0,0x0               
10028e78  7fe3fb78    or r3,r31,r31               
10028e7c  4bfe8745    bl 0x100115c0                  ; -> 100115c0
10028e80  60000000    ori r0,r0,0x0               
10028e84  7fe3fb78    or r3,r31,r31               
10028e88  4bfebb89    bl 0x10014a10                  ; -> 10014a10
10028e8c  60000000    ori r0,r0,0x0               
10028e90  a981003e    lha r12,0x3e(r1)               ; -> Stack[-0x52]
10028e94  b181003c    sth r12,0x3c(r1)               ; -> Stack[-0x54]
10028e98  4bfffb29    bl 0x100289c0                  ; -> 100289c0
10028e9c  7fe30734    extsh r3,r31                
10028ea0  1c630070    mulli r3,r3,0x70            
10028ea4  38630028    addi r3,r3,0x28             
10028ea8  7c7e18ae    lbzx r3,r30,r3              
10028eac  28030000    cmplwi r3,0x0               
10028eb0  408200d0    bne 0x10028f80                 ; -> 10028f80
10028eb4  7fe3fb78    or r3,r31,r31               
10028eb8  48000afd    bl 0x100299b4                  ; -> 100299b4
10028ebc  60000000    ori r0,r0,0x0               
10028ec0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10028ec4  28030000    cmplwi r3,0x0               
10028ec8  4182003c    beq 0x10028f04                 ; -> 10028f04
10028ecc  7fe40734    extsh r4,r31                
10028ed0  1c840070    mulli r4,r4,0x70            
10028ed4  3884005c    addi r4,r4,0x5c             
10028ed8  7c9e22ae    lhax r4,r30,r4              
10028edc  2c040002    cmpwi r4,0x2                
10028ee0  418200a0    beq 0x10028f80                 ; -> 10028f80
10028ee4  7fe3fb78    or r3,r31,r31               
10028ee8  4bfe9341    bl 0x10012228                  ; -> 10012228
10028eec  60000000    ori r0,r0,0x0               
10028ef0  7fe3fb78    or r3,r31,r31               
10028ef4  3880ffff    li r4,-0x1                  
10028ef8  4bfe5ad1    bl 0x1000e9c8                  ; -> 1000e9c8
10028efc  60000000    ori r0,r0,0x0               
10028f00  48000080    b 0x10028f80                   ; -> 10028f80
10028f04  38a26990    addi r5,r2,0x6990           
10028f08  88a50000    lbz r5,0x0(r5)              
10028f0c  28050000    cmplwi r5,0x0               
10028f10  41820044    beq 0x10028f54                 ; -> 10028f54
10028f14  7fe3fb78    or r3,r31,r31               
10028f18  4bfe9311    bl 0x10012228                  ; -> 10012228
10028f1c  60000000    ori r0,r0,0x0               
10028f20  7fe60734    extsh r6,r31                
10028f24  1cc60070    mulli r6,r6,0x70            
10028f28  38c60046    addi r6,r6,0x46             
10028f2c  7cde32ae    lhax r6,r30,r6              
10028f30  7fe3fb78    or r3,r31,r31               
10028f34  38c60001    addi r6,r6,0x1              
10028f38  7c8600d0    neg r4,r6                   
10028f3c  4bfe5a8d    bl 0x1000e9c8                  ; -> 1000e9c8
10028f40  60000000    ori r0,r0,0x0               
10028f44  39025262    addi r8,r2,0x5262           
10028f48  38e00001    li r7,0x1                   
10028f4c  98e80000    stb r7,0x0(r8)              
10028f50  48000030    b 0x10028f80                   ; -> 10028f80
10028f54  39226991    addi r9,r2,0x6991           
10028f58  89290000    lbz r9,0x0(r9)              
10028f5c  28090000    cmplwi r9,0x0               
10028f60  41820020    beq 0x10028f80                 ; -> 10028f80
10028f64  7fe3fb78    or r3,r31,r31               
10028f68  4bfe92c1    bl 0x10012228                  ; -> 10012228
10028f6c  60000000    ori r0,r0,0x0               
10028f70  7fe3fb78    or r3,r31,r31               
10028f74  3880ffff    li r4,-0x1                  
10028f78  4bfe5a51    bl 0x1000e9c8                  ; -> 1000e9c8
10028f7c  60000000    ori r0,r0,0x0               
10028f80  89510000    lbz r10,0x0(r17)            
10028f84  280a0000    cmplwi r10,0x0              
10028f88  4182000c    beq 0x10028f94                 ; -> 10028f94
10028f8c  4bffe0f1    bl 0x1002707c                  ; -> 1002707c
10028f90  3b400001    li r26,0x1                  
10028f94  7fec0734    extsh r12,r31               
10028f98  1d8c0070    mulli r12,r12,0x70          
10028f9c  3962712c    addi r11,r2,0x712c          
10028fa0  398c0038    addi r12,r12,0x38           
10028fa4  a96b0000    lha r11,0x0(r11)            
10028fa8  7d9e62ae    lhax r12,r30,r12            
10028fac  7d6b0734    extsh r11,r11               
10028fb0  7c0b6000    cmpw r11,r12                
10028fb4  40810038    ble 0x10028fec                 ; -> 10028fec
10028fb8  88780000    lbz r3,0x0(r24)             
10028fbc  28030000    cmplwi r3,0x0               
10028fc0  4182002c    beq 0x10028fec                 ; -> 10028fec
10028fc4  7fe50734    extsh r5,r31                
10028fc8  1ca50070    mulli r5,r5,0x70            
10028fcc  7fe70734    extsh r7,r31                
10028fd0  1ce70070    mulli r7,r7,0x70            
10028fd4  38800001    li r4,0x1                   
10028fd8  38a50029    addi r5,r5,0x29             
10028fdc  7c9e29ae    stbx r4,r30,r5              
10028fe0  38c00001    li r6,0x1                   
10028fe4  38e7002b    addi r7,r7,0x2b             
10028fe8  7cde39ae    stbx r6,r30,r7              
10028fec  7fe80734    extsh r8,r31                
10028ff0  1d080070    mulli r8,r8,0x70            
10028ff4  39080038    addi r8,r8,0x38             
10028ff8  7d1e42ae    lhax r8,r30,r8              
10028ffc  2c080001    cmpwi r8,0x1                
10029000  40810050    ble 0x10029050                 ; -> 10029050
10029004  89370000    lbz r9,0x0(r23)             
10029008  28090000    cmplwi r9,0x0               
1002900c  41820044    beq 0x10029050                 ; -> 10029050
10029010  7feb0734    extsh r11,r31               
10029014  1d6b0070    mulli r11,r11,0x70          
10029018  7fec0734    extsh r12,r31               
1002901c  1d8c0070    mulli r12,r12,0x70          
10029020  7fe50734    extsh r5,r31                
10029024  1ca50070    mulli r5,r5,0x70            
10029028  39400001    li r10,0x1                  
1002902c  396b002b    addi r11,r11,0x2b           
10029030  7d5e59ae    stbx r10,r30,r11            
10029034  398c0038    addi r12,r12,0x38           
10029038  7c7e62ae    lhax r3,r30,r12             
1002903c  38800001    li r4,0x1                   
10029040  3863fffe    subi r3,r3,0x2              
10029044  7c7e632e    sthx r3,r30,r12             
10029048  38a50029    addi r5,r5,0x29             
1002904c  7c9e29ae    stbx r4,r30,r5              
10029050  7fe60734    extsh r6,r31                
10029054  1cc60070    mulli r6,r6,0x70            
10029058  38c60029    addi r6,r6,0x29             
1002905c  7cde30ae    lbzx r6,r30,r6              
10029060  28060000    cmplwi r6,0x0               
10029064  4182011c    beq 0x10029180                 ; -> 10029180
10029068  38600014    li r3,0x14                  
1002906c  4bfef6d1    bl 0x1001873c                  ; -> 1001873c
10029070  60000000    ori r0,r0,0x0               
10029074  7fe80734    extsh r8,r31                
10029078  1d080070    mulli r8,r8,0x70            
1002907c  7fe90734    extsh r9,r31                
10029080  1d290070    mulli r9,r9,0x70            
10029084  7fec0734    extsh r12,r31               
10029088  7feb0734    extsh r11,r31               
1002908c  1d8c0070    mulli r12,r12,0x70          
10029090  38e00001    li r7,0x1                   
10029094  3908003a    addi r8,r8,0x3a             
10029098  7cfe41ae    stbx r7,r30,r8              
1002909c  39290038    addi r9,r9,0x38             
100290a0  7d5e4aae    lhax r10,r30,r9             
100290a4  1d6b0070    mulli r11,r11,0x70          
100290a8  394a0001    addi r10,r10,0x1            
100290ac  7d5e4b2e    sthx r10,r30,r9             
100290b0  398c0004    addi r12,r12,0x4            
100290b4  7d7e5aae    lhax r11,r30,r11            
100290b8  7d9e62ae    lhax r12,r30,r12            
100290bc  3a6b000c    addi r19,r11,0xc            
100290c0  3a4c0010    addi r18,r12,0x10           
100290c4  3860001f    li r3,0x1f                  
100290c8  38800064    li r4,0x64                  
100290cc  48001f55    bl 0x1002b020                  ; -> 1002b020
100290d0  60000000    ori r0,r0,0x0               
100290d4  4bfff885    bl 0x10028958                  ; -> 10028958
100290d8  7fe50734    extsh r5,r31                
100290dc  1ca50070    mulli r5,r5,0x70            
100290e0  7fe60734    extsh r6,r31                
100290e4  38826bc4    addi r4,r2,0x6bc4           
100290e8  1cc60070    mulli r6,r6,0x70            
100290ec  7fe70734    extsh r7,r31                
100290f0  1ce70070    mulli r7,r7,0x70            
100290f4  80640004    lwz r3,0x4(r4)              
100290f8  38a50018    addi r5,r5,0x18             
100290fc  7c9e2aae    lhax r4,r30,r5              
10029100  38c60014    addi r6,r6,0x14             
10029104  7cbe32ae    lhax r5,r30,r6              
10029108  38e70016    addi r7,r7,0x16             
1002910c  7cde3aae    lhax r6,r30,r7              
10029110  4bfdbba1    bl 0x10004cb0                  ; -> 10004cb0
10029114  60000000    ori r0,r0,0x0               
10029118  7fe3fb78    or r3,r31,r31               
1002911c  4bfeb825    bl 0x10014940                  ; -> 10014940
10029120  60000000    ori r0,r0,0x0               
10029124  4bfff89d    bl 0x100289c0                  ; -> 100289c0
10029128  7e639b78    or r3,r19,r19               
1002912c  7e449378    or r4,r18,r18               
10029130  38a00001    li r5,0x1                   
10029134  38c00002    li r6,0x2                   
10029138  4bffda81    bl 0x10026bb8                  ; -> 10026bb8
1002913c  89180000    lbz r8,0x0(r24)             
10029140  28080000    cmplwi r8,0x0               
10029144  40820010    bne 0x10029154                 ; -> 10029154
10029148  89370000    lbz r9,0x0(r23)             
1002914c  28090000    cmplwi r9,0x0               
10029150  41820018    beq 0x10029168                 ; -> 10029168
10029154  7feb0734    extsh r11,r31               
10029158  1d6b0070    mulli r11,r11,0x70          
1002915c  39400000    li r10,0x0                  
10029160  396b003c    addi r11,r11,0x3c           
10029164  7d5e592e    stwx r10,r30,r11            
10029168  89900000    lbz r12,0x0(r16)            
1002916c  280c0000    cmplwi r12,0x0              
10029170  40820010    bne 0x10029180                 ; -> 10029180
10029174  7fe3fb78    or r3,r31,r31               
10029178  4bfec259    bl 0x100153d0                  ; -> 100153d0
1002917c  60000000    ori r0,r0,0x0               
10029180  7fe30734    extsh r3,r31                
10029184  1c630070    mulli r3,r3,0x70            
10029188  3863003a    addi r3,r3,0x3a             
1002918c  7c7e18ae    lbzx r3,r30,r3              
10029190  28030000    cmplwi r3,0x0               
10029194  41820008    beq 0x1002919c                 ; -> 1002919c
10029198  3b400001    li r26,0x1                  
1002919c  5744063e    rlwinm r4,r26,0x0,0x18,0x1f 
100291a0  28040000    cmplwi r4,0x0               
100291a4  4182fa34    beq 0x10028bd8                 ; -> 10028bd8
100291a8  88b10000    lbz r5,0x0(r17)             
100291ac  28050000    cmplwi r5,0x0               
100291b0  40820080    bne 0x10029230                 ; -> 10029230
100291b4  88d00000    lbz r6,0x0(r16)             
100291b8  28060000    cmplwi r6,0x0               
100291bc  41820074    beq 0x10029230                 ; -> 10029230
100291c0  38e25262    addi r7,r2,0x5262           
100291c4  88e70000    lbz r7,0x0(r7)              
100291c8  28070000    cmplwi r7,0x0               
100291cc  40820064    bne 0x10029230                 ; -> 10029230
100291d0  7fe80734    extsh r8,r31                
100291d4  1d080070    mulli r8,r8,0x70            
100291d8  39080029    addi r8,r8,0x29             
100291dc  7d1e40ae    lbzx r8,r30,r8              
100291e0  28080000    cmplwi r8,0x0               
100291e4  4082001c    bne 0x10029200                 ; -> 10029200
100291e8  7fe90734    extsh r9,r31                
100291ec  1d290070    mulli r9,r9,0x70            
100291f0  39290038    addi r9,r9,0x38             
100291f4  7d5e4aae    lhax r10,r30,r9             
100291f8  394a0001    addi r10,r10,0x1            
100291fc  7d5e4b2e    sthx r10,r30,r9             
10029200  7fec0734    extsh r12,r31               
10029204  1d8c0070    mulli r12,r12,0x70          
10029208  398c0029    addi r12,r12,0x29           
1002920c  7d9e60ae    lbzx r12,r30,r12            
10029210  39600000    li r11,0x0                  
10029214  280c0000    cmplwi r12,0x0              
10029218  40820008    bne 0x10029220                 ; -> 10029220
1002921c  39600001    li r11,0x1                  
10029220  7d635b78    or r3,r11,r11               
10029224  7fe4fb78    or r4,r31,r31               
10029228  4bfedd59    bl 0x10016f80                  ; -> 10016f80
1002922c  60000000    ori r0,r0,0x0               
10029230  38600014    li r3,0x14                  
10029234  4bfef509    bl 0x1001873c                  ; -> 1001873c
10029238  60000000    ori r0,r0,0x0               
1002923c  3c600001    lis r3,0x1                  
10029240  3863ffff    subi r3,r3,0x1              
10029244  38800000    li r4,0x0                   
10029248  48008f21    bl 0x10032168                  ; -> 10032168
1002924c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
10029250  80010098    lwz r0,0x98(r1)                ; -> Stack[0x8]
10029254  38210090    addi r1,r1,0x90             
10029258  7c0803a6    mtspr LR,r0                 
1002925c  ba01ffc0    lmw r16,-0x40(r1)              ; -> Stack[-0x40]
10029260  4e800020    blr                         
