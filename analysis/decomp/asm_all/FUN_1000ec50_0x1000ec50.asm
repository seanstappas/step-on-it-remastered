; FUN_1000ec50 @ 0x1000ec50
1000ec50  7c0802a6    mfspr r0,LR                 
1000ec54  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000ec58  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000ec5c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000ec60  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000ec64  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000ec68  7c7f1b78    or r31,r3,r3                
1000ec6c  7c9d2378    or r29,r4,r4                
1000ec70  38622f74    addi r3,r2,0x2f74           
1000ec74  3bc26840    addi r30,r2,0x6840          
1000ec78  88630000    lbz r3,0x0(r3)              
1000ec7c  28030000    cmplwi r3,0x0               
1000ec80  41820078    beq 0x1000ecf8                 ; -> 1000ecf8
1000ec84  388269fe    addi r4,r2,0x69fe           
1000ec88  88840000    lbz r4,0x0(r4)              
1000ec8c  28040000    cmplwi r4,0x0               
1000ec90  41820068    beq 0x1000ecf8                 ; -> 1000ecf8
1000ec94  7fe50734    extsh r5,r31                
1000ec98  1ca50070    mulli r5,r5,0x70            
1000ec9c  38a5004a    addi r5,r5,0x4a             
1000eca0  7c7e2aae    lhax r3,r30,r5              
1000eca4  57e62036    rlwinm r6,r31,0x4,0x0,0x1b  
1000eca8  38800184    li r4,0x184                 
1000ecac  38a6fff0    subi r5,r6,0x10             
1000ecb0  4801f961    bl 0x1002e610                  ; -> 1002e610
1000ecb4  60000000    ori r0,r0,0x0               
1000ecb8  7fe70734    extsh r7,r31                
1000ecbc  1ce70070    mulli r7,r7,0x70            
1000ecc0  7fe90734    extsh r9,r31                
1000ecc4  1d290070    mulli r9,r9,0x70            
1000ecc8  38e7004a    addi r7,r7,0x4a             
1000eccc  7d1e3aae    lhax r8,r30,r7              
1000ecd0  57ea2036    rlwinm r10,r31,0x4,0x0,0x1b 
1000ecd4  7d08ea14    add r8,r8,r29               
1000ecd8  7d1e3b2e    sthx r8,r30,r7              
1000ecdc  3929004a    addi r9,r9,0x4a             
1000ece0  7c7e4aae    lhax r3,r30,r9              
1000ece4  38800184    li r4,0x184                 
1000ece8  38aafff0    subi r5,r10,0x10            
1000ecec  4801f7a1    bl 0x1002e48c                  ; -> 1002e48c
1000ecf0  60000000    ori r0,r0,0x0               
1000ecf4  4800005c    b 0x1000ed50                   ; -> 1000ed50
1000ecf8  7feb0734    extsh r11,r31               
1000ecfc  1d6b0070    mulli r11,r11,0x70          
1000ed00  396b004a    addi r11,r11,0x4a           
1000ed04  7c7e5aae    lhax r3,r30,r11             
1000ed08  38800184    li r4,0x184                 
1000ed0c  38a00008    li r5,0x8                   
1000ed10  4801f901    bl 0x1002e610                  ; -> 1002e610
1000ed14  60000000    ori r0,r0,0x0               
1000ed18  7fec0734    extsh r12,r31               
1000ed1c  1d8c0070    mulli r12,r12,0x70          
1000ed20  7fe40734    extsh r4,r31                
1000ed24  1c840070    mulli r4,r4,0x70            
1000ed28  398c004a    addi r12,r12,0x4a           
1000ed2c  7c7e62ae    lhax r3,r30,r12             
1000ed30  3884004a    addi r4,r4,0x4a             
1000ed34  7c63ea14    add r3,r3,r29               
1000ed38  7c7e632e    sthx r3,r30,r12             
1000ed3c  7c7e22ae    lhax r3,r30,r4              
1000ed40  38a00008    li r5,0x8                   
1000ed44  38800184    li r4,0x184                 
1000ed48  4801f745    bl 0x1002e48c                  ; -> 1002e48c
1000ed4c  60000000    ori r0,r0,0x0               
1000ed50  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000ed54  38210050    addi r1,r1,0x50             
1000ed58  7c0803a6    mtspr LR,r0                 
1000ed5c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000ed60  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000ed64  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000ed68  4e800020    blr                         
