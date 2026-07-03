; FUN_100238b4 @ 0x100238b4
100238b4  7c0802a6    mfspr r0,LR                 
100238b8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100238bc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100238c0  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
100238c4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100238c8  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
100238cc  7c7e1b78    or r30,r3,r3                
100238d0  3be2539c    addi r31,r2,0x539c          
100238d4  38610038    addi r3,r1,0x38             
100238d8  4800d8d1    bl 0x100311a8                  ; -> 100311a8
100238dc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
100238e0  38827530    addi r4,r2,0x7530           
100238e4  80640000    lwz r3,0x0(r4)              
100238e8  4800d8d9    bl 0x100311c0                  ; -> 100311c0
100238ec  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
100238f0  7fc50734    extsh r5,r30                
100238f4  1ca50014    mulli r5,r5,0x14            
100238f8  38a50008    addi r5,r5,0x8              
100238fc  7cbf28ae    lbzx r5,r31,r5              
10023900  28050000    cmplwi r5,0x0               
10023904  41820018    beq 0x1002391c                 ; -> 1002391c
10023908  7fc60734    extsh r6,r30                
1002390c  1cc60014    mulli r6,r6,0x14            
10023910  38c60010    addi r6,r6,0x10             
10023914  7fbf302e    lwzx r29,r31,r6             
10023918  48000014    b 0x1002392c                   ; -> 1002392c
1002391c  7fc70734    extsh r7,r30                
10023920  1ce70014    mulli r7,r7,0x14            
10023924  38e7000c    addi r7,r7,0xc              
10023928  7fbf382e    lwzx r29,r31,r7             
1002392c  7fc90734    extsh r9,r30                
10023930  7fca0734    extsh r10,r30               
10023934  7fcb0734    extsh r11,r30               
10023938  7fc80734    extsh r8,r30                
1002393c  1d290014    mulli r9,r9,0x14            
10023940  1d4a0014    mulli r10,r10,0x14          
10023944  1d6b0014    mulli r11,r11,0x14          
10023948  1d080014    mulli r8,r8,0x14            
1002394c  39290002    addi r9,r9,0x2              
10023950  394a0004    addi r10,r10,0x4            
10023954  396b0006    addi r11,r11,0x6            
10023958  7c9f42ae    lhax r4,r31,r8              
1002395c  7cbf4aae    lhax r5,r31,r9              
10023960  7cdf52ae    lhax r6,r31,r10             
10023964  7cff5aae    lhax r7,r31,r11             
10023968  3861003c    addi r3,r1,0x3c             
1002396c  4800e1cd    bl 0x10031b38                  ; -> 10031b38
10023970  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023974  3861003c    addi r3,r1,0x3c             
10023978  7fa4eb78    or r4,r29,r29               
1002397c  4800e33d    bl 0x10031cb8                  ; -> 10031cb8
10023980  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023984  80610038    lwz r3,0x38(r1)                ; -> Stack[-0x28]
10023988  4800d839    bl 0x100311c0                  ; -> 100311c0
1002398c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10023990  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10023994  38210060    addi r1,r1,0x60             
10023998  7c0803a6    mtspr LR,r0                 
1002399c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100239a0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100239a4  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100239a8  4e800020    blr                         
