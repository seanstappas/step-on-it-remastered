; FUN_10013980 @ 0x10013980  (166 instructions)
10013980  7c0802a6    mfspr r0,LR                 
10013984  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10013988  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001398c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10013990  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10013994  7c7f1b78    or r31,r3,r3                
10013998  3bc26840    addi r30,r2,0x6840          
1001399c  7fe3fb78    or r3,r31,r31               
100139a0  48000da5    bl 0x10014744                  ; -> 10014744
100139a4  60000000    ori r0,r0,0x0               
100139a8  7fe30734    extsh r3,r31                
100139ac  1c630070    mulli r3,r3,0x70            
100139b0  7fe50734    extsh r5,r31                
100139b4  7fe60734    extsh r6,r31                
100139b8  7c9e1aae    lhax r4,r30,r3              
100139bc  1cc60070    mulli r6,r6,0x70            
100139c0  7fe70734    extsh r7,r31                
100139c4  1ce70070    mulli r7,r7,0x70            
100139c8  5484003a    rlwinm r4,r4,0x0,0x0,0x1d   
100139cc  1ca50070    mulli r5,r5,0x70            
100139d0  7c9e1b2e    sthx r4,r30,r3              
100139d4  7cbe2aae    lhax r5,r30,r5              
100139d8  38c60002    addi r6,r6,0x2              
100139dc  7cbe332e    sthx r5,r30,r6              
100139e0  38e7001e    addi r7,r7,0x1e             
100139e4  7cfe38ae    lbzx r7,r30,r7              
100139e8  28070000    cmplwi r7,0x0               
100139ec  41820018    beq 0x10013a04                 ; -> 10013a04
100139f0  7fe90734    extsh r9,r31                
100139f4  1d290070    mulli r9,r9,0x70            
100139f8  39000001    li r8,0x1                   
100139fc  39290034    addi r9,r9,0x34             
10013a00  7d1e4b2e    sthx r8,r30,r9              
10013a04  7fea0734    extsh r10,r31               
10013a08  1d4a0070    mulli r10,r10,0x70          
10013a0c  394a001f    addi r10,r10,0x1f           
10013a10  7d5e50ae    lbzx r10,r30,r10            
10013a14  280a0000    cmplwi r10,0x0              
10013a18  41820018    beq 0x10013a30                 ; -> 10013a30
10013a1c  7fec0734    extsh r12,r31               
10013a20  1d8c0070    mulli r12,r12,0x70          
10013a24  3960ffff    li r11,-0x1                 
10013a28  398c0034    addi r12,r12,0x34           
10013a2c  7d7e632e    sthx r11,r30,r12            
10013a30  7fe30734    extsh r3,r31                
10013a34  1c630070    mulli r3,r3,0x70            
10013a38  38630032    addi r3,r3,0x32             
10013a3c  7c7e1aae    lhax r3,r30,r3              
10013a40  2c030000    cmpwi r3,0x0                
10013a44  40820060    bne 0x10013aa4                 ; -> 10013aa4
10013a48  7fe40734    extsh r4,r31                
10013a4c  1c840070    mulli r4,r4,0x70            
10013a50  7fe60734    extsh r6,r31                
10013a54  1cc60070    mulli r6,r6,0x70            
10013a58  38840032    addi r4,r4,0x32             
10013a5c  7cbe22ae    lhax r5,r30,r4              
10013a60  38c60034    addi r6,r6,0x34             
10013a64  38a50001    addi r5,r5,0x1              
10013a68  7cbe232e    sthx r5,r30,r4              
10013a6c  7cde32ae    lhax r6,r30,r6              
10013a70  2c060001    cmpwi r6,0x1                
10013a74  4082001c    bne 0x10013a90                 ; -> 10013a90
10013a78  7fe80734    extsh r8,r31                
10013a7c  1d080070    mulli r8,r8,0x70            
10013a80  38e00042    li r7,0x42                  
10013a84  3908000e    addi r8,r8,0xe              
10013a88  7cfe432e    sthx r7,r30,r8              
10013a8c  48000018    b 0x10013aa4                   ; -> 10013aa4
10013a90  7fea0734    extsh r10,r31               
10013a94  1d4a0070    mulli r10,r10,0x70          
10013a98  39200049    li r9,0x49                  
10013a9c  394a000e    addi r10,r10,0xe            
10013aa0  7d3e532e    sthx r9,r30,r10             
10013aa4  7feb0734    extsh r11,r31               
10013aa8  1d6b0070    mulli r11,r11,0x70          
10013aac  396b0034    addi r11,r11,0x34           
10013ab0  7d7e5aae    lhax r11,r30,r11            
10013ab4  2c0b0001    cmpwi r11,0x1               
10013ab8  408200a8    bne 0x10013b60                 ; -> 10013b60
10013abc  7fec0734    extsh r12,r31               
10013ac0  1d8c0070    mulli r12,r12,0x70          
10013ac4  398c0020    addi r12,r12,0x20           
10013ac8  7d9e60ae    lbzx r12,r30,r12            
10013acc  280c0000    cmplwi r12,0x0              
10013ad0  41820030    beq 0x10013b00                 ; -> 10013b00
10013ad4  7fe40734    extsh r4,r31                
10013ad8  1c840070    mulli r4,r4,0x70            
10013adc  7fe60734    extsh r6,r31                
10013ae0  1cc60070    mulli r6,r6,0x70            
10013ae4  38600002    li r3,0x2                   
10013ae8  3884001c    addi r4,r4,0x1c             
10013aec  7c7e232e    sthx r3,r30,r4              
10013af0  38a00000    li r5,0x0                   
10013af4  38c60032    addi r6,r6,0x32             
10013af8  7cbe332e    sthx r5,r30,r6              
10013afc  48000104    b 0x10013c00                   ; -> 10013c00
10013b00  7fe70734    extsh r7,r31                
10013b04  1ce70070    mulli r7,r7,0x70            
10013b08  38e7000e    addi r7,r7,0xe              
10013b0c  7d1e3aae    lhax r8,r30,r7              
10013b10  39080001    addi r8,r8,0x1              
10013b14  7d1e3b2e    sthx r8,r30,r7              
10013b18  7d080734    extsh r8,r8                 
10013b1c  2c080049    cmpwi r8,0x49               
10013b20  4180001c    blt 0x10013b3c                 ; -> 10013b3c
10013b24  7fea0734    extsh r10,r31               
10013b28  1d4a0070    mulli r10,r10,0x70          
10013b2c  39200000    li r9,0x0                   
10013b30  394a001c    addi r10,r10,0x1c           
10013b34  7d3e532e    sthx r9,r30,r10             
10013b38  480000c8    b 0x10013c00                   ; -> 10013c00
10013b3c  7fe30734    extsh r3,r31                
10013b40  1c630070    mulli r3,r3,0x70            
10013b44  7fec0734    extsh r12,r31               
10013b48  39626bc4    addi r11,r2,0x6bc4          
10013b4c  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
10013b50  7d6b602e    lwzx r11,r11,r12            
10013b54  38630006    addi r3,r3,0x6              
10013b58  7d7e192e    stwx r11,r30,r3             
10013b5c  480000a4    b 0x10013c00                   ; -> 10013c00
10013b60  7fe40734    extsh r4,r31                
10013b64  1c840070    mulli r4,r4,0x70            
10013b68  38840020    addi r4,r4,0x20             
10013b6c  7c9e20ae    lbzx r4,r30,r4              
10013b70  28040000    cmplwi r4,0x0               
10013b74  41820030    beq 0x10013ba4                 ; -> 10013ba4
10013b78  7fe60734    extsh r6,r31                
10013b7c  1cc60070    mulli r6,r6,0x70            
10013b80  7fe80734    extsh r8,r31                
10013b84  1d080070    mulli r8,r8,0x70            
10013b88  38a00002    li r5,0x2                   
10013b8c  38c6001c    addi r6,r6,0x1c             
10013b90  7cbe332e    sthx r5,r30,r6              
10013b94  38e00000    li r7,0x0                   
10013b98  39080032    addi r8,r8,0x32             
10013b9c  7cfe432e    sthx r7,r30,r8              
10013ba0  48000060    b 0x10013c00                   ; -> 10013c00
10013ba4  7fe90734    extsh r9,r31                
10013ba8  1d290070    mulli r9,r9,0x70            
10013bac  3929000e    addi r9,r9,0xe              
10013bb0  7d5e4aae    lhax r10,r30,r9             
10013bb4  394affff    subi r10,r10,0x1            
10013bb8  7d5e4b2e    sthx r10,r30,r9             
10013bbc  7d4a0734    extsh r10,r10               
10013bc0  2c0a0042    cmpwi r10,0x42              
10013bc4  4181001c    bgt 0x10013be0                 ; -> 10013be0
10013bc8  7fec0734    extsh r12,r31               
10013bcc  1d8c0070    mulli r12,r12,0x70          
10013bd0  39600000    li r11,0x0                  
10013bd4  398c001c    addi r12,r12,0x1c           
10013bd8  7d7e632e    sthx r11,r30,r12            
10013bdc  48000024    b 0x10013c00                   ; -> 10013c00
10013be0  7fe50734    extsh r5,r31                
10013be4  1ca50070    mulli r5,r5,0x70            
10013be8  7fe40734    extsh r4,r31                
10013bec  38626bc4    addi r3,r2,0x6bc4           
10013bf0  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10013bf4  7c63202e    lwzx r3,r3,r4               
10013bf8  38a50006    addi r5,r5,0x6              
10013bfc  7c7e292e    stwx r3,r30,r5              
10013c00  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10013c04  38210040    addi r1,r1,0x40             
10013c08  7c0803a6    mtspr LR,r0                 
10013c0c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10013c10  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10013c14  4e800020    blr                         
