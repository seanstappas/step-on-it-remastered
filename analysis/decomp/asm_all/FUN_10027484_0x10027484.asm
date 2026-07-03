; FUN_10027484 @ 0x10027484
10027484  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10027488  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002748c  388261fe    addi r4,r2,0x61fe           
10027490  38600000    li r3,0x0                   
10027494  38c261fc    addi r6,r2,0x61fc           
10027498  3bc262a0    addi r30,r2,0x62a0          
1002749c  b0640000    sth r3,0x0(r4)              
100274a0  38a0ffff    li r5,-0x1                  
100274a4  b0a60000    sth r5,0x0(r6)              
100274a8  3be00000    li r31,0x0                  
100274ac  4800001c    b 0x100274c8                   ; -> 100274c8
100274b0  7fe80734    extsh r8,r31                
100274b4  1d080018    mulli r8,r8,0x18            
100274b8  38ff0001    addi r7,r31,0x1             
100274bc  39080016    addi r8,r8,0x16             
100274c0  7cfe432e    sthx r7,r30,r8              
100274c4  3bff0001    addi r31,r31,0x1            
100274c8  7fe90734    extsh r9,r31                
100274cc  2c09003c    cmpwi r9,0x3c               
100274d0  4180ffe0    blt 0x100274b0                 ; -> 100274b0
100274d4  3940ffff    li r10,-0x1                 
100274d8  b15e059e    sth r10,0x59e(r30)          
100274dc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100274e0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100274e4  4e800020    blr                         
