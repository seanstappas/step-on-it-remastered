; FUN_10012444 @ 0x10012444
10012444  7c0802a6    mfspr r0,LR                 
10012448  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001244c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10012450  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10012454  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10012458  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001245c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10012460  7c7d1b78    or r29,r3,r3                
10012464  7fa60734    extsh r6,r29                
10012468  7fa40734    extsh r4,r29                
1001246c  38a26840    addi r5,r2,0x6840           
10012470  1cc60070    mulli r6,r6,0x70            
10012474  38a50004    addi r5,r5,0x4              
10012478  7ca532ae    lhax r5,r5,r6               
1001247c  1c840070    mulli r4,r4,0x70            
10012480  38626840    addi r3,r2,0x6840           
10012484  3be5fffe    subi r31,r5,0x2             
10012488  7fc322ae    lhax r30,r3,r4              
1001248c  7fe3fb78    or r3,r31,r31               
10012490  4801c269    bl 0x1002e6f8                  ; -> 1002e6f8
10012494  60000000    ori r0,r0,0x0               
10012498  7c630734    extsh r3,r3                 
1001249c  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100124a0  7c7c1b78    or r28,r3,r3                
100124a4  387e0010    addi r3,r30,0x10            
100124a8  4801c225    bl 0x1002e6cc                  ; -> 1002e6cc
100124ac  60000000    ori r0,r0,0x0               
100124b0  7c630734    extsh r3,r3                 
100124b4  1c63003c    mulli r3,r3,0x3c            
100124b8  38e26bf8    addi r7,r2,0x6bf8           
100124bc  7c63e214    add r3,r3,r28               
100124c0  7ce7182e    lwzx r7,r7,r3               
100124c4  54e705ac    rlwinm r7,r7,0x0,0x16,0x16  
100124c8  2c070000    cmpwi r7,0x0                
100124cc  40820048    bne 0x10012514                 ; -> 10012514
100124d0  7fe3fb78    or r3,r31,r31               
100124d4  4801c225    bl 0x1002e6f8                  ; -> 1002e6f8
100124d8  60000000    ori r0,r0,0x0               
100124dc  7c630734    extsh r3,r3                 
100124e0  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100124e4  7c7c1b78    or r28,r3,r3                
100124e8  387e000e    addi r3,r30,0xe             
100124ec  4801c1e1    bl 0x1002e6cc                  ; -> 1002e6cc
100124f0  60000000    ori r0,r0,0x0               
100124f4  7c630734    extsh r3,r3                 
100124f8  1c63003c    mulli r3,r3,0x3c            
100124fc  39026bf8    addi r8,r2,0x6bf8           
10012500  7c63e214    add r3,r3,r28               
10012504  7d08182e    lwzx r8,r8,r3               
10012508  550805ac    rlwinm r8,r8,0x0,0x16,0x16  
1001250c  2c080000    cmpwi r8,0x0                
10012510  4182000c    beq 0x1001251c                 ; -> 1001251c
10012514  38600000    li r3,0x0                   
10012518  4800001c    b 0x10012534                   ; -> 10012534
1001251c  7fe90734    extsh r9,r31                
10012520  2c090020    cmpwi r9,0x20               
10012524  4080000c    bge 0x10012530                 ; -> 10012530
10012528  38600000    li r3,0x0                   
1001252c  48000008    b 0x10012534                   ; -> 10012534
10012530  38600001    li r3,0x1                   
10012534  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10012538  38210050    addi r1,r1,0x50             
1001253c  7c0803a6    mtspr LR,r0                 
10012540  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10012544  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10012548  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001254c  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10012550  4e800020    blr                         
