; FUN_10005630 @ 0x10005630
10005630  7c0802a6    mfspr r0,LR                 
10005634  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10005638  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000563c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10005640  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10005644  b061005a    sth r3,0x5a(r1)                ; -> Stack[0x1a]
10005648  b081005e    sth r4,0x5e(r1)                ; -> Stack[0x1e]
1000564c  b0a10062    sth r5,0x62(r1)                ; -> Stack[0x22]
10005650  a861005a    lha r3,0x5a(r1)                ; -> Stack[0x1a]
10005654  48029079    bl 0x1002e6cc                  ; -> 1002e6cc
10005658  60000000    ori r0,r0,0x0               
1000565c  7c7f1b78    or r31,r3,r3                
10005660  a861005e    lha r3,0x5e(r1)                ; -> Stack[0x1e]
10005664  48029095    bl 0x1002e6f8                  ; -> 1002e6f8
10005668  60000000    ori r0,r0,0x0               
1000566c  7c7e1b78    or r30,r3,r3                
10005670  7fe40734    extsh r4,r31                
10005674  7fc50734    extsh r5,r30                
10005678  7fe90734    extsh r9,r31                
1000567c  7fca0734    extsh r10,r30               
10005680  1c84003c    mulli r4,r4,0x3c            
10005684  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
10005688  38626bf8    addi r3,r2,0x6bf8           
1000568c  7c842a14    add r4,r4,r5                
10005690  7cc3202e    lwzx r6,r3,r4               
10005694  1d29003c    mulli r9,r9,0x3c            
10005698  54c6001e    rlwinm r6,r6,0x0,0x0,0xf    
1000569c  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
100056a0  39026bf8    addi r8,r2,0x6bf8           
100056a4  7cc3212e    stwx r6,r3,r4               
100056a8  7d295214    add r9,r9,r10               
100056ac  a8e10062    lha r7,0x62(r1)                ; -> Stack[0x22]
100056b0  7d68482e    lwzx r11,r8,r9              
100056b4  7d6b3a14    add r11,r11,r7              
100056b8  7d68492e    stwx r11,r8,r9              
100056bc  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
100056c0  38210040    addi r1,r1,0x40             
100056c4  7c0803a6    mtspr LR,r0                 
100056c8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100056cc  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100056d0  4e800020    blr                         
