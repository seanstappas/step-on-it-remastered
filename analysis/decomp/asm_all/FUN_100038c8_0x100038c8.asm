; FUN_100038c8 @ 0x100038c8
100038c8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100038cc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100038d0  3be23702    addi r31,r2,0x3702          
100038d4  a87f0000    lha r3,0x0(r31)             
100038d8  2c03ffff    cmpwi r3,-0x1               
100038dc  4082000c    bne 0x100038e8                 ; -> 100038e8
100038e0  38600000    li r3,0x0                   
100038e4  48000024    b 0x10003908                   ; -> 10003908
100038e8  a8bf0000    lha r5,0x0(r31)             
100038ec  3882372e    addi r4,r2,0x372e           
100038f0  abdf0000    lha r30,0x0(r31)            
100038f4  1ca50014    mulli r5,r5,0x14            
100038f8  38840002    addi r4,r4,0x2              
100038fc  7c842aae    lhax r4,r4,r5               
10003900  7fc3f378    or r3,r30,r30               
10003904  b09f0000    sth r4,0x0(r31)             
10003908  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000390c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10003910  4e800020    blr                         
