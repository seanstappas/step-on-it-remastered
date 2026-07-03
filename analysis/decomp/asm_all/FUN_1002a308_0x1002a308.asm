; FUN_1002a308 @ 0x1002a308
1002a308  7c0802a6    mfspr r0,LR                 
1002a30c  be01ffc0    stmw r16,-0x40(r1)             ; -> Stack[-0x40]
1002a310  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002a314  9421ff80    stwu r1,-0x80(r1)              ; -> Stack[-0x80]
1002a318  3a425262    addi r18,r2,0x5262          
1002a31c  3b026b9e    addi r24,r2,0x6b9e          
1002a320  3a627124    addi r19,r2,0x7124          
1002a324  3be26840    addi r31,r2,0x6840          
1002a328  3a826990    addi r20,r2,0x6990          
1002a32c  3aa26991    addi r21,r2,0x6991          
1002a330  3a026bc4    addi r16,r2,0x6bc4          
1002a334  3b222f74    addi r25,r2,0x2f74          
1002a338  4bff6c25    bl 0x10020f5c                  ; -> 10020f5c
1002a33c  60000000    ori r0,r0,0x0               
1002a340  38600000    li r3,0x0                   
1002a344  3ca00001    lis r5,0x1                  
1002a348  98750000    stb r3,0x0(r21)             
1002a34c  38800000    li r4,0x0                   
1002a350  38c270ec    addi r6,r2,0x70ec           
1002a354  98940000    stb r4,0x0(r20)             
1002a358  38a5ffff    subi r5,r5,0x1              
1002a35c  38e270ec    addi r7,r2,0x70ec           
1002a360  b0a60004    sth r5,0x4(r6)              
1002a364  390270ec    addi r8,r2,0x70ec           
1002a368  b0a70002    sth r5,0x2(r7)              
1002a36c  b0a80000    sth r5,0x0(r8)              
1002a370  39200000    li r9,0x0                   
1002a374  39425260    addi r10,r2,0x5260          
1002a378  91330000    stw r9,0x0(r19)             
1002a37c  894a0000    lbz r10,0x0(r10)            
1002a380  280a0000    cmplwi r10,0x0              
1002a384  4182000c    beq 0x1002a390                 ; -> 1002a390
1002a388  4bfed7e1    bl 0x10017b68                  ; -> 10017b68
1002a38c  60000000    ori r0,r0,0x0               
1002a390  89780000    lbz r11,0x0(r24)            
1002a394  280b0000    cmplwi r11,0x0              
1002a398  41820020    beq 0x1002a3b8                 ; -> 1002a3b8
1002a39c  39825260    addi r12,r2,0x5260          
1002a3a0  898c0000    lbz r12,0x0(r12)            
1002a3a4  280c0000    cmplwi r12,0x0              
1002a3a8  40820010    bne 0x1002a3b8                 ; -> 1002a3b8
1002a3ac  38600001    li r3,0x1                   
1002a3b0  4bfec8e1    bl 0x10016c90                  ; -> 10016c90
1002a3b4  60000000    ori r0,r0,0x0               
1002a3b8  48003a49    bl 0x1002de00                  ; -> 1002de00
1002a3bc  60000000    ori r0,r0,0x0               
1002a3c0  38825332    addi r4,r2,0x5332           
1002a3c4  a8840000    lha r4,0x0(r4)              
1002a3c8  1c840070    mulli r4,r4,0x70            
1002a3cc  38840038    addi r4,r4,0x38             
1002a3d0  7c7f22ae    lhax r3,r31,r4              
1002a3d4  4bfee8b5    bl 0x10018c88                  ; -> 10018c88
1002a3d8  60000000    ori r0,r0,0x0               
1002a3dc  38600001    li r3,0x1                   
1002a3e0  4bfee44d    bl 0x1001882c                  ; -> 1001882c
1002a3e4  60000000    ori r0,r0,0x0               
1002a3e8  38a00001    li r5,0x1                   
1002a3ec  98bf011a    stb r5,0x11a(r31)           
1002a3f0  98bf00aa    stb r5,0xaa(r31)            
1002a3f4  38c00000    li r6,0x0                   
1002a3f8  98df010a    stb r6,0x10a(r31)           
1002a3fc  98df009a    stb r6,0x9a(r31)            
1002a400  88ff00b8    lbz r7,0xb8(r31)            
1002a404  28070000    cmplwi r7,0x0               
1002a408  41820014    beq 0x1002a41c                 ; -> 1002a41c
1002a40c  39000000    li r8,0x0                   
1002a410  991f00aa    stb r8,0xaa(r31)            
1002a414  39200001    li r9,0x1                   
1002a418  993f009a    stb r9,0x9a(r31)            
1002a41c  895f0128    lbz r10,0x128(r31)          
1002a420  280a0000    cmplwi r10,0x0              
1002a424  41820014    beq 0x1002a438                 ; -> 1002a438
1002a428  39600000    li r11,0x0                  
1002a42c  997f011a    stb r11,0x11a(r31)          
1002a430  39800001    li r12,0x1                  
1002a434  999f010a    stb r12,0x10a(r31)          
1002a438  38600000    li r3,0x0                   
1002a43c  9061003c    stw r3,0x3c(r1)                ; -> Stack[-0x44]
1002a440  4bfebba5    bl 0x10015fe4                  ; -> 10015fe4
1002a444  60000000    ori r0,r0,0x0               
1002a448  7c761b78    or r22,r3,r3                
1002a44c  4800000c    b 0x1002a458                   ; -> 1002a458
1002a450  38800000    li r4,0x0                   
1002a454  b0810038    sth r4,0x38(r1)                ; -> Stack[-0x48]
1002a458  4bfebb8d    bl 0x10015fe4                  ; -> 10015fe4
1002a45c  60000000    ori r0,r0,0x0               
1002a460  7c161800    cmpw r22,r3                 
1002a464  4182ffec    beq 0x1002a450                 ; -> 1002a450
1002a468  4bfebb7d    bl 0x10015fe4                  ; -> 10015fe4
1002a46c  60000000    ori r0,r0,0x0               
1002a470  7c761b78    or r22,r3,r3                
1002a474  48000010    b 0x1002a484                   ; -> 1002a484
1002a478  80a1003c    lwz r5,0x3c(r1)                ; -> Stack[-0x44]
1002a47c  38a50001    addi r5,r5,0x1              
1002a480  90a1003c    stw r5,0x3c(r1)                ; -> Stack[-0x44]
1002a484  4bfebb61    bl 0x10015fe4                  ; -> 10015fe4
1002a488  60000000    ori r0,r0,0x0               
1002a48c  7c161800    cmpw r22,r3                 
1002a490  4182ffe8    beq 0x1002a478                 ; -> 1002a478
1002a494  38c00258    li r6,0x258                 
1002a498  b0c1003a    sth r6,0x3a(r1)                ; -> Stack[-0x46]
1002a49c  4bfebb49    bl 0x10015fe4                  ; -> 10015fe4
1002a4a0  60000000    ori r0,r0,0x0               
1002a4a4  7c761b78    or r22,r3,r3                
1002a4a8  3c600001    lis r3,0x1                  
1002a4ac  39026994    addi r8,r2,0x6994           
1002a4b0  38e00000    li r7,0x0                   
1002a4b4  39425260    addi r10,r2,0x5260          
1002a4b8  98e80000    stb r7,0x0(r8)              
1002a4bc  39200000    li r9,0x0                   
1002a4c0  992a0000    stb r9,0x0(r10)             
1002a4c4  3863ffff    subi r3,r3,0x1              
1002a4c8  38800000    li r4,0x0                   
1002a4cc  48007c9d    bl 0x10032168                  ; -> 10032168
1002a4d0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002a4d4  3a200002    li r17,0x2                  
1002a4d8  3ae00000    li r23,0x0                  
1002a4dc  38600001    li r3,0x1                   
1002a4e0  4bfe718d    bl 0x1001166c                  ; -> 1001166c
1002a4e4  60000000    ori r0,r0,0x0               
1002a4e8  38600001    li r3,0x1                   
1002a4ec  4bfe70d5    bl 0x100115c0                  ; -> 100115c0
1002a4f0  60000000    ori r0,r0,0x0               
1002a4f4  38600002    li r3,0x2                   
1002a4f8  4bfe7175    bl 0x1001166c                  ; -> 1001166c
1002a4fc  60000000    ori r0,r0,0x0               
1002a500  38600002    li r3,0x2                   
1002a504  4bfe70bd    bl 0x100115c0                  ; -> 100115c0
1002a508  60000000    ori r0,r0,0x0               
1002a50c  39823bde    addi r12,r2,0x3bde          
1002a510  39600001    li r11,0x1                  
1002a514  996c0000    stb r11,0x0(r12)            
1002a518  4800096c    b 0x1002ae84                   ; -> 1002ae84
1002a51c  80730000    lwz r3,0x0(r19)             
1002a520  3863ffff    subi r3,r3,0x1              
1002a524  2c030000    cmpwi r3,0x0                
1002a528  90730000    stw r3,0x0(r19)             
1002a52c  40800070    bge 0x1002a59c                 ; -> 1002a59c
1002a530  889f00aa    lbz r4,0xaa(r31)            
1002a534  28040000    cmplwi r4,0x0               
1002a538  41820020    beq 0x1002a558                 ; -> 1002a558
1002a53c  a8bf00e0    lha r5,0xe0(r31)            
1002a540  a8df00e4    lha r6,0xe4(r31)            
1002a544  386007d0    li r3,0x7d0                 
1002a548  388007d0    li r4,0x7d0                 
1002a54c  4bfdaaf1    bl 0x1000503c                  ; -> 1000503c
1002a550  60000000    ori r0,r0,0x0               
1002a554  480000c0    b 0x1002a614                   ; -> 1002a614
1002a558  88bf011a    lbz r5,0x11a(r31)           
1002a55c  28050000    cmplwi r5,0x0               
1002a560  41820020    beq 0x1002a580                 ; -> 1002a580
1002a564  a87f0070    lha r3,0x70(r31)            
1002a568  a89f0074    lha r4,0x74(r31)            
1002a56c  38a007d0    li r5,0x7d0                 
1002a570  38c007d0    li r6,0x7d0                 
1002a574  4bfdaac9    bl 0x1000503c                  ; -> 1000503c
1002a578  60000000    ori r0,r0,0x0               
1002a57c  48000098    b 0x1002a614                   ; -> 1002a614
1002a580  a87f0070    lha r3,0x70(r31)            
1002a584  a89f0074    lha r4,0x74(r31)            
1002a588  a8bf00e0    lha r5,0xe0(r31)            
1002a58c  a8df00e4    lha r6,0xe4(r31)            
1002a590  4bfdaaad    bl 0x1000503c                  ; -> 1000503c
1002a594  60000000    ori r0,r0,0x0               
1002a598  4800007c    b 0x1002a614                   ; -> 1002a614
1002a59c  80d30000    lwz r6,0x0(r19)             
1002a5a0  54c607fe    rlwinm r6,r6,0x0,0x1f,0x1f  
1002a5a4  2c060000    cmpwi r6,0x0                
1002a5a8  4182006c    beq 0x1002a614                 ; -> 1002a614
1002a5ac  88ff00aa    lbz r7,0xaa(r31)            
1002a5b0  28070000    cmplwi r7,0x0               
1002a5b4  41820020    beq 0x1002a5d4                 ; -> 1002a5d4
1002a5b8  a8bf00e0    lha r5,0xe0(r31)            
1002a5bc  a8df00e4    lha r6,0xe4(r31)            
1002a5c0  386007d0    li r3,0x7d0                 
1002a5c4  388007d0    li r4,0x7d0                 
1002a5c8  4bfdaa75    bl 0x1000503c                  ; -> 1000503c
1002a5cc  60000000    ori r0,r0,0x0               
1002a5d0  48000044    b 0x1002a614                   ; -> 1002a614
1002a5d4  891f011a    lbz r8,0x11a(r31)           
1002a5d8  28080000    cmplwi r8,0x0               
1002a5dc  41820020    beq 0x1002a5fc                 ; -> 1002a5fc
1002a5e0  a87f0070    lha r3,0x70(r31)            
1002a5e4  a89f0074    lha r4,0x74(r31)            
1002a5e8  38a007d0    li r5,0x7d0                 
1002a5ec  38c007d0    li r6,0x7d0                 
1002a5f0  4bfdaa4d    bl 0x1000503c                  ; -> 1000503c
1002a5f4  60000000    ori r0,r0,0x0               
1002a5f8  4800001c    b 0x1002a614                   ; -> 1002a614
1002a5fc  a87f0070    lha r3,0x70(r31)            
1002a600  a89f0074    lha r4,0x74(r31)            
1002a604  a8bf00e0    lha r5,0xe0(r31)            
1002a608  a8df00e4    lha r6,0xe4(r31)            
1002a60c  4bfdaa31    bl 0x1000503c                  ; -> 1000503c
1002a610  60000000    ori r0,r0,0x0               
1002a614  3a31ffff    subi r17,r17,0x1            
1002a618  7e290734    extsh r9,r17                
1002a61c  2c090000    cmpwi r9,0x0                
1002a620  4181008c    bgt 0x1002a6ac                 ; -> 1002a6ac
1002a624  3a200002    li r17,0x2                  
1002a628  48002e19    bl 0x1002d440                  ; -> 1002d440
1002a62c  60000000    ori r0,r0,0x0               
1002a630  895f00aa    lbz r10,0xaa(r31)           
1002a634  280a0000    cmplwi r10,0x0              
1002a638  40820010    bne 0x1002a648                 ; -> 1002a648
1002a63c  38600001    li r3,0x1                   
1002a640  4bfe702d    bl 0x1001166c                  ; -> 1001166c
1002a644  60000000    ori r0,r0,0x0               
1002a648  897f011a    lbz r11,0x11a(r31)          
1002a64c  280b0000    cmplwi r11,0x0              
1002a650  40820010    bne 0x1002a660                 ; -> 1002a660
1002a654  38600002    li r3,0x2                   
1002a658  4bfe7015    bl 0x1001166c                  ; -> 1001166c
1002a65c  60000000    ori r0,r0,0x0               
1002a660  899f0098    lbz r12,0x98(r31)           
1002a664  280c0000    cmplwi r12,0x0              
1002a668  4082001c    bne 0x1002a684                 ; -> 1002a684
1002a66c  887f00aa    lbz r3,0xaa(r31)            
1002a670  28030000    cmplwi r3,0x0               
1002a674  40820010    bne 0x1002a684                 ; -> 1002a684
1002a678  38600001    li r3,0x1                   
1002a67c  480015e9    bl 0x1002bc64                  ; -> 1002bc64
1002a680  60000000    ori r0,r0,0x0               
1002a684  889f0108    lbz r4,0x108(r31)           
1002a688  28040000    cmplwi r4,0x0               
1002a68c  408200b0    bne 0x1002a73c                 ; -> 1002a73c
1002a690  88bf011a    lbz r5,0x11a(r31)           
1002a694  28050000    cmplwi r5,0x0               
1002a698  408200a4    bne 0x1002a73c                 ; -> 1002a73c
1002a69c  38600002    li r3,0x2                   
1002a6a0  480015c5    bl 0x1002bc64                  ; -> 1002bc64
1002a6a4  60000000    ori r0,r0,0x0               
1002a6a8  48000094    b 0x1002a73c                   ; -> 1002a73c
1002a6ac  a8df00cc    lha r6,0xcc(r31)            
1002a6b0  2c060001    cmpwi r6,0x1                
1002a6b4  4082001c    bne 0x1002a6d0                 ; -> 1002a6d0
1002a6b8  88ff00aa    lbz r7,0xaa(r31)            
1002a6bc  28070000    cmplwi r7,0x0               
1002a6c0  40820010    bne 0x1002a6d0                 ; -> 1002a6d0
1002a6c4  38600001    li r3,0x1                   
1002a6c8  4bfe6fa5    bl 0x1001166c                  ; -> 1001166c
1002a6cc  60000000    ori r0,r0,0x0               
1002a6d0  a91f013c    lha r8,0x13c(r31)           
1002a6d4  2c080001    cmpwi r8,0x1                
1002a6d8  4082001c    bne 0x1002a6f4                 ; -> 1002a6f4
1002a6dc  893f011a    lbz r9,0x11a(r31)           
1002a6e0  28090000    cmplwi r9,0x0               
1002a6e4  40820010    bne 0x1002a6f4                 ; -> 1002a6f4
1002a6e8  38600002    li r3,0x2                   
1002a6ec  4bfe6f81    bl 0x1001166c                  ; -> 1001166c
1002a6f0  60000000    ori r0,r0,0x0               
1002a6f4  895f0098    lbz r10,0x98(r31)           
1002a6f8  280a0000    cmplwi r10,0x0              
1002a6fc  4182001c    beq 0x1002a718                 ; -> 1002a718
1002a700  897f00aa    lbz r11,0xaa(r31)           
1002a704  280b0000    cmplwi r11,0x0              
1002a708  40820010    bne 0x1002a718                 ; -> 1002a718
1002a70c  38600001    li r3,0x1                   
1002a710  4bfe6f5d    bl 0x1001166c                  ; -> 1001166c
1002a714  60000000    ori r0,r0,0x0               
1002a718  899f0108    lbz r12,0x108(r31)          
1002a71c  280c0000    cmplwi r12,0x0              
1002a720  4182001c    beq 0x1002a73c                 ; -> 1002a73c
1002a724  887f011a    lbz r3,0x11a(r31)           
1002a728  28030000    cmplwi r3,0x0               
1002a72c  40820010    bne 0x1002a73c                 ; -> 1002a73c
1002a730  38600002    li r3,0x2                   
1002a734  4bfe6f39    bl 0x1001166c                  ; -> 1001166c
1002a738  60000000    ori r0,r0,0x0               
1002a73c  4bfec049    bl 0x10016784                  ; -> 10016784
1002a740  60000000    ori r0,r0,0x0               
1002a744  4bffe215    bl 0x10028958                  ; -> 10028958
1002a748  4bfd9a39    bl 0x10004180                  ; -> 10004180
1002a74c  60000000    ori r0,r0,0x0               
1002a750  387f0070    addi r3,r31,0x70            
1002a754  38800001    li r4,0x1                   
1002a758  4bfe5605    bl 0x1000fd5c                  ; -> 1000fd5c
1002a75c  60000000    ori r0,r0,0x0               
1002a760  387f00e0    addi r3,r31,0xe0            
1002a764  38800002    li r4,0x2                   
1002a768  4bfe55f5    bl 0x1000fd5c                  ; -> 1000fd5c
1002a76c  60000000    ori r0,r0,0x0               
1002a770  4bffd8f1    bl 0x10028060                  ; -> 10028060
1002a774  4bffdc2d    bl 0x100283a0                  ; -> 100283a0
1002a778  4bfe483d    bl 0x1000efb4                  ; -> 1000efb4
1002a77c  60000000    ori r0,r0,0x0               
1002a780  4bfe4d81    bl 0x1000f500                  ; -> 1000f500
1002a784  60000000    ori r0,r0,0x0               
1002a788  4bfda58d    bl 0x10004d14                  ; -> 10004d14
1002a78c  60000000    ori r0,r0,0x0               
1002a790  889f00aa    lbz r4,0xaa(r31)            
1002a794  28040000    cmplwi r4,0x0               
1002a798  40820044    bne 0x1002a7dc                 ; -> 1002a7dc
1002a79c  807f007a    lwz r3,0x7a(r31)            
1002a7a0  a89f0088    lha r4,0x88(r31)            
1002a7a4  a8bf0084    lha r5,0x84(r31)            
1002a7a8  a8df0086    lha r6,0x86(r31)            
1002a7ac  80ff0076    lwz r7,0x76(r31)            
1002a7b0  a91f007e    lha r8,0x7e(r31)            
1002a7b4  a93f0072    lha r9,0x72(r31)            
1002a7b8  a95f0074    lha r10,0x74(r31)           
1002a7bc  4bfd9be5    bl 0x100043a0                  ; -> 100043a0
1002a7c0  60000000    ori r0,r0,0x0               
1002a7c4  38600001    li r3,0x1                   
1002a7c8  4bfe6df9    bl 0x100115c0                  ; -> 100115c0
1002a7cc  60000000    ori r0,r0,0x0               
1002a7d0  38600001    li r3,0x1                   
1002a7d4  4bfea23d    bl 0x10014a10                  ; -> 10014a10
1002a7d8  60000000    ori r0,r0,0x0               
1002a7dc  88bf011a    lbz r5,0x11a(r31)           
1002a7e0  28050000    cmplwi r5,0x0               
1002a7e4  40820044    bne 0x1002a828                 ; -> 1002a828
1002a7e8  807f00ea    lwz r3,0xea(r31)            
1002a7ec  a89f00f8    lha r4,0xf8(r31)            
1002a7f0  a8bf00f4    lha r5,0xf4(r31)            
1002a7f4  a8df00f6    lha r6,0xf6(r31)            
1002a7f8  80ff00e6    lwz r7,0xe6(r31)            
1002a7fc  a91f00ee    lha r8,0xee(r31)            
1002a800  a93f00e2    lha r9,0xe2(r31)            
1002a804  a95f00e4    lha r10,0xe4(r31)           
1002a808  4bfd9b99    bl 0x100043a0                  ; -> 100043a0
1002a80c  60000000    ori r0,r0,0x0               
1002a810  38600002    li r3,0x2                   
1002a814  4bfe6dad    bl 0x100115c0                  ; -> 100115c0
1002a818  60000000    ori r0,r0,0x0               
1002a81c  38600002    li r3,0x2                   
1002a820  4bfea1f1    bl 0x10014a10                  ; -> 10014a10
1002a824  60000000    ori r0,r0,0x0               
1002a828  4bffe199    bl 0x100289c0                  ; -> 100289c0
1002a82c  88df00aa    lbz r6,0xaa(r31)            
1002a830  28060000    cmplwi r6,0x0               
1002a834  408200f0    bne 0x1002a924                 ; -> 1002a924
1002a838  88ff0098    lbz r7,0x98(r31)            
1002a83c  28070000    cmplwi r7,0x0               
1002a840  408200e4    bne 0x1002a924                 ; -> 1002a924
1002a844  38600001    li r3,0x1                   
1002a848  4bfff16d    bl 0x100299b4                  ; -> 100299b4
1002a84c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002a850  28030000    cmplwi r3,0x0               
1002a854  41820048    beq 0x1002a89c                 ; -> 1002a89c
1002a858  a91f00cc    lha r8,0xcc(r31)            
1002a85c  2c080002    cmpwi r8,0x2                
1002a860  418200c4    beq 0x1002a924                 ; -> 1002a924
1002a864  38600001    li r3,0x1                   
1002a868  4bfe79c1    bl 0x10012228                  ; -> 10012228
1002a86c  60000000    ori r0,r0,0x0               
1002a870  a93f00b6    lha r9,0xb6(r31)            
1002a874  2c090000    cmpwi r9,0x0                
1002a878  40810018    ble 0x1002a890                 ; -> 1002a890
1002a87c  38600001    li r3,0x1                   
1002a880  3880ffff    li r4,-0x1                  
1002a884  4bfe4145    bl 0x1000e9c8                  ; -> 1000e9c8
1002a888  60000000    ori r0,r0,0x0               
1002a88c  48000098    b 0x1002a924                   ; -> 1002a924
1002a890  39400000    li r10,0x0                  
1002a894  995f00b8    stb r10,0xb8(r31)           
1002a898  4800008c    b 0x1002a924                   ; -> 1002a924
1002a89c  89740000    lbz r11,0x0(r20)            
1002a8a0  280b0000    cmplwi r11,0x0              
1002a8a4  41820040    beq 0x1002a8e4                 ; -> 1002a8e4
1002a8a8  38600001    li r3,0x1                   
1002a8ac  4bfe797d    bl 0x10012228                  ; -> 10012228
1002a8b0  60000000    ori r0,r0,0x0               
1002a8b4  39800000    li r12,0x0                  
1002a8b8  b19f0126    sth r12,0x126(r31)          
1002a8bc  b19f00b6    sth r12,0xb6(r31)           
1002a8c0  38600000    li r3,0x0                   
1002a8c4  987f0128    stb r3,0x128(r31)           
1002a8c8  987f00b8    stb r3,0xb8(r31)            
1002a8cc  38800000    li r4,0x0                   
1002a8d0  989f0109    stb r4,0x109(r31)           
1002a8d4  989f0099    stb r4,0x99(r31)            
1002a8d8  38a00001    li r5,0x1                   
1002a8dc  98b20000    stb r5,0x0(r18)             
1002a8e0  48000044    b 0x1002a924                   ; -> 1002a924
1002a8e4  88d50000    lbz r6,0x0(r21)             
1002a8e8  28060000    cmplwi r6,0x0               
1002a8ec  41820038    beq 0x1002a924                 ; -> 1002a924
1002a8f0  38600001    li r3,0x1                   
1002a8f4  4bfe7935    bl 0x10012228                  ; -> 10012228
1002a8f8  60000000    ori r0,r0,0x0               
1002a8fc  a8ff00b6    lha r7,0xb6(r31)            
1002a900  2c070000    cmpwi r7,0x0                
1002a904  40810018    ble 0x1002a91c                 ; -> 1002a91c
1002a908  38600001    li r3,0x1                   
1002a90c  3880ffff    li r4,-0x1                  
1002a910  4bfe40b9    bl 0x1000e9c8                  ; -> 1000e9c8
1002a914  60000000    ori r0,r0,0x0               
1002a918  4800000c    b 0x1002a924                   ; -> 1002a924
1002a91c  39000000    li r8,0x0                   
1002a920  991f00b8    stb r8,0xb8(r31)            
1002a924  39225260    addi r9,r2,0x5260           
1002a928  89290000    lbz r9,0x0(r9)              
1002a92c  28090000    cmplwi r9,0x0               
1002a930  4182000c    beq 0x1002a93c                 ; -> 1002a93c
1002a934  4bffc749    bl 0x1002707c                  ; -> 1002707c
1002a938  3ae00001    li r23,0x1                  
1002a93c  895f011a    lbz r10,0x11a(r31)          
1002a940  280a0000    cmplwi r10,0x0              
1002a944  40820160    bne 0x1002aaa4                 ; -> 1002aaa4
1002a948  897f0108    lbz r11,0x108(r31)          
1002a94c  280b0000    cmplwi r11,0x0              
1002a950  40820154    bne 0x1002aaa4                 ; -> 1002aaa4
1002a954  38600002    li r3,0x2                   
1002a958  4bfff05d    bl 0x100299b4                  ; -> 100299b4
1002a95c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002a960  28030000    cmplwi r3,0x0               
1002a964  41820080    beq 0x1002a9e4                 ; -> 1002a9e4
1002a968  a99f013c    lha r12,0x13c(r31)          
1002a96c  2c0c0002    cmpwi r12,0x2               
1002a970  41820134    beq 0x1002aaa4                 ; -> 1002aaa4
1002a974  38600002    li r3,0x2                   
1002a978  4bfe78b1    bl 0x10012228                  ; -> 10012228
1002a97c  60000000    ori r0,r0,0x0               
1002a980  88790000    lbz r3,0x0(r25)             
1002a984  28030000    cmplwi r3,0x0               
1002a988  40820030    bne 0x1002a9b8                 ; -> 1002a9b8
1002a98c  a89f00b6    lha r4,0xb6(r31)            
1002a990  2c040000    cmpwi r4,0x0                
1002a994  40810018    ble 0x1002a9ac                 ; -> 1002a9ac
1002a998  38600001    li r3,0x1                   
1002a99c  3880ffff    li r4,-0x1                  
1002a9a0  4bfe4029    bl 0x1000e9c8                  ; -> 1000e9c8
1002a9a4  60000000    ori r0,r0,0x0               
1002a9a8  480000fc    b 0x1002aaa4                   ; -> 1002aaa4
1002a9ac  38a00000    li r5,0x0                   
1002a9b0  98bf0128    stb r5,0x128(r31)           
1002a9b4  480000f0    b 0x1002aaa4                   ; -> 1002aaa4
1002a9b8  a8df0126    lha r6,0x126(r31)           
1002a9bc  2c060000    cmpwi r6,0x0                
1002a9c0  40810018    ble 0x1002a9d8                 ; -> 1002a9d8
1002a9c4  38600002    li r3,0x2                   
1002a9c8  3880ffff    li r4,-0x1                  
1002a9cc  4bfe3ffd    bl 0x1000e9c8                  ; -> 1000e9c8
1002a9d0  60000000    ori r0,r0,0x0               
1002a9d4  480000d0    b 0x1002aaa4                   ; -> 1002aaa4
1002a9d8  38e00000    li r7,0x0                   
1002a9dc  98ff0128    stb r7,0x128(r31)           
1002a9e0  480000c4    b 0x1002aaa4                   ; -> 1002aaa4
1002a9e4  89140000    lbz r8,0x0(r20)             
1002a9e8  28080000    cmplwi r8,0x0               
1002a9ec  41820040    beq 0x1002aa2c                 ; -> 1002aa2c
1002a9f0  38600002    li r3,0x2                   
1002a9f4  4bfe7835    bl 0x10012228                  ; -> 10012228
1002a9f8  60000000    ori r0,r0,0x0               
1002a9fc  39200000    li r9,0x0                   
1002aa00  b13f0126    sth r9,0x126(r31)           
1002aa04  b13f00b6    sth r9,0xb6(r31)            
1002aa08  39400000    li r10,0x0                  
1002aa0c  995f0128    stb r10,0x128(r31)          
1002aa10  995f00b8    stb r10,0xb8(r31)           
1002aa14  39600000    li r11,0x0                  
1002aa18  997f0109    stb r11,0x109(r31)          
1002aa1c  997f0099    stb r11,0x99(r31)           
1002aa20  39800001    li r12,0x1                  
1002aa24  99920000    stb r12,0x0(r18)            
1002aa28  4800007c    b 0x1002aaa4                   ; -> 1002aaa4
1002aa2c  88750000    lbz r3,0x0(r21)             
1002aa30  28030000    cmplwi r3,0x0               
1002aa34  41820070    beq 0x1002aaa4                 ; -> 1002aaa4
1002aa38  38600002    li r3,0x2                   
1002aa3c  4bfe77ed    bl 0x10012228                  ; -> 10012228
1002aa40  60000000    ori r0,r0,0x0               
1002aa44  88990000    lbz r4,0x0(r25)             
1002aa48  28040000    cmplwi r4,0x0               
1002aa4c  40820030    bne 0x1002aa7c                 ; -> 1002aa7c
1002aa50  a8bf00b6    lha r5,0xb6(r31)            
1002aa54  2c050000    cmpwi r5,0x0                
1002aa58  40810018    ble 0x1002aa70                 ; -> 1002aa70
1002aa5c  38600001    li r3,0x1                   
1002aa60  3880ffff    li r4,-0x1                  
1002aa64  4bfe3f65    bl 0x1000e9c8                  ; -> 1000e9c8
1002aa68  60000000    ori r0,r0,0x0               
1002aa6c  48000038    b 0x1002aaa4                   ; -> 1002aaa4
1002aa70  38c00000    li r6,0x0                   
1002aa74  98df0128    stb r6,0x128(r31)           
1002aa78  4800002c    b 0x1002aaa4                   ; -> 1002aaa4
1002aa7c  a8ff0126    lha r7,0x126(r31)           
1002aa80  2c070000    cmpwi r7,0x0                
1002aa84  40810018    ble 0x1002aa9c                 ; -> 1002aa9c
1002aa88  38600002    li r3,0x2                   
1002aa8c  3880ffff    li r4,-0x1                  
1002aa90  4bfe3f39    bl 0x1000e9c8                  ; -> 1000e9c8
1002aa94  60000000    ori r0,r0,0x0               
1002aa98  4800000c    b 0x1002aaa4                   ; -> 1002aaa4
1002aa9c  39000000    li r8,0x0                   
1002aaa0  991f0128    stb r8,0x128(r31)           
1002aaa4  4bfee0f5    bl 0x10018b98                  ; -> 10018b98
1002aaa8  60000000    ori r0,r0,0x0               
1002aaac  3bc00000    li r30,0x0                  
1002aab0  48000008    b 0x1002aab8                   ; -> 1002aab8
1002aab4  3bde0001    addi r30,r30,0x1            
1002aab8  4bfee8f1    bl 0x100193a8                  ; -> 100193a8
1002aabc  60000000    ori r0,r0,0x0               
1002aac0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002aac4  28030000    cmplwi r3,0x0               
1002aac8  4182ffec    beq 0x1002aab4                 ; -> 1002aab4
1002aacc  4bfee8fd    bl 0x100193c8                  ; -> 100193c8
1002aad0  60000000    ori r0,r0,0x0               
1002aad4  893f00aa    lbz r9,0xaa(r31)            
1002aad8  28090000    cmplwi r9,0x0               
1002aadc  40820058    bne 0x1002ab34                 ; -> 1002ab34
1002aae0  895f0099    lbz r10,0x99(r31)           
1002aae4  280a0000    cmplwi r10,0x0              
1002aae8  4182004c    beq 0x1002ab34                 ; -> 1002ab34
1002aaec  39600001    li r11,0x1                  
1002aaf0  997f00aa    stb r11,0xaa(r31)           
1002aaf4  a99f00a8    lha r12,0xa8(r31)           
1002aaf8  ab7f0070    lha r27,0x70(r31)           
1002aafc  ab5f0074    lha r26,0x74(r31)           
1002ab00  398c0001    addi r12,r12,0x1            
1002ab04  b19f00a8    sth r12,0xa8(r31)           
1002ab08  4bffde51    bl 0x10028958                  ; -> 10028958
1002ab0c  80700004    lwz r3,0x4(r16)             
1002ab10  a89f007e    lha r4,0x7e(r31)            
1002ab14  a8bf0084    lha r5,0x84(r31)            
1002ab18  a8df0074    lha r6,0x74(r31)            
1002ab1c  4bfda195    bl 0x10004cb0                  ; -> 10004cb0
1002ab20  60000000    ori r0,r0,0x0               
1002ab24  38600001    li r3,0x1                   
1002ab28  4bfe9e19    bl 0x10014940                  ; -> 10014940
1002ab2c  60000000    ori r0,r0,0x0               
1002ab30  4bffde91    bl 0x100289c0                  ; -> 100289c0
1002ab34  887f011a    lbz r3,0x11a(r31)           
1002ab38  28030000    cmplwi r3,0x0               
1002ab3c  40820058    bne 0x1002ab94                 ; -> 1002ab94
1002ab40  889f0109    lbz r4,0x109(r31)           
1002ab44  28040000    cmplwi r4,0x0               
1002ab48  4182004c    beq 0x1002ab94                 ; -> 1002ab94
1002ab4c  38a00001    li r5,0x1                   
1002ab50  98bf011a    stb r5,0x11a(r31)           
1002ab54  a8df0118    lha r6,0x118(r31)           
1002ab58  ab7f00e0    lha r27,0xe0(r31)           
1002ab5c  ab5f00e4    lha r26,0xe4(r31)           
1002ab60  38c60001    addi r6,r6,0x1              
1002ab64  b0df0118    sth r6,0x118(r31)           
1002ab68  4bffddf1    bl 0x10028958                  ; -> 10028958
1002ab6c  80700004    lwz r3,0x4(r16)             
1002ab70  a89f00ee    lha r4,0xee(r31)            
1002ab74  a8bf00f4    lha r5,0xf4(r31)            
1002ab78  a8df00e4    lha r6,0xe4(r31)            
1002ab7c  4bfda135    bl 0x10004cb0                  ; -> 10004cb0
1002ab80  60000000    ori r0,r0,0x0               
1002ab84  38600002    li r3,0x2                   
1002ab88  4bfe9db9    bl 0x10014940                  ; -> 10014940
1002ab8c  60000000    ori r0,r0,0x0               
1002ab90  4bffde31    bl 0x100289c0                  ; -> 100289c0
1002ab94  88ff00aa    lbz r7,0xaa(r31)            
1002ab98  28070000    cmplwi r7,0x0               
1002ab9c  418202cc    beq 0x1002ae68                 ; -> 1002ae68
1002aba0  891f011a    lbz r8,0x11a(r31)           
1002aba4  28080000    cmplwi r8,0x0               
1002aba8  418202c0    beq 0x1002ae68                 ; -> 1002ae68
1002abac  89390000    lbz r9,0x0(r25)             
1002abb0  28090000    cmplwi r9,0x0               
1002abb4  40820120    bne 0x1002acd4                 ; -> 1002acd4
1002abb8  895f0099    lbz r10,0x99(r31)           
1002abbc  280a0000    cmplwi r10,0x0              
1002abc0  4182006c    beq 0x1002ac2c                 ; -> 1002ac2c
1002abc4  38600014    li r3,0x14                  
1002abc8  4bfedb75    bl 0x1001873c                  ; -> 1001873c
1002abcc  60000000    ori r0,r0,0x0               
1002abd0  3860001f    li r3,0x1f                  
1002abd4  38800064    li r4,0x64                  
1002abd8  48000449    bl 0x1002b020                  ; -> 1002b020
1002abdc  60000000    ori r0,r0,0x0               
1002abe0  3bbb000c    addi r29,r27,0xc            
1002abe4  3b9a0010    addi r28,r26,0x10           
1002abe8  7fa3eb78    or r3,r29,r29               
1002abec  7f84e378    or r4,r28,r28               
1002abf0  38a00001    li r5,0x1                   
1002abf4  38c00003    li r6,0x3                   
1002abf8  4bffbfc1    bl 0x10026bb8                  ; -> 10026bb8
1002abfc  a97f00b6    lha r11,0xb6(r31)           
1002ac00  2c0b0000    cmpwi r11,0x0               
1002ac04  4080000c    bge 0x1002ac10                 ; -> 1002ac10
1002ac08  39800000    li r12,0x0                  
1002ac0c  b19f00b6    sth r12,0xb6(r31)           
1002ac10  88780000    lbz r3,0x0(r24)             
1002ac14  28030000    cmplwi r3,0x0               
1002ac18  40820250    bne 0x1002ae68                 ; -> 1002ae68
1002ac1c  38600003    li r3,0x3                   
1002ac20  4bfea7b1    bl 0x100153d0                  ; -> 100153d0
1002ac24  60000000    ori r0,r0,0x0               
1002ac28  48000240    b 0x1002ae68                   ; -> 1002ae68
1002ac2c  889f0109    lbz r4,0x109(r31)           
1002ac30  28040000    cmplwi r4,0x0               
1002ac34  4182006c    beq 0x1002aca0                 ; -> 1002aca0
1002ac38  38600014    li r3,0x14                  
1002ac3c  4bfedb01    bl 0x1001873c                  ; -> 1001873c
1002ac40  60000000    ori r0,r0,0x0               
1002ac44  3860001f    li r3,0x1f                  
1002ac48  38800064    li r4,0x64                  
1002ac4c  480003d5    bl 0x1002b020                  ; -> 1002b020
1002ac50  60000000    ori r0,r0,0x0               
1002ac54  3bbb000c    addi r29,r27,0xc            
1002ac58  3b9a0010    addi r28,r26,0x10           
1002ac5c  7fa3eb78    or r3,r29,r29               
1002ac60  7f84e378    or r4,r28,r28               
1002ac64  38a00001    li r5,0x1                   
1002ac68  38c00003    li r6,0x3                   
1002ac6c  4bffbf4d    bl 0x10026bb8                  ; -> 10026bb8
1002ac70  a8bf00b6    lha r5,0xb6(r31)            
1002ac74  2c050000    cmpwi r5,0x0                
1002ac78  4080000c    bge 0x1002ac84                 ; -> 1002ac84
1002ac7c  38c00000    li r6,0x0                   
1002ac80  b0df00b6    sth r6,0xb6(r31)            
1002ac84  88f80000    lbz r7,0x0(r24)             
1002ac88  28070000    cmplwi r7,0x0               
1002ac8c  408201dc    bne 0x1002ae68                 ; -> 1002ae68
1002ac90  38600003    li r3,0x3                   
1002ac94  4bfea73d    bl 0x100153d0                  ; -> 100153d0
1002ac98  60000000    ori r0,r0,0x0               
1002ac9c  480001cc    b 0x1002ae68                   ; -> 1002ae68
1002aca0  891f00b8    lbz r8,0xb8(r31)            
1002aca4  28080000    cmplwi r8,0x0               
1002aca8  408201c0    bne 0x1002ae68                 ; -> 1002ae68
1002acac  893f0128    lbz r9,0x128(r31)           
1002acb0  28090000    cmplwi r9,0x0               
1002acb4  408201b4    bne 0x1002ae68                 ; -> 1002ae68
1002acb8  38600014    li r3,0x14                  
1002acbc  4bfeda81    bl 0x1001873c                  ; -> 1001873c
1002acc0  60000000    ori r0,r0,0x0               
1002acc4  38600000    li r3,0x0                   
1002acc8  4bff9355    bl 0x1002401c                  ; -> 1002401c
1002accc  60000000    ori r0,r0,0x0               
1002acd0  48000198    b 0x1002ae68                   ; -> 1002ae68
1002acd4  895f00b8    lbz r10,0xb8(r31)           
1002acd8  280a0000    cmplwi r10,0x0              
1002acdc  40820088    bne 0x1002ad64                 ; -> 1002ad64
1002ace0  897f0128    lbz r11,0x128(r31)          
1002ace4  280b0000    cmplwi r11,0x0              
1002ace8  4082007c    bne 0x1002ad64                 ; -> 1002ad64
1002acec  899f009a    lbz r12,0x9a(r31)           
1002acf0  280c0000    cmplwi r12,0x0              
1002acf4  4182002c    beq 0x1002ad20                 ; -> 1002ad20
1002acf8  887f010a    lbz r3,0x10a(r31)           
1002acfc  28030000    cmplwi r3,0x0               
1002ad00  41820020    beq 0x1002ad20                 ; -> 1002ad20
1002ad04  38600014    li r3,0x14                  
1002ad08  4bfeda35    bl 0x1001873c                  ; -> 1001873c
1002ad0c  60000000    ori r0,r0,0x0               
1002ad10  38600000    li r3,0x0                   
1002ad14  4bff9309    bl 0x1002401c                  ; -> 1002401c
1002ad18  60000000    ori r0,r0,0x0               
1002ad1c  48000090    b 0x1002adac                   ; -> 1002adac
1002ad20  889f009a    lbz r4,0x9a(r31)            
1002ad24  28040000    cmplwi r4,0x0               
1002ad28  41820020    beq 0x1002ad48                 ; -> 1002ad48
1002ad2c  38600014    li r3,0x14                  
1002ad30  4bfeda0d    bl 0x1001873c                  ; -> 1001873c
1002ad34  60000000    ori r0,r0,0x0               
1002ad38  38600000    li r3,0x0                   
1002ad3c  4bff92e1    bl 0x1002401c                  ; -> 1002401c
1002ad40  60000000    ori r0,r0,0x0               
1002ad44  48000068    b 0x1002adac                   ; -> 1002adac
1002ad48  38600014    li r3,0x14                  
1002ad4c  4bfed9f1    bl 0x1001873c                  ; -> 1001873c
1002ad50  60000000    ori r0,r0,0x0               
1002ad54  38600000    li r3,0x0                   
1002ad58  4bff92c5    bl 0x1002401c                  ; -> 1002401c
1002ad5c  60000000    ori r0,r0,0x0               
1002ad60  4800004c    b 0x1002adac                   ; -> 1002adac
1002ad64  88bf009a    lbz r5,0x9a(r31)            
1002ad68  28050000    cmplwi r5,0x0               
1002ad6c  4182001c    beq 0x1002ad88                 ; -> 1002ad88
1002ad70  88df00b8    lbz r6,0xb8(r31)            
1002ad74  28060000    cmplwi r6,0x0               
1002ad78  40820010    bne 0x1002ad88                 ; -> 1002ad88
1002ad7c  38600014    li r3,0x14                  
1002ad80  4bfed9bd    bl 0x1001873c                  ; -> 1001873c
1002ad84  60000000    ori r0,r0,0x0               
1002ad88  88ff010a    lbz r7,0x10a(r31)           
1002ad8c  28070000    cmplwi r7,0x0               
1002ad90  4182001c    beq 0x1002adac                 ; -> 1002adac
1002ad94  891f0128    lbz r8,0x128(r31)           
1002ad98  28080000    cmplwi r8,0x0               
1002ad9c  40820010    bne 0x1002adac                 ; -> 1002adac
1002ada0  38600014    li r3,0x14                  
1002ada4  4bfed999    bl 0x1001873c                  ; -> 1001873c
1002ada8  60000000    ori r0,r0,0x0               
1002adac  893f0099    lbz r9,0x99(r31)            
1002adb0  28090000    cmplwi r9,0x0               
1002adb4  41820058    beq 0x1002ae0c                 ; -> 1002ae0c
1002adb8  38600014    li r3,0x14                  
1002adbc  4bfed981    bl 0x1001873c                  ; -> 1001873c
1002adc0  60000000    ori r0,r0,0x0               
1002adc4  3860001f    li r3,0x1f                  
1002adc8  38800064    li r4,0x64                  
1002adcc  48000255    bl 0x1002b020                  ; -> 1002b020
1002add0  60000000    ori r0,r0,0x0               
1002add4  3bbb000c    addi r29,r27,0xc            
1002add8  3b9a0010    addi r28,r26,0x10           
1002addc  7fa3eb78    or r3,r29,r29               
1002ade0  7f84e378    or r4,r28,r28               
1002ade4  38a00001    li r5,0x1                   
1002ade8  38c00003    li r6,0x3                   
1002adec  4bffbdcd    bl 0x10026bb8                  ; -> 10026bb8
1002adf0  89580000    lbz r10,0x0(r24)            
1002adf4  280a0000    cmplwi r10,0x0              
1002adf8  40820070    bne 0x1002ae68                 ; -> 1002ae68
1002adfc  38600003    li r3,0x3                   
1002ae00  4bfea5d1    bl 0x100153d0                  ; -> 100153d0
1002ae04  60000000    ori r0,r0,0x0               
1002ae08  48000060    b 0x1002ae68                   ; -> 1002ae68
1002ae0c  897f0109    lbz r11,0x109(r31)          
1002ae10  280b0000    cmplwi r11,0x0              
1002ae14  41820054    beq 0x1002ae68                 ; -> 1002ae68
1002ae18  38600014    li r3,0x14                  
1002ae1c  4bfed921    bl 0x1001873c                  ; -> 1001873c
1002ae20  60000000    ori r0,r0,0x0               
1002ae24  3860001f    li r3,0x1f                  
1002ae28  38800064    li r4,0x64                  
1002ae2c  480001f5    bl 0x1002b020                  ; -> 1002b020
1002ae30  60000000    ori r0,r0,0x0               
1002ae34  3bbb000c    addi r29,r27,0xc            
1002ae38  3b9a0010    addi r28,r26,0x10           
1002ae3c  7fa3eb78    or r3,r29,r29               
1002ae40  7f84e378    or r4,r28,r28               
1002ae44  38a00001    li r5,0x1                   
1002ae48  38c00003    li r6,0x3                   
1002ae4c  4bffbd6d    bl 0x10026bb8                  ; -> 10026bb8
1002ae50  89980000    lbz r12,0x0(r24)            
1002ae54  280c0000    cmplwi r12,0x0              
1002ae58  40820010    bne 0x1002ae68                 ; -> 1002ae68
1002ae5c  38600003    li r3,0x3                   
1002ae60  4bfea571    bl 0x100153d0                  ; -> 100153d0
1002ae64  60000000    ori r0,r0,0x0               
1002ae68  887f00aa    lbz r3,0xaa(r31)            
1002ae6c  28030000    cmplwi r3,0x0               
1002ae70  41820014    beq 0x1002ae84                 ; -> 1002ae84
1002ae74  889f011a    lbz r4,0x11a(r31)           
1002ae78  28040000    cmplwi r4,0x0               
1002ae7c  41820008    beq 0x1002ae84                 ; -> 1002ae84
1002ae80  3ae00001    li r23,0x1                  
1002ae84  56e5063e    rlwinm r5,r23,0x0,0x18,0x1f 
1002ae88  28050000    cmplwi r5,0x0               
1002ae8c  4182f690    beq 0x1002a51c                 ; -> 1002a51c
1002ae90  38c25260    addi r6,r2,0x5260           
1002ae94  88c60000    lbz r6,0x0(r6)              
1002ae98  28060000    cmplwi r6,0x0               
1002ae9c  40820070    bne 0x1002af0c                 ; -> 1002af0c
1002aea0  88f80000    lbz r7,0x0(r24)             
1002aea4  28070000    cmplwi r7,0x0               
1002aea8  41820064    beq 0x1002af0c                 ; -> 1002af0c
1002aeac  89120000    lbz r8,0x0(r18)             
1002aeb0  28080000    cmplwi r8,0x0               
1002aeb4  40820058    bne 0x1002af0c                 ; -> 1002af0c
1002aeb8  893f0099    lbz r9,0x99(r31)            
1002aebc  28090000    cmplwi r9,0x0               
1002aec0  4082003c    bne 0x1002aefc                 ; -> 1002aefc
1002aec4  895f0109    lbz r10,0x109(r31)          
1002aec8  280a0000    cmplwi r10,0x0              
1002aecc  40820030    bne 0x1002aefc                 ; -> 1002aefc
1002aed0  a97f00a8    lha r11,0xa8(r31)           
1002aed4  38600001    li r3,0x1                   
1002aed8  396b0001    addi r11,r11,0x1            
1002aedc  b17f00a8    sth r11,0xa8(r31)           
1002aee0  a99f0118    lha r12,0x118(r31)          
1002aee4  38800001    li r4,0x1                   
1002aee8  398c0001    addi r12,r12,0x1            
1002aeec  b19f0118    sth r12,0x118(r31)          
1002aef0  4bfec091    bl 0x10016f80                  ; -> 10016f80
1002aef4  60000000    ori r0,r0,0x0               
1002aef8  48000014    b 0x1002af0c                   ; -> 1002af0c
1002aefc  38600000    li r3,0x0                   
1002af00  38800001    li r4,0x1                   
1002af04  4bfec07d    bl 0x10016f80                  ; -> 10016f80
1002af08  60000000    ori r0,r0,0x0               
1002af0c  a87f00a8    lha r3,0xa8(r31)            
1002af10  a89f0118    lha r4,0x118(r31)           
1002af14  7c630734    extsh r3,r3                 
1002af18  7c032000    cmpw r3,r4                  
1002af1c  4081000c    ble 0x1002af28                 ; -> 1002af28
1002af20  a8bf00a8    lha r5,0xa8(r31)            
1002af24  b0bf0118    sth r5,0x118(r31)           
1002af28  a8df0118    lha r6,0x118(r31)           
1002af2c  a8ff00a8    lha r7,0xa8(r31)            
1002af30  7cc60734    extsh r6,r6                 
1002af34  7c063800    cmpw r6,r7                  
1002af38  4081000c    ble 0x1002af44                 ; -> 1002af44
1002af3c  a91f0118    lha r8,0x118(r31)           
1002af40  b11f00a8    sth r8,0xa8(r31)            
1002af44  392261f0    addi r9,r2,0x61f0           
1002af48  80690000    lwz r3,0x0(r9)              
1002af4c  48006815    bl 0x10031760                  ; -> 10031760
1002af50  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x6c]
1002af54  38600014    li r3,0x14                  
1002af58  4bfed7e5    bl 0x1001873c                  ; -> 1001873c
1002af5c  60000000    ori r0,r0,0x0               
1002af60  80010088    lwz r0,0x88(r1)                ; -> Stack[0x8]
1002af64  38210080    addi r1,r1,0x80             
1002af68  7c0803a6    mtspr LR,r0                 
1002af6c  ba01ffc0    lmw r16,-0x40(r1)              ; -> Stack[-0x40]
1002af70  4e800020    blr                         
