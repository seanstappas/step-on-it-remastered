; FUN_1000ed6c @ 0x1000ed6c
1000ed6c  7c0802a6    mfspr r0,LR                 
1000ed70  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000ed74  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000ed78  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000ed7c  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1000ed80  7c7f1b78    or r31,r3,r3                
1000ed84  38622f74    addi r3,r2,0x2f74           
1000ed88  3bc26840    addi r30,r2,0x6840          
1000ed8c  88630000    lbz r3,0x0(r3)              
1000ed90  28030000    cmplwi r3,0x0               
1000ed94  40820008    bne 0x1000ed9c                 ; -> 1000ed9c
1000ed98  3be00001    li r31,0x1                  
1000ed9c  388269fe    addi r4,r2,0x69fe           
1000eda0  88840000    lbz r4,0x0(r4)              
1000eda4  28040000    cmplwi r4,0x0               
1000eda8  41820078    beq 0x1000ee20                 ; -> 1000ee20
1000edac  38a22f74    addi r5,r2,0x2f74           
1000edb0  88a50000    lbz r5,0x0(r5)              
1000edb4  28050000    cmplwi r5,0x0               
1000edb8  41820068    beq 0x1000ee20                 ; -> 1000ee20
1000edbc  7fe60734    extsh r6,r31                
1000edc0  1cc60070    mulli r6,r6,0x70            
1000edc4  38c6004a    addi r6,r6,0x4a             
1000edc8  57e72036    rlwinm r7,r31,0x4,0x0,0x1b  
1000edcc  7c7e32ae    lhax r3,r30,r6              
1000edd0  38800184    li r4,0x184                 
1000edd4  38a7fff0    subi r5,r7,0x10             
1000edd8  4801f839    bl 0x1002e610                  ; -> 1002e610
1000eddc  60000000    ori r0,r0,0x0               
1000ede0  7fe80734    extsh r8,r31                
1000ede4  1d080070    mulli r8,r8,0x70            
1000ede8  7fea0734    extsh r10,r31               
1000edec  1d4a0070    mulli r10,r10,0x70          
1000edf0  3908004a    addi r8,r8,0x4a             
1000edf4  7d3e42ae    lhax r9,r30,r8              
1000edf8  57eb2036    rlwinm r11,r31,0x4,0x0,0x1b 
1000edfc  3929ffff    subi r9,r9,0x1              
1000ee00  7d3e432e    sthx r9,r30,r8              
1000ee04  394a004a    addi r10,r10,0x4a           
1000ee08  7c7e52ae    lhax r3,r30,r10             
1000ee0c  38800184    li r4,0x184                 
1000ee10  38abfff0    subi r5,r11,0x10            
1000ee14  4801f679    bl 0x1002e48c                  ; -> 1002e48c
1000ee18  60000000    ori r0,r0,0x0               
1000ee1c  4800005c    b 0x1000ee78                   ; -> 1000ee78
1000ee20  7fec0734    extsh r12,r31               
1000ee24  1d8c0070    mulli r12,r12,0x70          
1000ee28  398c004a    addi r12,r12,0x4a           
1000ee2c  7c7e62ae    lhax r3,r30,r12             
1000ee30  38800184    li r4,0x184                 
1000ee34  38a00008    li r5,0x8                   
1000ee38  4801f7d9    bl 0x1002e610                  ; -> 1002e610
1000ee3c  60000000    ori r0,r0,0x0               
1000ee40  7fe30734    extsh r3,r31                
1000ee44  1c630070    mulli r3,r3,0x70            
1000ee48  7fe50734    extsh r5,r31                
1000ee4c  1ca50070    mulli r5,r5,0x70            
1000ee50  3863004a    addi r3,r3,0x4a             
1000ee54  7c9e1aae    lhax r4,r30,r3              
1000ee58  38a5004a    addi r5,r5,0x4a             
1000ee5c  3884ffff    subi r4,r4,0x1              
1000ee60  7c9e1b2e    sthx r4,r30,r3              
1000ee64  7c7e2aae    lhax r3,r30,r5              
1000ee68  38800184    li r4,0x184                 
1000ee6c  38a00008    li r5,0x8                   
1000ee70  4801f61d    bl 0x1002e48c                  ; -> 1002e48c
1000ee74  60000000    ori r0,r0,0x0               
1000ee78  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1000ee7c  38210040    addi r1,r1,0x40             
1000ee80  7c0803a6    mtspr LR,r0                 
1000ee84  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000ee88  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000ee8c  4e800020    blr                         
