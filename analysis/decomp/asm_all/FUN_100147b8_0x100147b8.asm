; FUN_100147b8 @ 0x100147b8
100147b8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100147bc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100147c0  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
100147c4  7c640734    extsh r4,r3                 
100147c8  1c840070    mulli r4,r4,0x70            
100147cc  3be26840    addi r31,r2,0x6840          
100147d0  3884005c    addi r4,r4,0x5c             
100147d4  7c9f22ae    lhax r4,r31,r4              
100147d8  2c040000    cmpwi r4,0x0                
100147dc  41820154    beq 0x10014930                 ; -> 10014930
100147e0  7c650734    extsh r5,r3                 
100147e4  1ca50070    mulli r5,r5,0x70            
100147e8  7c660734    extsh r6,r3                 
100147ec  1cc60070    mulli r6,r6,0x70            
100147f0  7c670734    extsh r7,r3                 
100147f4  7c680734    extsh r8,r3                 
100147f8  1ce70070    mulli r7,r7,0x70            
100147fc  1d080070    mulli r8,r8,0x70            
10014800  38a5005e    addi r5,r5,0x5e             
10014804  7c690734    extsh r9,r3                 
10014808  1d290070    mulli r9,r9,0x70            
1001480c  7cbf2aae    lhax r5,r31,r5              
10014810  38c60060    addi r6,r6,0x60             
10014814  7cbf332e    sthx r5,r31,r6              
10014818  38e70062    addi r7,r7,0x62             
1001481c  39080064    addi r8,r8,0x64             
10014820  3929006e    addi r9,r9,0x6e             
10014824  7cff3aae    lhax r7,r31,r7              
10014828  7d1f42ae    lhax r8,r31,r8              
1001482c  7d3f4aae    lhax r9,r31,r9              
10014830  7ce74050    subf r7,r7,r8               
10014834  3ba70001    addi r29,r7,0x1             
10014838  7faa0734    extsh r10,r29               
1001483c  7d6953d6    divw r11,r9,r10             
10014840  7c6c0734    extsh r12,r3                
10014844  1d8c0070    mulli r12,r12,0x70          
10014848  7d6b51d6    mullw r11,r11,r10           
1001484c  7c640734    extsh r4,r3                 
10014850  1c840070    mulli r4,r4,0x70            
10014854  7c650734    extsh r5,r3                 
10014858  1ca50070    mulli r5,r5,0x70            
1001485c  398c0062    addi r12,r12,0x62           
10014860  7d9f62ae    lhax r12,r31,r12            
10014864  7d6b4850    subf r11,r11,r9             
10014868  7d6b6214    add r11,r11,r12             
1001486c  3884005e    addi r4,r4,0x5e             
10014870  7d7f232e    sthx r11,r31,r4             
10014874  38a5006e    addi r5,r5,0x6e             
10014878  7cbf2aae    lhax r5,r31,r5              
1001487c  2c050078    cmpwi r5,0x78               
10014880  40800048    bge 0x100148c8                 ; -> 100148c8
10014884  7c660734    extsh r6,r3                 
10014888  1cc60070    mulli r6,r6,0x70            
1001488c  38c6006e    addi r6,r6,0x6e             
10014890  7fdf32ae    lhax r30,r31,r6             
10014894  38e00003    li r7,0x3                   
10014898  7ce70734    extsh r7,r7                 
1001489c  7fc80734    extsh r8,r30                
100148a0  7fc83bd6    divw r30,r8,r7              
100148a4  7fc90734    extsh r9,r30                
100148a8  552907fe    rlwinm r9,r9,0x0,0x1f,0x1f  
100148ac  2c090000    cmpwi r9,0x0                
100148b0  40820018    bne 0x100148c8                 ; -> 100148c8
100148b4  7c6b0734    extsh r11,r3                
100148b8  1d6b0070    mulli r11,r11,0x70          
100148bc  39400000    li r10,0x0                  
100148c0  396b005e    addi r11,r11,0x5e           
100148c4  7d5f5b2e    sthx r10,r31,r11            
100148c8  7c6c0734    extsh r12,r3                
100148cc  1d8c0070    mulli r12,r12,0x70          
100148d0  398c006e    addi r12,r12,0x6e           
100148d4  7c9f62ae    lhax r4,r31,r12             
100148d8  7c852378    or r5,r4,r4                 
100148dc  7ca50734    extsh r5,r5                 
100148e0  3884ffff    subi r4,r4,0x1              
100148e4  2c050000    cmpwi r5,0x0                
100148e8  7c9f632e    sthx r4,r31,r12             
100148ec  40800018    bge 0x10014904                 ; -> 10014904
100148f0  7c670734    extsh r7,r3                 
100148f4  1ce70070    mulli r7,r7,0x70            
100148f8  38c00000    li r6,0x0                   
100148fc  38e7005c    addi r7,r7,0x5c             
10014900  7cdf3b2e    sthx r6,r31,r7              
10014904  7c680734    extsh r8,r3                 
10014908  1d080070    mulli r8,r8,0x70            
1001490c  39080028    addi r8,r8,0x28             
10014910  7d1f40ae    lbzx r8,r31,r8              
10014914  28080000    cmplwi r8,0x0               
10014918  41820018    beq 0x10014930                 ; -> 10014930
1001491c  7c6a0734    extsh r10,r3                
10014920  1d4a0070    mulli r10,r10,0x70          
10014924  39200000    li r9,0x0                   
10014928  394a006e    addi r10,r10,0x6e           
1001492c  7d3f532e    sthx r9,r31,r10             
10014930  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10014934  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10014938  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1001493c  4e800020    blr                         
