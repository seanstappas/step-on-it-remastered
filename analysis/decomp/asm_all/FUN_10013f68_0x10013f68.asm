; FUN_10013f68 @ 0x10013f68
10013f68  7c0802a6    mfspr r0,LR                 
10013f6c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10013f70  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10013f74  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10013f78  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10013f7c  7c7f1b78    or r31,r3,r3                
10013f80  3bc26840    addi r30,r2,0x6840          
10013f84  7fe3fb78    or r3,r31,r31               
10013f88  480007bd    bl 0x10014744                  ; -> 10014744
10013f8c  60000000    ori r0,r0,0x0               
10013f90  7fe50734    extsh r5,r31                
10013f94  1ca50070    mulli r5,r5,0x70            
10013f98  7fe60734    extsh r6,r31                
10013f9c  7fe40734    extsh r4,r31                
10013fa0  7fe70734    extsh r7,r31                
10013fa4  1ce70070    mulli r7,r7,0x70            
10013fa8  7fe90734    extsh r9,r31                
10013fac  1d290070    mulli r9,r9,0x70            
10013fb0  7fea0734    extsh r10,r31               
10013fb4  1d4a0070    mulli r10,r10,0x70          
10013fb8  38626bc4    addi r3,r2,0x6bc4           
10013fbc  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10013fc0  1cc60070    mulli r6,r6,0x70            
10013fc4  7c63202e    lwzx r3,r3,r4               
10013fc8  38a50006    addi r5,r5,0x6              
10013fcc  7c7e292e    stwx r3,r30,r5              
10013fd0  7cde32ae    lhax r6,r30,r6              
10013fd4  38e70002    addi r7,r7,0x2              
10013fd8  7cde3b2e    sthx r6,r30,r7              
10013fdc  3900ffff    li r8,-0x1                  
10013fe0  39290034    addi r9,r9,0x34             
10013fe4  7d1e4b2e    sthx r8,r30,r9              
10013fe8  394a0032    addi r10,r10,0x32           
10013fec  7d7e52ae    lhax r11,r30,r10            
10013ff0  7d6c5b78    or r12,r11,r11              
10013ff4  7d8c0734    extsh r12,r12               
10013ff8  396b0001    addi r11,r11,0x1            
10013ffc  2c0c0000    cmpwi r12,0x0               
10014000  7d7e532e    sthx r11,r30,r10            
10014004  40820018    bne 0x1001401c                 ; -> 1001401c
10014008  7fe40734    extsh r4,r31                
1001400c  1c840070    mulli r4,r4,0x70            
10014010  3860005d    li r3,0x5d                  
10014014  3884000e    addi r4,r4,0xe              
10014018  7c7e232e    sthx r3,r30,r4              
1001401c  7fe50734    extsh r5,r31                
10014020  1ca50070    mulli r5,r5,0x70            
10014024  38a50020    addi r5,r5,0x20             
10014028  7cbe28ae    lbzx r5,r30,r5              
1001402c  28050000    cmplwi r5,0x0               
10014030  41820030    beq 0x10014060                 ; -> 10014060
10014034  7fe70734    extsh r7,r31                
10014038  1ce70070    mulli r7,r7,0x70            
1001403c  7fe90734    extsh r9,r31                
10014040  1d290070    mulli r9,r9,0x70            
10014044  38c00002    li r6,0x2                   
10014048  38e7001c    addi r7,r7,0x1c             
1001404c  7cde3b2e    sthx r6,r30,r7              
10014050  39000000    li r8,0x0                   
10014054  39290032    addi r9,r9,0x32             
10014058  7d1e4b2e    sthx r8,r30,r9              
1001405c  48000080    b 0x100140dc                   ; -> 100140dc
10014060  7fea0734    extsh r10,r31               
10014064  1d4a0070    mulli r10,r10,0x70          
10014068  394a000e    addi r10,r10,0xe            
1001406c  7d7e52ae    lhax r11,r30,r10            
10014070  396b0001    addi r11,r11,0x1            
10014074  7d7e532e    sthx r11,r30,r10            
10014078  7d6b0734    extsh r11,r11               
1001407c  2c0b0060    cmpwi r11,0x60              
10014080  4081005c    ble 0x100140dc                 ; -> 100140dc
10014084  7fec0734    extsh r12,r31               
10014088  1d8c0070    mulli r12,r12,0x70          
1001408c  398c001f    addi r12,r12,0x1f           
10014090  7d9e60ae    lbzx r12,r30,r12            
10014094  280c0000    cmplwi r12,0x0              
10014098  41820030    beq 0x100140c8                 ; -> 100140c8
1001409c  7fe40734    extsh r4,r31                
100140a0  1c840070    mulli r4,r4,0x70            
100140a4  7fe60734    extsh r6,r31                
100140a8  1cc60070    mulli r6,r6,0x70            
100140ac  38600001    li r3,0x1                   
100140b0  3884001c    addi r4,r4,0x1c             
100140b4  7c7e232e    sthx r3,r30,r4              
100140b8  38a00002    li r5,0x2                   
100140bc  38c6000e    addi r6,r6,0xe              
100140c0  7cbe332e    sthx r5,r30,r6              
100140c4  48000018    b 0x100140dc                   ; -> 100140dc
100140c8  7fe80734    extsh r8,r31                
100140cc  1d080070    mulli r8,r8,0x70            
100140d0  38e00000    li r7,0x0                   
100140d4  3908001c    addi r8,r8,0x1c             
100140d8  7cfe432e    sthx r7,r30,r8              
100140dc  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
100140e0  38210040    addi r1,r1,0x40             
100140e4  7c0803a6    mtspr LR,r0                 
100140e8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100140ec  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100140f0  4e800020    blr                         
