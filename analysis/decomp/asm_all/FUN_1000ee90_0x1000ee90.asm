; FUN_1000ee90 @ 0x1000ee90
1000ee90  7c0802a6    mfspr r0,LR                 
1000ee94  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000ee98  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000ee9c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000eea0  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1000eea4  7c7f1b78    or r31,r3,r3                
1000eea8  38622f74    addi r3,r2,0x2f74           
1000eeac  3bc26840    addi r30,r2,0x6840          
1000eeb0  88630000    lbz r3,0x0(r3)              
1000eeb4  28030000    cmplwi r3,0x0               
1000eeb8  40820008    bne 0x1000eec0                 ; -> 1000eec0
1000eebc  3be00001    li r31,0x1                  
1000eec0  388269fe    addi r4,r2,0x69fe           
1000eec4  88840000    lbz r4,0x0(r4)              
1000eec8  28040000    cmplwi r4,0x0               
1000eecc  41820078    beq 0x1000ef44                 ; -> 1000ef44
1000eed0  38a22f74    addi r5,r2,0x2f74           
1000eed4  88a50000    lbz r5,0x0(r5)              
1000eed8  28050000    cmplwi r5,0x0               
1000eedc  41820068    beq 0x1000ef44                 ; -> 1000ef44
1000eee0  7fe60734    extsh r6,r31                
1000eee4  1cc60070    mulli r6,r6,0x70            
1000eee8  38c6004c    addi r6,r6,0x4c             
1000eeec  57e72036    rlwinm r7,r31,0x4,0x0,0x1b  
1000eef0  7c7e32ae    lhax r3,r30,r6              
1000eef4  388001d4    li r4,0x1d4                 
1000eef8  38a7fff0    subi r5,r7,0x10             
1000eefc  4801f715    bl 0x1002e610                  ; -> 1002e610
1000ef00  60000000    ori r0,r0,0x0               
1000ef04  7fe80734    extsh r8,r31                
1000ef08  1d080070    mulli r8,r8,0x70            
1000ef0c  7fea0734    extsh r10,r31               
1000ef10  1d4a0070    mulli r10,r10,0x70          
1000ef14  3908004c    addi r8,r8,0x4c             
1000ef18  7d3e42ae    lhax r9,r30,r8              
1000ef1c  57eb2036    rlwinm r11,r31,0x4,0x0,0x1b 
1000ef20  3929ffff    subi r9,r9,0x1              
1000ef24  7d3e432e    sthx r9,r30,r8              
1000ef28  394a004c    addi r10,r10,0x4c           
1000ef2c  7c7e52ae    lhax r3,r30,r10             
1000ef30  388001d4    li r4,0x1d4                 
1000ef34  38abfff0    subi r5,r11,0x10            
1000ef38  4801f555    bl 0x1002e48c                  ; -> 1002e48c
1000ef3c  60000000    ori r0,r0,0x0               
1000ef40  4800005c    b 0x1000ef9c                   ; -> 1000ef9c
1000ef44  7fec0734    extsh r12,r31               
1000ef48  1d8c0070    mulli r12,r12,0x70          
1000ef4c  398c004c    addi r12,r12,0x4c           
1000ef50  7c7e62ae    lhax r3,r30,r12             
1000ef54  388001d4    li r4,0x1d4                 
1000ef58  38a00008    li r5,0x8                   
1000ef5c  4801f6b5    bl 0x1002e610                  ; -> 1002e610
1000ef60  60000000    ori r0,r0,0x0               
1000ef64  7fe30734    extsh r3,r31                
1000ef68  1c630070    mulli r3,r3,0x70            
1000ef6c  7fe50734    extsh r5,r31                
1000ef70  1ca50070    mulli r5,r5,0x70            
1000ef74  3863004c    addi r3,r3,0x4c             
1000ef78  7c9e1aae    lhax r4,r30,r3              
1000ef7c  38a5004c    addi r5,r5,0x4c             
1000ef80  3884ffff    subi r4,r4,0x1              
1000ef84  7c9e1b2e    sthx r4,r30,r3              
1000ef88  7c7e2aae    lhax r3,r30,r5              
1000ef8c  388001d4    li r4,0x1d4                 
1000ef90  38a00008    li r5,0x8                   
1000ef94  4801f4f9    bl 0x1002e48c                  ; -> 1002e48c
1000ef98  60000000    ori r0,r0,0x0               
1000ef9c  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1000efa0  38210040    addi r1,r1,0x40             
1000efa4  7c0803a6    mtspr LR,r0                 
1000efa8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000efac  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000efb0  4e800020    blr                         
