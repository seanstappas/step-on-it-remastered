; FUN_10018214 @ 0x10018214
10018214  7c0802a6    mfspr r0,LR                 
10018218  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001821c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10018220  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10018224  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10018228  7c7f1b78    or r31,r3,r3                
1001822c  7fe50734    extsh r5,r31                
10018230  38820890    addi r4,r2,0x890            
10018234  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
10018238  7c642aae    lhax r3,r4,r5               
1001823c  3bc26a7c    addi r30,r2,0x6a7c          
10018240  3880002a    li r4,0x2a                  
10018244  48001651    bl 0x10019894                  ; -> 10019894
10018248  60000000    ori r0,r0,0x0               
1001824c  7fe60734    extsh r6,r31                
10018250  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
10018254  7fe70734    extsh r7,r31                
10018258  7c7e312e    stwx r3,r30,r6              
1001825c  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
10018260  7cfe382e    lwzx r7,r30,r7              
10018264  28070000    cmplwi r7,0x0               
10018268  40820050    bne 0x100182b8                 ; -> 100182b8
1001826c  4bffff15    bl 0x10018180                  ; -> 10018180
10018270  7fe90734    extsh r9,r31                
10018274  39020890    addi r8,r2,0x890            
10018278  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1001827c  7c684aae    lhax r3,r8,r9               
10018280  3880002a    li r4,0x2a                  
10018284  48001611    bl 0x10019894                  ; -> 10019894
10018288  60000000    ori r0,r0,0x0               
1001828c  7fea0734    extsh r10,r31               
10018290  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
10018294  7feb0734    extsh r11,r31               
10018298  7c7e512e    stwx r3,r30,r10             
1001829c  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
100182a0  7d7e582e    lwzx r11,r30,r11            
100182a4  280b0000    cmplwi r11,0x0              
100182a8  40820010    bne 0x100182b8                 ; -> 100182b8
100182ac  38600006    li r3,0x6                   
100182b0  48001049    bl 0x100192f8                  ; -> 100192f8
100182b4  60000000    ori r0,r0,0x0               
100182b8  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
100182bc  38210040    addi r1,r1,0x40             
100182c0  7c0803a6    mtspr LR,r0                 
100182c4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100182c8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100182cc  4e800020    blr                         
