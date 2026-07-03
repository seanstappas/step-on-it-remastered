; FUN_100299b4 @ 0x100299b4
100299b4  7c0802a6    mfspr r0,LR                 
100299b8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100299bc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100299c0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100299c4  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100299c8  7c7e1b78    or r30,r3,r3                
100299cc  7fc30734    extsh r3,r30                
100299d0  1c630070    mulli r3,r3,0x70            
100299d4  3be26840    addi r31,r2,0x6840          
100299d8  3863001c    addi r3,r3,0x1c             
100299dc  7c7f1aae    lhax r3,r31,r3              
100299e0  2c030002    cmpwi r3,0x2                
100299e4  40820068    bne 0x10029a4c                 ; -> 10029a4c
100299e8  7fc40734    extsh r4,r30                
100299ec  7fc50734    extsh r5,r30                
100299f0  1c840070    mulli r4,r4,0x70            
100299f4  1ca50070    mulli r5,r5,0x70            
100299f8  7fc60734    extsh r6,r30                
100299fc  7fc70734    extsh r7,r30                
10029a00  1cc60070    mulli r6,r6,0x70            
10029a04  1ce70070    mulli r7,r7,0x70            
10029a08  7c9f22ae    lhax r4,r31,r4              
10029a0c  38a50004    addi r5,r5,0x4              
10029a10  38e70004    addi r7,r7,0x4              
10029a14  7cbf2aae    lhax r5,r31,r5              
10029a18  3864000d    addi r3,r4,0xd              
10029a1c  7cdf32ae    lhax r6,r31,r6              
10029a20  38850004    addi r4,r5,0x4              
10029a24  7cff3aae    lhax r7,r31,r7              
10029a28  38a60012    addi r5,r6,0x12             
10029a2c  38c70019    addi r6,r7,0x19             
10029a30  4bfd967d    bl 0x100030ac                  ; -> 100030ac
10029a34  60000000    ori r0,r0,0x0               
10029a38  7c630734    extsh r3,r3                 
10029a3c  2c030000    cmpwi r3,0x0                
10029a40  41820070    beq 0x10029ab0                 ; -> 10029ab0
10029a44  38600001    li r3,0x1                   
10029a48  4800006c    b 0x10029ab4                   ; -> 10029ab4
10029a4c  7fc90734    extsh r9,r30                
10029a50  7fcb0734    extsh r11,r30               
10029a54  7fc80734    extsh r8,r30                
10029a58  1d290070    mulli r9,r9,0x70            
10029a5c  7fca0734    extsh r10,r30               
10029a60  1d6b0070    mulli r11,r11,0x70          
10029a64  1d080070    mulli r8,r8,0x70            
10029a68  1d4a0070    mulli r10,r10,0x70          
10029a6c  39290004    addi r9,r9,0x4              
10029a70  396b0004    addi r11,r11,0x4            
10029a74  7d1f42ae    lhax r8,r31,r8              
10029a78  7d3f4aae    lhax r9,r31,r9              
10029a7c  7d5f52ae    lhax r10,r31,r10            
10029a80  7d7f5aae    lhax r11,r31,r11            
10029a84  3868000d    addi r3,r8,0xd              
10029a88  38890004    addi r4,r9,0x4              
10029a8c  38aa0012    addi r5,r10,0x12            
10029a90  38cb001d    addi r6,r11,0x1d            
10029a94  4bfd9619    bl 0x100030ac                  ; -> 100030ac
10029a98  60000000    ori r0,r0,0x0               
10029a9c  7c630734    extsh r3,r3                 
10029aa0  2c030000    cmpwi r3,0x0                
10029aa4  4182000c    beq 0x10029ab0                 ; -> 10029ab0
10029aa8  38600001    li r3,0x1                   
10029aac  48000008    b 0x10029ab4                   ; -> 10029ab4
10029ab0  38600000    li r3,0x0                   
10029ab4  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10029ab8  38210040    addi r1,r1,0x40             
10029abc  7c0803a6    mtspr LR,r0                 
10029ac0  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10029ac4  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10029ac8  4e800020    blr                         
