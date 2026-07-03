; FUN_10004108 @ 0x10004108
10004108  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000410c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10004110  3be23430    addi r31,r2,0x3430          
10004114  3bc23432    addi r30,r2,0x3432          
10004118  a8ff0000    lha r7,0x0(r31)             
1000411c  39000001    li r8,0x1                   
10004120  38e70001    addi r7,r7,0x1              
10004124  b0ff0000    sth r7,0x0(r31)             
10004128  a93f0000    lha r9,0x0(r31)             
1000412c  1d29000c    mulli r9,r9,0xc             
10004130  7d1e4b2e    sthx r8,r30,r9              
10004134  a95f0000    lha r10,0x0(r31)            
10004138  1d4a000c    mulli r10,r10,0xc           
1000413c  394a0002    addi r10,r10,0x2            
10004140  7c7e512e    stwx r3,r30,r10             
10004144  a97f0000    lha r11,0x0(r31)            
10004148  1d6b000c    mulli r11,r11,0xc           
1000414c  396b0006    addi r11,r11,0x6            
10004150  7c9e5b2e    sthx r4,r30,r11             
10004154  a99f0000    lha r12,0x0(r31)            
10004158  1d8c000c    mulli r12,r12,0xc           
1000415c  398c0008    addi r12,r12,0x8            
10004160  7cbe632e    sthx r5,r30,r12             
10004164  a8ff0000    lha r7,0x0(r31)             
10004168  1ce7000c    mulli r7,r7,0xc             
1000416c  38e7000a    addi r7,r7,0xa              
10004170  7cde3b2e    sthx r6,r30,r7              
10004174  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10004178  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000417c  4e800020    blr                         
