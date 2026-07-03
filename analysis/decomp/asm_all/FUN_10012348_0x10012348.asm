; FUN_10012348 @ 0x10012348
10012348  7c0802a6    mfspr r0,LR                 
1001234c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10012350  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10012354  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10012358  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1001235c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10012360  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10012364  7c7d1b78    or r29,r3,r3                
10012368  7fa60734    extsh r6,r29                
1001236c  7fa40734    extsh r4,r29                
10012370  38a26840    addi r5,r2,0x6840           
10012374  1cc60070    mulli r6,r6,0x70            
10012378  38a50004    addi r5,r5,0x4              
1001237c  7ca532ae    lhax r5,r5,r6               
10012380  1c840070    mulli r4,r4,0x70            
10012384  38626840    addi r3,r2,0x6840           
10012388  3bc5001f    addi r30,r5,0x1f            
1001238c  7fe322ae    lhax r31,r3,r4              
10012390  7fc3f378    or r3,r30,r30               
10012394  4801c365    bl 0x1002e6f8                  ; -> 1002e6f8
10012398  60000000    ori r0,r0,0x0               
1001239c  7c630734    extsh r3,r3                 
100123a0  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100123a4  7c7c1b78    or r28,r3,r3                
100123a8  387f0010    addi r3,r31,0x10            
100123ac  4801c321    bl 0x1002e6cc                  ; -> 1002e6cc
100123b0  60000000    ori r0,r0,0x0               
100123b4  7c630734    extsh r3,r3                 
100123b8  1c63003c    mulli r3,r3,0x3c            
100123bc  38e26bf8    addi r7,r2,0x6bf8           
100123c0  7c63e214    add r3,r3,r28               
100123c4  7ce7182e    lwzx r7,r7,r3               
100123c8  54e705ac    rlwinm r7,r7,0x0,0x16,0x16  
100123cc  2c070000    cmpwi r7,0x0                
100123d0  40820048    bne 0x10012418                 ; -> 10012418
100123d4  7fc3f378    or r3,r30,r30               
100123d8  4801c321    bl 0x1002e6f8                  ; -> 1002e6f8
100123dc  60000000    ori r0,r0,0x0               
100123e0  7c630734    extsh r3,r3                 
100123e4  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100123e8  7c7c1b78    or r28,r3,r3                
100123ec  387f000e    addi r3,r31,0xe             
100123f0  4801c2dd    bl 0x1002e6cc                  ; -> 1002e6cc
100123f4  60000000    ori r0,r0,0x0               
100123f8  7c630734    extsh r3,r3                 
100123fc  1c63003c    mulli r3,r3,0x3c            
10012400  39026bf8    addi r8,r2,0x6bf8           
10012404  7c63e214    add r3,r3,r28               
10012408  7d08182e    lwzx r8,r8,r3               
1001240c  550805ac    rlwinm r8,r8,0x0,0x16,0x16  
10012410  2c080000    cmpwi r8,0x0                
10012414  4182000c    beq 0x10012420                 ; -> 10012420
10012418  38600001    li r3,0x1                   
1001241c  48000008    b 0x10012424                   ; -> 10012424
10012420  38600000    li r3,0x0                   
10012424  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10012428  38210050    addi r1,r1,0x50             
1001242c  7c0803a6    mtspr LR,r0                 
10012430  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10012434  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10012438  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001243c  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10012440  4e800020    blr                         
