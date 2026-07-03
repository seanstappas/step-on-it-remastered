; FUN_1000dd4c @ 0x1000dd4c
1000dd4c  7c0802a6    mfspr r0,LR                 
1000dd50  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000dd54  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000dd58  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000dd5c  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1000dd60  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000dd64  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000dd68  7c7c1b78    or r28,r3,r3                
1000dd6c  7f830734    extsh r3,r28                
1000dd70  1c630046    mulli r3,r3,0x46            
1000dd74  3bc23cd8    addi r30,r2,0x3cd8          
1000dd78  3ba261a4    addi r29,r2,0x61a4          
1000dd7c  7ffe1a14    add r31,r30,r3              
1000dd80  889f001f    lbz r4,0x1f(r31)            
1000dd84  28040000    cmplwi r4,0x0               
1000dd88  418200b8    beq 0x1000de40                 ; -> 1000de40
1000dd8c  38a00000    li r5,0x0                   
1000dd90  98bf001f    stb r5,0x1f(r31)            
1000dd94  38c00001    li r6,0x1                   
1000dd98  b0df0024    sth r6,0x24(r31)            
1000dd9c  38e00000    li r7,0x0                   
1000dda0  b0ff002e    sth r7,0x2e(r31)            
1000dda4  811d0010    lwz r8,0x10(r29)            
1000dda8  39200000    li r9,0x0                   
1000ddac  911f000a    stw r8,0xa(r31)             
1000ddb0  913f0014    stw r9,0x14(r31)            
1000ddb4  a95f0004    lha r10,0x4(r31)            
1000ddb8  2c0a0002    cmpwi r10,0x2               
1000ddbc  4082002c    bne 0x1000dde8                 ; -> 1000dde8
1000ddc0  a99f0010    lha r12,0x10(r31)           
1000ddc4  3962053c    addi r11,r2,0x53c           
1000ddc8  7d832e70    srawi r3,r12,0x5            
1000ddcc  7c630194    addze r3,r3                 
1000ddd0  54632834    rlwinm r3,r3,0x5,0x0,0x1a   
1000ddd4  7c636010    subfc r3,r3,r12             
1000ddd8  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
1000dddc  7d6b1aae    lhax r11,r11,r3             
1000dde0  b17f000e    sth r11,0xe(r31)            
1000dde4  48000028    b 0x1000de0c                   ; -> 1000de0c
1000dde8  a8bf0010    lha r5,0x10(r31)            
1000ddec  388204fc    addi r4,r2,0x4fc            
1000ddf0  7ca62e70    srawi r6,r5,0x5             
1000ddf4  7cc60194    addze r6,r6                 
1000ddf8  54c62834    rlwinm r6,r6,0x5,0x0,0x1a   
1000ddfc  7cc62810    subfc r6,r6,r5              
1000de00  54c6083c    rlwinm r6,r6,0x1,0x0,0x1e   
1000de04  7c8432ae    lhax r4,r4,r6               
1000de08  b09f000e    sth r4,0xe(r31)             
1000de0c  a8ff0012    lha r7,0x12(r31)            
1000de10  39000001    li r8,0x1                   
1000de14  38e70006    addi r7,r7,0x6              
1000de18  b0ff0012    sth r7,0x12(r31)            
1000de1c  991f001e    stb r8,0x1e(r31)            
1000de20  a93f0008    lha r9,0x8(r31)             
1000de24  394004e2    li r10,0x4e2                
1000de28  1d290006    mulli r9,r9,0x6             
1000de2c  b13f0026    sth r9,0x26(r31)            
1000de30  b15f0042    sth r10,0x42(r31)           
1000de34  39600000    li r11,0x0                  
1000de38  b17f0044    sth r11,0x44(r31)           
1000de3c  48000564    b 0x1000e3a0                   ; -> 1000e3a0
1000de40  a99f0024    lha r12,0x24(r31)           
1000de44  7d836378    or r3,r12,r12               
1000de48  7c630734    extsh r3,r3                 
1000de4c  398cffff    subi r12,r12,0x1            
1000de50  2c030000    cmpwi r3,0x0                
1000de54  b19f0024    sth r12,0x24(r31)           
1000de58  41810548    bgt 0x1000e3a0                 ; -> 1000e3a0
1000de5c  38800001    li r4,0x1                   
1000de60  989f001e    stb r4,0x1e(r31)            
1000de64  a8bf0026    lha r5,0x26(r31)            
1000de68  38a5ffff    subi r5,r5,0x1              
1000de6c  b0bf0026    sth r5,0x26(r31)            
1000de70  a8df0040    lha r6,0x40(r31)            
1000de74  2c060000    cmpwi r6,0x0                
1000de78  40810058    ble 0x1000ded0                 ; -> 1000ded0
1000de7c  3860000c    li r3,0xc                   
1000de80  38800005    li r4,0x5                   
1000de84  4801d19d    bl 0x1002b020                  ; -> 1002b020
1000de88  60000000    ori r0,r0,0x0               
1000de8c  38e00001    li r7,0x1                   
1000de90  98ff0020    stb r7,0x20(r31)            
1000de94  807f000a    lwz r3,0xa(r31)             
1000de98  a89f000e    lha r4,0xe(r31)             
1000de9c  a8bf0010    lha r5,0x10(r31)            
1000dea0  a8df0012    lha r6,0x12(r31)            
1000dea4  38e00001    li r7,0x1                   
1000dea8  4801a16d    bl 0x10028014                  ; -> 10028014
1000deac  60000000    ori r0,r0,0x0               
1000deb0  a95f0040    lha r10,0x40(r31)           
1000deb4  39226840    addi r9,r2,0x6840           
1000deb8  1d4a0070    mulli r10,r10,0x70          
1000debc  3929003c    addi r9,r9,0x3c             
1000dec0  a91f0042    lha r8,0x42(r31)            
1000dec4  7d69502e    lwzx r11,r9,r10             
1000dec8  7d6b4214    add r11,r11,r8              
1000decc  7d69512e    stwx r11,r9,r10             
1000ded0  39800002    li r12,0x2                  
1000ded4  b19f0024    sth r12,0x24(r31)           
1000ded8  a89f0010    lha r4,0x10(r31)            
1000dedc  a8bf0010    lha r5,0x10(r31)            
1000dee0  38640008    addi r3,r4,0x8              
1000dee4  a8df0012    lha r6,0x12(r31)            
1000dee8  38850020    addi r4,r5,0x20             
1000deec  38a6001a    addi r5,r6,0x1a             
1000def0  4bff7861    bl 0x10005750                  ; -> 10005750
1000def4  60000000    ori r0,r0,0x0               
1000def8  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000defc  28030000    cmplwi r3,0x0               
1000df00  41820100    beq 0x1000e000                 ; -> 1000e000
1000df04  a8ff0044    lha r7,0x44(r31)            
1000df08  2c070000    cmpwi r7,0x0                
1000df0c  40820018    bne 0x1000df24                 ; -> 1000df24
1000df10  a87f0010    lha r3,0x10(r31)            
1000df14  a89f0012    lha r4,0x12(r31)            
1000df18  4bff7905    bl 0x1000581c                  ; -> 1000581c
1000df1c  60000000    ori r0,r0,0x0               
1000df20  b07f0044    sth r3,0x44(r31)            
1000df24  39000001    li r8,0x1                   
1000df28  b11f0024    sth r8,0x24(r31)            
1000df2c  a93f0012    lha r9,0x12(r31)            
1000df30  39290004    addi r9,r9,0x4              
1000df34  b13f0012    sth r9,0x12(r31)            
1000df38  a95f000e    lha r10,0xe(r31)            
1000df3c  394a0004    addi r10,r10,0x4            
1000df40  b15f000e    sth r10,0xe(r31)            
1000df44  a97f0004    lha r11,0x4(r31)            
1000df48  2c0b0002    cmpwi r11,0x2               
1000df4c  4082001c    bne 0x1000df68                 ; -> 1000df68
1000df50  a99f000e    lha r12,0xe(r31)            
1000df54  2c0c0030    cmpwi r12,0x30              
1000df58  40810024    ble 0x1000df7c                 ; -> 1000df7c
1000df5c  38600021    li r3,0x21                  
1000df60  b07f000e    sth r3,0xe(r31)             
1000df64  48000018    b 0x1000df7c                   ; -> 1000df7c
1000df68  a89f000e    lha r4,0xe(r31)             
1000df6c  2c040010    cmpwi r4,0x10               
1000df70  4081000c    ble 0x1000df7c                 ; -> 1000df7c
1000df74  38a00001    li r5,0x1                   
1000df78  b0bf000e    sth r5,0xe(r31)             
1000df7c  a8df0010    lha r6,0x10(r31)            
1000df80  a8ff0010    lha r7,0x10(r31)            
1000df84  a91f0012    lha r8,0x12(r31)            
1000df88  38660008    addi r3,r6,0x8              
1000df8c  38870020    addi r4,r7,0x20             
1000df90  38a8001a    addi r5,r8,0x1a             
1000df94  4bff77bd    bl 0x10005750                  ; -> 10005750
1000df98  60000000    ori r0,r0,0x0               
1000df9c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000dfa0  28030000    cmplwi r3,0x0               
1000dfa4  408203cc    bne 0x1000e370                 ; -> 1000e370
1000dfa8  3860000c    li r3,0xc                   
1000dfac  38800005    li r4,0x5                   
1000dfb0  4801d071    bl 0x1002b020                  ; -> 1002b020
1000dfb4  60000000    ori r0,r0,0x0               
1000dfb8  a97f0044    lha r11,0x44(r31)           
1000dfbc  39426840    addi r10,r2,0x6840          
1000dfc0  1d6b0070    mulli r11,r11,0x70          
1000dfc4  394a003c    addi r10,r10,0x3c           
1000dfc8  a93f0042    lha r9,0x42(r31)            
1000dfcc  7d8a582e    lwzx r12,r10,r11            
1000dfd0  38600001    li r3,0x1                   
1000dfd4  7d8c4a14    add r12,r12,r9              
1000dfd8  7d8a592e    stwx r12,r10,r11            
1000dfdc  987f0020    stb r3,0x20(r31)            
1000dfe0  807f000a    lwz r3,0xa(r31)             
1000dfe4  a89f000e    lha r4,0xe(r31)             
1000dfe8  a8bf0010    lha r5,0x10(r31)            
1000dfec  a8df0012    lha r6,0x12(r31)            
1000dff0  38e00001    li r7,0x1                   
1000dff4  4801a021    bl 0x10028014                  ; -> 10028014
1000dff8  60000000    ori r0,r0,0x0               
1000dffc  48000374    b 0x1000e370                   ; -> 1000e370
1000e000  a89f0004    lha r4,0x4(r31)             
1000e004  2c040002    cmpwi r4,0x2                
1000e008  4082017c    bne 0x1000e184                 ; -> 1000e184
1000e00c  a8bf0010    lha r5,0x10(r31)            
1000e010  a8df0012    lha r6,0x12(r31)            
1000e014  38650022    addi r3,r5,0x22             
1000e018  3886000a    addi r4,r6,0xa              
1000e01c  4bff7531    bl 0x1000554c                  ; -> 1000554c
1000e020  60000000    ori r0,r0,0x0               
1000e024  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000e028  28030000    cmplwi r3,0x0               
1000e02c  40820028    bne 0x1000e054                 ; -> 1000e054
1000e030  a8ff0010    lha r7,0x10(r31)            
1000e034  a91f0012    lha r8,0x12(r31)            
1000e038  38670022    addi r3,r7,0x22             
1000e03c  3888001a    addi r4,r8,0x1a             
1000e040  4bff750d    bl 0x1000554c                  ; -> 1000554c
1000e044  60000000    ori r0,r0,0x0               
1000e048  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000e04c  28030000    cmplwi r3,0x0               
1000e050  40820018    bne 0x1000e068                 ; -> 1000e068
1000e054  39200005    li r9,0x5                   
1000e058  b13f0004    sth r9,0x4(r31)             
1000e05c  39400020    li r10,0x20                 
1000e060  b15f000e    sth r10,0xe(r31)            
1000e064  48000034    b 0x1000e098                   ; -> 1000e098
1000e068  a97f0010    lha r11,0x10(r31)           
1000e06c  3982053c    addi r12,r2,0x53c           
1000e070  396b0001    addi r11,r11,0x1            
1000e074  b17f0010    sth r11,0x10(r31)           
1000e078  a87f0010    lha r3,0x10(r31)            
1000e07c  7c642e70    srawi r4,r3,0x5             
1000e080  7c840194    addze r4,r4                 
1000e084  54842834    rlwinm r4,r4,0x5,0x0,0x1a   
1000e088  7c841810    subfc r4,r4,r3              
1000e08c  5484083c    rlwinm r4,r4,0x1,0x0,0x1e   
1000e090  7d8c22ae    lhax r12,r12,r4             
1000e094  b19f000e    sth r12,0xe(r31)            
1000e098  7f83e378    or r3,r28,r28               
1000e09c  4800052d    bl 0x1000e5c8                  ; -> 1000e5c8
1000e0a0  60000000    ori r0,r0,0x0               
1000e0a4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000e0a8  28030000    cmplwi r3,0x0               
1000e0ac  418202c4    beq 0x1000e370                 ; -> 1000e370
1000e0b0  38600013    li r3,0x13                  
1000e0b4  38800004    li r4,0x4                   
1000e0b8  4801cf69    bl 0x1002b020                  ; -> 1002b020
1000e0bc  60000000    ori r0,r0,0x0               
1000e0c0  a8bf0008    lha r5,0x8(r31)             
1000e0c4  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
1000e0c8  b0bf0026    sth r5,0x26(r31)            
1000e0cc  4bff787d    bl 0x10005948                  ; -> 10005948
1000e0d0  60000000    ori r0,r0,0x0               
1000e0d4  b07f0032    sth r3,0x32(r31)            
1000e0d8  a8ff0032    lha r7,0x32(r31)            
1000e0dc  a8df0010    lha r6,0x10(r31)            
1000e0e0  1ce70046    mulli r7,r7,0x46            
1000e0e4  38c6001e    addi r6,r6,0x1e             
1000e0e8  38e70010    addi r7,r7,0x10             
1000e0ec  7cde3b2e    sthx r6,r30,r7              
1000e0f0  a93f0032    lha r9,0x32(r31)            
1000e0f4  a91f0012    lha r8,0x12(r31)            
1000e0f8  1d290046    mulli r9,r9,0x46            
1000e0fc  39080008    addi r8,r8,0x8              
1000e100  39290012    addi r9,r9,0x12             
1000e104  7d1e4b2e    sthx r8,r30,r9              
1000e108  a97f0032    lha r11,0x32(r31)           
1000e10c  39400002    li r10,0x2                  
1000e110  1d6b0046    mulli r11,r11,0x46          
1000e114  396b0004    addi r11,r11,0x4            
1000e118  7d5e5b2e    sthx r10,r30,r11            
1000e11c  a87f0032    lha r3,0x32(r31)            
1000e120  39800031    li r12,0x31                 
1000e124  1c630046    mulli r3,r3,0x46            
1000e128  3863000e    addi r3,r3,0xe              
1000e12c  7d9e1b2e    sthx r12,r30,r3             
1000e130  a8bf0032    lha r5,0x32(r31)            
1000e134  38800068    li r4,0x68                  
1000e138  1ca50046    mulli r5,r5,0x46            
1000e13c  38a50002    addi r5,r5,0x2              
1000e140  7c9e2b2e    sthx r4,r30,r5              
1000e144  a8ff0032    lha r7,0x32(r31)            
1000e148  80dd0010    lwz r6,0x10(r29)            
1000e14c  1ce70046    mulli r7,r7,0x46            
1000e150  38e7000a    addi r7,r7,0xa              
1000e154  7cde392e    stwx r6,r30,r7              
1000e158  a93f0032    lha r9,0x32(r31)            
1000e15c  39000000    li r8,0x0                   
1000e160  1d290046    mulli r9,r9,0x46            
1000e164  39290014    addi r9,r9,0x14             
1000e168  7d1e492e    stwx r8,r30,r9              
1000e16c  a97f0032    lha r11,0x32(r31)           
1000e170  39400000    li r10,0x0                  
1000e174  1d6b0046    mulli r11,r11,0x46          
1000e178  396b001e    addi r11,r11,0x1e           
1000e17c  7d5e59ae    stbx r10,r30,r11            
1000e180  480001f0    b 0x1000e370                   ; -> 1000e370
1000e184  a99f0004    lha r12,0x4(r31)            
1000e188  2c0c0001    cmpwi r12,0x1               
1000e18c  4082017c    bne 0x1000e308                 ; -> 1000e308
1000e190  a89f0010    lha r4,0x10(r31)            
1000e194  a8bf0012    lha r5,0x12(r31)            
1000e198  38640002    addi r3,r4,0x2              
1000e19c  3885000a    addi r4,r5,0xa              
1000e1a0  4bff73ad    bl 0x1000554c                  ; -> 1000554c
1000e1a4  60000000    ori r0,r0,0x0               
1000e1a8  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000e1ac  28030000    cmplwi r3,0x0               
1000e1b0  40820028    bne 0x1000e1d8                 ; -> 1000e1d8
1000e1b4  a8df0010    lha r6,0x10(r31)            
1000e1b8  a8ff0012    lha r7,0x12(r31)            
1000e1bc  38660002    addi r3,r6,0x2              
1000e1c0  3887001a    addi r4,r7,0x1a             
1000e1c4  4bff7389    bl 0x1000554c                  ; -> 1000554c
1000e1c8  60000000    ori r0,r0,0x0               
1000e1cc  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000e1d0  28030000    cmplwi r3,0x0               
1000e1d4  40820018    bne 0x1000e1ec                 ; -> 1000e1ec
1000e1d8  39000006    li r8,0x6                   
1000e1dc  b11f0004    sth r8,0x4(r31)             
1000e1e0  39200011    li r9,0x11                  
1000e1e4  b13f000e    sth r9,0xe(r31)             
1000e1e8  48000034    b 0x1000e21c                   ; -> 1000e21c
1000e1ec  a95f0010    lha r10,0x10(r31)           
1000e1f0  396204fc    addi r11,r2,0x4fc           
1000e1f4  394affff    subi r10,r10,0x1            
1000e1f8  b15f0010    sth r10,0x10(r31)           
1000e1fc  a99f0010    lha r12,0x10(r31)           
1000e200  7d832e70    srawi r3,r12,0x5            
1000e204  7c630194    addze r3,r3                 
1000e208  54632834    rlwinm r3,r3,0x5,0x0,0x1a   
1000e20c  7c636010    subfc r3,r3,r12             
1000e210  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
1000e214  7d6b1aae    lhax r11,r11,r3             
1000e218  b17f000e    sth r11,0xe(r31)            
1000e21c  7f83e378    or r3,r28,r28               
1000e220  480005a9    bl 0x1000e7c8                  ; -> 1000e7c8
1000e224  60000000    ori r0,r0,0x0               
1000e228  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000e22c  28030000    cmplwi r3,0x0               
1000e230  41820140    beq 0x1000e370                 ; -> 1000e370
1000e234  38600013    li r3,0x13                  
1000e238  38800004    li r4,0x4                   
1000e23c  4801cde5    bl 0x1002b020                  ; -> 1002b020
1000e240  60000000    ori r0,r0,0x0               
1000e244  a89f0008    lha r4,0x8(r31)             
1000e248  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1000e24c  b09f0026    sth r4,0x26(r31)            
1000e250  4bff76f9    bl 0x10005948                  ; -> 10005948
1000e254  60000000    ori r0,r0,0x0               
1000e258  b07f0032    sth r3,0x32(r31)            
1000e25c  a8df0032    lha r6,0x32(r31)            
1000e260  a8bf0010    lha r5,0x10(r31)            
1000e264  1cc60046    mulli r6,r6,0x46            
1000e268  38a5fff8    subi r5,r5,0x8              
1000e26c  38c60010    addi r6,r6,0x10             
1000e270  7cbe332e    sthx r5,r30,r6              
1000e274  a91f0032    lha r8,0x32(r31)            
1000e278  a8ff0012    lha r7,0x12(r31)            
1000e27c  1d080046    mulli r8,r8,0x46            
1000e280  38e70004    addi r7,r7,0x4              
1000e284  39080012    addi r8,r8,0x12             
1000e288  7cfe432e    sthx r7,r30,r8              
1000e28c  a95f0032    lha r10,0x32(r31)           
1000e290  39200001    li r9,0x1                   
1000e294  1d4a0046    mulli r10,r10,0x46          
1000e298  394a0004    addi r10,r10,0x4            
1000e29c  7d3e532e    sthx r9,r30,r10             
1000e2a0  a99f0032    lha r12,0x32(r31)           
1000e2a4  39600041    li r11,0x41                 
1000e2a8  1d8c0046    mulli r12,r12,0x46          
1000e2ac  398c000e    addi r12,r12,0xe            
1000e2b0  7d7e632e    sthx r11,r30,r12            
1000e2b4  a89f0032    lha r4,0x32(r31)            
1000e2b8  38600068    li r3,0x68                  
1000e2bc  1c840046    mulli r4,r4,0x46            
1000e2c0  38840002    addi r4,r4,0x2              
1000e2c4  7c7e232e    sthx r3,r30,r4              
1000e2c8  a8df0032    lha r6,0x32(r31)            
1000e2cc  80bd0010    lwz r5,0x10(r29)            
1000e2d0  1cc60046    mulli r6,r6,0x46            
1000e2d4  38c6000a    addi r6,r6,0xa              
1000e2d8  7cbe312e    stwx r5,r30,r6              
1000e2dc  a91f0032    lha r8,0x32(r31)            
1000e2e0  38e00000    li r7,0x0                   
1000e2e4  1d080046    mulli r8,r8,0x46            
1000e2e8  39080014    addi r8,r8,0x14             
1000e2ec  7cfe412e    stwx r7,r30,r8              
1000e2f0  a95f0032    lha r10,0x32(r31)           
1000e2f4  39200000    li r9,0x0                   
1000e2f8  1d4a0046    mulli r10,r10,0x46          
1000e2fc  394a001e    addi r10,r10,0x1e           
1000e300  7d3e51ae    stbx r9,r30,r10             
1000e304  4800006c    b 0x1000e370                   ; -> 1000e370
1000e308  a97f0004    lha r11,0x4(r31)            
1000e30c  2c0b0006    cmpwi r11,0x6               
1000e310  40820034    bne 0x1000e344                 ; -> 1000e344
1000e314  a99f000e    lha r12,0xe(r31)            
1000e318  398c0001    addi r12,r12,0x1            
1000e31c  b19f000e    sth r12,0xe(r31)            
1000e320  7d8c0734    extsh r12,r12               
1000e324  2c0c0020    cmpwi r12,0x20              
1000e328  40810048    ble 0x1000e370                 ; -> 1000e370
1000e32c  38600002    li r3,0x2                   
1000e330  b07f0004    sth r3,0x4(r31)             
1000e334  a89f0010    lha r4,0x10(r31)            
1000e338  3884fffd    subi r4,r4,0x3              
1000e33c  b09f0010    sth r4,0x10(r31)            
1000e340  48000030    b 0x1000e370                   ; -> 1000e370
1000e344  a8bf0004    lha r5,0x4(r31)             
1000e348  2c050005    cmpwi r5,0x5                
1000e34c  40820024    bne 0x1000e370                 ; -> 1000e370
1000e350  a8df000e    lha r6,0xe(r31)             
1000e354  38c6ffff    subi r6,r6,0x1              
1000e358  b0df000e    sth r6,0xe(r31)             
1000e35c  7cc60734    extsh r6,r6                 
1000e360  2c060011    cmpwi r6,0x11               
1000e364  4080000c    bge 0x1000e370                 ; -> 1000e370
1000e368  38e00001    li r7,0x1                   
1000e36c  b0ff0004    sth r7,0x4(r31)             
1000e370  a91f0010    lha r8,0x10(r31)            
1000e374  39080008    addi r8,r8,0x8              
1000e378  b11f003a    sth r8,0x3a(r31)            
1000e37c  a93f0010    lha r9,0x10(r31)            
1000e380  3929001e    addi r9,r9,0x1e             
1000e384  b13f003c    sth r9,0x3c(r31)            
1000e388  a95f0012    lha r10,0x12(r31)           
1000e38c  394a0004    addi r10,r10,0x4            
1000e390  b15f0038    sth r10,0x38(r31)           
1000e394  a97f0012    lha r11,0x12(r31)           
1000e398  396b0018    addi r11,r11,0x18           
1000e39c  b17f0036    sth r11,0x36(r31)           
1000e3a0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000e3a4  38210050    addi r1,r1,0x50             
1000e3a8  7c0803a6    mtspr LR,r0                 
1000e3ac  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000e3b0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000e3b4  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000e3b8  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1000e3bc  4e800020    blr                         
