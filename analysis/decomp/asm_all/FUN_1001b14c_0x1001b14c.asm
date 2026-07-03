; FUN_1001b14c @ 0x1001b14c
1001b14c  7c0802a6    mfspr r0,LR                 
1001b150  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001b154  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001b158  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001b15c  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1001b160  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001b164  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001b168  7c7f1b78    or r31,r3,r3                
1001b16c  7fe30734    extsh r3,r31                
1001b170  54630528    rlwinm r3,r3,0x0,0x14,0x14  
1001b174  2c030000    cmpwi r3,0x0                
1001b178  4081000c    ble 0x1001b184                 ; -> 1001b184
1001b17c  3bc00001    li r30,0x1                  
1001b180  48000008    b 0x1001b188                   ; -> 1001b188
1001b184  3bc00000    li r30,0x0                  
1001b188  7fc40774    extsb r4,r30                
1001b18c  2c040001    cmpwi r4,0x1                
1001b190  40820054    bne 0x1001b1e4                 ; -> 1001b1e4
1001b194  57ff057e    rlwinm r31,r31,0x0,0x15,0x1f
1001b198  3860aa6e    li r3,-0x5592               
1001b19c  38800001    li r4,0x1                   
1001b1a0  48015fd9    bl 0x10031178                  ; -> 10031178
1001b1a4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001b1a8  7c7c1b78    or r28,r3,r3                
1001b1ac  3860a86e    li r3,-0x5792               
1001b1b0  38800001    li r4,0x1                   
1001b1b4  48015fc5    bl 0x10031178                  ; -> 10031178
1001b1b8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001b1bc  7c03e040    cmplw r3,r28                
1001b1c0  4082000c    bne 0x1001b1cc                 ; -> 1001b1cc
1001b1c4  3ba00200    li r29,0x200                
1001b1c8  48000008    b 0x1001b1d0                   ; -> 1001b1d0
1001b1cc  3ba00400    li r29,0x400                
1001b1d0  7fe50734    extsh r5,r31                
1001b1d4  7fa60734    extsh r6,r29                
1001b1d8  7c053000    cmpw r5,r6                  
1001b1dc  41800008    blt 0x1001b1e4                 ; -> 1001b1e4
1001b1e0  3be0a89f    li r31,-0x5761              
1001b1e4  3860a89f    li r3,-0x5761               
1001b1e8  38800001    li r4,0x1                   
1001b1ec  48015f8d    bl 0x10031178                  ; -> 10031178
1001b1f0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001b1f4  7c7c1b78    or r28,r3,r3                
1001b1f8  7fe3fb78    or r3,r31,r31               
1001b1fc  7fc4f378    or r4,r30,r30               
1001b200  48015f79    bl 0x10031178                  ; -> 10031178
1001b204  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001b208  7c03e040    cmplw r3,r28                
1001b20c  7ce00026    mfcr r7                     
1001b210  54e71ffe    rlwinm r7,r7,0x3,0x1f,0x1f  
1001b214  68e30001    xori r3,r7,0x1              
1001b218  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001b21c  38210050    addi r1,r1,0x50             
1001b220  7c0803a6    mtspr LR,r0                 
1001b224  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001b228  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001b22c  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001b230  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1001b234  4e800020    blr                         
