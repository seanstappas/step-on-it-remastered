; FUN_1000554c @ 0x1000554c
1000554c  7c0802a6    mfspr r0,LR                 
10005550  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10005554  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10005558  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1000555c  b061005a    sth r3,0x5a(r1)                ; -> Stack[0x1a]
10005560  b081005e    sth r4,0x5e(r1)                ; -> Stack[0x1e]
10005564  a861005e    lha r3,0x5e(r1)                ; -> Stack[0x1e]
10005568  48029191    bl 0x1002e6f8                  ; -> 1002e6f8
1000556c  60000000    ori r0,r0,0x0               
10005570  7c630734    extsh r3,r3                 
10005574  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10005578  7c7f1b78    or r31,r3,r3                
1000557c  a861005a    lha r3,0x5a(r1)                ; -> Stack[0x1a]
10005580  4802914d    bl 0x1002e6cc                  ; -> 1002e6cc
10005584  60000000    ori r0,r0,0x0               
10005588  7c630734    extsh r3,r3                 
1000558c  1c63003c    mulli r3,r3,0x3c            
10005590  38826bf8    addi r4,r2,0x6bf8           
10005594  7c63fa14    add r3,r3,r31               
10005598  7c84182e    lwzx r4,r4,r3               
1000559c  548405ac    rlwinm r4,r4,0x0,0x16,0x16  
100055a0  2c040000    cmpwi r4,0x0                
100055a4  4182000c    beq 0x100055b0                 ; -> 100055b0
100055a8  38600001    li r3,0x1                   
100055ac  48000008    b 0x100055b4                   ; -> 100055b4
100055b0  38600000    li r3,0x0                   
100055b4  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
100055b8  38210040    addi r1,r1,0x40             
100055bc  7c0803a6    mtspr LR,r0                 
100055c0  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100055c4  4e800020    blr                         
