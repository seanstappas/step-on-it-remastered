; FUN_1001b994 @ 0x1001b994
1001b994  7c0802a6    mfspr r0,LR                 
1001b998  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001b99c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001b9a0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001b9a4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001b9a8  7c7e1b78    or r30,r3,r3                
1001b9ac  a07e000e    lhz r3,0xe(r30)             
1001b9b0  83fe0002    lwz r31,0x2(r30)            
1001b9b4  546307fe    rlwinm r3,r3,0x0,0x1f,0x1f  
1001b9b8  2c030000    cmpwi r3,0x0                
1001b9bc  7c800026    mfcr r4                     
1001b9c0  54841ffe    rlwinm r4,r4,0x3,0x1f,0x1f  
1001b9c4  68840001    xori r4,r4,0x1              
1001b9c8  98810038    stb r4,0x38(r1)                ; -> Stack[-0x18]
1001b9cc  7fe3fb78    or r3,r31,r31               
1001b9d0  48003351    bl 0x1001ed20                  ; -> 1001ed20
1001b9d4  60000000    ori r0,r0,0x0               
1001b9d8  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001b9dc  38210050    addi r1,r1,0x50             
1001b9e0  7c0803a6    mtspr LR,r0                 
1001b9e4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001b9e8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001b9ec  4e800020    blr                         
