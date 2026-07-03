; FUN_100186b8 @ 0x100186b8
100186b8  7c0802a6    mfspr r0,LR                 
100186bc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100186c0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100186c4  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100186c8  b061005a    sth r3,0x5a(r1)                ; -> Stack[0x1a]
100186cc  38624eda    addi r3,r2,0x4eda           
100186d0  88630000    lbz r3,0x0(r3)              
100186d4  28030000    cmplwi r3,0x0               
100186d8  41820050    beq 0x10018728                 ; -> 10018728
100186dc  38824ed8    addi r4,r2,0x4ed8           
100186e0  88840000    lbz r4,0x0(r4)              
100186e4  28040000    cmplwi r4,0x0               
100186e8  41820040    beq 0x10018728                 ; -> 10018728
100186ec  38a24ede    addi r5,r2,0x4ede           
100186f0  a8a50000    lha r5,0x0(r5)              
100186f4  2c050000    cmpwi r5,0x0                
100186f8  41820030    beq 0x10018728                 ; -> 10018728
100186fc  38c24edc    addi r6,r2,0x4edc           
10018700  39224ee4    addi r9,r2,0x4ee4           
10018704  a8c60000    lha r6,0x0(r6)              
10018708  a8e1005a    lha r7,0x5a(r1)                ; -> Stack[0x1a]
1001870c  39000100    li r8,0x100                 
10018710  7fe731d6    mullw r31,r7,r6             
10018714  7fff43d6    divw r31,r31,r8             
10018718  80690000    lwz r3,0x0(r9)              
1001871c  7fe4fb78    or r4,r31,r31               
10018720  480193b9    bl 0x10031ad8                  ; -> 10031ad8
10018724  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
10018728  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001872c  38210040    addi r1,r1,0x40             
10018730  7c0803a6    mtspr LR,r0                 
10018734  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10018738  4e800020    blr                         
