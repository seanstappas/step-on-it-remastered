; FUN_10026fd8 @ 0x10026fd8
10026fd8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10026fdc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10026fe0  8bc30000    lbz r30,0x0(r3)             
10026fe4  3be00000    li r31,0x0                  
10026fe8  48000018    b 0x10027000                   ; -> 10027000
10026fec  88a30000    lbz r5,0x0(r3)              
10026ff0  3bff0001    addi r31,r31,0x1            
10026ff4  98a40000    stb r5,0x0(r4)              
10026ff8  38630001    addi r3,r3,0x1              
10026ffc  38840001    addi r4,r4,0x1              
10027000  57e6063e    rlwinm r6,r31,0x0,0x18,0x1f 
10027004  57c7063e    rlwinm r7,r30,0x0,0x18,0x1f 
10027008  7c063840    cmplw r6,r7                 
1002700c  4081ffe0    ble 0x10026fec                 ; -> 10026fec
10027010  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10027014  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10027018  4e800020    blr                         
