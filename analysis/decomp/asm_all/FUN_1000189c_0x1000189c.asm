; FUN_1000189c @ 0x1000189c
1000189c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100018a0  a9630000    lha r11,0x0(r3)             
100018a4  a9030006    lha r8,0x6(r3)              
100018a8  a9230002    lha r9,0x2(r3)              
100018ac  38080003    addi r0,r8,0x3              
100018b0  5528043a    rlwinm r8,r9,0x0,0x10,0x1d  
100018b4  5400043a    rlwinm r0,r0,0x0,0x10,0x1d  
100018b8  a9430004    lha r10,0x4(r3)             
100018bc  7d090734    extsh r9,r8                 
100018c0  7c000734    extsh r0,r0                 
100018c4  7d890050    subf r12,r9,r0              
100018c8  7d0c2850    subf r8,r12,r5              
100018cc  7c0559d6    mullw r0,r5,r11             
100018d0  7cac3850    subf r5,r12,r7              
100018d4  38600004    li r3,0x4                   
100018d8  7d8c1bd6    divw r12,r12,r3             
100018dc  7fe90214    add r31,r9,r0               
100018e0  7fe4fa14    add r31,r4,r31              
100018e4  7d081670    srawi r8,r8,0x2             
100018e8  7d080194    addze r8,r8                 
100018ec  7c6b5050    subf r3,r11,r10             
100018f0  7caa1670    srawi r10,r5,0x2            
100018f4  7c0759d6    mullw r0,r7,r11             
100018f8  7fe4fb78    or r4,r31,r31               
100018fc  7fe90214    add r31,r9,r0               
10001900  7fe6fa14    add r31,r6,r31              
10001904  7fe5fb78    or r5,r31,r31               
10001908  38c30001    addi r6,r3,0x1              
1000190c  7d4a0194    addze r10,r10               
10001910  48000038    b 0x10001948                   ; -> 10001948
10001914  38600000    li r3,0x0                   
10001918  48000018    b 0x10001930                   ; -> 10001930
1000191c  80040000    lwz r0,0x0(r4)              
10001920  38630001    addi r3,r3,0x1              
10001924  90050000    stw r0,0x0(r5)              
10001928  38840004    addi r4,r4,0x4              
1000192c  38a50004    addi r5,r5,0x4              
10001930  7c036000    cmpw r3,r12                 
10001934  4180ffe8    blt 0x1000191c                 ; -> 1000191c
10001938  5543103a    rlwinm r3,r10,0x2,0x0,0x1d  
1000193c  5500103a    rlwinm r0,r8,0x2,0x0,0x1d   
10001940  7ca51a14    add r5,r5,r3                
10001944  7c840214    add r4,r4,r0                
10001948  7cc03379    or. r0,r6,r6                
1000194c  38c6ffff    subi r6,r6,0x1              
10001950  4181ffc4    bgt 0x10001914                 ; -> 10001914
10001954  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10001958  4e800020    blr                         
