; FUN_1000eb34 @ 0x1000eb34
1000eb34  7c0802a6    mfspr r0,LR                 
1000eb38  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000eb3c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000eb40  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000eb44  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000eb48  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000eb4c  7c7f1b78    or r31,r3,r3                
1000eb50  7c9d2378    or r29,r4,r4                
1000eb54  38622f74    addi r3,r2,0x2f74           
1000eb58  3bc26840    addi r30,r2,0x6840          
1000eb5c  88630000    lbz r3,0x0(r3)              
1000eb60  28030000    cmplwi r3,0x0               
1000eb64  41820078    beq 0x1000ebdc                 ; -> 1000ebdc
1000eb68  388269fe    addi r4,r2,0x69fe           
1000eb6c  88840000    lbz r4,0x0(r4)              
1000eb70  28040000    cmplwi r4,0x0               
1000eb74  41820068    beq 0x1000ebdc                 ; -> 1000ebdc
1000eb78  7fe50734    extsh r5,r31                
1000eb7c  1ca50070    mulli r5,r5,0x70            
1000eb80  38a5004c    addi r5,r5,0x4c             
1000eb84  7c7e2aae    lhax r3,r30,r5              
1000eb88  57e62036    rlwinm r6,r31,0x4,0x0,0x1b  
1000eb8c  388001d4    li r4,0x1d4                 
1000eb90  38a6fff0    subi r5,r6,0x10             
1000eb94  4801fa7d    bl 0x1002e610                  ; -> 1002e610
1000eb98  60000000    ori r0,r0,0x0               
1000eb9c  7fe70734    extsh r7,r31                
1000eba0  1ce70070    mulli r7,r7,0x70            
1000eba4  7fe90734    extsh r9,r31                
1000eba8  1d290070    mulli r9,r9,0x70            
1000ebac  38e7004c    addi r7,r7,0x4c             
1000ebb0  7d1e3aae    lhax r8,r30,r7              
1000ebb4  57ea2036    rlwinm r10,r31,0x4,0x0,0x1b 
1000ebb8  7d08ea14    add r8,r8,r29               
1000ebbc  7d1e3b2e    sthx r8,r30,r7              
1000ebc0  3929004c    addi r9,r9,0x4c             
1000ebc4  7c7e4aae    lhax r3,r30,r9              
1000ebc8  388001d4    li r4,0x1d4                 
1000ebcc  38aafff0    subi r5,r10,0x10            
1000ebd0  4801f8bd    bl 0x1002e48c                  ; -> 1002e48c
1000ebd4  60000000    ori r0,r0,0x0               
1000ebd8  4800005c    b 0x1000ec34                   ; -> 1000ec34
1000ebdc  7feb0734    extsh r11,r31               
1000ebe0  1d6b0070    mulli r11,r11,0x70          
1000ebe4  396b004c    addi r11,r11,0x4c           
1000ebe8  7c7e5aae    lhax r3,r30,r11             
1000ebec  388001d4    li r4,0x1d4                 
1000ebf0  38a00008    li r5,0x8                   
1000ebf4  4801fa1d    bl 0x1002e610                  ; -> 1002e610
1000ebf8  60000000    ori r0,r0,0x0               
1000ebfc  7fec0734    extsh r12,r31               
1000ec00  1d8c0070    mulli r12,r12,0x70          
1000ec04  7fe40734    extsh r4,r31                
1000ec08  1c840070    mulli r4,r4,0x70            
1000ec0c  398c004c    addi r12,r12,0x4c           
1000ec10  7c7e62ae    lhax r3,r30,r12             
1000ec14  3884004c    addi r4,r4,0x4c             
1000ec18  7c63ea14    add r3,r3,r29               
1000ec1c  7c7e632e    sthx r3,r30,r12             
1000ec20  7c7e22ae    lhax r3,r30,r4              
1000ec24  38a00008    li r5,0x8                   
1000ec28  388001d4    li r4,0x1d4                 
1000ec2c  4801f861    bl 0x1002e48c                  ; -> 1002e48c
1000ec30  60000000    ori r0,r0,0x0               
1000ec34  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000ec38  38210050    addi r1,r1,0x50             
1000ec3c  7c0803a6    mtspr LR,r0                 
1000ec40  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000ec44  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000ec48  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000ec4c  4e800020    blr                         
