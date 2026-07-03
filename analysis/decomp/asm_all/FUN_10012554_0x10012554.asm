; FUN_10012554 @ 0x10012554
10012554  7c0802a6    mfspr r0,LR                 
10012558  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
1001255c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10012560  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10012564  7c7b1b78    or r27,r3,r3                
10012568  7f640734    extsh r4,r27                
1001256c  7f630734    extsh r3,r27                
10012570  1c840070    mulli r4,r4,0x70            
10012574  1c630070    mulli r3,r3,0x70            
10012578  3ba26840    addi r29,r2,0x6840          
1001257c  38840004    addi r4,r4,0x4              
10012580  7ffd1aae    lhax r31,r29,r3             
10012584  7fdd22ae    lhax r30,r29,r4             
10012588  3b826bf8    addi r28,r2,0x6bf8          
1001258c  387e0007    addi r3,r30,0x7             
10012590  4801c169    bl 0x1002e6f8                  ; -> 1002e6f8
10012594  60000000    ori r0,r0,0x0               
10012598  7c630734    extsh r3,r3                 
1001259c  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100125a0  7c7a1b78    or r26,r3,r3                
100125a4  387f000a    addi r3,r31,0xa             
100125a8  4801c125    bl 0x1002e6cc                  ; -> 1002e6cc
100125ac  60000000    ori r0,r0,0x0               
100125b0  7c630734    extsh r3,r3                 
100125b4  1c63003c    mulli r3,r3,0x3c            
100125b8  7c63d214    add r3,r3,r26               
100125bc  7c7c182e    lwzx r3,r28,r3              
100125c0  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
100125c4  2c030000    cmpwi r3,0x0                
100125c8  40820044    bne 0x1001260c                 ; -> 1001260c
100125cc  387e001e    addi r3,r30,0x1e            
100125d0  4801c129    bl 0x1002e6f8                  ; -> 1002e6f8
100125d4  60000000    ori r0,r0,0x0               
100125d8  7c630734    extsh r3,r3                 
100125dc  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100125e0  7c7a1b78    or r26,r3,r3                
100125e4  387f000a    addi r3,r31,0xa             
100125e8  4801c0e5    bl 0x1002e6cc                  ; -> 1002e6cc
100125ec  60000000    ori r0,r0,0x0               
100125f0  7c630734    extsh r3,r3                 
100125f4  1c63003c    mulli r3,r3,0x3c            
100125f8  7c63d214    add r3,r3,r26               
100125fc  7c7c182e    lwzx r3,r28,r3              
10012600  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10012604  2c030000    cmpwi r3,0x0                
10012608  41820018    beq 0x10012620                 ; -> 10012620
1001260c  7f650734    extsh r5,r27                
10012610  1ca50070    mulli r5,r5,0x70            
10012614  7cdd2aae    lhax r6,r29,r5              
10012618  38c60002    addi r6,r6,0x2              
1001261c  7cdd2b2e    sthx r6,r29,r5              
10012620  387e0007    addi r3,r30,0x7             
10012624  4801c0d5    bl 0x1002e6f8                  ; -> 1002e6f8
10012628  60000000    ori r0,r0,0x0               
1001262c  7c630734    extsh r3,r3                 
10012630  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10012634  7c7a1b78    or r26,r3,r3                
10012638  387f0014    addi r3,r31,0x14            
1001263c  4801c091    bl 0x1002e6cc                  ; -> 1002e6cc
10012640  60000000    ori r0,r0,0x0               
10012644  7c630734    extsh r3,r3                 
10012648  1c63003c    mulli r3,r3,0x3c            
1001264c  7c63d214    add r3,r3,r26               
10012650  7c7c182e    lwzx r3,r28,r3              
10012654  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10012658  2c030000    cmpwi r3,0x0                
1001265c  40820044    bne 0x100126a0                 ; -> 100126a0
10012660  387e001e    addi r3,r30,0x1e            
10012664  4801c095    bl 0x1002e6f8                  ; -> 1002e6f8
10012668  60000000    ori r0,r0,0x0               
1001266c  7c630734    extsh r3,r3                 
10012670  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10012674  7c7a1b78    or r26,r3,r3                
10012678  387f0014    addi r3,r31,0x14            
1001267c  4801c051    bl 0x1002e6cc                  ; -> 1002e6cc
10012680  60000000    ori r0,r0,0x0               
10012684  7c630734    extsh r3,r3                 
10012688  1c63003c    mulli r3,r3,0x3c            
1001268c  7c63d214    add r3,r3,r26               
10012690  7c7c182e    lwzx r3,r28,r3              
10012694  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10012698  2c030000    cmpwi r3,0x0                
1001269c  41820018    beq 0x100126b4                 ; -> 100126b4
100126a0  7f670734    extsh r7,r27                
100126a4  1ce70070    mulli r7,r7,0x70            
100126a8  7d1d3aae    lhax r8,r29,r7              
100126ac  3908fffe    subi r8,r8,0x2              
100126b0  7d1d3b2e    sthx r8,r29,r7              
100126b4  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
100126b8  38210050    addi r1,r1,0x50             
100126bc  7c0803a6    mtspr LR,r0                 
100126c0  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
100126c4  4e800020    blr                         
