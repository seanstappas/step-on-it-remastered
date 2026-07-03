; FUN_1002d2d4 @ 0x1002d2d4
1002d2d4  7c0802a6    mfspr r0,LR                 
1002d2d8  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1002d2dc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002d2e0  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002d2e4  3b62758c    addi r27,r2,0x758c          
1002d2e8  7f63db78    or r3,r27,r27               
1002d2ec  48004edd    bl 0x100321c8                  ; -> 100321c8
1002d2f0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1002d2f4  3be00000    li r31,0x0                  
1002d2f8  4800006c    b 0x1002d364                   ; -> 1002d364
1002d2fc  7fe30734    extsh r3,r31                
1002d300  7c7d2e70    srawi r29,r3,0x5            
1002d304  7fbd0194    addze r29,r29               
1002d308  7fe40734    extsh r4,r31                
1002d30c  7c9e2e70    srawi r30,r4,0x5            
1002d310  7fde0194    addze r30,r30               
1002d314  57de2834    rlwinm r30,r30,0x5,0x0,0x1a 
1002d318  7fde2010    subfc r30,r30,r4            
1002d31c  7fc70734    extsh r7,r30                
1002d320  7ce71e70    srawi r7,r7,0x3             
1002d324  7ce70194    addze r7,r7                 
1002d328  54e72036    rlwinm r7,r7,0x4,0x0,0x1b   
1002d32c  57a8103a    rlwinm r8,r29,0x2,0x0,0x1d  
1002d330  7fc60734    extsh r6,r30                
1002d334  38e70007    addi r7,r7,0x7              
1002d338  3ca08000    lis r5,-0x8000              
1002d33c  7cc63850    subf r6,r6,r7               
1002d340  7d1b402e    lwzx r8,r27,r8              
1002d344  7cbc3430    srw r28,r5,r6               
1002d348  7f884038    and r8,r28,r8               
1002d34c  28080000    cmplwi r8,0x0               
1002d350  41820010    beq 0x1002d360                 ; -> 1002d360
1002d354  7fe90734    extsh r9,r31                
1002d358  5523402e    rlwinm r3,r9,0x8,0x0,0x17   
1002d35c  48000018    b 0x1002d374                   ; -> 1002d374
1002d360  3bff0001    addi r31,r31,0x1            
1002d364  7fea0734    extsh r10,r31               
1002d368  2c0a007f    cmpwi r10,0x7f              
1002d36c  4180ff90    blt 0x1002d2fc                 ; -> 1002d2fc
1002d370  3860ffff    li r3,-0x1                  
1002d374  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002d378  38210050    addi r1,r1,0x50             
1002d37c  7c0803a6    mtspr LR,r0                 
1002d380  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1002d384  4e800020    blr                         
