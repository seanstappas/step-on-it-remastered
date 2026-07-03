; FUN_10014940 @ 0x10014940
10014940  7c0802a6    mfspr r0,LR                 
10014944  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10014948  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001494c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10014950  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10014954  7c7e1b78    or r30,r3,r3                
10014958  38627528    addi r3,r2,0x7528           
1001495c  3be26840    addi r31,r2,0x6840          
10014960  a8630000    lha r3,0x0(r3)              
10014964  2c030000    cmpwi r3,0x0                
10014968  40810090    ble 0x100149f8                 ; -> 100149f8
1001496c  7fc40734    extsh r4,r30                
10014970  1c840070    mulli r4,r4,0x70            
10014974  3884005c    addi r4,r4,0x5c             
10014978  7c9f22ae    lhax r4,r31,r4              
1001497c  2c040000    cmpwi r4,0x0                
10014980  41820078    beq 0x100149f8                 ; -> 100149f8
10014984  7fc50734    extsh r5,r30                
10014988  1ca50070    mulli r5,r5,0x70            
1001498c  38a50060    addi r5,r5,0x60             
10014990  7cbf2aae    lhax r5,r31,r5              
10014994  2c050000    cmpwi r5,0x0                
10014998  41820060    beq 0x100149f8                 ; -> 100149f8
1001499c  7fc60734    extsh r6,r30                
100149a0  1cc60070    mulli r6,r6,0x70            
100149a4  7fc70734    extsh r7,r30                
100149a8  7fc80734    extsh r8,r30                
100149ac  7fc90734    extsh r9,r30                
100149b0  1ce70070    mulli r7,r7,0x70            
100149b4  1d080070    mulli r8,r8,0x70            
100149b8  1d290070    mulli r9,r9,0x70            
100149bc  38c6006a    addi r6,r6,0x6a             
100149c0  38e70060    addi r7,r7,0x60             
100149c4  39080066    addi r8,r8,0x66             
100149c8  7c7f302e    lwzx r3,r31,r6              
100149cc  39290068    addi r9,r9,0x68             
100149d0  7c9f3aae    lhax r4,r31,r7              
100149d4  7cbf42ae    lhax r5,r31,r8              
100149d8  7cdf4aae    lhax r6,r31,r9              
100149dc  4bff02d5    bl 0x10004cb0                  ; -> 10004cb0
100149e0  60000000    ori r0,r0,0x0               
100149e4  7fcb0734    extsh r11,r30               
100149e8  1d6b0070    mulli r11,r11,0x70          
100149ec  39400000    li r10,0x0                  
100149f0  396b0060    addi r11,r11,0x60           
100149f4  7d5f5b2e    sthx r10,r31,r11            
100149f8  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
100149fc  38210040    addi r1,r1,0x40             
10014a00  7c0803a6    mtspr LR,r0                 
10014a04  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10014a08  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10014a0c  4e800020    blr                         
