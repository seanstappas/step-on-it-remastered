; FUN_10003914 @ 0x10003914
10003914  7c0802a6    mfspr r0,LR                 
10003918  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1000391c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10003920  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10003924  3b623704    addi r27,r2,0x3704          
10003928  3ba2372e    addi r29,r2,0x372e          
1000392c  4800023d    bl 0x10003b68                  ; -> 10003b68
10003930  60000000    ori r0,r0,0x0               
10003934  3b800000    li r28,0x0                  
10003938  480000b4    b 0x100039ec                   ; -> 100039ec
1000393c  7f830734    extsh r3,r28                
10003940  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
10003944  7fdb1aae    lhax r30,r27,r3             
10003948  48000094    b 0x100039dc                   ; -> 100039dc
1000394c  7fc40734    extsh r4,r30                
10003950  1c840014    mulli r4,r4,0x14            
10003954  38840002    addi r4,r4,0x2              
10003958  7ffd22ae    lhax r31,r29,r4             
1000395c  48000024    b 0x10003980                   ; -> 10003980
10003960  7fc3f378    or r3,r30,r30               
10003964  7fe4fb78    or r4,r31,r31               
10003968  480000a5    bl 0x10003a0c                  ; -> 10003a0c
1000396c  60000000    ori r0,r0,0x0               
10003970  7fe50734    extsh r5,r31                
10003974  1ca50014    mulli r5,r5,0x14            
10003978  38a50002    addi r5,r5,0x2              
1000397c  7ffd2aae    lhax r31,r29,r5             
10003980  7fe60734    extsh r6,r31                
10003984  2c06ffff    cmpwi r6,-0x1               
10003988  4082ffd8    bne 0x10003960                 ; -> 10003960
1000398c  7f870734    extsh r7,r28                
10003990  38e70001    addi r7,r7,0x1              
10003994  54e7083c    rlwinm r7,r7,0x1,0x0,0x1e   
10003998  7ffb3aae    lhax r31,r27,r7             
1000399c  48000024    b 0x100039c0                   ; -> 100039c0
100039a0  7fc3f378    or r3,r30,r30               
100039a4  7fe4fb78    or r4,r31,r31               
100039a8  48000065    bl 0x10003a0c                  ; -> 10003a0c
100039ac  60000000    ori r0,r0,0x0               
100039b0  7fe80734    extsh r8,r31                
100039b4  1d080014    mulli r8,r8,0x14            
100039b8  39080002    addi r8,r8,0x2              
100039bc  7ffd42ae    lhax r31,r29,r8             
100039c0  7fe90734    extsh r9,r31                
100039c4  2c09ffff    cmpwi r9,-0x1               
100039c8  4082ffd8    bne 0x100039a0                 ; -> 100039a0
100039cc  7fca0734    extsh r10,r30               
100039d0  1d4a0014    mulli r10,r10,0x14          
100039d4  394a0002    addi r10,r10,0x2            
100039d8  7fdd52ae    lhax r30,r29,r10            
100039dc  7fcb0734    extsh r11,r30               
100039e0  2c0bffff    cmpwi r11,-0x1              
100039e4  4082ff68    bne 0x1000394c                 ; -> 1000394c
100039e8  3b9c0001    addi r28,r28,0x1            
100039ec  7f8c0734    extsh r12,r28               
100039f0  2c0c0013    cmpwi r12,0x13              
100039f4  4081ff48    ble 0x1000393c                 ; -> 1000393c
100039f8  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
100039fc  38210050    addi r1,r1,0x50             
10003a00  7c0803a6    mtspr LR,r0                 
10003a04  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10003a08  4e800020    blr                         
