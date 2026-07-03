; FUN_10023e70 @ 0x10023e70
10023e70  7c0802a6    mfspr r0,LR                 
10023e74  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
10023e78  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10023e7c  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10023e80  38625330    addi r3,r2,0x5330           
10023e84  3b825358    addi r28,r2,0x5358          
10023e88  a8830000    lha r4,0x0(r3)              
10023e8c  3bc2535a    addi r30,r2,0x535a          
10023e90  38840001    addi r4,r4,0x1              
10023e94  b0830000    sth r4,0x0(r3)              
10023e98  3ba25608    addi r29,r2,0x5608          
10023e9c  3be270ec    addi r31,r2,0x70ec          
10023ea0  38610038    addi r3,r1,0x38             
10023ea4  4800d305    bl 0x100311a8                  ; -> 100311a8
10023ea8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023eac  38a27530    addi r5,r2,0x7530           
10023eb0  80650000    lwz r3,0x0(r5)              
10023eb4  4800d30d    bl 0x100311c0                  ; -> 100311c0
10023eb8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023ebc  39225356    addi r9,r2,0x5356           
10023ec0  38e25330    addi r7,r2,0x5330           
10023ec4  a97e0000    lha r11,0x0(r30)            
10023ec8  a99c0000    lha r12,0x0(r28)            
10023ecc  a91e0000    lha r8,0x0(r30)             
10023ed0  a9290000    lha r9,0x0(r9)              
10023ed4  a8e70000    lha r7,0x0(r7)              
10023ed8  7d084850    subf r8,r8,r9               
10023edc  7ce839d6    mullw r7,r8,r7              
10023ee0  3940003e    li r10,0x3e                 
10023ee4  39025354    addi r8,r2,0x5354           
10023ee8  7ce753d6    divw r7,r7,r10              
10023eec  a8de0000    lha r6,0x0(r30)             
10023ef0  a9080000    lha r8,0x0(r8)              
10023ef4  7f663a14    add r27,r6,r7               
10023ef8  3861003c    addi r3,r1,0x3c             
10023efc  388b0001    addi r4,r11,0x1             
10023f00  38ac0001    addi r5,r12,0x1             
10023f04  38dbffff    subi r6,r27,0x1             
10023f08  38e8ffff    subi r7,r8,0x1              
10023f0c  4800dc2d    bl 0x10031b38                  ; -> 10031b38
10023f10  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023f14  39200000    li r9,0x0                   
10023f18  3d600001    lis r11,0x1                 
10023f1c  b13f0004    sth r9,0x4(r31)             
10023f20  39400000    li r10,0x0                  
10023f24  b15f0002    sth r10,0x2(r31)            
10023f28  396b9c40    subi r11,r11,0x63c0         
10023f2c  b17f0000    sth r11,0x0(r31)            
10023f30  7fe3fb78    or r3,r31,r31               
10023f34  4800dc65    bl 0x10031b98                  ; -> 10031b98
10023f38  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023f3c  3861003c    addi r3,r1,0x3c             
10023f40  4800dc71    bl 0x10031bb0                  ; -> 10031bb0
10023f44  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023f48  a8dc0000    lha r6,0x0(r28)             
10023f4c  a99e0000    lha r12,0x0(r30)            
10023f50  a8fe0000    lha r7,0x0(r30)             
10023f54  38a6001a    addi r5,r6,0x1a             
10023f58  a91c0000    lha r8,0x0(r28)             
10023f5c  38c700c8    addi r6,r7,0xc8             
10023f60  3861003c    addi r3,r1,0x3c             
10023f64  388cffba    subi r4,r12,0x46            
10023f68  38e80024    addi r7,r8,0x24             
10023f6c  4800dbcd    bl 0x10031b38                  ; -> 10031b38
10023f70  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023f74  39207777    li r9,0x7777                
10023f78  b13d0004    sth r9,0x4(r29)             
10023f7c  b13d0002    sth r9,0x2(r29)             
10023f80  b13d0000    sth r9,0x0(r29)             
10023f84  7fa3eb78    or r3,r29,r29               
10023f88  4800dc11    bl 0x10031b98                  ; -> 10031b98
10023f8c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023f90  3861003c    addi r3,r1,0x3c             
10023f94  4800dc1d    bl 0x10031bb0                  ; -> 10031bb0
10023f98  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023f9c  39400000    li r10,0x0                  
10023fa0  b15f0004    sth r10,0x4(r31)            
10023fa4  39600000    li r11,0x0                  
10023fa8  b17f0002    sth r11,0x2(r31)            
10023fac  39800000    li r12,0x0                  
10023fb0  b19f0000    sth r12,0x0(r31)            
10023fb4  7fe3fb78    or r3,r31,r31               
10023fb8  4800dbe1    bl 0x10031b98                  ; -> 10031b98
10023fbc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023fc0  a89e0000    lha r4,0x0(r30)             
10023fc4  a8bc0000    lha r5,0x0(r28)             
10023fc8  3864ffba    subi r3,r4,0x46             
10023fcc  38850022    addi r4,r5,0x22             
10023fd0  4800dc29    bl 0x10031bf8                  ; -> 10031bf8
10023fd4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023fd8  3860000a    li r3,0xa                   
10023fdc  4800dc35    bl 0x10031c10                  ; -> 10031c10
10023fe0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023fe4  38600000    li r3,0x0                   
10023fe8  4800dc41    bl 0x10031c28                  ; -> 10031c28
10023fec  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023ff0  38600014    li r3,0x14                  
10023ff4  4800dc4d    bl 0x10031c40                  ; -> 10031c40
10023ff8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023ffc  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x28]
10024000  4800d1c1    bl 0x100311c0                  ; -> 100311c0
10024004  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10024008  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1002400c  38210060    addi r1,r1,0x60             
10024010  7c0803a6    mtspr LR,r0                 
10024014  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10024018  4e800020    blr                         
