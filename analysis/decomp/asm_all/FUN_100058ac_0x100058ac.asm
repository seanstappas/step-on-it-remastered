; FUN_100058ac @ 0x100058ac
100058ac  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100058b0  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100058b4  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
100058b8  388261fa    addi r4,r2,0x61fa           
100058bc  38600000    li r3,0x0                   
100058c0  38c261f8    addi r6,r2,0x61f8           
100058c4  3bc23cd8    addi r30,r2,0x3cd8          
100058c8  b0640000    sth r3,0x0(r4)              
100058cc  38a00001    li r5,0x1                   
100058d0  3ba23be8    addi r29,r2,0x3be8          
100058d4  b0a60000    sth r5,0x0(r6)              
100058d8  38e00000    li r7,0x0                   
100058dc  b0fe10a6    sth r7,0x10a6(r30)          
100058e0  3be00001    li r31,0x1                  
100058e4  48000048    b 0x1000592c                   ; -> 1000592c
100058e8  7fe80734    extsh r8,r31                
100058ec  1d080046    mulli r8,r8,0x46            
100058f0  7feb0734    extsh r11,r31               
100058f4  1d6b0046    mulli r11,r11,0x46          
100058f8  7fe30734    extsh r3,r31                
100058fc  39080036    addi r8,r8,0x36             
10005900  7fe90734    extsh r9,r31                
10005904  1c630046    mulli r3,r3,0x46            
10005908  7d1e4214    add r8,r30,r8               
1000590c  5529103a    rlwinm r9,r9,0x2,0x0,0x1d   
10005910  7d1d492e    stwx r8,r29,r9              
10005914  395f0001    addi r10,r31,0x1            
10005918  396b003e    addi r11,r11,0x3e           
1000591c  399fffff    subi r12,r31,0x1            
10005920  7d5e5b2e    sthx r10,r30,r11            
10005924  7d9e1b2e    sthx r12,r30,r3             
10005928  3bff0001    addi r31,r31,0x1            
1000592c  7fe40734    extsh r4,r31                
10005930  2c04003c    cmpwi r4,0x3c               
10005934  4180ffb4    blt 0x100058e8                 ; -> 100058e8
10005938  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000593c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10005940  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10005944  4e800020    blr                         
