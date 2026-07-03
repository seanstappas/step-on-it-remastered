; FUN_100274e8 @ 0x100274e8
100274e8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100274ec  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100274f0  38826bea    addi r4,r2,0x6bea           
100274f4  38600000    li r3,0x0                   
100274f8  38c26be8    addi r6,r2,0x6be8           
100274fc  3bc26200    addi r30,r2,0x6200          
10027500  b0640000    sth r3,0x0(r4)              
10027504  38a0ffff    li r5,-0x1                  
10027508  b0a60000    sth r5,0x0(r6)              
1002750c  3be00000    li r31,0x0                  
10027510  4800001c    b 0x1002752c                   ; -> 1002752c
10027514  7fe80734    extsh r8,r31                
10027518  55082036    rlwinm r8,r8,0x4,0x0,0x1b   
1002751c  38ff0001    addi r7,r31,0x1             
10027520  3908000e    addi r8,r8,0xe              
10027524  7cfe432e    sthx r7,r30,r8              
10027528  3bff0001    addi r31,r31,0x1            
1002752c  7fe90734    extsh r9,r31                
10027530  2c09000a    cmpwi r9,0xa                
10027534  4180ffe0    blt 0x10027514                 ; -> 10027514
10027538  3940ffff    li r10,-0x1                 
1002753c  b15e009e    sth r10,0x9e(r30)           
10027540  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10027544  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10027548  4e800020    blr                         
