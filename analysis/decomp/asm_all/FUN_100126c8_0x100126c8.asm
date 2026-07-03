; FUN_100126c8 @ 0x100126c8
100126c8  7c0802a6    mfspr r0,LR                 
100126cc  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
100126d0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100126d4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
100126d8  7c7e1b78    or r30,r3,r3                
100126dc  7fc50734    extsh r5,r30                
100126e0  1ca50070    mulli r5,r5,0x70            
100126e4  7fc30734    extsh r3,r30                
100126e8  7fc40734    extsh r4,r30                
100126ec  1c840070    mulli r4,r4,0x70            
100126f0  1c630070    mulli r3,r3,0x70            
100126f4  3be26840    addi r31,r2,0x6840          
100126f8  38a50032    addi r5,r5,0x32             
100126fc  7cbf2aae    lhax r5,r31,r5              
10012700  7c7f1aae    lhax r3,r31,r3              
10012704  38840004    addi r4,r4,0x4              
10012708  2c050011    cmpwi r5,0x11               
1001270c  7f9f22ae    lhax r28,r31,r4             
10012710  3b600001    li r27,0x1                  
10012714  3ba3000a    addi r29,r3,0xa             
10012718  40800020    bge 0x10012738                 ; -> 10012738
1001271c  7fc60734    extsh r6,r30                
10012720  1cc60070    mulli r6,r6,0x70            
10012724  38c6001c    addi r6,r6,0x1c             
10012728  7cdf32ae    lhax r6,r31,r6              
1001272c  2c060002    cmpwi r6,0x2                
10012730  40820008    bne 0x10012738                 ; -> 10012738
10012734  3b600007    li r27,0x7                  
10012738  7c7cda14    add r3,r28,r27              
1001273c  4801bfbd    bl 0x1002e6f8                  ; -> 1002e6f8
10012740  60000000    ori r0,r0,0x0               
10012744  7c630734    extsh r3,r3                 
10012748  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1001274c  7c7a1b78    or r26,r3,r3                
10012750  7fa3eb78    or r3,r29,r29               
10012754  4801bf79    bl 0x1002e6cc                  ; -> 1002e6cc
10012758  60000000    ori r0,r0,0x0               
1001275c  7c630734    extsh r3,r3                 
10012760  1c63003c    mulli r3,r3,0x3c            
10012764  38e26bf8    addi r7,r2,0x6bf8           
10012768  7c63d214    add r3,r3,r26               
1001276c  7ce7182e    lwzx r7,r7,r3               
10012770  54e705ac    rlwinm r7,r7,0x0,0x16,0x16  
10012774  2c070000    cmpwi r7,0x0                
10012778  40820050    bne 0x100127c8                 ; -> 100127c8
1001277c  387c001e    addi r3,r28,0x1e            
10012780  4801bf79    bl 0x1002e6f8                  ; -> 1002e6f8
10012784  60000000    ori r0,r0,0x0               
10012788  7c630734    extsh r3,r3                 
1001278c  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10012790  7c7a1b78    or r26,r3,r3                
10012794  7fa3eb78    or r3,r29,r29               
10012798  4801bf35    bl 0x1002e6cc                  ; -> 1002e6cc
1001279c  60000000    ori r0,r0,0x0               
100127a0  7c630734    extsh r3,r3                 
100127a4  1c63003c    mulli r3,r3,0x3c            
100127a8  39026bf8    addi r8,r2,0x6bf8           
100127ac  7c63d214    add r3,r3,r26               
100127b0  7d08182e    lwzx r8,r8,r3               
100127b4  550805ac    rlwinm r8,r8,0x0,0x16,0x16  
100127b8  2c080000    cmpwi r8,0x0                
100127bc  4082000c    bne 0x100127c8                 ; -> 100127c8
100127c0  38600001    li r3,0x1                   
100127c4  48000008    b 0x100127cc                   ; -> 100127cc
100127c8  38600000    li r3,0x0                   
100127cc  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
100127d0  38210050    addi r1,r1,0x50             
100127d4  7c0803a6    mtspr LR,r0                 
100127d8  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
100127dc  4e800020    blr                         
