; FUN_1000543c @ 0x1000543c
1000543c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10005440  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10005444  388261fa    addi r4,r2,0x61fa           
10005448  3bc23cd8    addi r30,r2,0x3cd8          
1000544c  abe40000    lha r31,0x0(r4)             
10005450  4800003c    b 0x1000548c                   ; -> 1000548c
10005454  7fe50734    extsh r5,r31                
10005458  1ca50046    mulli r5,r5,0x46            
1000545c  38a50002    addi r5,r5,0x2              
10005460  7cbe2aae    lhax r5,r30,r5              
10005464  2c050063    cmpwi r5,0x63               
10005468  40810014    ble 0x1000547c                 ; -> 1000547c
1000546c  7fe60734    extsh r6,r31                
10005470  1cc60046    mulli r6,r6,0x46            
10005474  38c60040    addi r6,r6,0x40             
10005478  7c7e332e    sthx r3,r30,r6              
1000547c  7fe70734    extsh r7,r31                
10005480  1ce70046    mulli r7,r7,0x46            
10005484  38e7003e    addi r7,r7,0x3e             
10005488  7ffe3aae    lhax r31,r30,r7             
1000548c  7fe80734    extsh r8,r31                
10005490  2c080000    cmpwi r8,0x0                
10005494  4082ffc0    bne 0x10005454                 ; -> 10005454
10005498  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000549c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100054a0  4e800020    blr                         
