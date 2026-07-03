; FUN_1002b950 @ 0x1002b950
1002b950  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002b954  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002b958  3bc02710    li r30,0x2710               
1002b95c  3be00004    li r31,0x4                  
1002b960  48000044    b 0x1002b9a4                   ; -> 1002b9a4
1002b964  7fe70734    extsh r7,r31                
1002b968  3960000a    li r11,0xa                  
1002b96c  7fc80734    extsh r8,r30                
1002b970  7c690734    extsh r9,r3                 
1002b974  7d4943d6    divw r10,r9,r8              
1002b978  7c650734    extsh r5,r3                 
1002b97c  7fc60734    extsh r6,r30                
1002b980  7d4a41d6    mullw r10,r10,r8            
1002b984  7ca533d6    divw r5,r5,r6               
1002b988  7d6b0734    extsh r11,r11               
1002b98c  7fcc0734    extsh r12,r30               
1002b990  7fcc5bd6    divw r30,r12,r11            
1002b994  54e7083c    rlwinm r7,r7,0x1,0x0,0x1e   
1002b998  7ca43b2e    sthx r5,r4,r7               
1002b99c  7c6a4850    subf r3,r10,r9              
1002b9a0  3bffffff    subi r31,r31,0x1            
1002b9a4  7fe50734    extsh r5,r31                
1002b9a8  2c050000    cmpwi r5,0x0                
1002b9ac  4080ffb8    bge 0x1002b964                 ; -> 1002b964
1002b9b0  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002b9b4  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002b9b8  4e800020    blr                         
