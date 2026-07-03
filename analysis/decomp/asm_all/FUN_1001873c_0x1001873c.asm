; FUN_1001873c @ 0x1001873c
1001873c  7c0802a6    mfspr r0,LR                 
10018740  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10018744  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10018748  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1001874c  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10018750  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10018754  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10018758  7c7c1b78    or r28,r3,r3                
1001875c  38624eda    addi r3,r2,0x4eda           
10018760  88630000    lbz r3,0x0(r3)              
10018764  28030000    cmplwi r3,0x0               
10018768  418200a4    beq 0x1001880c                 ; -> 1001880c
1001876c  38824ede    addi r4,r2,0x4ede           
10018770  a8840000    lha r4,0x0(r4)              
10018774  2c040000    cmpwi r4,0x0                
10018778  41820094    beq 0x1001880c                 ; -> 1001880c
1001877c  38a24ed8    addi r5,r2,0x4ed8           
10018780  88a50000    lbz r5,0x0(r5)              
10018784  28050000    cmplwi r5,0x0               
10018788  41820084    beq 0x1001880c                 ; -> 1001880c
1001878c  7f860734    extsh r6,r28                
10018790  2c0600ff    cmpwi r6,0xff               
10018794  40810008    ble 0x1001879c                 ; -> 1001879c
10018798  3b8000ff    li r28,0xff                 
1001879c  4801882d    bl 0x10030fc8                  ; -> 10030fc8
100187a0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
100187a4  7c7f1b78    or r31,r3,r3                
100187a8  7f9ee378    or r30,r28,r28              
100187ac  48000040    b 0x100187ec                   ; -> 100187ec
100187b0  7fc70734    extsh r7,r30                
100187b4  1ce700ff    mulli r7,r7,0xff            
100187b8  7f880734    extsh r8,r28                
100187bc  7fa743d6    divw r29,r7,r8              
100187c0  7fa3eb78    or r3,r29,r29               
100187c4  4bfffef5    bl 0x100186b8                  ; -> 100186b8
100187c8  48000004    b 0x100187cc                   ; -> 100187cc
100187cc  480187fd    bl 0x10030fc8                  ; -> 10030fc8
100187d0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
100187d4  7c1f1840    cmplw r31,r3                
100187d8  4182fff4    beq 0x100187cc                 ; -> 100187cc
100187dc  480187ed    bl 0x10030fc8                  ; -> 10030fc8
100187e0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
100187e4  7c7f1b78    or r31,r3,r3                
100187e8  3bdeffff    subi r30,r30,0x1            
100187ec  7fc90734    extsh r9,r30                
100187f0  2c090000    cmpwi r9,0x0                
100187f4  4181ffbc    bgt 0x100187b0                 ; -> 100187b0
100187f8  480001b5    bl 0x100189ac                  ; -> 100189ac
100187fc  60000000    ori r0,r0,0x0               
10018800  39624ed8    addi r11,r2,0x4ed8          
10018804  39400000    li r10,0x0                  
10018808  994b0000    stb r10,0x0(r11)            
1001880c  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10018810  38210050    addi r1,r1,0x50             
10018814  7c0803a6    mtspr LR,r0                 
10018818  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001881c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10018820  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10018824  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10018828  4e800020    blr                         
