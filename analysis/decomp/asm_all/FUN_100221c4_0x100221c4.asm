; FUN_100221c4 @ 0x100221c4
100221c4  7c0802a6    mfspr r0,LR                 
100221c8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100221cc  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100221d0  4bffffbd    bl 0x1002218c                  ; -> 1002218c
100221d4  3862613e    addi r3,r2,0x613e           
100221d8  a8630000    lha r3,0x0(r3)              
100221dc  2803000a    cmplwi r3,0xa               
100221e0  41810120    bgt 0x10022300                 ; -> 10022300
100221e4  38822df4    addi r4,r2,0x2df4           
100221e8  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100221ec  7c84182e    lwzx r4,r4,r3               
100221f0  7c8903a6    mtspr CTR,r4                
100221f4  4e800420    bctr                        
10022300  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10022304  38210040    addi r1,r1,0x40             
10022308  7c0803a6    mtspr LR,r0                 
1002230c  4e800020    blr                         
