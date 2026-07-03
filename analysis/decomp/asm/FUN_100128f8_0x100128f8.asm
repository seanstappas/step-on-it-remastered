; FUN_100128f8 @ 0x100128f8  (191 instructions)
100128f8  7c0802a6    mfspr r0,LR                 
100128fc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10012900  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10012904  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10012908  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001290c  7c7f1b78    or r31,r3,r3                
10012910  3bc26840    addi r30,r2,0x6840          
10012914  7fe3fb78    or r3,r31,r31               
10012918  48001e2d    bl 0x10014744                  ; -> 10014744
1001291c  60000000    ori r0,r0,0x0               
10012920  7fe50734    extsh r5,r31                
10012924  1ca50070    mulli r5,r5,0x70            
10012928  7fe60734    extsh r6,r31                
1001292c  7fe40734    extsh r4,r31                
10012930  7fe80734    extsh r8,r31                
10012934  7fe90734    extsh r9,r31                
10012938  1d290070    mulli r9,r9,0x70            
1001293c  7fea0734    extsh r10,r31               
10012940  1d4a0070    mulli r10,r10,0x70          
10012944  38626bc4    addi r3,r2,0x6bc4           
10012948  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1001294c  1cc60070    mulli r6,r6,0x70            
10012950  7c63202e    lwzx r3,r3,r4               
10012954  38a50006    addi r5,r5,0x6              
10012958  7c7e292e    stwx r3,r30,r5              
1001295c  7cfe32ae    lhax r7,r30,r6              
10012960  1d080070    mulli r8,r8,0x70            
10012964  54e7003a    rlwinm r7,r7,0x0,0x0,0x1d   
10012968  7cfe332e    sthx r7,r30,r6              
1001296c  7d1e42ae    lhax r8,r30,r8              
10012970  39290002    addi r9,r9,0x2              
10012974  7d1e4b2e    sthx r8,r30,r9              
10012978  394a0034    addi r10,r10,0x34           
1001297c  7d5e52ae    lhax r10,r30,r10            
10012980  2c0a0001    cmpwi r10,0x1               
10012984  4082001c    bne 0x100129a0                 ; -> 100129a0
10012988  7fec0734    extsh r12,r31               
1001298c  1d8c0070    mulli r12,r12,0x70          
10012990  3960003d    li r11,0x3d                 
10012994  398c000e    addi r12,r12,0xe            
10012998  7d7e632e    sthx r11,r30,r12            
1001299c  48000018    b 0x100129b4                   ; -> 100129b4
100129a0  7fe40734    extsh r4,r31                
100129a4  1c840070    mulli r4,r4,0x70            
100129a8  38600034    li r3,0x34                  
100129ac  3884000e    addi r4,r4,0xe              
100129b0  7c7e232e    sthx r3,r30,r4              
100129b4  7fe3fb78    or r3,r31,r31               
100129b8  4bfff991    bl 0x10012348                  ; -> 10012348
100129bc  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
100129c0  28030000    cmplwi r3,0x0               
100129c4  4082001c    bne 0x100129e0                 ; -> 100129e0
100129c8  7fe60734    extsh r6,r31                
100129cc  1cc60070    mulli r6,r6,0x70            
100129d0  38a00003    li r5,0x3                   
100129d4  38c6001c    addi r6,r6,0x1c             
100129d8  7cbe332e    sthx r5,r30,r6              
100129dc  48000200    b 0x10012bdc                   ; -> 10012bdc
100129e0  7fe70734    extsh r7,r31                
100129e4  1ce70070    mulli r7,r7,0x70            
100129e8  38e70020    addi r7,r7,0x20             
100129ec  7cfe38ae    lbzx r7,r30,r7              
100129f0  28070000    cmplwi r7,0x0               
100129f4  4182003c    beq 0x10012a30                 ; -> 10012a30
100129f8  7fe3fb78    or r3,r31,r31               
100129fc  48000dfd    bl 0x100137f8                  ; -> 100137f8
10012a00  60000000    ori r0,r0,0x0               
10012a04  7fe90734    extsh r9,r31                
10012a08  1d290070    mulli r9,r9,0x70            
10012a0c  7feb0734    extsh r11,r31               
10012a10  1d6b0070    mulli r11,r11,0x70          
10012a14  39000002    li r8,0x2                   
10012a18  3929001c    addi r9,r9,0x1c             
10012a1c  7d1e4b2e    sthx r8,r30,r9              
10012a20  39400000    li r10,0x0                  
10012a24  396b0032    addi r11,r11,0x32           
10012a28  7d5e5b2e    sthx r10,r30,r11            
10012a2c  480001b0    b 0x10012bdc                   ; -> 10012bdc
10012a30  7fec0734    extsh r12,r31               
10012a34  1d8c0070    mulli r12,r12,0x70          
10012a38  398c001e    addi r12,r12,0x1e           
10012a3c  7d9e60ae    lbzx r12,r30,r12            
10012a40  280c0000    cmplwi r12,0x0              
10012a44  41820094    beq 0x10012ad8                 ; -> 10012ad8
10012a48  7fe3fb78    or r3,r31,r31               
10012a4c  48000dad    bl 0x100137f8                  ; -> 100137f8
10012a50  60000000    ori r0,r0,0x0               
10012a54  7fe30734    extsh r3,r31                
10012a58  1c630070    mulli r3,r3,0x70            
10012a5c  38630034    addi r3,r3,0x34             
10012a60  7c7e1aae    lhax r3,r30,r3              
10012a64  2c030001    cmpwi r3,0x1                
10012a68  40820030    bne 0x10012a98                 ; -> 10012a98
10012a6c  7fe50734    extsh r5,r31                
10012a70  1ca50070    mulli r5,r5,0x70            
10012a74  7fe70734    extsh r7,r31                
10012a78  1ce70070    mulli r7,r7,0x70            
10012a7c  38800001    li r4,0x1                   
10012a80  38a5001c    addi r5,r5,0x1c             
10012a84  7c9e2b2e    sthx r4,r30,r5              
10012a88  38c00000    li r6,0x0                   
10012a8c  38e70032    addi r7,r7,0x32             
10012a90  7cde3b2e    sthx r6,r30,r7              
10012a94  48000148    b 0x10012bdc                   ; -> 10012bdc
10012a98  7fe90734    extsh r9,r31                
10012a9c  1d290070    mulli r9,r9,0x70            
10012aa0  7feb0734    extsh r11,r31               
10012aa4  1d6b0070    mulli r11,r11,0x70          
10012aa8  7fe30734    extsh r3,r31                
10012aac  1c630070    mulli r3,r3,0x70            
10012ab0  39000009    li r8,0x9                   
10012ab4  3929001c    addi r9,r9,0x1c             
10012ab8  7d1e4b2e    sthx r8,r30,r9              
10012abc  39400000    li r10,0x0                  
10012ac0  396b0032    addi r11,r11,0x32           
10012ac4  7d5e5b2e    sthx r10,r30,r11            
10012ac8  39800001    li r12,0x1                  
10012acc  38630034    addi r3,r3,0x34             
10012ad0  7d9e1b2e    sthx r12,r30,r3             
10012ad4  48000108    b 0x10012bdc                   ; -> 10012bdc
10012ad8  7fe40734    extsh r4,r31                
10012adc  1c840070    mulli r4,r4,0x70            
10012ae0  3884001f    addi r4,r4,0x1f             
10012ae4  7c9e20ae    lbzx r4,r30,r4              
10012ae8  28040000    cmplwi r4,0x0               
10012aec  41820094    beq 0x10012b80                 ; -> 10012b80
10012af0  7fe3fb78    or r3,r31,r31               
10012af4  48000d05    bl 0x100137f8                  ; -> 100137f8
10012af8  60000000    ori r0,r0,0x0               
10012afc  7fe50734    extsh r5,r31                
10012b00  1ca50070    mulli r5,r5,0x70            
10012b04  38a50034    addi r5,r5,0x34             
10012b08  7cbe2aae    lhax r5,r30,r5              
10012b0c  2c05ffff    cmpwi r5,-0x1               
10012b10  40820030    bne 0x10012b40                 ; -> 10012b40
10012b14  7fe70734    extsh r7,r31                
10012b18  1ce70070    mulli r7,r7,0x70            
10012b1c  7fe90734    extsh r9,r31                
10012b20  1d290070    mulli r9,r9,0x70            
10012b24  38c00001    li r6,0x1                   
10012b28  38e7001c    addi r7,r7,0x1c             
10012b2c  7cde3b2e    sthx r6,r30,r7              
10012b30  39000000    li r8,0x0                   
10012b34  39290032    addi r9,r9,0x32             
10012b38  7d1e4b2e    sthx r8,r30,r9              
10012b3c  480000a0    b 0x10012bdc                   ; -> 10012bdc
10012b40  7feb0734    extsh r11,r31               
10012b44  1d6b0070    mulli r11,r11,0x70          
10012b48  7fe30734    extsh r3,r31                
10012b4c  1c630070    mulli r3,r3,0x70            
10012b50  7fe50734    extsh r5,r31                
10012b54  1ca50070    mulli r5,r5,0x70            
10012b58  3940000a    li r10,0xa                  
10012b5c  396b001c    addi r11,r11,0x1c           
10012b60  7d5e5b2e    sthx r10,r30,r11            
10012b64  39800000    li r12,0x0                  
10012b68  38630032    addi r3,r3,0x32             
10012b6c  7d9e1b2e    sthx r12,r30,r3             
10012b70  3880ffff    li r4,-0x1                  
10012b74  38a50034    addi r5,r5,0x34             
10012b78  7c9e2b2e    sthx r4,r30,r5              
10012b7c  48000060    b 0x10012bdc                   ; -> 10012bdc
10012b80  7fe3fb78    or r3,r31,r31               
10012b84  48000c75    bl 0x100137f8                  ; -> 100137f8
10012b88  60000000    ori r0,r0,0x0               
10012b8c  7fe80734    extsh r8,r31                
10012b90  1d080070    mulli r8,r8,0x70            
10012b94  7fe90734    extsh r9,r31                
10012b98  7fe70734    extsh r7,r31                
10012b9c  7feb0734    extsh r11,r31               
10012ba0  7fec0734    extsh r12,r31               
10012ba4  1d8c0070    mulli r12,r12,0x70          
10012ba8  38c26bc4    addi r6,r2,0x6bc4           
10012bac  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
10012bb0  1d290070    mulli r9,r9,0x70            
10012bb4  7cc6382e    lwzx r6,r6,r7               
10012bb8  39080006    addi r8,r8,0x6              
10012bbc  7cde412e    stwx r6,r30,r8              
10012bc0  7d5e4aae    lhax r10,r30,r9             
10012bc4  1d6b0070    mulli r11,r11,0x70          
10012bc8  554a003a    rlwinm r10,r10,0x0,0x0,0x1d 
10012bcc  7d5e4b2e    sthx r10,r30,r9             
10012bd0  7d7e5aae    lhax r11,r30,r11            
10012bd4  398c0002    addi r12,r12,0x2            
10012bd8  7d7e632e    sthx r11,r30,r12            
10012bdc  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10012be0  38210040    addi r1,r1,0x40             
10012be4  7c0803a6    mtspr LR,r0                 
10012be8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10012bec  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10012bf0  4e800020    blr                         
