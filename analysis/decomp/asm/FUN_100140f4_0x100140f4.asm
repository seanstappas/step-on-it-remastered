; FUN_100140f4 @ 0x100140f4  (138 instructions)
100140f4  7c0802a6    mfspr r0,LR                 
100140f8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100140fc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10014100  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10014104  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10014108  7c7f1b78    or r31,r3,r3                
1001410c  3bc26840    addi r30,r2,0x6840          
10014110  7fe3fb78    or r3,r31,r31               
10014114  4800068d    bl 0x100147a0                  ; -> 100147a0
10014118  60000000    ori r0,r0,0x0               
1001411c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10014120  28030000    cmplwi r3,0x0               
10014124  41820080    beq 0x100141a4                 ; -> 100141a4
10014128  7fe3fb78    or r3,r31,r31               
1001412c  48000619    bl 0x10014744                  ; -> 10014744
10014130  60000000    ori r0,r0,0x0               
10014134  7fe40734    extsh r4,r31                
10014138  1c840070    mulli r4,r4,0x70            
1001413c  7fe60734    extsh r6,r31                
10014140  1cc60070    mulli r6,r6,0x70            
10014144  7fe70734    extsh r7,r31                
10014148  1ce70070    mulli r7,r7,0x70            
1001414c  38600000    li r3,0x0                   
10014150  3884001c    addi r4,r4,0x1c             
10014154  7c7e232e    sthx r3,r30,r4              
10014158  38a00000    li r5,0x0                   
1001415c  38c60032    addi r6,r6,0x32             
10014160  7cbe332e    sthx r5,r30,r6              
10014164  38e70034    addi r7,r7,0x34             
10014168  7cfe3aae    lhax r7,r30,r7              
1001416c  2c070001    cmpwi r7,0x1                
10014170  4082001c    bne 0x1001418c                 ; -> 1001418c
10014174  7fe90734    extsh r9,r31                
10014178  1d290070    mulli r9,r9,0x70            
1001417c  3900003d    li r8,0x3d                  
10014180  3929000e    addi r9,r9,0xe              
10014184  7d1e4b2e    sthx r8,r30,r9              
10014188  48000018    b 0x100141a0                   ; -> 100141a0
1001418c  7feb0734    extsh r11,r31               
10014190  1d6b0070    mulli r11,r11,0x70          
10014194  39400034    li r10,0x34                 
10014198  396b000e    addi r11,r11,0xe            
1001419c  7d5e5b2e    sthx r10,r30,r11            
100141a0  48000164    b 0x10014304                   ; -> 10014304
100141a4  7fec0734    extsh r12,r31               
100141a8  1d8c0070    mulli r12,r12,0x70          
100141ac  398c0032    addi r12,r12,0x32           
100141b0  7c7e62ae    lhax r3,r30,r12             
100141b4  7c641b78    or r4,r3,r3                 
100141b8  7c840734    extsh r4,r4                 
100141bc  38630001    addi r3,r3,0x1              
100141c0  2c040000    cmpwi r4,0x0                
100141c4  7c7e632e    sthx r3,r30,r12             
100141c8  40820030    bne 0x100141f8                 ; -> 100141f8
100141cc  7fe60734    extsh r6,r31                
100141d0  1cc60070    mulli r6,r6,0x70            
100141d4  7fe70734    extsh r7,r31                
100141d8  38c6000e    addi r6,r6,0xe              
100141dc  1ce70070    mulli r7,r7,0x70            
100141e0  7cde32ae    lhax r6,r30,r6              
100141e4  38a206d0    addi r5,r2,0x6d0            
100141e8  54c6083c    rlwinm r6,r6,0x1,0x0,0x1e   
100141ec  7ca532ae    lhax r5,r5,r6               
100141f0  38e70010    addi r7,r7,0x10             
100141f4  7cbe3b2e    sthx r5,r30,r7              
100141f8  7fe80734    extsh r8,r31                
100141fc  1d080070    mulli r8,r8,0x70            
10014200  7fe90734    extsh r9,r31                
10014204  1d290070    mulli r9,r9,0x70            
10014208  3908000e    addi r8,r8,0xe              
1001420c  7d1e42ae    lhax r8,r30,r8              
10014210  39290010    addi r9,r9,0x10             
10014214  7d3e4aae    lhax r9,r30,r9              
10014218  7d080734    extsh r8,r8                 
1001421c  7c084800    cmpw r8,r9                  
10014220  40810020    ble 0x10014240                 ; -> 10014240
10014224  7fea0734    extsh r10,r31               
10014228  1d4a0070    mulli r10,r10,0x70          
1001422c  394a000e    addi r10,r10,0xe            
10014230  7d7e52ae    lhax r11,r30,r10            
10014234  396bfffe    subi r11,r11,0x2            
10014238  7d7e532e    sthx r11,r30,r10            
1001423c  4800001c    b 0x10014258                   ; -> 10014258
10014240  7fec0734    extsh r12,r31               
10014244  1d8c0070    mulli r12,r12,0x70          
10014248  398c000e    addi r12,r12,0xe            
1001424c  7c7e62ae    lhax r3,r30,r12             
10014250  38630002    addi r3,r3,0x2              
10014254  7c7e632e    sthx r3,r30,r12             
10014258  7fe40734    extsh r4,r31                
1001425c  1c840070    mulli r4,r4,0x70            
10014260  7fe50734    extsh r5,r31                
10014264  1ca50070    mulli r5,r5,0x70            
10014268  3884000e    addi r4,r4,0xe              
1001426c  7c9e22ae    lhax r4,r30,r4              
10014270  38a50010    addi r5,r5,0x10             
10014274  7cbe2aae    lhax r5,r30,r5              
10014278  7c840734    extsh r4,r4                 
1001427c  7c042800    cmpw r4,r5                  
10014280  40820084    bne 0x10014304                 ; -> 10014304
10014284  7fe60734    extsh r6,r31                
10014288  1cc60070    mulli r6,r6,0x70            
1001428c  38c6000e    addi r6,r6,0xe              
10014290  7cde32ae    lhax r6,r30,r6              
10014294  2c06001a    cmpwi r6,0x1a               
10014298  40820018    bne 0x100142b0                 ; -> 100142b0
1001429c  7fe80734    extsh r8,r31                
100142a0  1d080070    mulli r8,r8,0x70            
100142a4  38e00002    li r7,0x2                   
100142a8  3908000e    addi r8,r8,0xe              
100142ac  7cfe432e    sthx r7,r30,r8              
100142b0  7fe90734    extsh r9,r31                
100142b4  1d290070    mulli r9,r9,0x70            
100142b8  3929000e    addi r9,r9,0xe              
100142bc  7d3e4aae    lhax r9,r30,r9              
100142c0  2c090031    cmpwi r9,0x31               
100142c4  40820018    bne 0x100142dc                 ; -> 100142dc
100142c8  7feb0734    extsh r11,r31               
100142cc  1d6b0070    mulli r11,r11,0x70          
100142d0  39400019    li r10,0x19                 
100142d4  396b000e    addi r11,r11,0xe            
100142d8  7d5e5b2e    sthx r10,r30,r11            
100142dc  7fe30734    extsh r3,r31                
100142e0  1c630070    mulli r3,r3,0x70            
100142e4  7fe50734    extsh r5,r31                
100142e8  1ca50070    mulli r5,r5,0x70            
100142ec  3980000d    li r12,0xd                  
100142f0  3863001c    addi r3,r3,0x1c             
100142f4  7d9e1b2e    sthx r12,r30,r3             
100142f8  38800000    li r4,0x0                   
100142fc  38a50032    addi r5,r5,0x32             
10014300  7c9e2b2e    sthx r4,r30,r5              
10014304  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10014308  38210040    addi r1,r1,0x40             
1001430c  7c0803a6    mtspr LR,r0                 
10014310  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10014314  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10014318  4e800020    blr                         
