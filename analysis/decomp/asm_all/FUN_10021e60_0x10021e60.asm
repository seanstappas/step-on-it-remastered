; FUN_10021e60 @ 0x10021e60
10021e60  7c0802a6    mfspr r0,LR                 
10021e64  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
10021e68  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10021e6c  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10021e70  7c7b1b78    or r27,r3,r3                
10021e74  38625324    addi r3,r2,0x5324           
10021e78  3ba2756c    addi r29,r2,0x756c          
10021e7c  88630000    lbz r3,0x0(r3)              
10021e80  3bc25328    addi r30,r2,0x5328          
10021e84  28030000    cmplwi r3,0x0               
10021e88  4182001c    beq 0x10021ea4                 ; -> 10021ea4
10021e8c  809e0000    lwz r4,0x0(r30)             
10021e90  807e0000    lwz r3,0x0(r30)             
10021e94  80840000    lwz r4,0x0(r4)              
10021e98  83840000    lwz r28,0x0(r4)             
10021e9c  4800f1bd    bl 0x10031058                  ; -> 10031058
10021ea0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021ea4  93610038    stw r27,0x38(r1)               ; -> Stack[-0x28]
10021ea8  38610038    addi r3,r1,0x38             
10021eac  4800f135    bl 0x10030fe0                  ; -> 10030fe0
10021eb0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021eb4  937e0000    stw r27,0x0(r30)            
10021eb8  7fc3f378    or r3,r30,r30               
10021ebc  4800f125    bl 0x10030fe0                  ; -> 10030fe0
10021ec0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021ec4  807e0000    lwz r3,0x0(r30)             
10021ec8  4800f8e1    bl 0x100317a8                  ; -> 100317a8
10021ecc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021ed0  807e0000    lwz r3,0x0(r30)             
10021ed4  4800f125    bl 0x10030ff8                  ; -> 10030ff8
10021ed8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021edc  80be0000    lwz r5,0x0(r30)             
10021ee0  3be00000    li r31,0x0                  
10021ee4  80a50000    lwz r5,0x0(r5)              
10021ee8  93850000    stw r28,0x0(r5)             
10021eec  48000020    b 0x10021f0c                   ; -> 10021f0c
10021ef0  80de0000    lwz r6,0x0(r30)             
10021ef4  7fe70734    extsh r7,r31                
10021ef8  80c60000    lwz r6,0x0(r6)              
10021efc  54e71838    rlwinm r7,r7,0x3,0x0,0x1c   
10021f00  38c60008    addi r6,r6,0x8              
10021f04  7fe63b2e    sthx r31,r6,r7              
10021f08  3bff0001    addi r31,r31,0x1            
10021f0c  813e0000    lwz r9,0x0(r30)             
10021f10  7fe80734    extsh r8,r31                
10021f14  81290000    lwz r9,0x0(r9)              
10021f18  a9290006    lha r9,0x6(r9)              
10021f1c  7c084800    cmpw r8,r9                  
10021f20  4081ffd0    ble 0x10021ef0                 ; -> 10021ef0
10021f24  807e0000    lwz r3,0x0(r30)             
10021f28  4800f0e9    bl 0x10031010                  ; -> 10031010
10021f2c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021f30  815d0000    lwz r10,0x0(r29)            
10021f34  81610038    lwz r11,0x38(r1)               ; -> Stack[-0x28]
10021f38  814a0000    lwz r10,0x0(r10)            
10021f3c  816b0000    lwz r11,0x0(r11)            
10021f40  814a0016    lwz r10,0x16(r10)           
10021f44  814a0000    lwz r10,0x0(r10)            
10021f48  814a002a    lwz r10,0x2a(r10)           
10021f4c  814a0000    lwz r10,0x0(r10)            
10021f50  814a0000    lwz r10,0x0(r10)            
10021f54  914b0000    stw r10,0x0(r11)            
10021f58  819d0000    lwz r12,0x0(r29)            
10021f5c  818c0000    lwz r12,0x0(r12)            
10021f60  818c0016    lwz r12,0x16(r12)           
10021f64  818c0000    lwz r12,0x0(r12)            
10021f68  806c002a    lwz r3,0x2a(r12)            
10021f6c  4800f0ed    bl 0x10031058                  ; -> 10031058
10021f70  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021f74  809d0000    lwz r4,0x0(r29)             
10021f78  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x28]
10021f7c  80840000    lwz r4,0x0(r4)              
10021f80  80840016    lwz r4,0x16(r4)             
10021f84  80840000    lwz r4,0x0(r4)              
10021f88  9064002a    stw r3,0x2a(r4)             
10021f8c  80bd0000    lwz r5,0x0(r29)             
10021f90  80dd0000    lwz r6,0x0(r29)             
10021f94  80a50000    lwz r5,0x0(r5)              
10021f98  80fd0000    lwz r7,0x0(r29)             
10021f9c  80a50016    lwz r5,0x16(r5)             
10021fa0  80c60000    lwz r6,0x0(r6)              
10021fa4  80a50000    lwz r5,0x0(r5)              
10021fa8  80e70000    lwz r7,0x0(r7)              
10021fac  8065002a    lwz r3,0x2a(r5)             
10021fb0  80860006    lwz r4,0x6(r6)              
10021fb4  a8a7000a    lha r5,0xa(r7)              
10021fb8  4800f0b9    bl 0x10031070                  ; -> 10031070
10021fbc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021fc0  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10021fc4  38210060    addi r1,r1,0x60             
10021fc8  7c0803a6    mtspr LR,r0                 
10021fcc  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10021fd0  4e800020    blr                         
