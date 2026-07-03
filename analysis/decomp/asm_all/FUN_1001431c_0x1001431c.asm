; FUN_1001431c @ 0x1001431c
1001431c  7c0802a6    mfspr r0,LR                 
10014320  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10014324  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10014328  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001432c  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10014330  7c7f1b78    or r31,r3,r3                
10014334  3bc26840    addi r30,r2,0x6840          
10014338  7fe3fb78    or r3,r31,r31               
1001433c  48000465    bl 0x100147a0                  ; -> 100147a0
10014340  60000000    ori r0,r0,0x0               
10014344  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10014348  28030000    cmplwi r3,0x0               
1001434c  41820080    beq 0x100143cc                 ; -> 100143cc
10014350  7fe3fb78    or r3,r31,r31               
10014354  480003f1    bl 0x10014744                  ; -> 10014744
10014358  60000000    ori r0,r0,0x0               
1001435c  7fe40734    extsh r4,r31                
10014360  1c840070    mulli r4,r4,0x70            
10014364  7fe60734    extsh r6,r31                
10014368  1cc60070    mulli r6,r6,0x70            
1001436c  7fe70734    extsh r7,r31                
10014370  1ce70070    mulli r7,r7,0x70            
10014374  38600000    li r3,0x0                   
10014378  3884001c    addi r4,r4,0x1c             
1001437c  7c7e232e    sthx r3,r30,r4              
10014380  38a00000    li r5,0x0                   
10014384  38c60032    addi r6,r6,0x32             
10014388  7cbe332e    sthx r5,r30,r6              
1001438c  38e70034    addi r7,r7,0x34             
10014390  7cfe3aae    lhax r7,r30,r7              
10014394  2c070001    cmpwi r7,0x1                
10014398  4082001c    bne 0x100143b4                 ; -> 100143b4
1001439c  7fe90734    extsh r9,r31                
100143a0  1d290070    mulli r9,r9,0x70            
100143a4  3900003d    li r8,0x3d                  
100143a8  3929000e    addi r9,r9,0xe              
100143ac  7d1e4b2e    sthx r8,r30,r9              
100143b0  48000018    b 0x100143c8                   ; -> 100143c8
100143b4  7feb0734    extsh r11,r31               
100143b8  1d6b0070    mulli r11,r11,0x70          
100143bc  39400034    li r10,0x34                 
100143c0  396b000e    addi r11,r11,0xe            
100143c4  7d5e5b2e    sthx r10,r30,r11            
100143c8  48000144    b 0x1001450c                   ; -> 1001450c
100143cc  7fec0734    extsh r12,r31               
100143d0  1d8c0070    mulli r12,r12,0x70          
100143d4  398c0032    addi r12,r12,0x32           
100143d8  7c7e62ae    lhax r3,r30,r12             
100143dc  7c641b78    or r4,r3,r3                 
100143e0  7c840734    extsh r4,r4                 
100143e4  38630001    addi r3,r3,0x1              
100143e8  2c040000    cmpwi r4,0x0                
100143ec  7c7e632e    sthx r3,r30,r12             
100143f0  408200c4    bne 0x100144b4                 ; -> 100144b4
100143f4  7fe50734    extsh r5,r31                
100143f8  1ca50070    mulli r5,r5,0x70            
100143fc  38a5000e    addi r5,r5,0xe              
10014400  7cbe2aae    lhax r5,r30,r5              
10014404  2c050004    cmpwi r5,0x4                
10014408  4181001c    bgt 0x10014424                 ; -> 10014424
1001440c  7fe70734    extsh r7,r31                
10014410  1ce70070    mulli r7,r7,0x70            
10014414  38c00031    li r6,0x31                  
10014418  38e7000e    addi r7,r7,0xe              
1001441c  7cde3b2e    sthx r6,r30,r7              
10014420  480000ac    b 0x100144cc                   ; -> 100144cc
10014424  7fe80734    extsh r8,r31                
10014428  1d080070    mulli r8,r8,0x70            
1001442c  3908000e    addi r8,r8,0xe              
10014430  7d1e42ae    lhax r8,r30,r8              
10014434  2c080010    cmpwi r8,0x10               
10014438  4181001c    bgt 0x10014454                 ; -> 10014454
1001443c  7fea0734    extsh r10,r31               
10014440  1d4a0070    mulli r10,r10,0x70          
10014444  39200036    li r9,0x36                  
10014448  394a000e    addi r10,r10,0xe            
1001444c  7d3e532e    sthx r9,r30,r10             
10014450  4800007c    b 0x100144cc                   ; -> 100144cc
10014454  7feb0734    extsh r11,r31               
10014458  1d6b0070    mulli r11,r11,0x70          
1001445c  396b000e    addi r11,r11,0xe            
10014460  7d7e5aae    lhax r11,r30,r11            
10014464  2c0b001b    cmpwi r11,0x1b              
10014468  4181001c    bgt 0x10014484                 ; -> 10014484
1001446c  7fe30734    extsh r3,r31                
10014470  1c630070    mulli r3,r3,0x70            
10014474  3980003a    li r12,0x3a                 
10014478  3863000e    addi r3,r3,0xe              
1001447c  7d9e1b2e    sthx r12,r30,r3             
10014480  4800004c    b 0x100144cc                   ; -> 100144cc
10014484  7fe40734    extsh r4,r31                
10014488  1c840070    mulli r4,r4,0x70            
1001448c  3884000e    addi r4,r4,0xe              
10014490  7c9e22ae    lhax r4,r30,r4              
10014494  2c040027    cmpwi r4,0x27               
10014498  41810034    bgt 0x100144cc                 ; -> 100144cc
1001449c  7fe60734    extsh r6,r31                
100144a0  1cc60070    mulli r6,r6,0x70            
100144a4  38a0003f    li r5,0x3f                  
100144a8  38c6000e    addi r6,r6,0xe              
100144ac  7cbe332e    sthx r5,r30,r6              
100144b0  4800001c    b 0x100144cc                   ; -> 100144cc
100144b4  7fe70734    extsh r7,r31                
100144b8  1ce70070    mulli r7,r7,0x70            
100144bc  38e7000e    addi r7,r7,0xe              
100144c0  7d1e3aae    lhax r8,r30,r7              
100144c4  39080001    addi r8,r8,0x1              
100144c8  7d1e3b2e    sthx r8,r30,r7              
100144cc  7fe90734    extsh r9,r31                
100144d0  1d290070    mulli r9,r9,0x70            
100144d4  39290032    addi r9,r9,0x32             
100144d8  7d3e4aae    lhax r9,r30,r9              
100144dc  2c090003    cmpwi r9,0x3                
100144e0  4180002c    blt 0x1001450c                 ; -> 1001450c
100144e4  7feb0734    extsh r11,r31               
100144e8  1d6b0070    mulli r11,r11,0x70          
100144ec  7fe30734    extsh r3,r31                
100144f0  1c630070    mulli r3,r3,0x70            
100144f4  39400000    li r10,0x0                  
100144f8  396b001c    addi r11,r11,0x1c           
100144fc  7d5e5b2e    sthx r10,r30,r11            
10014500  39800000    li r12,0x0                  
10014504  38630032    addi r3,r3,0x32             
10014508  7d9e1b2e    sthx r12,r30,r3             
1001450c  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10014510  38210040    addi r1,r1,0x40             
10014514  7c0803a6    mtspr LR,r0                 
10014518  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001451c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10014520  4e800020    blr                         
