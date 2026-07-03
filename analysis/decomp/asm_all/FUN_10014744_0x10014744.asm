; FUN_10014744 @ 0x10014744
10014744  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10014748  7c640734    extsh r4,r3                 
1001474c  1c840070    mulli r4,r4,0x70            
10014750  3be26840    addi r31,r2,0x6840          
10014754  38840026    addi r4,r4,0x26             
10014758  7c9f20ae    lbzx r4,r31,r4              
1001475c  28040000    cmplwi r4,0x0               
10014760  41820038    beq 0x10014798                 ; -> 10014798
10014764  7c660734    extsh r6,r3                 
10014768  1cc60070    mulli r6,r6,0x70            
1001476c  7c670734    extsh r7,r3                 
10014770  1ce70070    mulli r7,r7,0x70            
10014774  7c680734    extsh r8,r3                 
10014778  1d080070    mulli r8,r8,0x70            
1001477c  38a00000    li r5,0x0                   
10014780  38c60026    addi r6,r6,0x26             
10014784  7cbf31ae    stbx r5,r31,r6              
10014788  38e7001a    addi r7,r7,0x1a             
1001478c  7cff3aae    lhax r7,r31,r7              
10014790  3908000e    addi r8,r8,0xe              
10014794  7cff432e    sthx r7,r31,r8              
10014798  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001479c  4e800020    blr                         
