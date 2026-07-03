; FUN_1002b900 @ 0x1002b900
1002b900  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002b904  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002b908  3fc03b9b    lis r30,0x3b9b              
1002b90c  3bdeca00    subi r30,r30,0x3600         
1002b910  3be00009    li r31,0x9                  
1002b914  48000028    b 0x1002b93c                   ; -> 1002b93c
1002b918  7ce3f3d6    divw r7,r3,r30              
1002b91c  7ca3f3d6    divw r5,r3,r30              
1002b920  7ce7f1d6    mullw r7,r7,r30             
1002b924  3900000a    li r8,0xa                   
1002b928  7fde43d6    divw r30,r30,r8             
1002b92c  57e6083c    rlwinm r6,r31,0x1,0x0,0x1e  
1002b930  7ca4332e    sthx r5,r4,r6               
1002b934  7c671850    subf r3,r7,r3               
1002b938  3bffffff    subi r31,r31,0x1            
1002b93c  2c1f0000    cmpwi r31,0x0               
1002b940  4080ffd8    bge 0x1002b918                 ; -> 1002b918
1002b944  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002b948  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002b94c  4e800020    blr                         
