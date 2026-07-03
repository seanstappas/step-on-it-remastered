; FUN_100110b4 @ 0x100110b4
100110b4  7c0802a6    mfspr r0,LR                 
100110b8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100110bc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100110c0  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
100110c4  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
100110c8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100110cc  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
100110d0  7c7e1b78    or r30,r3,r3                
100110d4  38622f74    addi r3,r2,0x2f74           
100110d8  3be26840    addi r31,r2,0x6840          
100110dc  88630000    lbz r3,0x0(r3)              
100110e0  28030000    cmplwi r3,0x0               
100110e4  4082000c    bne 0x100110f0                 ; -> 100110f0
100110e8  3ba00001    li r29,0x1                  
100110ec  48000008    b 0x100110f4                   ; -> 100110f4
100110f0  7fddf378    or r29,r30,r30              
100110f4  7fc40734    extsh r4,r30                
100110f8  1c840070    mulli r4,r4,0x70            
100110fc  3884004e    addi r4,r4,0x4e             
10011100  7c9f22ae    lhax r4,r31,r4              
10011104  2c040000    cmpwi r4,0x0                
10011108  40820300    bne 0x10011408                 ; -> 10011408
1001110c  7fa50734    extsh r5,r29                
10011110  1ca50070    mulli r5,r5,0x70            
10011114  38a5004a    addi r5,r5,0x4a             
10011118  7cbf2aae    lhax r5,r31,r5              
1001111c  2c050000    cmpwi r5,0x0                
10011120  408102e8    ble 0x10011408                 ; -> 10011408
10011124  7fc70734    extsh r7,r30                
10011128  1ce70070    mulli r7,r7,0x70            
1001112c  38c00000    li r6,0x0                   
10011130  38e70024    addi r7,r7,0x24             
10011134  7cdf39ae    stbx r6,r31,r7              
10011138  38600001    li r3,0x1                   
1001113c  38800007    li r4,0x7                   
10011140  48019ee1    bl 0x1002b020                  ; -> 1002b020
10011144  60000000    ori r0,r0,0x0               
10011148  7fa3eb78    or r3,r29,r29               
1001114c  4bffdc21    bl 0x1000ed6c                  ; -> 1000ed6c
10011150  7fa90734    extsh r9,r29                
10011154  1d290070    mulli r9,r9,0x70            
10011158  7fca0734    extsh r10,r30               
1001115c  1d4a0070    mulli r10,r10,0x70          
10011160  39000000    li r8,0x0                   
10011164  39290042    addi r9,r9,0x42             
10011168  7d1f4b2e    sthx r8,r31,r9              
1001116c  394a0004    addi r10,r10,0x4            
10011170  7d5f52ae    lhax r10,r31,r10            
10011174  386a0010    addi r3,r10,0x10            
10011178  4801d555    bl 0x1002e6cc                  ; -> 1002e6cc
1001117c  60000000    ori r0,r0,0x0               
10011180  7c7c1b78    or r28,r3,r3                
10011184  7f83e378    or r3,r28,r28               
10011188  4801d525    bl 0x1002e6ac                  ; -> 1002e6ac
1001118c  60000000    ori r0,r0,0x0               
10011190  7fcb0734    extsh r11,r30               
10011194  1d6b0070    mulli r11,r11,0x70          
10011198  7fdc0734    extsh r28,r30               
1001119c  1f9c0070    mulli r28,r28,0x70          
100111a0  7fc40734    extsh r4,r30                
100111a4  1c840070    mulli r4,r4,0x70            
100111a8  7fc50734    extsh r5,r30                
100111ac  1ca50070    mulli r5,r5,0x70            
100111b0  38630008    addi r3,r3,0x8              
100111b4  396b0050    addi r11,r11,0x50           
100111b8  7c7f5b2e    sthx r3,r31,r11             
100111bc  39800001    li r12,0x1                  
100111c0  3b9c0054    addi r28,r28,0x54           
100111c4  7d9fe32e    sthx r12,r31,r28            
100111c8  38600000    li r3,0x0                   
100111cc  38840058    addi r4,r4,0x58             
100111d0  7c7f21ae    stbx r3,r31,r4              
100111d4  38a50034    addi r5,r5,0x34             
100111d8  7cbf2aae    lhax r5,r31,r5              
100111dc  2c050001    cmpwi r5,0x1                
100111e0  4082011c    bne 0x100112fc                 ; -> 100112fc
100111e4  7fc60734    extsh r6,r30                
100111e8  1cc60070    mulli r6,r6,0x70            
100111ec  7fc70734    extsh r7,r30                
100111f0  1ce70070    mulli r7,r7,0x70            
100111f4  7fc80734    extsh r8,r30                
100111f8  1d080070    mulli r8,r8,0x70            
100111fc  7cdf32ae    lhax r6,r31,r6              
10011200  38e7004e    addi r7,r7,0x4e             
10011204  38c60014    addi r6,r6,0x14             
10011208  7cdf3b2e    sthx r6,r31,r7              
1001120c  39080050    addi r8,r8,0x50             
10011210  7c7f42ae    lhax r3,r31,r8              
10011214  4801d4e5    bl 0x1002e6f8                  ; -> 1002e6f8
10011218  60000000    ori r0,r0,0x0               
1001121c  7fc90734    extsh r9,r30                
10011220  1d290070    mulli r9,r9,0x70            
10011224  7c630734    extsh r3,r3                 
10011228  3929004e    addi r9,r9,0x4e             
1001122c  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10011230  7d3f4aae    lhax r9,r31,r9              
10011234  7c7c1b78    or r28,r3,r3                
10011238  38690018    addi r3,r9,0x18             
1001123c  4801d491    bl 0x1002e6cc                  ; -> 1002e6cc
10011240  60000000    ori r0,r0,0x0               
10011244  7c630734    extsh r3,r3                 
10011248  1c63003c    mulli r3,r3,0x3c            
1001124c  39426bf8    addi r10,r2,0x6bf8          
10011250  7c63e214    add r3,r3,r28               
10011254  7d4a182e    lwzx r10,r10,r3             
10011258  554a05ac    rlwinm r10,r10,0x0,0x16,0x16
1001125c  2c0a0000    cmpwi r10,0x0               
10011260  41820044    beq 0x100112a4                 ; -> 100112a4
10011264  7fcb0734    extsh r11,r30               
10011268  1d6b0070    mulli r11,r11,0x70          
1001126c  396b004e    addi r11,r11,0x4e           
10011270  7d7f5aae    lhax r11,r31,r11            
10011274  386bfff8    subi r3,r11,0x8             
10011278  4801d455    bl 0x1002e6cc                  ; -> 1002e6cc
1001127c  60000000    ori r0,r0,0x0               
10011280  7c7c1b78    or r28,r3,r3                
10011284  7f83e378    or r3,r28,r28               
10011288  4801d425    bl 0x1002e6ac                  ; -> 1002e6ac
1001128c  60000000    ori r0,r0,0x0               
10011290  7fcc0734    extsh r12,r30               
10011294  1d8c0070    mulli r12,r12,0x70          
10011298  38630008    addi r3,r3,0x8              
1001129c  398c004e    addi r12,r12,0x4e           
100112a0  7c7f632e    sthx r3,r31,r12             
100112a4  7fdc0734    extsh r28,r30               
100112a8  1f9c0070    mulli r28,r28,0x70          
100112ac  7fc30734    extsh r3,r30                
100112b0  1c630070    mulli r3,r3,0x70            
100112b4  7fc60734    extsh r6,r30                
100112b8  1cc60070    mulli r6,r6,0x70            
100112bc  7fc70734    extsh r7,r30                
100112c0  3b9c0034    addi r28,r28,0x34           
100112c4  1ce70070    mulli r7,r7,0x70            
100112c8  7f9fe2ae    lhax r28,r31,r28            
100112cc  38630052    addi r3,r3,0x52             
100112d0  7f9f1b2e    sthx r28,r31,r3             
100112d4  38826bb0    addi r4,r2,0x6bb0           
100112d8  38c6004e    addi r6,r6,0x4e             
100112dc  80640000    lwz r3,0x0(r4)              
100112e0  7cbf32ae    lhax r5,r31,r6              
100112e4  38e70050    addi r7,r7,0x50             
100112e8  7cdf3aae    lhax r6,r31,r7              
100112ec  3880000a    li r4,0xa                   
100112f0  4bff38c5    bl 0x10004bb4                  ; -> 10004bb4
100112f4  60000000    ori r0,r0,0x0               
100112f8  48000110    b 0x10011408                   ; -> 10011408
100112fc  7fc80734    extsh r8,r30                
10011300  1d080070    mulli r8,r8,0x70            
10011304  7fc90734    extsh r9,r30                
10011308  1d290070    mulli r9,r9,0x70            
1001130c  7fca0734    extsh r10,r30               
10011310  1d4a0070    mulli r10,r10,0x70          
10011314  7d1f42ae    lhax r8,r31,r8              
10011318  3929004e    addi r9,r9,0x4e             
1001131c  3908fff2    subi r8,r8,0xe              
10011320  7d1f4b2e    sthx r8,r31,r9              
10011324  394a0050    addi r10,r10,0x50           
10011328  7c7f52ae    lhax r3,r31,r10             
1001132c  4801d3cd    bl 0x1002e6f8                  ; -> 1002e6f8
10011330  60000000    ori r0,r0,0x0               
10011334  7fcb0734    extsh r11,r30               
10011338  1d6b0070    mulli r11,r11,0x70          
1001133c  7c630734    extsh r3,r3                 
10011340  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10011344  7c7c1b78    or r28,r3,r3                
10011348  396b004e    addi r11,r11,0x4e           
1001134c  7c7f5aae    lhax r3,r31,r11             
10011350  4801d37d    bl 0x1002e6cc                  ; -> 1002e6cc
10011354  60000000    ori r0,r0,0x0               
10011358  7c630734    extsh r3,r3                 
1001135c  1c63003c    mulli r3,r3,0x3c            
10011360  39826bf8    addi r12,r2,0x6bf8          
10011364  7c63e214    add r3,r3,r28               
10011368  7d8c182e    lwzx r12,r12,r3             
1001136c  558c05ac    rlwinm r12,r12,0x0,0x16,0x16
10011370  2c0c0000    cmpwi r12,0x0               
10011374  41820040    beq 0x100113b4                 ; -> 100113b4
10011378  7fdc0734    extsh r28,r30               
1001137c  1f9c0070    mulli r28,r28,0x70          
10011380  3b9c004e    addi r28,r28,0x4e           
10011384  7f9fe2ae    lhax r28,r31,r28            
10011388  387c0020    addi r3,r28,0x20            
1001138c  4801d341    bl 0x1002e6cc                  ; -> 1002e6cc
10011390  60000000    ori r0,r0,0x0               
10011394  7c7c1b78    or r28,r3,r3                
10011398  7f83e378    or r3,r28,r28               
1001139c  4801d311    bl 0x1002e6ac                  ; -> 1002e6ac
100113a0  60000000    ori r0,r0,0x0               
100113a4  7fc40734    extsh r4,r30                
100113a8  1c840070    mulli r4,r4,0x70            
100113ac  3884004e    addi r4,r4,0x4e             
100113b0  7c7f232e    sthx r3,r31,r4              
100113b4  7fc50734    extsh r5,r30                
100113b8  1ca50070    mulli r5,r5,0x70            
100113bc  7fc60734    extsh r6,r30                
100113c0  1cc60070    mulli r6,r6,0x70            
100113c4  7fc80734    extsh r8,r30                
100113c8  7fc90734    extsh r9,r30                
100113cc  1d080070    mulli r8,r8,0x70            
100113d0  1d290070    mulli r9,r9,0x70            
100113d4  38a50034    addi r5,r5,0x34             
100113d8  7cbf2aae    lhax r5,r31,r5              
100113dc  38c60052    addi r6,r6,0x52             
100113e0  38e26bb0    addi r7,r2,0x6bb0           
100113e4  7cbf332e    sthx r5,r31,r6              
100113e8  3908004e    addi r8,r8,0x4e             
100113ec  39290050    addi r9,r9,0x50             
100113f0  80670000    lwz r3,0x0(r7)              
100113f4  7cbf42ae    lhax r5,r31,r8              
100113f8  7cdf4aae    lhax r6,r31,r9              
100113fc  38800009    li r4,0x9                   
10011400  4bff37b5    bl 0x10004bb4                  ; -> 10004bb4
10011404  60000000    ori r0,r0,0x0               
10011408  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001140c  38210050    addi r1,r1,0x50             
10011410  7c0803a6    mtspr LR,r0                 
10011414  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10011418  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001141c  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10011420  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10011424  4e800020    blr                         
