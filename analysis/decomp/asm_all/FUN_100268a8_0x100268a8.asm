; FUN_100268a8 @ 0x100268a8
100268a8  7c0802a6    mfspr r0,LR                 
100268ac  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100268b0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100268b4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
100268b8  90610068    stw r3,0x68(r1)                ; -> Stack[0x18]
100268bc  3c806d69    lis r4,0x6d69               
100268c0  3ca06b65    lis r5,0x6b65               
100268c4  80610068    lwz r3,0x68(r1)                ; -> Stack[0x18]
100268c8  38847373    addi r4,r4,0x7373           
100268cc  38a57977    addi r5,r5,0x7977           
100268d0  38c10040    addi r6,r1,0x40             
100268d4  38e10038    addi r7,r1,0x38             
100268d8  39000004    li r8,0x4                   
100268dc  3921003c    addi r9,r1,0x3c             
100268e0  4800b6c1    bl 0x10031fa0                  ; -> 10031fa0
100268e4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
100268e8  7c7f1b78    or r31,r3,r3                
100268ec  7fe30734    extsh r3,r31                
100268f0  2c03f95b    cmpwi r3,-0x6a5             
100268f4  4082000c    bne 0x10026900                 ; -> 10026900
100268f8  38600001    li r3,0x1                   
100268fc  48000008    b 0x10026904                   ; -> 10026904
10026900  38600000    li r3,0x0                   
10026904  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10026908  38210050    addi r1,r1,0x50             
1002690c  7c0803a6    mtspr LR,r0                 
10026910  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10026914  4e800020    blr                         
