; FUN_1001f028 @ 0x1001f028
1001f028  7c0802a6    mfspr r0,LR                 
1001f02c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001f030  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001f034  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001f038  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1001f03c  7c7f1b78    or r31,r3,r3                
1001f040  7fe30734    extsh r3,r31                
1001f044  2803001e    cmplwi r3,0x1e              
1001f048  41810360    bgt 0x1001f3a8                 ; -> 1001f3a8
1001f04c  38820c9c    addi r4,r2,0xc9c            
1001f050  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1001f054  7c84182e    lwzx r4,r4,r3               
1001f058  7c8903a6    mtspr CTR,r4                
1001f05c  4e800420    bctr                        
1001f3a8  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001f3ac  38210040    addi r1,r1,0x40             
1001f3b0  7c0803a6    mtspr LR,r0                 
1001f3b4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001f3b8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001f3bc  4e800020    blr                         
