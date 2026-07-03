; FUN_10013404 @ 0x10013404
10013404  7c0802a6    mfspr r0,LR                 
10013408  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001340c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10013410  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10013414  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10013418  7c7f1b78    or r31,r3,r3                
1001341c  3bc26840    addi r30,r2,0x6840          
10013420  7fe3fb78    or r3,r31,r31               
10013424  48001321    bl 0x10014744                  ; -> 10014744
10013428  60000000    ori r0,r0,0x0               
1001342c  7fe30734    extsh r3,r31                
10013430  1c630070    mulli r3,r3,0x70            
10013434  38630032    addi r3,r3,0x32             
10013438  7c7e1aae    lhax r3,r30,r3              
1001343c  2c030000    cmpwi r3,0x0                
10013440  40820074    bne 0x100134b4                 ; -> 100134b4
10013444  7fe3fb78    or r3,r31,r31               
10013448  4bffeffd    bl 0x10012444                  ; -> 10012444
1001344c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10013450  28030000    cmplwi r3,0x0               
10013454  4082001c    bne 0x10013470                 ; -> 10013470
10013458  7fe50734    extsh r5,r31                
1001345c  1ca50070    mulli r5,r5,0x70            
10013460  38800004    li r4,0x4                   
10013464  38a5001c    addi r5,r5,0x1c             
10013468  7c9e2b2e    sthx r4,r30,r5              
1001346c  48000374    b 0x100137e0                   ; -> 100137e0
10013470  7fe60734    extsh r6,r31                
10013474  1cc60070    mulli r6,r6,0x70            
10013478  38c60034    addi r6,r6,0x34             
1001347c  7cde32ae    lhax r6,r30,r6              
10013480  2c060001    cmpwi r6,0x1                
10013484  4082001c    bne 0x100134a0                 ; -> 100134a0
10013488  7fe80734    extsh r8,r31                
1001348c  1d080070    mulli r8,r8,0x70            
10013490  38e00085    li r7,0x85                  
10013494  39080010    addi r8,r8,0x10             
10013498  7cfe432e    sthx r7,r30,r8              
1001349c  48000018    b 0x100134b4                   ; -> 100134b4
100134a0  7fea0734    extsh r10,r31               
100134a4  1d4a0070    mulli r10,r10,0x70          
100134a8  3920007e    li r9,0x7e                  
100134ac  394a0010    addi r10,r10,0x10           
100134b0  7d3e532e    sthx r9,r30,r10             
100134b4  7feb0734    extsh r11,r31               
100134b8  1d6b0070    mulli r11,r11,0x70          
100134bc  396b0032    addi r11,r11,0x32           
100134c0  7d7e5aae    lhax r11,r30,r11            
100134c4  2c0b0008    cmpwi r11,0x8               
100134c8  40800030    bge 0x100134f8                 ; -> 100134f8
100134cc  7fe3fb78    or r3,r31,r31               
100134d0  4bffef75    bl 0x10012444                  ; -> 10012444
100134d4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
100134d8  28030000    cmplwi r3,0x0               
100134dc  40820024    bne 0x10013500                 ; -> 10013500
100134e0  7fe30734    extsh r3,r31                
100134e4  1c630070    mulli r3,r3,0x70            
100134e8  3980000c    li r12,0xc                  
100134ec  38630032    addi r3,r3,0x32             
100134f0  7d9e1b2e    sthx r12,r30,r3             
100134f4  4800000c    b 0x10013500                   ; -> 10013500
100134f8  7fe3fb78    or r3,r31,r31               
100134fc  4bfff059    bl 0x10012554                  ; -> 10012554
10013500  7fe40734    extsh r4,r31                
10013504  1c840070    mulli r4,r4,0x70            
10013508  38840032    addi r4,r4,0x32             
1001350c  7cbe22ae    lhax r5,r30,r4              
10013510  38a50001    addi r5,r5,0x1              
10013514  7cbe232e    sthx r5,r30,r4              
10013518  7ca50734    extsh r5,r5                 
1001351c  2c050011    cmpwi r5,0x11               
10013520  40810018    ble 0x10013538                 ; -> 10013538
10013524  7fe70734    extsh r7,r31                
10013528  1ce70070    mulli r7,r7,0x70            
1001352c  38c00011    li r6,0x11                  
10013530  38e70032    addi r7,r7,0x32             
10013534  7cde3b2e    sthx r6,r30,r7              
10013538  7fe90734    extsh r9,r31                
1001353c  1d290070    mulli r9,r9,0x70            
10013540  7fea0734    extsh r10,r31               
10013544  1d4a0070    mulli r10,r10,0x70          
10013548  39290032    addi r9,r9,0x32             
1001354c  7d3e4aae    lhax r9,r30,r9              
10013550  7fec0734    extsh r12,r31               
10013554  1d8c0070    mulli r12,r12,0x70          
10013558  394a0004    addi r10,r10,0x4            
1001355c  7fe40734    extsh r4,r31                
10013560  1c840070    mulli r4,r4,0x70            
10013564  390205dc    addi r8,r2,0x5dc            
10013568  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1001356c  7d084aae    lhax r8,r8,r9               
10013570  7d7e52ae    lhax r11,r30,r10            
10013574  398c0010    addi r12,r12,0x10           
10013578  7d6b4214    add r11,r11,r8              
1001357c  7d7e532e    sthx r11,r30,r10            
10013580  7c7e62ae    lhax r3,r30,r12             
10013584  3884001e    addi r4,r4,0x1e             
10013588  38630001    addi r3,r3,0x1              
1001358c  7c7e632e    sthx r3,r30,r12             
10013590  7c9e20ae    lbzx r4,r30,r4              
10013594  28040000    cmplwi r4,0x0               
10013598  41820050    beq 0x100135e8                 ; -> 100135e8
1001359c  7fe3fb78    or r3,r31,r31               
100135a0  4bfff241    bl 0x100127e0                  ; -> 100127e0
100135a4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
100135a8  28030000    cmplwi r3,0x0               
100135ac  4182009c    beq 0x10013648                 ; -> 10013648
100135b0  7fe50734    extsh r5,r31                
100135b4  1ca50070    mulli r5,r5,0x70            
100135b8  7fe70734    extsh r7,r31                
100135bc  7cde2aae    lhax r6,r30,r5              
100135c0  7fe80734    extsh r8,r31                
100135c4  1d080070    mulli r8,r8,0x70            
100135c8  38c60002    addi r6,r6,0x2              
100135cc  1ce70070    mulli r7,r7,0x70            
100135d0  7cde2b2e    sthx r6,r30,r5              
100135d4  7cfe3aae    lhax r7,r30,r7              
100135d8  39080002    addi r8,r8,0x2              
100135dc  54e7043a    rlwinm r7,r7,0x0,0x10,0x1d  
100135e0  7cfe432e    sthx r7,r30,r8              
100135e4  48000064    b 0x10013648                   ; -> 10013648
100135e8  7fe90734    extsh r9,r31                
100135ec  1d290070    mulli r9,r9,0x70            
100135f0  3929001f    addi r9,r9,0x1f             
100135f4  7d3e48ae    lbzx r9,r30,r9              
100135f8  28090000    cmplwi r9,0x0               
100135fc  4182004c    beq 0x10013648                 ; -> 10013648
10013600  7fe3fb78    or r3,r31,r31               
10013604  4bfff0c5    bl 0x100126c8                  ; -> 100126c8
10013608  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1001360c  28030000    cmplwi r3,0x0               
10013610  41820038    beq 0x10013648                 ; -> 10013648
10013614  7fea0734    extsh r10,r31               
10013618  1d4a0070    mulli r10,r10,0x70          
1001361c  7fec0734    extsh r12,r31               
10013620  7d7e52ae    lhax r11,r30,r10            
10013624  7fe30734    extsh r3,r31                
10013628  1c630070    mulli r3,r3,0x70            
1001362c  396bfffe    subi r11,r11,0x2            
10013630  1d8c0070    mulli r12,r12,0x70          
10013634  7d7e532e    sthx r11,r30,r10            
10013638  7d9e62ae    lhax r12,r30,r12            
1001363c  38630002    addi r3,r3,0x2              
10013640  558c043a    rlwinm r12,r12,0x0,0x10,0x1d
10013644  7d9e1b2e    sthx r12,r30,r3             
10013648  7fe40734    extsh r4,r31                
1001364c  1c840070    mulli r4,r4,0x70            
10013650  38840034    addi r4,r4,0x34             
10013654  7c9e22ae    lhax r4,r30,r4              
10013658  2c040001    cmpwi r4,0x1                
1001365c  40820034    bne 0x10013690                 ; -> 10013690
10013660  7fe50734    extsh r5,r31                
10013664  1ca50070    mulli r5,r5,0x70            
10013668  38a50010    addi r5,r5,0x10             
1001366c  7cbe2aae    lhax r5,r30,r5              
10013670  2c05008d    cmpwi r5,0x8d               
10013674  40810048    ble 0x100136bc                 ; -> 100136bc
10013678  7fe70734    extsh r7,r31                
1001367c  1ce70070    mulli r7,r7,0x70            
10013680  38c00086    li r6,0x86                  
10013684  38e70010    addi r7,r7,0x10             
10013688  7cde3b2e    sthx r6,r30,r7              
1001368c  48000030    b 0x100136bc                   ; -> 100136bc
10013690  7fe80734    extsh r8,r31                
10013694  1d080070    mulli r8,r8,0x70            
10013698  39080010    addi r8,r8,0x10             
1001369c  7d1e42ae    lhax r8,r30,r8              
100136a0  2c080085    cmpwi r8,0x85               
100136a4  40810018    ble 0x100136bc                 ; -> 100136bc
100136a8  7fea0734    extsh r10,r31               
100136ac  1d4a0070    mulli r10,r10,0x70          
100136b0  3920007e    li r9,0x7e                  
100136b4  394a0010    addi r10,r10,0x10           
100136b8  7d3e532e    sthx r9,r30,r10             
100136bc  7feb0734    extsh r11,r31               
100136c0  1d6b0070    mulli r11,r11,0x70          
100136c4  396b0032    addi r11,r11,0x32           
100136c8  7d7e5aae    lhax r11,r30,r11            
100136cc  2c0b000c    cmpwi r11,0xc               
100136d0  40810090    ble 0x10013760                 ; -> 10013760
100136d4  7fe3fb78    or r3,r31,r31               
100136d8  4bffec71    bl 0x10012348                  ; -> 10012348
100136dc  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
100136e0  28030000    cmplwi r3,0x0               
100136e4  4182007c    beq 0x10013760                 ; -> 10013760
100136e8  7fe3fb78    or r3,r31,r31               
100136ec  4800010d    bl 0x100137f8                  ; -> 100137f8
100136f0  60000000    ori r0,r0,0x0               
100136f4  7fe30734    extsh r3,r31                
100136f8  1c630070    mulli r3,r3,0x70            
100136fc  7fe40734    extsh r4,r31                
10013700  1c840070    mulli r4,r4,0x70            
10013704  39800000    li r12,0x0                  
10013708  3863001c    addi r3,r3,0x1c             
1001370c  7d9e1b2e    sthx r12,r30,r3             
10013710  3884001e    addi r4,r4,0x1e             
10013714  7c9e20ae    lbzx r4,r30,r4              
10013718  28040000    cmplwi r4,0x0               
1001371c  4082001c    bne 0x10013738                 ; -> 10013738
10013720  7fe50734    extsh r5,r31                
10013724  1ca50070    mulli r5,r5,0x70            
10013728  38a5001f    addi r5,r5,0x1f             
1001372c  7cbe28ae    lbzx r5,r30,r5              
10013730  28050000    cmplwi r5,0x0               
10013734  4182002c    beq 0x10013760                 ; -> 10013760
10013738  7fe70734    extsh r7,r31                
1001373c  1ce70070    mulli r7,r7,0x70            
10013740  7fe90734    extsh r9,r31                
10013744  1d290070    mulli r9,r9,0x70            
10013748  38c00001    li r6,0x1                   
1001374c  38e7001c    addi r7,r7,0x1c             
10013750  7cde3b2e    sthx r6,r30,r7              
10013754  39000000    li r8,0x0                   
10013758  39290032    addi r9,r9,0x32             
1001375c  7d1e4b2e    sthx r8,r30,r9              
10013760  7fea0734    extsh r10,r31               
10013764  1d4a0070    mulli r10,r10,0x70          
10013768  7feb0734    extsh r11,r31               
1001376c  1d6b0070    mulli r11,r11,0x70          
10013770  7fec0734    extsh r12,r31               
10013774  394a0010    addi r10,r10,0x10           
10013778  1d8c0070    mulli r12,r12,0x70          
1001377c  7d5e52ae    lhax r10,r30,r10            
10013780  396b000e    addi r11,r11,0xe            
10013784  7d5e5b2e    sthx r10,r30,r11            
10013788  7d9e62ae    lhax r12,r30,r12            
1001378c  558c07bc    rlwinm r12,r12,0x0,0x1e,0x1e
10013790  2c0c0000    cmpwi r12,0x0               
10013794  4182001c    beq 0x100137b0                 ; -> 100137b0
10013798  7fe30734    extsh r3,r31                
1001379c  1c630070    mulli r3,r3,0x70            
100137a0  3863000e    addi r3,r3,0xe              
100137a4  7c9e1aae    lhax r4,r30,r3              
100137a8  38840010    addi r4,r4,0x10             
100137ac  7c9e1b2e    sthx r4,r30,r3              
100137b0  7fe50734    extsh r5,r31                
100137b4  1ca50070    mulli r5,r5,0x70            
100137b8  38a50004    addi r5,r5,0x4              
100137bc  7cbe2aae    lhax r5,r30,r5              
100137c0  2c0501ca    cmpwi r5,0x1ca              
100137c4  4081001c    ble 0x100137e0                 ; -> 100137e0
100137c8  7fe60734    extsh r6,r31                
100137cc  1cc60070    mulli r6,r6,0x70            
100137d0  38c60004    addi r6,r6,0x4              
100137d4  7cfe32ae    lhax r7,r30,r6              
100137d8  38e7fec0    subi r7,r7,0x140            
100137dc  7cfe332e    sthx r7,r30,r6              
100137e0  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
100137e4  38210040    addi r1,r1,0x40             
100137e8  7c0803a6    mtspr LR,r0                 
100137ec  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100137f0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100137f4  4e800020    blr                         
