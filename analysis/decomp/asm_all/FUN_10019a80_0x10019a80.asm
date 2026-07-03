; FUN_10019a80 @ 0x10019a80
10019a80  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
10019a84  28030000    cmplwi r3,0x0               
10019a88  3bc24f54    addi r30,r2,0x4f54          
10019a8c  3b824f08    addi r28,r2,0x4f08          
10019a90  41820220    beq 0x10019cb0                 ; -> 10019cb0
10019a94  80bc0010    lwz r5,0x10(r28)            
10019a98  80dc000c    lwz r6,0xc(r28)             
10019a9c  83630000    lwz r27,0x0(r3)             
10019aa0  7c053000    cmpw r5,r6                  
10019aa4  41820038    beq 0x10019adc                 ; -> 10019adc
10019aa8  80fc000c    lwz r7,0xc(r28)             
10019aac  3be00000    li r31,0x0                  
10019ab0  90fc0010    stw r7,0x10(r28)            
10019ab4  4800001c    b 0x10019ad0                   ; -> 10019ad0
10019ab8  7fe90734    extsh r9,r31                
10019abc  5529103a    rlwinm r9,r9,0x2,0x0,0x1d   
10019ac0  39000000    li r8,0x0                   
10019ac4  39290014    addi r9,r9,0x14             
10019ac8  7d1c492e    stwx r8,r28,r9              
10019acc  3bff0001    addi r31,r31,0x1            
10019ad0  7fea0734    extsh r10,r31               
10019ad4  2c0a000c    cmpwi r10,0xc               
10019ad8  4180ffe0    blt 0x10019ab8                 ; -> 10019ab8
10019adc  3be00000    li r31,0x0                  
10019ae0  48000020    b 0x10019b00                   ; -> 10019b00
10019ae4  7feb0734    extsh r11,r31               
10019ae8  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
10019aec  396b0014    addi r11,r11,0x14           
10019af0  7d7c582e    lwzx r11,r28,r11            
10019af4  7c0b1840    cmplw r11,r3                
10019af8  418201b8    beq 0x10019cb0                 ; -> 10019cb0
10019afc  3bff0001    addi r31,r31,0x1            
10019b00  7fec0734    extsh r12,r31               
10019b04  2c0c000c    cmpwi r12,0xc               
10019b08  4180ffdc    blt 0x10019ae4                 ; -> 10019ae4
10019b0c  3be00000    li r31,0x0                  
10019b10  480000b4    b 0x10019bc4                   ; -> 10019bc4
10019b14  7fe50734    extsh r5,r31                
10019b18  7fe60734    extsh r6,r31                
10019b1c  1ca50024    mulli r5,r5,0x24            
10019b20  1cc60024    mulli r6,r6,0x24            
10019b24  38a50008    addi r5,r5,0x8              
10019b28  38c60004    addi r6,r6,0x4              
10019b2c  7cbe282e    lwzx r5,r30,r5              
10019b30  7cde302e    lwzx r6,r30,r6              
10019b34  7c053000    cmpw r5,r6                  
10019b38  40810088    ble 0x10019bc0                 ; -> 10019bc0
10019b3c  7fe70734    extsh r7,r31                
10019b40  1ce70024    mulli r7,r7,0x24            
10019b44  7fe90734    extsh r9,r31                
10019b48  1d290024    mulli r9,r9,0x24            
10019b4c  38e70010    addi r7,r7,0x10             
10019b50  7c9e392e    stwx r4,r30,r7              
10019b54  7feb0734    extsh r11,r31               
10019b58  1d6b0024    mulli r11,r11,0x24          
10019b5c  7fe50734    extsh r5,r31                
10019b60  1ca50024    mulli r5,r5,0x24            
10019b64  7fe60734    extsh r6,r31                
10019b68  811b0004    lwz r8,0x4(r27)             
10019b6c  3929000c    addi r9,r9,0xc              
10019b70  7d1e492e    stwx r8,r30,r9              
10019b74  7fe80734    extsh r8,r31                
10019b78  1d080024    mulli r8,r8,0x24            
10019b7c  39400000    li r10,0x0                  
10019b80  396b0014    addi r11,r11,0x14           
10019b84  7d5e592e    stwx r10,r30,r11            
10019b88  7fea0734    extsh r10,r31               
10019b8c  1d4a0024    mulli r10,r10,0x24          
10019b90  1cc60024    mulli r6,r6,0x24            
10019b94  39800000    li r12,0x0                  
10019b98  38a50004    addi r5,r5,0x4              
10019b9c  7d9e292e    stwx r12,r30,r5             
10019ba0  7c7e312e    stwx r3,r30,r6              
10019ba4  38e00000    li r7,0x0                   
10019ba8  39080008    addi r8,r8,0x8              
10019bac  7cfe412e    stwx r7,r30,r8              
10019bb0  813b0000    lwz r9,0x0(r27)             
10019bb4  394a0004    addi r10,r10,0x4            
10019bb8  7d3e512e    stwx r9,r30,r10             
10019bbc  480000f4    b 0x10019cb0                   ; -> 10019cb0
10019bc0  3bff0001    addi r31,r31,0x1            
10019bc4  7feb0734    extsh r11,r31               
10019bc8  2c0b0004    cmpwi r11,0x4               
10019bcc  4180ff48    blt 0x10019b14                 ; -> 10019b14
10019bd0  3ba00000    li r29,0x0                  
10019bd4  7fac0734    extsh r12,r29               
10019bd8  1d8c0024    mulli r12,r12,0x24          
10019bdc  398c0010    addi r12,r12,0x10           
10019be0  7f5e602e    lwzx r26,r30,r12            
10019be4  3be00001    li r31,0x1                  
10019be8  48000034    b 0x10019c1c                   ; -> 10019c1c
10019bec  7fe50734    extsh r5,r31                
10019bf0  1ca50024    mulli r5,r5,0x24            
10019bf4  38a50010    addi r5,r5,0x10             
10019bf8  7cbe282e    lwzx r5,r30,r5              
10019bfc  7c05d000    cmpw r5,r26                 
10019c00  40800018    bge 0x10019c18                 ; -> 10019c18
10019c04  7ffdfb78    or r29,r31,r31              
10019c08  7fa60734    extsh r6,r29                
10019c0c  1cc60024    mulli r6,r6,0x24            
10019c10  38c60010    addi r6,r6,0x10             
10019c14  7f5e302e    lwzx r26,r30,r6             
10019c18  3bff0001    addi r31,r31,0x1            
10019c1c  7fe70734    extsh r7,r31                
10019c20  2c070004    cmpwi r7,0x4                
10019c24  4180ffc8    blt 0x10019bec                 ; -> 10019bec
10019c28  7c1a2000    cmpw r26,r4                 
10019c2c  41810084    bgt 0x10019cb0                 ; -> 10019cb0
10019c30  7fa80734    extsh r8,r29                
10019c34  1d080024    mulli r8,r8,0x24            
10019c38  7faa0734    extsh r10,r29               
10019c3c  1d4a0024    mulli r10,r10,0x24          
10019c40  39080010    addi r8,r8,0x10             
10019c44  7c9e412e    stwx r4,r30,r8              
10019c48  7fac0734    extsh r12,r29               
10019c4c  1d8c0024    mulli r12,r12,0x24          
10019c50  7fa60734    extsh r6,r29                
10019c54  1cc60024    mulli r6,r6,0x24            
10019c58  7fa70734    extsh r7,r29                
10019c5c  813b0004    lwz r9,0x4(r27)             
10019c60  394a000c    addi r10,r10,0xc            
10019c64  7d3e512e    stwx r9,r30,r10             
10019c68  7fa90734    extsh r9,r29                
10019c6c  1d290024    mulli r9,r9,0x24            
10019c70  39600000    li r11,0x0                  
10019c74  398c0014    addi r12,r12,0x14           
10019c78  7d7e612e    stwx r11,r30,r12            
10019c7c  7fab0734    extsh r11,r29               
10019c80  1d6b0024    mulli r11,r11,0x24          
10019c84  1ce70024    mulli r7,r7,0x24            
10019c88  38a00000    li r5,0x0                   
10019c8c  38c60004    addi r6,r6,0x4              
10019c90  7cbe312e    stwx r5,r30,r6              
10019c94  7c7e392e    stwx r3,r30,r7              
10019c98  39000000    li r8,0x0                   
10019c9c  39290008    addi r9,r9,0x8              
10019ca0  7d1e492e    stwx r8,r30,r9              
10019ca4  815b0000    lwz r10,0x0(r27)            
10019ca8  396b0004    addi r11,r11,0x4            
10019cac  7d5e592e    stwx r10,r30,r11            
10019cb0  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
10019cb4  4e800020    blr                         
