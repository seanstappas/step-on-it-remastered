; FUN_1001b8b0 @ 0x1001b8b0
1001b8b0  7c0802a6    mfspr r0,LR                 
1001b8b4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001b8b8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001b8bc  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001b8c0  7c7f1b78    or r31,r3,r3                
1001b8c4  a07f0000    lhz r3,0x0(r31)             
1001b8c8  28030017    cmplwi r3,0x17              
1001b8cc  41810084    bgt 0x1001b950                 ; -> 1001b950
1001b8d0  38820b08    addi r4,r2,0xb08            
1001b8d4  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1001b8d8  7c84182e    lwzx r4,r4,r3               
1001b8dc  7c8903a6    mtspr CTR,r4                
1001b8e0  4e800420    bctr                        
1001b950  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001b954  38210040    addi r1,r1,0x40             
1001b958  7c0803a6    mtspr LR,r0                 
1001b95c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001b960  4e800020    blr                         
