; FUN_1000c194 @ 0x1000c194
1000c194  7c0802a6    mfspr r0,LR                 
1000c198  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1000c19c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000c1a0  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000c1a4  90610068    stw r3,0x68(r1)                ; -> Stack[0x18]
1000c1a8  9081006c    stw r4,0x6c(r1)                ; -> Stack[0x1c]
1000c1ac  3b626bf8    addi r27,r2,0x6bf8          
1000c1b0  3b800000    li r28,0x0                  
1000c1b4  3ba00000    li r29,0x0                  
1000c1b8  4800006c    b 0x1000c224                   ; -> 1000c224
1000c1bc  38600013    li r3,0x13                  
1000c1c0  48000a21    bl 0x1000cbe0                  ; -> 1000cbe0
1000c1c4  60000000    ori r0,r0,0x0               
1000c1c8  7c7f1b78    or r31,r3,r3                
1000c1cc  38600003    li r3,0x3                   
1000c1d0  48000a11    bl 0x1000cbe0                  ; -> 1000cbe0
1000c1d4  60000000    ori r0,r0,0x0               
1000c1d8  7c7e1b78    or r30,r3,r3                
1000c1dc  7fe30734    extsh r3,r31                
1000c1e0  7fc40734    extsh r4,r30                
1000c1e4  1c63003c    mulli r3,r3,0x3c            
1000c1e8  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1000c1ec  7c632214    add r3,r3,r4                
1000c1f0  7c7b182e    lwzx r3,r27,r3              
1000c1f4  2c030000    cmpwi r3,0x0                
1000c1f8  40820028    bne 0x1000c220                 ; -> 1000c220
1000c1fc  7fe3fb78    or r3,r31,r31               
1000c200  7fc4f378    or r4,r30,r30               
1000c204  48000a4d    bl 0x1000cc50                  ; -> 1000cc50
1000c208  60000000    ori r0,r0,0x0               
1000c20c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000c210  28030000    cmplwi r3,0x0               
1000c214  4182000c    beq 0x1000c220                 ; -> 1000c220
1000c218  3ba00001    li r29,0x1                  
1000c21c  48000008    b 0x1000c224                   ; -> 1000c224
1000c220  3b9c0001    addi r28,r28,0x1            
1000c224  57a5063e    rlwinm r5,r29,0x0,0x18,0x1f 
1000c228  28050000    cmplwi r5,0x0               
1000c22c  40820010    bne 0x1000c23c                 ; -> 1000c23c
1000c230  7f860734    extsh r6,r28                
1000c234  2c06000a    cmpwi r6,0xa                
1000c238  4180ff84    blt 0x1000c1bc                 ; -> 1000c1bc
1000c23c  57a7063e    rlwinm r7,r29,0x0,0x18,0x1f 
1000c240  28070000    cmplwi r7,0x0               
1000c244  4182001c    beq 0x1000c260                 ; -> 1000c260
1000c248  81010068    lwz r8,0x68(r1)                ; -> Stack[0x18]
1000c24c  8121006c    lwz r9,0x6c(r1)                ; -> Stack[0x1c]
1000c250  b3e80000    sth r31,0x0(r8)             
1000c254  b3c90000    sth r30,0x0(r9)             
1000c258  38600001    li r3,0x1                   
1000c25c  48000008    b 0x1000c264                   ; -> 1000c264
1000c260  38600000    li r3,0x0                   
1000c264  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000c268  38210050    addi r1,r1,0x50             
1000c26c  7c0803a6    mtspr LR,r0                 
1000c270  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1000c274  4e800020    blr                         
