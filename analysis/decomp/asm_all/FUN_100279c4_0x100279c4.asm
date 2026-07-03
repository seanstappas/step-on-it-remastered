; FUN_100279c4 @ 0x100279c4
100279c4  7c0802a6    mfspr r0,LR                 
100279c8  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
100279cc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100279d0  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
100279d4  7c7e1b78    or r30,r3,r3                
100279d8  7c9f2378    or r31,r4,r4                
100279dc  7fc30734    extsh r3,r30                
100279e0  7fe40734    extsh r4,r31                
100279e4  1c63003c    mulli r3,r3,0x3c            
100279e8  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
100279ec  3ba26bf8    addi r29,r2,0x6bf8          
100279f0  7c632214    add r3,r3,r4                
100279f4  7c7d182e    lwzx r3,r29,r3              
100279f8  546305ee    rlwinm r3,r3,0x0,0x17,0x17  
100279fc  2c030000    cmpwi r3,0x0                
10027a00  408200d8    bne 0x10027ad8                 ; -> 10027ad8
10027a04  7fc50734    extsh r5,r30                
10027a08  7fe60734    extsh r6,r31                
10027a0c  1ca5003c    mulli r5,r5,0x3c            
10027a10  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
10027a14  7ca53214    add r5,r5,r6                
10027a18  7cbd282e    lwzx r5,r29,r5              
10027a1c  54a5063e    rlwinm r5,r5,0x0,0x18,0x1f  
10027a20  2c050000    cmpwi r5,0x0                
10027a24  418200b4    beq 0x10027ad8                 ; -> 10027ad8
10027a28  7fc70734    extsh r7,r30                
10027a2c  7fe80734    extsh r8,r31                
10027a30  1ce7003c    mulli r7,r7,0x3c            
10027a34  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
10027a38  7ce74214    add r7,r7,r8                
10027a3c  7cfd382e    lwzx r7,r29,r7              
10027a40  54e704e6    rlwinm r7,r7,0x0,0x13,0x13  
10027a44  2c070000    cmpwi r7,0x0                
10027a48  40820040    bne 0x10027a88                 ; -> 10027a88
10027a4c  7fe3fb78    or r3,r31,r31               
10027a50  48006c6d    bl 0x1002e6bc                  ; -> 1002e6bc
10027a54  60000000    ori r0,r0,0x0               
10027a58  7c7c1b78    or r28,r3,r3                
10027a5c  7fc3f378    or r3,r30,r30               
10027a60  48006c4d    bl 0x1002e6ac                  ; -> 1002e6ac
10027a64  60000000    ori r0,r0,0x0               
10027a68  7c7b1b78    or r27,r3,r3                
10027a6c  7f63db78    or r3,r27,r27               
10027a70  7f84e378    or r4,r28,r28               
10027a74  38a0ffff    li r5,-0x1                  
10027a78  38c00000    li r6,0x0                   
10027a7c  38e00000    li r7,0x0                   
10027a80  4bfffacd    bl 0x1002754c                  ; -> 1002754c
10027a84  48000054    b 0x10027ad8                   ; -> 10027ad8
10027a88  7fe3fb78    or r3,r31,r31               
10027a8c  48006c31    bl 0x1002e6bc                  ; -> 1002e6bc
10027a90  60000000    ori r0,r0,0x0               
10027a94  7c7c1b78    or r28,r3,r3                
10027a98  7fc3f378    or r3,r30,r30               
10027a9c  48006c11    bl 0x1002e6ac                  ; -> 1002e6ac
10027aa0  60000000    ori r0,r0,0x0               
10027aa4  7fc90734    extsh r9,r30                
10027aa8  7fea0734    extsh r10,r31               
10027aac  7c7b1b78    or r27,r3,r3                
10027ab0  1d29003c    mulli r9,r9,0x3c            
10027ab4  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
10027ab8  7d295214    add r9,r9,r10               
10027abc  7d3d482e    lwzx r9,r29,r9              
10027ac0  7f63db78    or r3,r27,r27               
10027ac4  7f84e378    or r4,r28,r28               
10027ac8  38a0ffff    li r5,-0x1                  
10027acc  38c00000    li r6,0x0                   
10027ad0  5527843e    rlwinm r7,r9,0x10,0x10,0x1f 
10027ad4  4bfffa79    bl 0x1002754c                  ; -> 1002754c
10027ad8  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10027adc  38210050    addi r1,r1,0x50             
10027ae0  7c0803a6    mtspr LR,r0                 
10027ae4  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10027ae8  4e800020    blr                         
