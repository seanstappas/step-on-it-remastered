; FUN_10018918 @ 0x10018918
10018918  7c0802a6    mfspr r0,LR                 
1001891c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10018920  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10018924  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10018928  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1001892c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10018930  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10018934  7c7f1b78    or r31,r3,r3                
10018938  3bc00000    li r30,0x0                  
1001893c  7fe3fb78    or r3,r31,r31               
10018940  38800000    li r4,0x0                   
10018944  480195e5    bl 0x10031f28                  ; -> 10031f28
10018948  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001894c  7c7d1b78    or r29,r3,r3                
10018950  7fe3fb78    or r3,r31,r31               
10018954  480195ed    bl 0x10031f40                  ; -> 10031f40
10018958  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001895c  90610038    stw r3,0x38(r1)                ; -> Stack[-0x18]
10018960  7fe3fb78    or r3,r31,r31               
10018964  480195f5    bl 0x10031f58                  ; -> 10031f58
10018968  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001896c  7c7c1b78    or r28,r3,r3                
10018970  7fe3fb78    or r3,r31,r31               
10018974  7fa4eb78    or r4,r29,r29               
10018978  7f85e378    or r5,r28,r28               
1001897c  480195f5    bl 0x10031f70                  ; -> 10031f70
10018980  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10018984  7c7e1b78    or r30,r3,r3                
10018988  7fc3f378    or r3,r30,r30               
1001898c  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10018990  38210050    addi r1,r1,0x50             
10018994  7c0803a6    mtspr LR,r0                 
10018998  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001899c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100189a0  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100189a4  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
100189a8  4e800020    blr                         
