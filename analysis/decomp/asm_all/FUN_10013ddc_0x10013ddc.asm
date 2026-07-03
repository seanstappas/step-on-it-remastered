; FUN_10013ddc @ 0x10013ddc
10013ddc  7c0802a6    mfspr r0,LR                 
10013de0  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10013de4  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10013de8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10013dec  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10013df0  7c7f1b78    or r31,r3,r3                
10013df4  3bc26840    addi r30,r2,0x6840          
10013df8  7fe3fb78    or r3,r31,r31               
10013dfc  48000949    bl 0x10014744                  ; -> 10014744
10013e00  60000000    ori r0,r0,0x0               
10013e04  7fe50734    extsh r5,r31                
10013e08  1ca50070    mulli r5,r5,0x70            
10013e0c  7fe60734    extsh r6,r31                
10013e10  7fe40734    extsh r4,r31                
10013e14  7fe70734    extsh r7,r31                
10013e18  1ce70070    mulli r7,r7,0x70            
10013e1c  7fe90734    extsh r9,r31                
10013e20  1d290070    mulli r9,r9,0x70            
10013e24  7fea0734    extsh r10,r31               
10013e28  1d4a0070    mulli r10,r10,0x70          
10013e2c  38626bc4    addi r3,r2,0x6bc4           
10013e30  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10013e34  1cc60070    mulli r6,r6,0x70            
10013e38  7c63202e    lwzx r3,r3,r4               
10013e3c  38a50006    addi r5,r5,0x6              
10013e40  7c7e292e    stwx r3,r30,r5              
10013e44  7cde32ae    lhax r6,r30,r6              
10013e48  38e70002    addi r7,r7,0x2              
10013e4c  7cde3b2e    sthx r6,r30,r7              
10013e50  39000001    li r8,0x1                   
10013e54  39290034    addi r9,r9,0x34             
10013e58  7d1e4b2e    sthx r8,r30,r9              
10013e5c  394a0032    addi r10,r10,0x32           
10013e60  7d7e52ae    lhax r11,r30,r10            
10013e64  7d6c5b78    or r12,r11,r11              
10013e68  7d8c0734    extsh r12,r12               
10013e6c  396b0001    addi r11,r11,0x1            
10013e70  2c0c0000    cmpwi r12,0x0               
10013e74  7d7e532e    sthx r11,r30,r10            
10013e78  40820018    bne 0x10013e90                 ; -> 10013e90
10013e7c  7fe40734    extsh r4,r31                
10013e80  1c840070    mulli r4,r4,0x70            
10013e84  3860005a    li r3,0x5a                  
10013e88  3884000e    addi r4,r4,0xe              
10013e8c  7c7e232e    sthx r3,r30,r4              
10013e90  7fe50734    extsh r5,r31                
10013e94  1ca50070    mulli r5,r5,0x70            
10013e98  38a50020    addi r5,r5,0x20             
10013e9c  7cbe28ae    lbzx r5,r30,r5              
10013ea0  28050000    cmplwi r5,0x0               
10013ea4  41820030    beq 0x10013ed4                 ; -> 10013ed4
10013ea8  7fe70734    extsh r7,r31                
10013eac  1ce70070    mulli r7,r7,0x70            
10013eb0  7fe90734    extsh r9,r31                
10013eb4  1d290070    mulli r9,r9,0x70            
10013eb8  38c00002    li r6,0x2                   
10013ebc  38e7001c    addi r7,r7,0x1c             
10013ec0  7cde3b2e    sthx r6,r30,r7              
10013ec4  39000000    li r8,0x0                   
10013ec8  39290032    addi r9,r9,0x32             
10013ecc  7d1e4b2e    sthx r8,r30,r9              
10013ed0  48000080    b 0x10013f50                   ; -> 10013f50
10013ed4  7fea0734    extsh r10,r31               
10013ed8  1d4a0070    mulli r10,r10,0x70          
10013edc  394a000e    addi r10,r10,0xe            
10013ee0  7d7e52ae    lhax r11,r30,r10            
10013ee4  396b0001    addi r11,r11,0x1            
10013ee8  7d7e532e    sthx r11,r30,r10            
10013eec  7d6b0734    extsh r11,r11               
10013ef0  2c0b005d    cmpwi r11,0x5d              
10013ef4  4081005c    ble 0x10013f50                 ; -> 10013f50
10013ef8  7fec0734    extsh r12,r31               
10013efc  1d8c0070    mulli r12,r12,0x70          
10013f00  398c001e    addi r12,r12,0x1e           
10013f04  7d9e60ae    lbzx r12,r30,r12            
10013f08  280c0000    cmplwi r12,0x0              
10013f0c  41820030    beq 0x10013f3c                 ; -> 10013f3c
10013f10  7fe40734    extsh r4,r31                
10013f14  1c840070    mulli r4,r4,0x70            
10013f18  7fe60734    extsh r6,r31                
10013f1c  1cc60070    mulli r6,r6,0x70            
10013f20  38600001    li r3,0x1                   
10013f24  3884001c    addi r4,r4,0x1c             
10013f28  7c7e232e    sthx r3,r30,r4              
10013f2c  38a00027    li r5,0x27                  
10013f30  38c6000e    addi r6,r6,0xe              
10013f34  7cbe332e    sthx r5,r30,r6              
10013f38  48000018    b 0x10013f50                   ; -> 10013f50
10013f3c  7fe80734    extsh r8,r31                
10013f40  1d080070    mulli r8,r8,0x70            
10013f44  38e00000    li r7,0x0                   
10013f48  3908001c    addi r8,r8,0x1c             
10013f4c  7cfe432e    sthx r7,r30,r8              
10013f50  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10013f54  38210040    addi r1,r1,0x40             
10013f58  7c0803a6    mtspr LR,r0                 
10013f5c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10013f60  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10013f64  4e800020    blr                         
