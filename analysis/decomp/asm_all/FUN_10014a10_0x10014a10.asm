; FUN_10014a10 @ 0x10014a10
10014a10  7c0802a6    mfspr r0,LR                 
10014a14  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10014a18  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10014a1c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10014a20  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10014a24  7c7e1b78    or r30,r3,r3                
10014a28  38627528    addi r3,r2,0x7528           
10014a2c  3be26840    addi r31,r2,0x6840          
10014a30  a8630000    lha r3,0x0(r3)              
10014a34  2c030000    cmpwi r3,0x0                
10014a38  408101d8    ble 0x10014c10                 ; -> 10014c10
10014a3c  7fc40734    extsh r4,r30                
10014a40  1c840070    mulli r4,r4,0x70            
10014a44  3884005c    addi r4,r4,0x5c             
10014a48  7c9f22ae    lhax r4,r31,r4              
10014a4c  2c040000    cmpwi r4,0x0                
10014a50  418201c0    beq 0x10014c10                 ; -> 10014c10
10014a54  7fc50734    extsh r5,r30                
10014a58  1ca50070    mulli r5,r5,0x70            
10014a5c  38a5005e    addi r5,r5,0x5e             
10014a60  7cbf2aae    lhax r5,r31,r5              
10014a64  2c050000    cmpwi r5,0x0                
10014a68  40820068    bne 0x10014ad0                 ; -> 10014ad0
10014a6c  7fc60734    extsh r6,r30                
10014a70  1cc60070    mulli r6,r6,0x70            
10014a74  38c60060    addi r6,r6,0x60             
10014a78  7cdf32ae    lhax r6,r31,r6              
10014a7c  2c060000    cmpwi r6,0x0                
10014a80  4182014c    beq 0x10014bcc                 ; -> 10014bcc
10014a84  7fc70734    extsh r7,r30                
10014a88  7fc80734    extsh r8,r30                
10014a8c  7fc90734    extsh r9,r30                
10014a90  7fca0734    extsh r10,r30               
10014a94  1ce70070    mulli r7,r7,0x70            
10014a98  1d080070    mulli r8,r8,0x70            
10014a9c  1d290070    mulli r9,r9,0x70            
10014aa0  1d4a0070    mulli r10,r10,0x70          
10014aa4  38e7006a    addi r7,r7,0x6a             
10014aa8  39080060    addi r8,r8,0x60             
10014aac  39290066    addi r9,r9,0x66             
10014ab0  394a0068    addi r10,r10,0x68           
10014ab4  7c7f382e    lwzx r3,r31,r7              
10014ab8  7c9f42ae    lhax r4,r31,r8              
10014abc  7cbf4aae    lhax r5,r31,r9              
10014ac0  7cdf52ae    lhax r6,r31,r10             
10014ac4  4bff01ed    bl 0x10004cb0                  ; -> 10004cb0
10014ac8  60000000    ori r0,r0,0x0               
10014acc  48000100    b 0x10014bcc                   ; -> 10014bcc
10014ad0  7fcb0734    extsh r11,r30               
10014ad4  1d6b0070    mulli r11,r11,0x70          
10014ad8  396b0060    addi r11,r11,0x60           
10014adc  7d7f5aae    lhax r11,r31,r11            
10014ae0  2c0b0000    cmpwi r11,0x0               
10014ae4  40820054    bne 0x10014b38                 ; -> 10014b38
10014ae8  7fc50734    extsh r5,r30                
10014aec  1ca50070    mulli r5,r5,0x70            
10014af0  7fc60734    extsh r6,r30                
10014af4  7fc70734    extsh r7,r30                
10014af8  7fcc0734    extsh r12,r30               
10014afc  1cc60070    mulli r6,r6,0x70            
10014b00  1ce70070    mulli r7,r7,0x70            
10014b04  1d8c0070    mulli r12,r12,0x70          
10014b08  38a5005e    addi r5,r5,0x5e             
10014b0c  38e70004    addi r7,r7,0x4              
10014b10  398c006a    addi r12,r12,0x6a           
10014b14  7c9f2aae    lhax r4,r31,r5              
10014b18  7cdf32ae    lhax r6,r31,r6              
10014b1c  7cff3aae    lhax r7,r31,r7              
10014b20  38a60006    addi r5,r6,0x6              
10014b24  7c7f602e    lwzx r3,r31,r12             
10014b28  38c7fff0    subi r6,r7,0x10             
10014b2c  4bff0089    bl 0x10004bb4                  ; -> 10004bb4
10014b30  60000000    ori r0,r0,0x0               
10014b34  48000098    b 0x10014bcc                   ; -> 10014bcc
10014b38  7fc80734    extsh r8,r30                
10014b3c  7fc90734    extsh r9,r30                
10014b40  7fca0734    extsh r10,r30               
10014b44  7fcb0734    extsh r11,r30               
10014b48  1d080070    mulli r8,r8,0x70            
10014b4c  1d290070    mulli r9,r9,0x70            
10014b50  1d4a0070    mulli r10,r10,0x70          
10014b54  1d6b0070    mulli r11,r11,0x70          
10014b58  3908006a    addi r8,r8,0x6a             
10014b5c  39290060    addi r9,r9,0x60             
10014b60  394a0066    addi r10,r10,0x66           
10014b64  396b0068    addi r11,r11,0x68           
10014b68  7c7f402e    lwzx r3,r31,r8              
10014b6c  7c9f4aae    lhax r4,r31,r9              
10014b70  7cbf52ae    lhax r5,r31,r10             
10014b74  7cdf5aae    lhax r6,r31,r11             
10014b78  4bff0139    bl 0x10004cb0                  ; -> 10004cb0
10014b7c  60000000    ori r0,r0,0x0               
10014b80  7fc50734    extsh r5,r30                
10014b84  1ca50070    mulli r5,r5,0x70            
10014b88  7fc60734    extsh r6,r30                
10014b8c  7fc70734    extsh r7,r30                
10014b90  7fcc0734    extsh r12,r30               
10014b94  1cc60070    mulli r6,r6,0x70            
10014b98  1ce70070    mulli r7,r7,0x70            
10014b9c  1d8c0070    mulli r12,r12,0x70          
10014ba0  38a5005e    addi r5,r5,0x5e             
10014ba4  38e70004    addi r7,r7,0x4              
10014ba8  398c006a    addi r12,r12,0x6a           
10014bac  7c9f2aae    lhax r4,r31,r5              
10014bb0  7cdf32ae    lhax r6,r31,r6              
10014bb4  7cff3aae    lhax r7,r31,r7              
10014bb8  38a60006    addi r5,r6,0x6              
10014bbc  7c7f602e    lwzx r3,r31,r12             
10014bc0  38c7fff0    subi r6,r7,0x10             
10014bc4  4bfefff1    bl 0x10004bb4                  ; -> 10004bb4
10014bc8  60000000    ori r0,r0,0x0               
10014bcc  7fc80734    extsh r8,r30                
10014bd0  1d080070    mulli r8,r8,0x70            
10014bd4  7fc90734    extsh r9,r30                
10014bd8  1d290070    mulli r9,r9,0x70            
10014bdc  7fca0734    extsh r10,r30               
10014be0  1d4a0070    mulli r10,r10,0x70          
10014be4  7d1f42ae    lhax r8,r31,r8              
10014be8  7fcb0734    extsh r11,r30               
10014bec  1d6b0070    mulli r11,r11,0x70          
10014bf0  39080006    addi r8,r8,0x6              
10014bf4  39290066    addi r9,r9,0x66             
10014bf8  7d1f4b2e    sthx r8,r31,r9              
10014bfc  394a0004    addi r10,r10,0x4            
10014c00  7d5f52ae    lhax r10,r31,r10            
10014c04  396b0068    addi r11,r11,0x68           
10014c08  394afff0    subi r10,r10,0x10           
10014c0c  7d5f5b2e    sthx r10,r31,r11            
10014c10  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10014c14  38210040    addi r1,r1,0x40             
10014c18  7c0803a6    mtspr LR,r0                 
10014c1c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10014c20  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10014c24  4e800020    blr                         
