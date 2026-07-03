; .GetTempBuffer @ 0x1002f93c
1002f93c  7c0802a6    mfspr r0,LR                 
1002f940  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002f944  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002f948  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1002f94c  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1002f950  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002f954  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002f958  7c7f1b78    or r31,r3,r3                
1002f95c  7c9c2378    or r28,r4,r4                
1002f960  57ff002a    rlwinm r31,r31,0x0,0x0,0x15 
1002f964  2c1f0400    cmpwi r31,0x400             
1002f968  40800008    bge 0x1002f970                 ; -> 1002f970
1002f96c  3be00400    li r31,0x400                
1002f970  7fe3fb78    or r3,r31,r31               
1002f974  48001b1d    bl 0x10031490                  ; -> 10031490
1002f978  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1002f97c  7c7e1b78    or r30,r3,r3                
1002f980  281e0000    cmplwi r30,0x0              
1002f984  40820050    bne 0x1002f9d4                 ; -> 1002f9d4
1002f988  2c1f0400    cmpwi r31,0x400             
1002f98c  40810048    ble 0x1002f9d4                 ; -> 1002f9d4
1002f990  48001a41    bl 0x100313d0                  ; -> 100313d0
1002f994  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1002f998  38638000    subi r3,r3,0x8000           
1002f99c  547d002a    rlwinm r29,r3,0x0,0x0,0x15  
1002f9a0  48001b09    bl 0x100314a8                  ; -> 100314a8
1002f9a4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1002f9a8  547f002a    rlwinm r31,r3,0x0,0x0,0x15  
1002f9ac  7c1fe800    cmpw r31,r29                
1002f9b0  40810008    ble 0x1002f9b8                 ; -> 1002f9b8
1002f9b4  7fbfeb78    or r31,r29,r29              
1002f9b8  2c1f0000    cmpwi r31,0x0               
1002f9bc  40820008    bne 0x1002f9c4                 ; -> 1002f9c4
1002f9c0  3be00400    li r31,0x400                
1002f9c4  7fe3fb78    or r3,r31,r31               
1002f9c8  48001ac9    bl 0x10031490                  ; -> 10031490
1002f9cc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1002f9d0  7c7e1b78    or r30,r3,r3                
1002f9d4  281e0000    cmplwi r30,0x0              
1002f9d8  4182000c    beq 0x1002f9e4                 ; -> 1002f9e4
1002f9dc  93fc0000    stw r31,0x0(r28)            
1002f9e0  4800000c    b 0x1002f9ec                   ; -> 1002f9ec
1002f9e4  38600000    li r3,0x0                   
1002f9e8  907c0000    stw r3,0x0(r28)             
1002f9ec  7fc3f378    or r3,r30,r30               
1002f9f0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002f9f4  38210050    addi r1,r1,0x50             
1002f9f8  7c0803a6    mtspr LR,r0                 
1002f9fc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002fa00  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002fa04  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1002fa08  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1002fa0c  4e800020    blr                         
