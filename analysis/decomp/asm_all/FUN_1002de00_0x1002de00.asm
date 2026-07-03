; FUN_1002de00 @ 0x1002de00
1002de00  7c0802a6    mfspr r0,LR                 
1002de04  bdc1ffb8    stmw r14,-0x48(r1)             ; -> Stack[-0x48]
1002de08  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002de0c  9421ff70    stwu r1,-0x90(r1)              ; -> Stack[-0x90]
1002de10  3a226a70    addi r17,r2,0x6a70          
1002de14  3a426a52    addi r18,r2,0x6a52          
1002de18  3ae26840    addi r23,r2,0x6840          
1002de1c  3b826bf8    addi r28,r2,0x6bf8          
1002de20  3b026ba4    addi r24,r2,0x6ba4          
1002de24  3aa26bb8    addi r21,r2,0x6bb8          
1002de28  3b226bbc    addi r25,r2,0x6bbc          
1002de2c  3b426bc0    addi r26,r2,0x6bc0          
1002de30  3a627934    addi r19,r2,0x7934          
1002de34  3ac27534    addi r22,r2,0x7534          
1002de38  3b6269fc    addi r27,r2,0x69fc          
1002de3c  3a825332    addi r20,r2,0x5332          
1002de40  4bfe9d29    bl 0x10017b68                  ; -> 10017b68
1002de44  60000000    ori r0,r0,0x0               
1002de48  38825346    addi r4,r2,0x5346           
1002de4c  38600000    li r3,0x0                   
1002de50  38c2613e    addi r6,r2,0x613e           
1002de54  98640000    stb r3,0x0(r4)              
1002de58  38a00008    li r5,0x8                   
1002de5c  b0a60000    sth r5,0x0(r6)              
1002de60  4bfd6221    bl 0x10004080                  ; -> 10004080
1002de64  60000000    ori r0,r0,0x0               
1002de68  4bffff29    bl 0x1002dd90                  ; -> 1002dd90
1002de6c  38600001    li r3,0x1                   
1002de70  4bff3ac9    bl 0x10021938                  ; -> 10021938
1002de74  60000000    ori r0,r0,0x0               
1002de78  38e27530    addi r7,r2,0x7530           
1002de7c  80670000    lwz r3,0x0(r7)              
1002de80  480042b9    bl 0x10032138                  ; -> 10032138
1002de84  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002de88  48003c81    bl 0x10031b08                  ; -> 10031b08
1002de8c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002de90  a9130056    lha r8,0x56(r19)            
1002de94  7c6f1b78    or r15,r3,r3                
1002de98  7d0e4378    or r14,r8,r8                
1002de9c  a8930058    lha r4,0x58(r19)            
1002dea0  a8b30056    lha r5,0x56(r19)            
1002dea4  a8d3005c    lha r6,0x5c(r19)            
1002dea8  3861003e    addi r3,r1,0x3e             
1002deac  7cee7a14    add r7,r14,r15              
1002deb0  48003c89    bl 0x10031b38                  ; -> 10031b38
1002deb4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002deb8  48003c99    bl 0x10031b50                  ; -> 10031b50
1002debc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002dec0  7c701b78    or r16,r3,r3                
1002dec4  7e038378    or r3,r16,r16               
1002dec8  3881003e    addi r4,r1,0x3e             
1002decc  48003b4d    bl 0x10031a18                  ; -> 10031a18
1002ded0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002ded4  81360000    lwz r9,0x0(r22)             
1002ded8  81560000    lwz r10,0x0(r22)            
1002dedc  80690018    lwz r3,0x18(r9)             
1002dee0  388a0010    addi r4,r10,0x10            
1002dee4  48003b35    bl 0x10031a18                  ; -> 10031a18
1002dee8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002deec  81760000    lwz r11,0x0(r22)            
1002def0  81960000    lwz r12,0x0(r22)            
1002def4  806b0018    lwz r3,0x18(r11)            
1002def8  80ac0018    lwz r5,0x18(r12)            
1002defc  7e048378    or r4,r16,r16               
1002df00  48003c69    bl 0x10031b68                  ; -> 10031b68
1002df04  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002df08  7e038378    or r3,r16,r16               
1002df0c  48003c75    bl 0x10031b80                  ; -> 10031b80
1002df10  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002df14  38600000    li r3,0x0                   
1002df18  48003171    bl 0x10031088                  ; -> 10031088
1002df1c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002df20  80760000    lwz r3,0x0(r22)             
1002df24  4800329d    bl 0x100311c0                  ; -> 100311c0
1002df28  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002df2c  39c00000    li r14,0x0                  
1002df30  b1c1003c    sth r14,0x3c(r1)               ; -> Stack[-0x54]
1002df34  b1c1003a    sth r14,0x3a(r1)               ; -> Stack[-0x56]
1002df38  b1c10038    sth r14,0x38(r1)               ; -> Stack[-0x58]
1002df3c  38610038    addi r3,r1,0x38             
1002df40  48003c59    bl 0x10031b98                  ; -> 10031b98
1002df44  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002df48  81f60000    lwz r15,0x0(r22)            
1002df4c  386f0010    addi r3,r15,0x10            
1002df50  48003c61    bl 0x10031bb0                  ; -> 10031bb0
1002df54  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x7c]
1002df58  388270fc    addi r4,r2,0x70fc           
1002df5c  80640000    lwz r3,0x0(r4)              
1002df60  4bff3f01    bl 0x10021e60                  ; -> 10021e60
1002df64  60000000    ori r0,r0,0x0               
1002df68  4bfd6b61    bl 0x10004ac8                  ; -> 10004ac8
1002df6c  60000000    ori r0,r0,0x0               
1002df70  4bffa9e9    bl 0x10028958                  ; -> 10028958
1002df74  38a22f74    addi r5,r2,0x2f74           
1002df78  88a50000    lbz r5,0x0(r5)              
1002df7c  28050000    cmplwi r5,0x0               
1002df80  41820080    beq 0x1002e000                 ; -> 1002e000
1002df84  38c269fe    addi r6,r2,0x69fe           
1002df88  88c60000    lbz r6,0x0(r6)              
1002df8c  28060000    cmplwi r6,0x0               
1002df90  41820070    beq 0x1002e000                 ; -> 1002e000
1002df94  80750000    lwz r3,0x0(r21)             
1002df98  38800003    li r4,0x3                   
1002df9c  38a0001e    li r5,0x1e                  
1002dfa0  38c00000    li r6,0x0                   
1002dfa4  4bfd6c11    bl 0x10004bb4                  ; -> 10004bb4
1002dfa8  60000000    ori r0,r0,0x0               
1002dfac  80750000    lwz r3,0x0(r21)             
1002dfb0  38800004    li r4,0x4                   
1002dfb4  38a0001e    li r5,0x1e                  
1002dfb8  38c00010    li r6,0x10                  
1002dfbc  4bfd6bf9    bl 0x10004bb4                  ; -> 10004bb4
1002dfc0  60000000    ori r0,r0,0x0               
1002dfc4  807700ac    lwz r3,0xac(r23)            
1002dfc8  7e449378    or r4,r18,r18               
1002dfcc  4bffd935    bl 0x1002b900                  ; -> 1002b900
1002dfd0  7e439378    or r3,r18,r18               
1002dfd4  38800050    li r4,0x50                  
1002dfd8  38a00000    li r5,0x0                   
1002dfdc  4bffd835    bl 0x1002b810                  ; -> 1002b810
1002dfe0  8077011c    lwz r3,0x11c(r23)           
1002dfe4  38826a16    addi r4,r2,0x6a16           
1002dfe8  4bffd919    bl 0x1002b900                  ; -> 1002b900
1002dfec  38626a16    addi r3,r2,0x6a16           
1002dff0  38800050    li r4,0x50                  
1002dff4  38a00010    li r5,0x10                  
1002dff8  4bffd819    bl 0x1002b810                  ; -> 1002b810
1002dffc  48000048    b 0x1002e044                   ; -> 1002e044
1002e000  a8f40000    lha r7,0x0(r20)             
1002e004  80750000    lwz r3,0x0(r21)             
1002e008  38870002    addi r4,r7,0x2              
1002e00c  38a0001e    li r5,0x1e                  
1002e010  38c00008    li r6,0x8                   
1002e014  4bfd6ba1    bl 0x10004bb4                  ; -> 10004bb4
1002e018  60000000    ori r0,r0,0x0               
1002e01c  a9140000    lha r8,0x0(r20)             
1002e020  7e449378    or r4,r18,r18               
1002e024  1d080070    mulli r8,r8,0x70            
1002e028  3908003c    addi r8,r8,0x3c             
1002e02c  7c77402e    lwzx r3,r23,r8              
1002e030  4bffd8d1    bl 0x1002b900                  ; -> 1002b900
1002e034  7e439378    or r3,r18,r18               
1002e038  38800050    li r4,0x50                  
1002e03c  38a00008    li r5,0x8                   
1002e040  4bffd7d1    bl 0x1002b810                  ; -> 1002b810
1002e044  39222f74    addi r9,r2,0x2f74           
1002e048  89290000    lbz r9,0x0(r9)              
1002e04c  28090000    cmplwi r9,0x0               
1002e050  41820080    beq 0x1002e0d0                 ; -> 1002e0d0
1002e054  394269fe    addi r10,r2,0x69fe          
1002e058  894a0000    lbz r10,0x0(r10)            
1002e05c  280a0000    cmplwi r10,0x0              
1002e060  41820070    beq 0x1002e0d0                 ; -> 1002e0d0
1002e064  80750000    lwz r3,0x0(r21)             
1002e068  38800001    li r4,0x1                   
1002e06c  38a000c8    li r5,0xc8                  
1002e070  38c00000    li r6,0x0                   
1002e074  4bfd6b41    bl 0x10004bb4                  ; -> 10004bb4
1002e078  60000000    ori r0,r0,0x0               
1002e07c  a87700b0    lha r3,0xb0(r23)            
1002e080  7e248b78    or r4,r17,r17               
1002e084  4bffd8cd    bl 0x1002b950                  ; -> 1002b950
1002e088  7e238b78    or r3,r17,r17               
1002e08c  388000f4    li r4,0xf4                  
1002e090  38a00000    li r5,0x0                   
1002e094  4bffd7f5    bl 0x1002b888                  ; -> 1002b888
1002e098  80750000    lwz r3,0x0(r21)             
1002e09c  38800002    li r4,0x2                   
1002e0a0  38a000c8    li r5,0xc8                  
1002e0a4  38c00010    li r6,0x10                  
1002e0a8  4bfd6b0d    bl 0x10004bb4                  ; -> 10004bb4
1002e0ac  60000000    ori r0,r0,0x0               
1002e0b0  a8770120    lha r3,0x120(r23)           
1002e0b4  38826a34    addi r4,r2,0x6a34           
1002e0b8  4bffd899    bl 0x1002b950                  ; -> 1002b950
1002e0bc  38626a34    addi r3,r2,0x6a34           
1002e0c0  388000f4    li r4,0xf4                  
1002e0c4  38a00010    li r5,0x10                  
1002e0c8  4bffd7c1    bl 0x1002b888                  ; -> 1002b888
1002e0cc  48000044    b 0x1002e110                   ; -> 1002e110
1002e0d0  80750000    lwz r3,0x0(r21)             
1002e0d4  a8940000    lha r4,0x0(r20)             
1002e0d8  38a000c8    li r5,0xc8                  
1002e0dc  38c00008    li r6,0x8                   
1002e0e0  4bfd6ad5    bl 0x10004bb4                  ; -> 10004bb4
1002e0e4  60000000    ori r0,r0,0x0               
1002e0e8  a9740000    lha r11,0x0(r20)            
1002e0ec  7e248b78    or r4,r17,r17               
1002e0f0  1d6b0070    mulli r11,r11,0x70          
1002e0f4  396b0040    addi r11,r11,0x40           
1002e0f8  7c775aae    lhax r3,r23,r11             
1002e0fc  4bffd855    bl 0x1002b950                  ; -> 1002b950
1002e100  7e238b78    or r3,r17,r17               
1002e104  388000f4    li r4,0xf4                  
1002e108  38a00008    li r5,0x8                   
1002e10c  4bffd77d    bl 0x1002b888                  ; -> 1002b888
1002e110  39c26a01    addi r14,r2,0x6a01          
1002e114  39800001    li r12,0x1                  
1002e118  38626a00    addi r3,r2,0x6a00           
1002e11c  998e0000    stb r12,0x0(r14)            
1002e120  39e00001    li r15,0x1                  
1002e124  99e30000    stb r15,0x0(r3)             
1002e128  4bfe7f15    bl 0x1001603c                  ; -> 1001603c
1002e12c  60000000    ori r0,r0,0x0               
1002e130  4bfe19e9    bl 0x1000fb18                  ; -> 1000fb18
1002e134  60000000    ori r0,r0,0x0               
1002e138  a8940000    lha r4,0x0(r20)             
1002e13c  38a00008    li r5,0x8                   
1002e140  1c840070    mulli r4,r4,0x70            
1002e144  38840038    addi r4,r4,0x38             
1002e148  7c7722ae    lhax r3,r23,r4              
1002e14c  3880021c    li r4,0x21c                 
1002e150  480003d9    bl 0x1002e528                  ; -> 1002e528
1002e154  60000000    ori r0,r0,0x0               
1002e158  480001ed    bl 0x1002e344                  ; -> 1002e344
1002e15c  60000000    ori r0,r0,0x0               
1002e160  3ba00001    li r29,0x1                  
1002e164  480001ac    b 0x1002e310                   ; -> 1002e310
1002e168  3be00001    li r31,0x1                  
1002e16c  4800018c    b 0x1002e2f8                   ; -> 1002e2f8
1002e170  7fa70734    extsh r7,r29                
1002e174  7fa50734    extsh r5,r29                
1002e178  7fe80734    extsh r8,r31                
1002e17c  7fe60734    extsh r6,r31                
1002e180  1ce7003c    mulli r7,r7,0x3c            
1002e184  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
1002e188  7ce74214    add r7,r7,r8                
1002e18c  7cfc382e    lwzx r7,r28,r7              
1002e190  1ca5003c    mulli r5,r5,0x3c            
1002e194  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002e198  7ca53214    add r5,r5,r6                
1002e19c  54e70528    rlwinm r7,r7,0x0,0x14,0x14  
1002e1a0  7cbc282e    lwzx r5,r28,r5              
1002e1a4  2c070000    cmpwi r7,0x0                
1002e1a8  54be063e    rlwinm r30,r5,0x0,0x18,0x1f 
1002e1ac  418200c0    beq 0x1002e26c                 ; -> 1002e26c
1002e1b0  7fc90734    extsh r9,r30                
1002e1b4  2c090001    cmpwi r9,0x1                
1002e1b8  40820008    bne 0x1002e1c0                 ; -> 1002e1c0
1002e1bc  48000010    b 0x1002e1cc                   ; -> 1002e1cc
1002e1c0  7fca0734    extsh r10,r30               
1002e1c4  2c0a0004    cmpwi r10,0x4               
1002e1c8  40820004    bne 0x1002e1cc                 ; -> 1002e1cc
1002e1cc  7fcb0734    extsh r11,r30               
1002e1d0  2c0b00ff    cmpwi r11,0xff              
1002e1d4  40820040    bne 0x1002e214                 ; -> 1002e214
1002e1d8  7fe3fb78    or r3,r31,r31               
1002e1dc  480004e1    bl 0x1002e6bc                  ; -> 1002e6bc
1002e1e0  60000000    ori r0,r0,0x0               
1002e1e4  7c6f1b78    or r15,r3,r3                
1002e1e8  7fa3eb78    or r3,r29,r29               
1002e1ec  480004c1    bl 0x1002e6ac                  ; -> 1002e6ac
1002e1f0  60000000    ori r0,r0,0x0               
1002e1f4  7c6e1b78    or r14,r3,r3                
1002e1f8  80780000    lwz r3,0x0(r24)             
1002e1fc  38800010    li r4,0x10                  
1002e200  38ae0004    addi r5,r14,0x4             
1002e204  38cf0004    addi r6,r15,0x4             
1002e208  4bfd5f01    bl 0x10004108                  ; -> 10004108
1002e20c  60000000    ori r0,r0,0x0               
1002e210  480000e4    b 0x1002e2f4                   ; -> 1002e2f4
1002e214  7fac0734    extsh r12,r29               
1002e218  7fee0734    extsh r14,r31               
1002e21c  1d8c003c    mulli r12,r12,0x3c          
1002e220  55ce103a    rlwinm r14,r14,0x2,0x0,0x1d 
1002e224  7d8c7214    add r12,r12,r14             
1002e228  7d9c602e    lwzx r12,r28,r12            
1002e22c  7fe3fb78    or r3,r31,r31               
1002e230  559e063e    rlwinm r30,r12,0x0,0x18,0x1f
1002e234  48000489    bl 0x1002e6bc                  ; -> 1002e6bc
1002e238  60000000    ori r0,r0,0x0               
1002e23c  7c6f1b78    or r15,r3,r3                
1002e240  7fa3eb78    or r3,r29,r29               
1002e244  48000469    bl 0x1002e6ac                  ; -> 1002e6ac
1002e248  60000000    ori r0,r0,0x0               
1002e24c  7c6e1b78    or r14,r3,r3                
1002e250  80790000    lwz r3,0x0(r25)             
1002e254  7fc4f378    or r4,r30,r30               
1002e258  7dc57378    or r5,r14,r14               
1002e25c  7de67b78    or r6,r15,r15               
1002e260  4bfd5ea9    bl 0x10004108                  ; -> 10004108
1002e264  60000000    ori r0,r0,0x0               
1002e268  4800008c    b 0x1002e2f4                   ; -> 1002e2f4
1002e26c  7faf0734    extsh r15,r29               
1002e270  7fe30734    extsh r3,r31                
1002e274  1def003c    mulli r15,r15,0x3c          
1002e278  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1002e27c  7def1a14    add r15,r15,r3              
1002e280  7dfc782e    lwzx r15,r28,r15            
1002e284  55ef056a    rlwinm r15,r15,0x0,0x15,0x15
1002e288  2c0f0000    cmpwi r15,0x0               
1002e28c  40820068    bne 0x1002e2f4                 ; -> 1002e2f4
1002e290  7fc40734    extsh r4,r30                
1002e294  2c040000    cmpwi r4,0x0                
1002e298  4182005c    beq 0x1002e2f4                 ; -> 1002e2f4
1002e29c  7fc3f378    or r3,r30,r30               
1002e2a0  7fa4eb78    or r4,r29,r29               
1002e2a4  7fe5fb78    or r5,r31,r31               
1002e2a8  4bfe7da5    bl 0x1001604c                  ; -> 1001604c
1002e2ac  60000000    ori r0,r0,0x0               
1002e2b0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002e2b4  28030000    cmplwi r3,0x0               
1002e2b8  4082003c    bne 0x1002e2f4                 ; -> 1002e2f4
1002e2bc  7fe3fb78    or r3,r31,r31               
1002e2c0  480003fd    bl 0x1002e6bc                  ; -> 1002e6bc
1002e2c4  60000000    ori r0,r0,0x0               
1002e2c8  7c6f1b78    or r15,r3,r3                
1002e2cc  7fa3eb78    or r3,r29,r29               
1002e2d0  480003dd    bl 0x1002e6ac                  ; -> 1002e6ac
1002e2d4  60000000    ori r0,r0,0x0               
1002e2d8  7c6e1b78    or r14,r3,r3                
1002e2dc  807a0000    lwz r3,0x0(r26)             
1002e2e0  7fc4f378    or r4,r30,r30               
1002e2e4  7dc57378    or r5,r14,r14               
1002e2e8  7de67b78    or r6,r15,r15               
1002e2ec  4bfd5e1d    bl 0x10004108                  ; -> 10004108
1002e2f0  60000000    ori r0,r0,0x0               
1002e2f4  3bff0001    addi r31,r31,0x1            
1002e2f8  7fe50734    extsh r5,r31                
1002e2fc  2c05000d    cmpwi r5,0xd                
1002e300  4081fe70    ble 0x1002e170                 ; -> 1002e170
1002e304  4bfd5e7d    bl 0x10004180                  ; -> 10004180
1002e308  60000000    ori r0,r0,0x0               
1002e30c  3bbd0001    addi r29,r29,0x1            
1002e310  7fa60734    extsh r6,r29                
1002e314  2c060013    cmpwi r6,0x13               
1002e318  4081fe50    ble 0x1002e168                 ; -> 1002e168
1002e31c  4bffa6a5    bl 0x100289c0                  ; -> 100289c0
1002e320  4bfd5d61    bl 0x10004080                  ; -> 10004080
1002e324  60000000    ori r0,r0,0x0               
1002e328  4bff38ed    bl 0x10021c14                  ; -> 10021c14
1002e32c  60000000    ori r0,r0,0x0               
1002e330  80010098    lwz r0,0x98(r1)                ; -> Stack[0x8]
1002e334  38210090    addi r1,r1,0x90             
1002e338  7c0803a6    mtspr LR,r0                 
1002e33c  b9c1ffb8    lmw r14,-0x48(r1)              ; -> Stack[-0x48]
1002e340  4e800020    blr                         
