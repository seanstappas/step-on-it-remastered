; FUN_1002b060 @ 0x1002b060
1002b060  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002b064  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002b068  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1002b06c  3bc26840    addi r30,r2,0x6840          
1002b070  3ba251ec    addi r29,r2,0x51ec          
1002b074  3be00001    li r31,0x1                  
1002b078  4800009c    b 0x1002b114                   ; -> 1002b114
1002b07c  889d0000    lbz r4,0x0(r29)             
1002b080  28040000    cmplwi r4,0x0               
1002b084  4082008c    bne 0x1002b110                 ; -> 1002b110
1002b088  7fe60734    extsh r6,r31                
1002b08c  1cc60070    mulli r6,r6,0x70            
1002b090  7fe80734    extsh r8,r31                
1002b094  1d080070    mulli r8,r8,0x70            
1002b098  7fea0734    extsh r10,r31               
1002b09c  1d4a0070    mulli r10,r10,0x70          
1002b0a0  7fec0734    extsh r12,r31               
1002b0a4  1d8c0070    mulli r12,r12,0x70          
1002b0a8  38a00000    li r5,0x0                   
1002b0ac  38c6003c    addi r6,r6,0x3c             
1002b0b0  7cbe312e    stwx r5,r30,r6              
1002b0b4  7fe50734    extsh r5,r31                
1002b0b8  1ca50070    mulli r5,r5,0x70            
1002b0bc  38e00002    li r7,0x2                   
1002b0c0  39080046    addi r8,r8,0x46             
1002b0c4  7cfe432e    sthx r7,r30,r8              
1002b0c8  7fe70734    extsh r7,r31                
1002b0cc  1ce70070    mulli r7,r7,0x70            
1002b0d0  7fe80734    extsh r8,r31                
1002b0d4  1d080070    mulli r8,r8,0x70            
1002b0d8  39200001    li r9,0x1                   
1002b0dc  394a004a    addi r10,r10,0x4a           
1002b0e0  7d3e532e    sthx r9,r30,r10             
1002b0e4  39600001    li r11,0x1                  
1002b0e8  398c004c    addi r12,r12,0x4c           
1002b0ec  7d7e632e    sthx r11,r30,r12            
1002b0f0  38800000    li r4,0x0                   
1002b0f4  38a5002b    addi r5,r5,0x2b             
1002b0f8  7c9e29ae    stbx r4,r30,r5              
1002b0fc  38c00001    li r6,0x1                   
1002b100  38e70048    addi r7,r7,0x48             
1002b104  7cde39ae    stbx r6,r30,r7              
1002b108  39080038    addi r8,r8,0x38             
1002b10c  7c7e432e    sthx r3,r30,r8              
1002b110  3bff0001    addi r31,r31,0x1            
1002b114  7fe90734    extsh r9,r31                
1002b118  2c090002    cmpwi r9,0x2                
1002b11c  4081ff60    ble 0x1002b07c                 ; -> 1002b07c
1002b120  39422f74    addi r10,r2,0x2f74          
1002b124  894a0000    lbz r10,0x0(r10)            
1002b128  280a0000    cmplwi r10,0x0              
1002b12c  40820030    bne 0x1002b15c                 ; -> 1002b15c
1002b130  897d0000    lbz r11,0x0(r29)            
1002b134  280b0000    cmplwi r11,0x0              
1002b138  40820024    bne 0x1002b15c                 ; -> 1002b15c
1002b13c  39800004    li r12,0x4                  
1002b140  b19e00b6    sth r12,0xb6(r30)           
1002b144  3880ffff    li r4,-0x1                  
1002b148  b09e0126    sth r4,0x126(r30)           
1002b14c  38a00002    li r5,0x2                   
1002b150  b0be00ba    sth r5,0xba(r30)            
1002b154  38c00002    li r6,0x2                   
1002b158  b0de00bc    sth r6,0xbc(r30)            
1002b15c  38e00000    li r7,0x0                   
1002b160  98fd0000    stb r7,0x0(r29)             
1002b164  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002b168  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002b16c  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1002b170  4e800020    blr                         
