; FUN_1002b9bc @ 0x1002b9bc
1002b9bc  7c0802a6    mfspr r0,LR                 
1002b9c0  be01ffc0    stmw r16,-0x40(r1)             ; -> Stack[-0x40]
1002b9c4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002b9c8  9421ff80    stwu r1,-0x80(r1)              ; -> Stack[-0x80]
1002b9cc  b061009a    sth r3,0x9a(r1)                ; -> Stack[0x1a]
1002b9d0  7c902378    or r16,r4,r4                
1002b9d4  7cb12b78    or r17,r5,r5                
1002b9d8  a881009a    lha r4,0x9a(r1)                ; -> Stack[0x1a]
1002b9dc  a8c1009a    lha r6,0x9a(r1)                ; -> Stack[0x1a]
1002b9e0  38a26840    addi r5,r2,0x6840           
1002b9e4  3ac00001    li r22,0x1                  
1002b9e8  1c840070    mulli r4,r4,0x70            
1002b9ec  38626840    addi r3,r2,0x6840           
1002b9f0  1cc60070    mulli r6,r6,0x70            
1002b9f4  38a50004    addi r5,r5,0x4              
1002b9f8  7ea322ae    lhax r21,r3,r4              
1002b9fc  7e8532ae    lhax r20,r5,r6              
1002ba00  3b626bb4    addi r27,r2,0x6bb4          
1002ba04  3a62342e    addi r19,r2,0x342e          
1002ba08  7edcb378    or r28,r22,r22              
1002ba0c  7eb8ab78    or r24,r21,r21              
1002ba10  7e97a378    or r23,r20,r20              
1002ba14  3a400000    li r18,0x0                  
1002ba18  4bfea5cd    bl 0x10015fe4                  ; -> 10015fe4
1002ba1c  60000000    ori r0,r0,0x0               
1002ba20  7c7f1b78    or r31,r3,r3                
1002ba24  48000008    b 0x1002ba2c                   ; -> 1002ba2c
1002ba28  3bc00000    li r30,0x0                  
1002ba2c  4bfea5b9    bl 0x10015fe4                  ; -> 10015fe4
1002ba30  60000000    ori r0,r0,0x0               
1002ba34  7c1f1800    cmpw r31,r3                 
1002ba38  4182fff0    beq 0x1002ba28                 ; -> 1002ba28
1002ba3c  4bfea5a9    bl 0x10015fe4                  ; -> 10015fe4
1002ba40  60000000    ori r0,r0,0x0               
1002ba44  7c7f1b78    or r31,r3,r3                
1002ba48  48000008    b 0x1002ba50                   ; -> 1002ba50
1002ba4c  3a520001    addi r18,r18,0x1            
1002ba50  4bfea595    bl 0x10015fe4                  ; -> 10015fe4
1002ba54  60000000    ori r0,r0,0x0               
1002ba58  7c1f1800    cmpw r31,r3                 
1002ba5c  4182fff0    beq 0x1002ba4c                 ; -> 1002ba4c
1002ba60  3a400000    li r18,0x0                  
1002ba64  38600025    li r3,0x25                  
1002ba68  38800064    li r4,0x64                  
1002ba6c  4bfff5b5    bl 0x1002b020                  ; -> 1002b020
1002ba70  4bffcee9    bl 0x10028958                  ; -> 10028958
1002ba74  a901009a    lha r8,0x9a(r1)                ; -> Stack[0x1a]
1002ba78  38e26840    addi r7,r2,0x6840           
1002ba7c  a941009a    lha r10,0x9a(r1)               ; -> Stack[0x1a]
1002ba80  a981009a    lha r12,0x9a(r1)               ; -> Stack[0x1a]
1002ba84  39226840    addi r9,r2,0x6840           
1002ba88  39626840    addi r11,r2,0x6840          
1002ba8c  1d080070    mulli r8,r8,0x70            
1002ba90  38e7000a    addi r7,r7,0xa              
1002ba94  7c67402e    lwzx r3,r7,r8               
1002ba98  1d4a0070    mulli r10,r10,0x70          
1002ba9c  a901009a    lha r8,0x9a(r1)                ; -> Stack[0x1a]
1002baa0  38e26840    addi r7,r2,0x6840           
1002baa4  39290018    addi r9,r9,0x18             
1002baa8  1d8c0070    mulli r12,r12,0x70          
1002baac  396b0014    addi r11,r11,0x14           
1002bab0  1d080070    mulli r8,r8,0x70            
1002bab4  38e70016    addi r7,r7,0x16             
1002bab8  7c8952ae    lhax r4,r9,r10              
1002babc  7cab62ae    lhax r5,r11,r12             
1002bac0  7cc742ae    lhax r6,r7,r8               
1002bac4  4bfd91ed    bl 0x10004cb0                  ; -> 10004cb0
1002bac8  60000000    ori r0,r0,0x0               
1002bacc  a861009a    lha r3,0x9a(r1)                ; -> Stack[0x1a]
1002bad0  4bfe8e71    bl 0x10014940                  ; -> 10014940
1002bad4  60000000    ori r0,r0,0x0               
1002bad8  89330000    lbz r9,0x0(r19)             
1002badc  28090000    cmplwi r9,0x0               
1002bae0  4182000c    beq 0x1002baec                 ; -> 1002baec
1002bae4  4bfd8a9d    bl 0x10004580                  ; -> 10004580
1002bae8  60000000    ori r0,r0,0x0               
1002baec  807b0000    lwz r3,0x0(r27)             
1002baf0  38800001    li r4,0x1                   
1002baf4  7ea5ab78    or r5,r21,r21               
1002baf8  7e86a378    or r6,r20,r20               
1002bafc  4bfd90b9    bl 0x10004bb4                  ; -> 10004bb4
1002bb00  60000000    ori r0,r0,0x0               
1002bb04  4bffcebd    bl 0x100289c0                  ; -> 100289c0
1002bb08  3b400001    li r26,0x1                  
1002bb0c  48000108    b 0x1002bc14                   ; -> 1002bc14
1002bb10  3b9c0001    addi r28,r28,0x1            
1002bb14  7f870734    extsh r7,r28                
1002bb18  7eaa0734    extsh r10,r21               
1002bb1c  7e0b0734    extsh r11,r16               
1002bb20  7d4a5850    subf r10,r10,r11            
1002bb24  7d5a51d6    mullw r10,r26,r10           
1002bb28  398000d4    li r12,0xd4                 
1002bb2c  7d4a63d6    divw r10,r10,r12            
1002bb30  7fb55214    add r29,r21,r10             
1002bb34  7fa30734    extsh r3,r29                
1002bb38  7c630e70    srawi r3,r3,0x1             
1002bb3c  7c630194    addze r3,r3                 
1002bb40  7e840734    extsh r4,r20                
1002bb44  7e250734    extsh r5,r17                
1002bb48  7c842850    subf r4,r4,r5               
1002bb4c  7c9a21d6    mullw r4,r26,r4             
1002bb50  38c000d4    li r6,0xd4                  
1002bb54  7c8433d6    divw r4,r4,r6               
1002bb58  2c07000f    cmpwi r7,0xf                
1002bb5c  547d083c    rlwinm r29,r3,0x1,0x0,0x1e  
1002bb60  7f342214    add r25,r20,r4              
1002bb64  40810008    ble 0x1002bb6c                 ; -> 1002bb6c
1002bb68  3b800001    li r28,0x1                  
1002bb6c  4bfed02d    bl 0x10018b98                  ; -> 10018b98
1002bb70  60000000    ori r0,r0,0x0               
1002bb74  48000008    b 0x1002bb7c                   ; -> 1002bb7c
1002bb78  3bc00000    li r30,0x0                  
1002bb7c  4bfea469    bl 0x10015fe4                  ; -> 10015fe4
1002bb80  60000000    ori r0,r0,0x0               
1002bb84  391f0001    addi r8,r31,0x1             
1002bb88  7c081800    cmpw r8,r3                  
1002bb8c  4181ffec    bgt 0x1002bb78                 ; -> 1002bb78
1002bb90  4bfea455    bl 0x10015fe4                  ; -> 10015fe4
1002bb94  60000000    ori r0,r0,0x0               
1002bb98  7c7f1b78    or r31,r3,r3                
1002bb9c  4bffcdbd    bl 0x10028958                  ; -> 10028958
1002bba0  89330000    lbz r9,0x0(r19)             
1002bba4  28090000    cmplwi r9,0x0               
1002bba8  41820030    beq 0x1002bbd8                 ; -> 1002bbd8
1002bbac  807b0000    lwz r3,0x0(r27)             
1002bbb0  80fb0000    lwz r7,0x0(r27)             
1002bbb4  7ec4b378    or r4,r22,r22               
1002bbb8  7f05c378    or r5,r24,r24               
1002bbbc  7ee6bb78    or r6,r23,r23               
1002bbc0  7f88e378    or r8,r28,r28               
1002bbc4  7fa9eb78    or r9,r29,r29               
1002bbc8  7f2acb78    or r10,r25,r25              
1002bbcc  4bfd88c5    bl 0x10004490                  ; -> 10004490
1002bbd0  60000000    ori r0,r0,0x0               
1002bbd4  4800002c    b 0x1002bc00                   ; -> 1002bc00
1002bbd8  807b0000    lwz r3,0x0(r27)             
1002bbdc  80fb0000    lwz r7,0x0(r27)             
1002bbe0  7ec4b378    or r4,r22,r22               
1002bbe4  7f05c378    or r5,r24,r24               
1002bbe8  7ee6bb78    or r6,r23,r23               
1002bbec  7f88e378    or r8,r28,r28               
1002bbf0  7fa9eb78    or r9,r29,r29               
1002bbf4  7f2acb78    or r10,r25,r25              
1002bbf8  4bfd87a9    bl 0x100043a0                  ; -> 100043a0
1002bbfc  60000000    ori r0,r0,0x0               
1002bc00  4bffcdc1    bl 0x100289c0                  ; -> 100289c0
1002bc04  7fb8eb78    or r24,r29,r29              
1002bc08  7f37cb78    or r23,r25,r25              
1002bc0c  7f96e378    or r22,r28,r28              
1002bc10  3b5a0001    addi r26,r26,0x1            
1002bc14  2c1a00d4    cmpwi r26,0xd4              
1002bc18  4180fef8    blt 0x1002bb10                 ; -> 1002bb10
1002bc1c  4bffcd3d    bl 0x10028958                  ; -> 10028958
1002bc20  807b0000    lwz r3,0x0(r27)             
1002bc24  7ec4b378    or r4,r22,r22               
1002bc28  7f05c378    or r5,r24,r24               
1002bc2c  7ee6bb78    or r6,r23,r23               
1002bc30  4bfd9081    bl 0x10004cb0                  ; -> 10004cb0
1002bc34  60000000    ori r0,r0,0x0               
1002bc38  89530000    lbz r10,0x0(r19)            
1002bc3c  280a0000    cmplwi r10,0x0              
1002bc40  4182000c    beq 0x1002bc4c                 ; -> 1002bc4c
1002bc44  4bfd89a5    bl 0x100045e8                  ; -> 100045e8
1002bc48  60000000    ori r0,r0,0x0               
1002bc4c  4bffcd75    bl 0x100289c0                  ; -> 100289c0
1002bc50  80010088    lwz r0,0x88(r1)                ; -> Stack[0x8]
1002bc54  38210080    addi r1,r1,0x80             
1002bc58  7c0803a6    mtspr LR,r0                 
1002bc5c  ba01ffc0    lmw r16,-0x40(r1)              ; -> Stack[-0x40]
1002bc60  4e800020    blr                         
