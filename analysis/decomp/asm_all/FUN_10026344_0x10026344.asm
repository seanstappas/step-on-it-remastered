; FUN_10026344 @ 0x10026344
10026344  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10026348  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002634c  3bc25336    addi r30,r2,0x5336          
10026350  a8830002    lha r4,0x2(r3)              
10026354  39227544    addi r9,r2,0x7544           
10026358  b09e0002    sth r4,0x2(r30)             
1002635c  a8a30000    lha r5,0x0(r3)              
10026360  3be2533e    addi r31,r2,0x533e          
10026364  b0be0000    sth r5,0x0(r30)             
10026368  a8c30006    lha r6,0x6(r3)              
1002636c  39627544    addi r11,r2,0x7544          
10026370  b0de0006    sth r6,0x6(r30)             
10026374  a8e30004    lha r7,0x4(r3)              
10026378  b0fe0004    sth r7,0x4(r30)             
1002637c  a9030006    lha r8,0x6(r3)              
10026380  a9290006    lha r9,0x6(r9)              
10026384  7d084850    subf r8,r8,r9               
10026388  7d080e70    srawi r8,r8,0x1             
1002638c  7d080194    addze r8,r8                 
10026390  b11f0002    sth r8,0x2(r31)             
10026394  a9430004    lha r10,0x4(r3)             
10026398  a96b0004    lha r11,0x4(r11)            
1002639c  7d4a5850    subf r10,r10,r11            
100263a0  7d4a0e70    srawi r10,r10,0x1           
100263a4  7d4a0194    addze r10,r10               
100263a8  b15f0000    sth r10,0x0(r31)            
100263ac  a99f0002    lha r12,0x2(r31)            
100263b0  a8830006    lha r4,0x6(r3)              
100263b4  7d8c2214    add r12,r12,r4              
100263b8  b19f0006    sth r12,0x6(r31)            
100263bc  a8bf0000    lha r5,0x0(r31)             
100263c0  a8c30004    lha r6,0x4(r3)              
100263c4  7ca53214    add r5,r5,r6                
100263c8  b0bf0004    sth r5,0x4(r31)             
100263cc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100263d0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100263d4  4e800020    blr                         
