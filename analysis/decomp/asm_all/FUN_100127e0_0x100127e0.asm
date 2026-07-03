; FUN_100127e0 @ 0x100127e0
100127e0  7c0802a6    mfspr r0,LR                 
100127e4  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
100127e8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100127ec  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
100127f0  7c7e1b78    or r30,r3,r3                
100127f4  7fc50734    extsh r5,r30                
100127f8  1ca50070    mulli r5,r5,0x70            
100127fc  7fc30734    extsh r3,r30                
10012800  7fc40734    extsh r4,r30                
10012804  1c840070    mulli r4,r4,0x70            
10012808  1c630070    mulli r3,r3,0x70            
1001280c  3be26840    addi r31,r2,0x6840          
10012810  38a50032    addi r5,r5,0x32             
10012814  7cbf2aae    lhax r5,r31,r5              
10012818  7c7f1aae    lhax r3,r31,r3              
1001281c  38840004    addi r4,r4,0x4              
10012820  2c050011    cmpwi r5,0x11               
10012824  7f9f22ae    lhax r28,r31,r4             
10012828  3b600001    li r27,0x1                  
1001282c  3ba30014    addi r29,r3,0x14            
10012830  40800020    bge 0x10012850                 ; -> 10012850
10012834  7fc60734    extsh r6,r30                
10012838  1cc60070    mulli r6,r6,0x70            
1001283c  38c6001c    addi r6,r6,0x1c             
10012840  7cdf32ae    lhax r6,r31,r6              
10012844  2c060002    cmpwi r6,0x2                
10012848  40820008    bne 0x10012850                 ; -> 10012850
1001284c  3b600007    li r27,0x7                  
10012850  7c7cda14    add r3,r28,r27              
10012854  4801bea5    bl 0x1002e6f8                  ; -> 1002e6f8
10012858  60000000    ori r0,r0,0x0               
1001285c  7c630734    extsh r3,r3                 
10012860  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10012864  7c7a1b78    or r26,r3,r3                
10012868  7fa3eb78    or r3,r29,r29               
1001286c  4801be61    bl 0x1002e6cc                  ; -> 1002e6cc
10012870  60000000    ori r0,r0,0x0               
10012874  7c630734    extsh r3,r3                 
10012878  1c63003c    mulli r3,r3,0x3c            
1001287c  38e26bf8    addi r7,r2,0x6bf8           
10012880  7c63d214    add r3,r3,r26               
10012884  7ce7182e    lwzx r7,r7,r3               
10012888  54e705ac    rlwinm r7,r7,0x0,0x16,0x16  
1001288c  2c070000    cmpwi r7,0x0                
10012890  40820050    bne 0x100128e0                 ; -> 100128e0
10012894  387c001e    addi r3,r28,0x1e            
10012898  4801be61    bl 0x1002e6f8                  ; -> 1002e6f8
1001289c  60000000    ori r0,r0,0x0               
100128a0  7c630734    extsh r3,r3                 
100128a4  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100128a8  7c7a1b78    or r26,r3,r3                
100128ac  7fa3eb78    or r3,r29,r29               
100128b0  4801be1d    bl 0x1002e6cc                  ; -> 1002e6cc
100128b4  60000000    ori r0,r0,0x0               
100128b8  7c630734    extsh r3,r3                 
100128bc  1c63003c    mulli r3,r3,0x3c            
100128c0  39026bf8    addi r8,r2,0x6bf8           
100128c4  7c63d214    add r3,r3,r26               
100128c8  7d08182e    lwzx r8,r8,r3               
100128cc  550805ac    rlwinm r8,r8,0x0,0x16,0x16  
100128d0  2c080000    cmpwi r8,0x0                
100128d4  4082000c    bne 0x100128e0                 ; -> 100128e0
100128d8  38600001    li r3,0x1                   
100128dc  48000008    b 0x100128e4                   ; -> 100128e4
100128e0  38600000    li r3,0x0                   
100128e4  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
100128e8  38210050    addi r1,r1,0x50             
100128ec  7c0803a6    mtspr LR,r0                 
100128f0  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
100128f4  4e800020    blr                         
