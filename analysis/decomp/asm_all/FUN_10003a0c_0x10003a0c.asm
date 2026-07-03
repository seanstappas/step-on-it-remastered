; FUN_10003a0c @ 0x10003a0c
10003a0c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10003a10  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10003a14  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10003a18  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10003a1c  7c650734    extsh r5,r3                 
10003a20  1ca50014    mulli r5,r5,0x14            
10003a24  7c860734    extsh r6,r4                 
10003a28  1cc60014    mulli r6,r6,0x14            
10003a2c  3ba2372e    addi r29,r2,0x372e          
10003a30  38a5000c    addi r5,r5,0xc              
10003a34  7ffd2a14    add r31,r29,r5              
10003a38  38c6000c    addi r6,r6,0xc              
10003a3c  7fdd3214    add r30,r29,r6              
10003a40  a8ff0000    lha r7,0x0(r31)             
10003a44  a91e0004    lha r8,0x4(r30)             
10003a48  7ce70734    extsh r7,r7                 
10003a4c  7c074000    cmpw r7,r8                  
10003a50  3b823cd8    addi r28,r2,0x3cd8          
10003a54  41810100    bgt 0x10003b54                 ; -> 10003b54
10003a58  a93e0000    lha r9,0x0(r30)             
10003a5c  a95f0004    lha r10,0x4(r31)            
10003a60  7d290734    extsh r9,r9                 
10003a64  7c095000    cmpw r9,r10                 
10003a68  418100ec    bgt 0x10003b54                 ; -> 10003b54
10003a6c  a97e0002    lha r11,0x2(r30)            
10003a70  a99f0006    lha r12,0x6(r31)            
10003a74  7d6b0734    extsh r11,r11               
10003a78  7c0b6000    cmpw r11,r12                
10003a7c  418100d8    bgt 0x10003b54                 ; -> 10003b54
10003a80  a8bf0002    lha r5,0x2(r31)             
10003a84  a8de0006    lha r6,0x6(r30)             
10003a88  7ca50734    extsh r5,r5                 
10003a8c  7c053000    cmpw r5,r6                  
10003a90  418100c4    bgt 0x10003b54                 ; -> 10003b54
10003a94  7c670734    extsh r7,r3                 
10003a98  1ce70014    mulli r7,r7,0x14            
10003a9c  7cfd3aae    lhax r7,r29,r7              
10003aa0  1ce70046    mulli r7,r7,0x46            
10003aa4  38e70021    addi r7,r7,0x21             
10003aa8  7cfc38ae    lbzx r7,r28,r7              
10003aac  28070000    cmplwi r7,0x0               
10003ab0  40820044    bne 0x10003af4                 ; -> 10003af4
10003ab4  7c690734    extsh r9,r3                 
10003ab8  1d290014    mulli r9,r9,0x14            
10003abc  7d3d4aae    lhax r9,r29,r9              
10003ac0  39000001    li r8,0x1                   
10003ac4  1d290046    mulli r9,r9,0x46            
10003ac8  39290021    addi r9,r9,0x21             
10003acc  396233b4    addi r11,r2,0x33b4          
10003ad0  7d1c49ae    stbx r8,r28,r9              
10003ad4  a98b0000    lha r12,0x0(r11)            
10003ad8  394233b6    addi r10,r2,0x33b6          
10003adc  7d856378    or r5,r12,r12               
10003ae0  398c0001    addi r12,r12,0x1            
10003ae4  7ca50734    extsh r5,r5                 
10003ae8  b18b0000    sth r12,0x0(r11)            
10003aec  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
10003af0  7c6a2b2e    sthx r3,r10,r5              
10003af4  7c860734    extsh r6,r4                 
10003af8  1cc60014    mulli r6,r6,0x14            
10003afc  7cdd32ae    lhax r6,r29,r6              
10003b00  1cc60046    mulli r6,r6,0x46            
10003b04  38c60021    addi r6,r6,0x21             
10003b08  7cdc30ae    lbzx r6,r28,r6              
10003b0c  28060000    cmplwi r6,0x0               
10003b10  40820044    bne 0x10003b54                 ; -> 10003b54
10003b14  7c880734    extsh r8,r4                 
10003b18  1d080014    mulli r8,r8,0x14            
10003b1c  7d1d42ae    lhax r8,r29,r8              
10003b20  38e00001    li r7,0x1                   
10003b24  1d080046    mulli r8,r8,0x46            
10003b28  39080021    addi r8,r8,0x21             
10003b2c  394233b4    addi r10,r2,0x33b4          
10003b30  7cfc41ae    stbx r7,r28,r8              
10003b34  a96a0000    lha r11,0x0(r10)            
10003b38  392233b6    addi r9,r2,0x33b6           
10003b3c  7d6c5b78    or r12,r11,r11              
10003b40  396b0001    addi r11,r11,0x1            
10003b44  7d8c0734    extsh r12,r12               
10003b48  b16a0000    sth r11,0x0(r10)            
10003b4c  558c083c    rlwinm r12,r12,0x1,0x0,0x1e 
10003b50  7c89632e    sthx r4,r9,r12              
10003b54  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10003b58  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10003b5c  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10003b60  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10003b64  4e800020    blr                         
