; FUN_100015c0 @ 0x100015c0
100015c0  7c0802a6    mfspr r0,LR                 
100015c4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100015c8  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100015cc  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
100015d0  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
100015d4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100015d8  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
100015dc  7cdc3378    or r28,r6,r6                
100015e0  b0a10072    sth r5,0x72(r1)                ; -> Stack[0x22]
100015e4  7c850734    extsh r5,r4                 
100015e8  2c050001    cmpwi r5,0x1                
100015ec  3bc26bd0    addi r30,r2,0x6bd0          
100015f0  3be270e4    addi r31,r2,0x70e4          
100015f4  80c30000    lwz r6,0x0(r3)              
100015f8  4180010c    blt 0x10001704                 ; -> 10001704
100015fc  a8060000    lha r0,0x0(r6)              
10001600  7c050000    cmpw r5,r0                  
10001604  40810008    ble 0x1000160c                 ; -> 1000160c
10001608  480000fc    b 0x10001704                   ; -> 10001704
1000160c  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
10001610  38050008    addi r0,r5,0x8              
10001614  7c06002e    lwzx r0,r6,r0               
10001618  38a10072    addi r5,r1,0x72             
1000161c  7fa60214    add r29,r6,r0               
10001620  38c10038    addi r6,r1,0x38             
10001624  4bfffd25    bl 0x10001348                  ; -> 10001348
10001628  a81d0000    lha r0,0x0(r29)             
1000162c  38a00004    li r5,0x4                   
10001630  81610038    lwz r11,0x38(r1)               ; -> Stack[-0x18]
10001634  390270e8    addi r8,r2,0x70e8           
10001638  38826bd4    addi r4,r2,0x6bd4           
1000163c  814b0004    lwz r10,0x4(r11)            
10001640  80df0000    lwz r6,0x0(r31)             
10001644  7c090734    extsh r9,r0                 
10001648  a87e0000    lha r3,0x0(r30)             
1000164c  7f870734    extsh r7,r28                
10001650  7d893050    subf r12,r9,r6              
10001654  7f891850    subf r28,r9,r3              
10001658  7ca00734    extsh r0,r5                 
1000165c  7d8c2bd6    divw r12,r12,r5             
10001660  7f9c2bd6    divw r28,r28,r5             
10001664  7c0903d6    divw r0,r9,r0               
10001668  7cc639d6    mullw r6,r6,r7              
1000166c  a8a10072    lha r5,0x72(r1)                ; -> Stack[0x22]
10001670  7c6719d6    mullw r3,r7,r3              
10001674  80e80000    lwz r7,0x0(r8)              
10001678  7cc62a14    add r6,r6,r5                
1000167c  80840000    lwz r4,0x0(r4)              
10001680  7d032a14    add r8,r3,r5                
10001684  a93d0002    lha r9,0x2(r29)             
10001688  7cab5214    add r5,r11,r10              
1000168c  7cc73214    add r6,r7,r6                
10001690  7d044214    add r8,r4,r8                
10001694  3960ffff    li r11,-0x1                 
10001698  48000064    b 0x100016fc                   ; -> 100016fc
1000169c  80e50000    lwz r7,0x0(r5)              
100016a0  39400000    li r10,0x0                  
100016a4  38a50004    addi r5,r5,0x4              
100016a8  48000030    b 0x100016d8                   ; -> 100016d8
100016ac  54e307ff    rlwinm. r3,r7,0x0,0x1f,0x1f 
100016b0  41820018    beq 0x100016c8                 ; -> 100016c8
100016b4  91660000    stw r11,0x0(r6)             
100016b8  91680000    stw r11,0x0(r8)             
100016bc  38c60004    addi r6,r6,0x4              
100016c0  39080004    addi r8,r8,0x4              
100016c4  4800000c    b 0x100016d0                   ; -> 100016d0
100016c8  39080004    addi r8,r8,0x4              
100016cc  38c60004    addi r6,r6,0x4              
100016d0  7ce70e70    srawi r7,r7,0x1             
100016d4  394a0001    addi r10,r10,0x1            
100016d8  7d440734    extsh r4,r10                
100016dc  7c030734    extsh r3,r0                 
100016e0  7c041800    cmpw r4,r3                  
100016e4  4180ffc8    blt 0x100016ac                 ; -> 100016ac
100016e8  5784103a    rlwinm r4,r28,0x2,0x0,0x1d  
100016ec  5583103a    rlwinm r3,r12,0x2,0x0,0x1d  
100016f0  7d082214    add r8,r8,r4                
100016f4  7cc61a14    add r6,r6,r3                
100016f8  3929ffff    subi r9,r9,0x1              
100016fc  7d230735    extsh. r3,r9                
10001700  4181ff9c    bgt 0x1000169c                 ; -> 1000169c
10001704  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10001708  38210050    addi r1,r1,0x50             
1000170c  7c0803a6    mtspr LR,r0                 
10001710  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10001714  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10001718  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000171c  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10001720  4e800020    blr                         
