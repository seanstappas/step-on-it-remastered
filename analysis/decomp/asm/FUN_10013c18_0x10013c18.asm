; FUN_10013c18 @ 0x10013c18  (113 instructions)
10013c18  7c0802a6    mfspr r0,LR                 
10013c1c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10013c20  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10013c24  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10013c28  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10013c2c  7c7f1b78    or r31,r3,r3                
10013c30  3bc26840    addi r30,r2,0x6840          
10013c34  7fe3fb78    or r3,r31,r31               
10013c38  48000b0d    bl 0x10014744                  ; -> 10014744
10013c3c  60000000    ori r0,r0,0x0               
10013c40  7fe50734    extsh r5,r31                
10013c44  1ca50070    mulli r5,r5,0x70            
10013c48  7fe60734    extsh r6,r31                
10013c4c  7fe40734    extsh r4,r31                
10013c50  7fe70734    extsh r7,r31                
10013c54  1ce70070    mulli r7,r7,0x70            
10013c58  7fe80734    extsh r8,r31                
10013c5c  1d080070    mulli r8,r8,0x70            
10013c60  38626bc4    addi r3,r2,0x6bc4           
10013c64  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10013c68  1cc60070    mulli r6,r6,0x70            
10013c6c  7c63202e    lwzx r3,r3,r4               
10013c70  38a50006    addi r5,r5,0x6              
10013c74  7c7e292e    stwx r3,r30,r5              
10013c78  7cde32ae    lhax r6,r30,r6              
10013c7c  38e70002    addi r7,r7,0x2              
10013c80  7cde3b2e    sthx r6,r30,r7              
10013c84  39080020    addi r8,r8,0x20             
10013c88  7d1e40ae    lbzx r8,r30,r8              
10013c8c  28080000    cmplwi r8,0x0               
10013c90  41820030    beq 0x10013cc0                 ; -> 10013cc0
10013c94  7fea0734    extsh r10,r31               
10013c98  1d4a0070    mulli r10,r10,0x70          
10013c9c  7fec0734    extsh r12,r31               
10013ca0  1d8c0070    mulli r12,r12,0x70          
10013ca4  39200002    li r9,0x2                   
10013ca8  394a001c    addi r10,r10,0x1c           
10013cac  7d3e532e    sthx r9,r30,r10             
10013cb0  39600000    li r11,0x0                  
10013cb4  398c0032    addi r12,r12,0x32           
10013cb8  7d7e632e    sthx r11,r30,r12            
10013cbc  48000108    b 0x10013dc4                   ; -> 10013dc4
10013cc0  7fe30734    extsh r3,r31                
10013cc4  1c630070    mulli r3,r3,0x70            
10013cc8  38630032    addi r3,r3,0x32             
10013ccc  7c9e1aae    lhax r4,r30,r3              
10013cd0  7c852378    or r5,r4,r4                 
10013cd4  7ca50734    extsh r5,r5                 
10013cd8  38840001    addi r4,r4,0x1              
10013cdc  2c050000    cmpwi r5,0x0                
10013ce0  7c9e1b2e    sthx r4,r30,r3              
10013ce4  40820060    bne 0x10013d44                 ; -> 10013d44
10013ce8  7fe70734    extsh r7,r31                
10013cec  1ce70070    mulli r7,r7,0x70            
10013cf0  7fe80734    extsh r8,r31                
10013cf4  38e7000e    addi r7,r7,0xe              
10013cf8  1d080070    mulli r8,r8,0x70            
10013cfc  7fea0734    extsh r10,r31               
10013d00  7cfe3aae    lhax r7,r30,r7              
10013d04  1d4a0070    mulli r10,r10,0x70          
10013d08  7feb0734    extsh r11,r31               
10013d0c  1d6b0070    mulli r11,r11,0x70          
10013d10  38c2066e    addi r6,r2,0x66e            
10013d14  54e7083c    rlwinm r7,r7,0x1,0x0,0x1e   
10013d18  7cc63aae    lhax r6,r6,r7               
10013d1c  39080010    addi r8,r8,0x10             
10013d20  7cde432e    sthx r6,r30,r8              
10013d24  394a000e    addi r10,r10,0xe            
10013d28  7d5e52ae    lhax r10,r30,r10            
10013d2c  3922060c    addi r9,r2,0x60c            
10013d30  554a083c    rlwinm r10,r10,0x1,0x0,0x1e 
10013d34  7d2952ae    lhax r9,r9,r10              
10013d38  396b000e    addi r11,r11,0xe            
10013d3c  7d3e5b2e    sthx r9,r30,r11             
10013d40  48000084    b 0x10013dc4                   ; -> 10013dc4
10013d44  7fec0734    extsh r12,r31               
10013d48  1d8c0070    mulli r12,r12,0x70          
10013d4c  7fe40734    extsh r4,r31                
10013d50  1c840070    mulli r4,r4,0x70            
10013d54  398c000e    addi r12,r12,0xe            
10013d58  7c7e62ae    lhax r3,r30,r12             
10013d5c  38840032    addi r4,r4,0x32             
10013d60  38630001    addi r3,r3,0x1              
10013d64  7c7e632e    sthx r3,r30,r12             
10013d68  7c9e22ae    lhax r4,r30,r4              
10013d6c  2c040004    cmpwi r4,0x4                
10013d70  40820054    bne 0x10013dc4                 ; -> 10013dc4
10013d74  7fe60734    extsh r6,r31                
10013d78  1cc60070    mulli r6,r6,0x70            
10013d7c  7fe70734    extsh r7,r31                
10013d80  1ce70070    mulli r7,r7,0x70            
10013d84  7fe80734    extsh r8,r31                
10013d88  1d080070    mulli r8,r8,0x70            
10013d8c  7fe90734    extsh r9,r31                
10013d90  1d290070    mulli r9,r9,0x70            
10013d94  38a00001    li r5,0x1                   
10013d98  38c6001c    addi r6,r6,0x1c             
10013d9c  7cbe332e    sthx r5,r30,r6              
10013da0  38e70010    addi r7,r7,0x10             
10013da4  7cfe3aae    lhax r7,r30,r7              
10013da8  3908000e    addi r8,r8,0xe              
10013dac  7cfe432e    sthx r7,r30,r8              
10013db0  39290034    addi r9,r9,0x34             
10013db4  7d3e4aae    lhax r9,r30,r9              
10013db8  2c090001    cmpwi r9,0x1                
10013dbc  7d400026    mfcr r10                    
10013dc0  554a1ffe    rlwinm r10,r10,0x3,0x1f,0x1f
10013dc4  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10013dc8  38210040    addi r1,r1,0x40             
10013dcc  7c0803a6    mtspr LR,r0                 
10013dd0  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10013dd4  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10013dd8  4e800020    blr                         
