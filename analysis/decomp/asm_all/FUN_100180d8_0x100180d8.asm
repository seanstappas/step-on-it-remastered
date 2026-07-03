; FUN_100180d8 @ 0x100180d8
100180d8  7c0802a6    mfspr r0,LR                 
100180dc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100180e0  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100180e4  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
100180e8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100180ec  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
100180f0  3ba261a4    addi r29,r2,0x61a4          
100180f4  3bc24e88    addi r30,r2,0x4e88          
100180f8  3be00001    li r31,0x1                  
100180fc  4800005c    b 0x10018158                   ; -> 10018158
10018100  7fe30734    extsh r3,r31                
10018104  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10018108  38630001    addi r3,r3,0x1              
1001810c  7c7e18ae    lbzx r3,r30,r3              
10018110  28030000    cmplwi r3,0x0               
10018114  41820040    beq 0x10018154                 ; -> 10018154
10018118  7fe40734    extsh r4,r31                
1001811c  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10018120  7c9e20ae    lbzx r4,r30,r4              
10018124  28040000    cmplwi r4,0x0               
10018128  4082002c    bne 0x10018154                 ; -> 10018154
1001812c  7fe50734    extsh r5,r31                
10018130  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
10018134  7c7d282e    lwzx r3,r29,r5              
10018138  48018f21    bl 0x10031058                  ; -> 10031058
1001813c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10018140  7fe70734    extsh r7,r31                
10018144  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
10018148  38c00000    li r6,0x0                   
1001814c  38e70001    addi r7,r7,0x1              
10018150  7cde39ae    stbx r6,r30,r7              
10018154  3bff0001    addi r31,r31,0x1            
10018158  7fe80734    extsh r8,r31                
1001815c  2c080013    cmpwi r8,0x13               
10018160  4081ffa0    ble 0x10018100                 ; -> 10018100
10018164  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10018168  38210050    addi r1,r1,0x50             
1001816c  7c0803a6    mtspr LR,r0                 
10018170  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10018174  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10018178  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001817c  4e800020    blr                         
