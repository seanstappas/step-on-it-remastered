; FUN_10004090 @ 0x10004090
10004090  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10004094  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10004098  3be23430    addi r31,r2,0x3430          
1000409c  3bc23432    addi r30,r2,0x3432          
100040a0  a8ff0000    lha r7,0x0(r31)             
100040a4  39000002    li r8,0x2                   
100040a8  38e70001    addi r7,r7,0x1              
100040ac  b0ff0000    sth r7,0x0(r31)             
100040b0  a93f0000    lha r9,0x0(r31)             
100040b4  1d29000c    mulli r9,r9,0xc             
100040b8  7d1e4b2e    sthx r8,r30,r9              
100040bc  a95f0000    lha r10,0x0(r31)            
100040c0  1d4a000c    mulli r10,r10,0xc           
100040c4  394a0002    addi r10,r10,0x2            
100040c8  7c7e512e    stwx r3,r30,r10             
100040cc  a97f0000    lha r11,0x0(r31)            
100040d0  1d6b000c    mulli r11,r11,0xc           
100040d4  396b0006    addi r11,r11,0x6            
100040d8  7c9e5b2e    sthx r4,r30,r11             
100040dc  a99f0000    lha r12,0x0(r31)            
100040e0  1d8c000c    mulli r12,r12,0xc           
100040e4  398c0008    addi r12,r12,0x8            
100040e8  7cbe632e    sthx r5,r30,r12             
100040ec  a8ff0000    lha r7,0x0(r31)             
100040f0  1ce7000c    mulli r7,r7,0xc             
100040f4  38e7000a    addi r7,r7,0xa              
100040f8  7cde3b2e    sthx r6,r30,r7              
100040fc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10004100  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10004104  4e800020    blr                         
