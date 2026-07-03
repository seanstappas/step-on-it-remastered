; FUN_10003f7c @ 0x10003f7c
10003f7c  7c0802a6    mfspr r0,LR                 
10003f80  bea1ffd4    stmw r21,-0x2c(r1)             ; -> Stack[-0x2c]
10003f84  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10003f88  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
10003f8c  3ac270e4    addi r22,r2,0x70e4          
10003f90  3ae270e8    addi r23,r2,0x70e8          
10003f94  3b426bd8    addi r26,r2,0x6bd8          
10003f98  3b626bdc    addi r27,r2,0x6bdc          
10003f9c  3ba233b6    addi r29,r2,0x33b6          
10003fa0  3b8233b4    addi r28,r2,0x33b4          
10003fa4  3bc2372e    addi r30,r2,0x372e          
10003fa8  3b026bd0    addi r24,r2,0x6bd0          
10003fac  3b226bd4    addi r25,r2,0x6bd4          
10003fb0  3be00000    li r31,0x0                  
10003fb4  4800005c    b 0x10004010                   ; -> 10004010
10003fb8  7fe30734    extsh r3,r31                
10003fbc  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
10003fc0  7c7d1aae    lhax r3,r29,r3              
10003fc4  1c630014    mulli r3,r3,0x14            
10003fc8  3863000c    addi r3,r3,0xc              
10003fcc  7c7e1aae    lhax r3,r30,r3              
10003fd0  2c03015e    cmpwi r3,0x15e              
10003fd4  40810008    ble 0x10003fdc                 ; -> 10003fdc
10003fd8  7ff5fb78    or r21,r31,r31              
10003fdc  7fe40734    extsh r4,r31                
10003fe0  5484083c    rlwinm r4,r4,0x1,0x0,0x1e   
10003fe4  7c9d22ae    lhax r4,r29,r4              
10003fe8  80ba0000    lwz r5,0x0(r26)             
10003fec  1c840014    mulli r4,r4,0x14            
10003ff0  3884000c    addi r4,r4,0xc              
10003ff4  7c7e2214    add r3,r30,r4               
10003ff8  809b0000    lwz r4,0x0(r27)             
10003ffc  80d90000    lwz r6,0x0(r25)             
10004000  a8f80000    lha r7,0x0(r24)             
10004004  4bffd899    bl 0x1000189c                  ; -> 1000189c
10004008  60000000    ori r0,r0,0x0               
1000400c  3bff0001    addi r31,r31,0x1            
10004010  a8dc0000    lha r6,0x0(r28)             
10004014  7fe50734    extsh r5,r31                
10004018  7c053000    cmpw r5,r6                  
1000401c  4180ff9c    blt 0x10003fb8                 ; -> 10003fb8
10004020  3be00000    li r31,0x0                  
10004024  48000038    b 0x1000405c                   ; -> 1000405c
10004028  7fe70734    extsh r7,r31                
1000402c  54e7083c    rlwinm r7,r7,0x1,0x0,0x1e   
10004030  7cfd3aae    lhax r7,r29,r7              
10004034  80970000    lwz r4,0x0(r23)             
10004038  1ce70014    mulli r7,r7,0x14            
1000403c  38e70004    addi r7,r7,0x4              
10004040  7c7e3a14    add r3,r30,r7               
10004044  80b60000    lwz r5,0x0(r22)             
10004048  80db0000    lwz r6,0x0(r27)             
1000404c  80fa0000    lwz r7,0x0(r26)             
10004050  4bffd84d    bl 0x1000189c                  ; -> 1000189c
10004054  60000000    ori r0,r0,0x0               
10004058  3bff0001    addi r31,r31,0x1            
1000405c  a93c0000    lha r9,0x0(r28)             
10004060  7fe80734    extsh r8,r31                
10004064  7c084800    cmpw r8,r9                  
10004068  4180ffc0    blt 0x10004028                 ; -> 10004028
1000406c  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
10004070  38210070    addi r1,r1,0x70             
10004074  7c0803a6    mtspr LR,r0                 
10004078  baa1ffd4    lmw r21,-0x2c(r1)              ; -> Stack[-0x2c]
1000407c  4e800020    blr                         
