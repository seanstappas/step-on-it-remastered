; FUN_10014700 @ 0x10014700
10014700  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10014704  7c650734    extsh r5,r3                 
10014708  1ca50070    mulli r5,r5,0x70            
1001470c  7c660734    extsh r6,r3                 
10014710  1cc60070    mulli r6,r6,0x70            
10014714  7c670734    extsh r7,r3                 
10014718  1ce70070    mulli r7,r7,0x70            
1001471c  3be26840    addi r31,r2,0x6840          
10014720  38800001    li r4,0x1                   
10014724  38a50026    addi r5,r5,0x26             
10014728  7c9f29ae    stbx r4,r31,r5              
1001472c  38c6000e    addi r6,r6,0xe              
10014730  7cdf32ae    lhax r6,r31,r6              
10014734  38e7001a    addi r7,r7,0x1a             
10014738  7cdf3b2e    sthx r6,r31,r7              
1001473c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10014740  4e800020    blr                         
