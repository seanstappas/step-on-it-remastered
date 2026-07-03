; FUN_1000e9c8 @ 0x1000e9c8
1000e9c8  7c0802a6    mfspr r0,LR                 
1000e9cc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000e9d0  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000e9d4  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000e9d8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000e9dc  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000e9e0  7c7f1b78    or r31,r3,r3                
1000e9e4  7c9d2378    or r29,r4,r4                
1000e9e8  38622f74    addi r3,r2,0x2f74           
1000e9ec  3bc26840    addi r30,r2,0x6840          
1000e9f0  88630000    lbz r3,0x0(r3)              
1000e9f4  28030000    cmplwi r3,0x0               
1000e9f8  40820008    bne 0x1000ea00                 ; -> 1000ea00
1000e9fc  3be00001    li r31,0x1                  
1000ea00  7fe50734    extsh r5,r31                
1000ea04  1ca50070    mulli r5,r5,0x70            
1000ea08  38a50046    addi r5,r5,0x46             
1000ea0c  7cbe2aae    lhax r5,r30,r5              
1000ea10  7fa40734    extsh r4,r29                
1000ea14  7c842a14    add r4,r4,r5                
1000ea18  2c040000    cmpwi r4,0x0                
1000ea1c  418000e4    blt 0x1000eb00                 ; -> 1000eb00
1000ea20  38c22f74    addi r6,r2,0x2f74           
1000ea24  88c60000    lbz r6,0x0(r6)              
1000ea28  28060000    cmplwi r6,0x0               
1000ea2c  41820078    beq 0x1000eaa4                 ; -> 1000eaa4
1000ea30  38e269fe    addi r7,r2,0x69fe           
1000ea34  88e70000    lbz r7,0x0(r7)              
1000ea38  28070000    cmplwi r7,0x0               
1000ea3c  41820068    beq 0x1000eaa4                 ; -> 1000eaa4
1000ea40  7fe80734    extsh r8,r31                
1000ea44  1d080070    mulli r8,r8,0x70            
1000ea48  39080046    addi r8,r8,0x46             
1000ea4c  57e92036    rlwinm r9,r31,0x4,0x0,0x1b  
1000ea50  7c7e42ae    lhax r3,r30,r8              
1000ea54  3880015c    li r4,0x15c                 
1000ea58  38a9fff0    subi r5,r9,0x10             
1000ea5c  4801fbb5    bl 0x1002e610                  ; -> 1002e610
1000ea60  60000000    ori r0,r0,0x0               
1000ea64  7fea0734    extsh r10,r31               
1000ea68  1d4a0070    mulli r10,r10,0x70          
1000ea6c  7fec0734    extsh r12,r31               
1000ea70  1d8c0070    mulli r12,r12,0x70          
1000ea74  394a0046    addi r10,r10,0x46           
1000ea78  7d7e52ae    lhax r11,r30,r10            
1000ea7c  57e62036    rlwinm r6,r31,0x4,0x0,0x1b  
1000ea80  7d6bea14    add r11,r11,r29             
1000ea84  7d7e532e    sthx r11,r30,r10            
1000ea88  398c0046    addi r12,r12,0x46           
1000ea8c  7c7e62ae    lhax r3,r30,r12             
1000ea90  3880015c    li r4,0x15c                 
1000ea94  38a6fff0    subi r5,r6,0x10             
1000ea98  4801f9f5    bl 0x1002e48c                  ; -> 1002e48c
1000ea9c  60000000    ori r0,r0,0x0               
1000eaa0  48000078    b 0x1000eb18                   ; -> 1000eb18
1000eaa4  7fe70734    extsh r7,r31                
1000eaa8  1ce70070    mulli r7,r7,0x70            
1000eaac  38e70046    addi r7,r7,0x46             
1000eab0  7c7e3aae    lhax r3,r30,r7              
1000eab4  3880015c    li r4,0x15c                 
1000eab8  38a00008    li r5,0x8                   
1000eabc  4801fb55    bl 0x1002e610                  ; -> 1002e610
1000eac0  60000000    ori r0,r0,0x0               
1000eac4  7fe80734    extsh r8,r31                
1000eac8  1d080070    mulli r8,r8,0x70            
1000eacc  7fea0734    extsh r10,r31               
1000ead0  1d4a0070    mulli r10,r10,0x70          
1000ead4  39080046    addi r8,r8,0x46             
1000ead8  7d3e42ae    lhax r9,r30,r8              
1000eadc  394a0046    addi r10,r10,0x46           
1000eae0  7d29ea14    add r9,r9,r29               
1000eae4  7d3e432e    sthx r9,r30,r8              
1000eae8  7c7e52ae    lhax r3,r30,r10             
1000eaec  3880015c    li r4,0x15c                 
1000eaf0  38a00008    li r5,0x8                   
1000eaf4  4801f999    bl 0x1002e48c                  ; -> 1002e48c
1000eaf8  60000000    ori r0,r0,0x0               
1000eafc  4800001c    b 0x1000eb18                   ; -> 1000eb18
1000eb00  7feb0734    extsh r11,r31               
1000eb04  1d6b0070    mulli r11,r11,0x70          
1000eb08  396b0046    addi r11,r11,0x46           
1000eb0c  7d9e5aae    lhax r12,r30,r11            
1000eb10  7d8cea14    add r12,r12,r29             
1000eb14  7d9e5b2e    sthx r12,r30,r11            
1000eb18  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000eb1c  38210050    addi r1,r1,0x50             
1000eb20  7c0803a6    mtspr LR,r0                 
1000eb24  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000eb28  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000eb2c  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000eb30  4e800020    blr                         
