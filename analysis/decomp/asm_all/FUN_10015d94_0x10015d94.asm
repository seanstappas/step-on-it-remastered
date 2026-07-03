; FUN_10015d94 @ 0x10015d94
10015d94  7c0802a6    mfspr r0,LR                 
10015d98  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
10015d9c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10015da0  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
10015da4  90610088    stw r3,0x88(r1)                ; -> Stack[0x18]
10015da8  7c9b2378    or r27,r4,r4                
10015dac  7cbc2b78    or r28,r5,r5                
10015db0  3ba26bb8    addi r29,r2,0x6bb8          
10015db4  80610088    lwz r3,0x88(r1)                ; -> Stack[0x18]
10015db8  3bc00000    li r30,0x0                  
10015dbc  38810038    addi r4,r1,0x38             
10015dc0  48015b41    bl 0x1002b900                  ; -> 1002b900
10015dc4  60000000    ori r0,r0,0x0               
10015dc8  3be00009    li r31,0x9                  
10015dcc  480000a4    b 0x10015e70                   ; -> 10015e70
10015dd0  7fe30734    extsh r3,r31                
10015dd4  2c030000    cmpwi r3,0x0                
10015dd8  40820008    bne 0x10015de0                 ; -> 10015de0
10015ddc  3bc00001    li r30,0x1                  
10015de0  7fe40734    extsh r4,r31                
10015de4  5484083c    rlwinm r4,r4,0x1,0x0,0x1e   
10015de8  38a10038    addi r5,r1,0x38             
10015dec  7ca522ae    lhax r5,r5,r4               
10015df0  2c050000    cmpwi r5,0x0                
10015df4  40820044    bne 0x10015e38                 ; -> 10015e38
10015df8  57c6063e    rlwinm r6,r30,0x0,0x18,0x1f 
10015dfc  28060000    cmplwi r6,0x0               
10015e00  4182006c    beq 0x10015e6c                 ; -> 10015e6c
10015e04  7fe70734    extsh r7,r31                
10015e08  393f0001    addi r9,r31,0x1             
10015e0c  55291838    rlwinm r9,r9,0x3,0x0,0x1c   
10015e10  54e7083c    rlwinm r7,r7,0x1,0x0,0x1e   
10015e14  39010038    addi r8,r1,0x38             
10015e18  7d083aae    lhax r8,r8,r7               
10015e1c  807d0000    lwz r3,0x0(r29)             
10015e20  38880005    addi r4,r8,0x5              
10015e24  7ca9d850    subf r5,r9,r27              
10015e28  7f86e378    or r6,r28,r28               
10015e2c  4bfeed89    bl 0x10004bb4                  ; -> 10004bb4
10015e30  60000000    ori r0,r0,0x0               
10015e34  48000038    b 0x10015e6c                   ; -> 10015e6c
10015e38  7fea0734    extsh r10,r31               
10015e3c  399f0001    addi r12,r31,0x1            
10015e40  558c1838    rlwinm r12,r12,0x3,0x0,0x1c 
10015e44  554a083c    rlwinm r10,r10,0x1,0x0,0x1e 
10015e48  39610038    addi r11,r1,0x38            
10015e4c  7d6b52ae    lhax r11,r11,r10            
10015e50  807d0000    lwz r3,0x0(r29)             
10015e54  3bc00001    li r30,0x1                  
10015e58  388b0005    addi r4,r11,0x5             
10015e5c  7cacd850    subf r5,r12,r27             
10015e60  7f86e378    or r6,r28,r28               
10015e64  4bfeed51    bl 0x10004bb4                  ; -> 10004bb4
10015e68  60000000    ori r0,r0,0x0               
10015e6c  3bffffff    subi r31,r31,0x1            
10015e70  7fe30734    extsh r3,r31                
10015e74  2c030000    cmpwi r3,0x0                
10015e78  4080ff58    bge 0x10015dd0                 ; -> 10015dd0
10015e7c  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
10015e80  38210070    addi r1,r1,0x70             
10015e84  7c0803a6    mtspr LR,r0                 
10015e88  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10015e8c  4e800020    blr                         
