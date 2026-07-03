; FUN_1001a2c8 @ 0x1001a2c8
1001a2c8  7c0802a6    mfspr r0,LR                 
1001a2cc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001a2d0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001a2d4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001a2d8  7c7f1b78    or r31,r3,r3                
1001a2dc  7fe30734    extsh r3,r31                
1001a2e0  2c030007    cmpwi r3,0x7                
1001a2e4  41810010    bgt 0x1001a2f4                 ; -> 1001a2f4
1001a2e8  7fe40734    extsh r4,r31                
1001a2ec  2c040000    cmpwi r4,0x0                
1001a2f0  40800008    bge 0x1001a2f8                 ; -> 1001a2f8
1001a2f4  48000040    b 0x1001a334                   ; -> 1001a334
1001a2f8  38a0002b    li r5,0x2b                  
1001a2fc  1cdf0024    mulli r6,r31,0x24           
1001a300  b0a1003a    sth r5,0x3a(r1)                ; -> Stack[-0x16]
1001a304  b0c1003c    sth r6,0x3c(r1)                ; -> Stack[-0x14]
1001a308  38e00000    li r7,0x0                   
1001a30c  39024eec    addi r8,r2,0x4eec           
1001a310  90e1003e    stw r7,0x3e(r1)                ; -> Stack[-0x12]
1001a314  80680000    lwz r3,0x0(r8)              
1001a318  3881003a    addi r4,r1,0x3a             
1001a31c  48017685    bl 0x100319a0                  ; -> 100319a0
1001a320  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001a324  39424f4c    addi r10,r2,0x4f4c          
1001a328  7fe90734    extsh r9,r31                
1001a32c  b0610038    sth r3,0x38(r1)                ; -> Stack[-0x18]
1001a330  912a0000    stw r9,0x0(r10)             
1001a334  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001a338  38210050    addi r1,r1,0x50             
1001a33c  7c0803a6    mtspr LR,r0                 
1001a340  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001a344  4e800020    blr                         
