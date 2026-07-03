; FUN_1002bc64 @ 0x1002bc64
1002bc64  7c0802a6    mfspr r0,LR                 
1002bc68  bdc1ffb8    stmw r14,-0x48(r1)             ; -> Stack[-0x48]
1002bc6c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002bc70  9421ff70    stwu r1,-0x90(r1)              ; -> Stack[-0x90]
1002bc74  7c7e1b78    or r30,r3,r3                
1002bc78  38622f74    addi r3,r2,0x2f74           
1002bc7c  3b826840    addi r28,r2,0x6840          
1002bc80  88630000    lbz r3,0x0(r3)              
1002bc84  3b026bf8    addi r24,r2,0x6bf8          
1002bc88  28030000    cmplwi r3,0x0               
1002bc8c  3ac26bbc    addi r22,r2,0x6bbc          
1002bc90  4182000c    beq 0x1002bc9c                 ; -> 1002bc9c
1002bc94  7fd4f378    or r20,r30,r30              
1002bc98  48000008    b 0x1002bca0                   ; -> 1002bca0
1002bc9c  3a800001    li r20,0x1                  
1002bca0  7fc40734    extsh r4,r30                
1002bca4  1c840070    mulli r4,r4,0x70            
1002bca8  7c9c22ae    lhax r4,r28,r4              
1002bcac  3864000c    addi r3,r4,0xc              
1002bcb0  48002a1d    bl 0x1002e6cc                  ; -> 1002e6cc
1002bcb4  60000000    ori r0,r0,0x0               
1002bcb8  7fc50734    extsh r5,r30                
1002bcbc  1ca50070    mulli r5,r5,0x70            
1002bcc0  38a50004    addi r5,r5,0x4              
1002bcc4  7cbc2aae    lhax r5,r28,r5              
1002bcc8  7c7b1b78    or r27,r3,r3                
1002bccc  38650010    addi r3,r5,0x10             
1002bcd0  48002a29    bl 0x1002e6f8                  ; -> 1002e6f8
1002bcd4  60000000    ori r0,r0,0x0               
1002bcd8  7fc60734    extsh r6,r30                
1002bcdc  1cc60070    mulli r6,r6,0x70            
1002bce0  38c60012    addi r6,r6,0x12             
1002bce4  7cdc32ae    lhax r6,r28,r6              
1002bce8  7c791b78    or r25,r3,r3                
1002bcec  3866000c    addi r3,r6,0xc              
1002bcf0  480029dd    bl 0x1002e6cc                  ; -> 1002e6cc
1002bcf4  60000000    ori r0,r0,0x0               
1002bcf8  7fc70734    extsh r7,r30                
1002bcfc  1ce70070    mulli r7,r7,0x70            
1002bd00  38e70016    addi r7,r7,0x16             
1002bd04  7cfc3aae    lhax r7,r28,r7              
1002bd08  7c701b78    or r16,r3,r3                
1002bd0c  38670010    addi r3,r7,0x10             
1002bd10  480029e9    bl 0x1002e6f8                  ; -> 1002e6f8
1002bd14  60000000    ori r0,r0,0x0               
1002bd18  7f680734    extsh r8,r27                
1002bd1c  7e090734    extsh r9,r16                
1002bd20  7c084800    cmpw r8,r9                  
1002bd24  b061003a    sth r3,0x3a(r1)                ; -> Stack[-0x56]
1002bd28  40820014    bne 0x1002bd3c                 ; -> 1002bd3c
1002bd2c  a961003a    lha r11,0x3a(r1)               ; -> Stack[-0x56]
1002bd30  7f2a0734    extsh r10,r25               
1002bd34  7c0a5800    cmpw r10,r11                
1002bd38  4182000c    beq 0x1002bd44                 ; -> 1002bd44
1002bd3c  3a200001    li r17,0x1                  
1002bd40  48000008    b 0x1002bd48                   ; -> 1002bd48
1002bd44  3a200000    li r17,0x0                  
1002bd48  7f63db78    or r3,r27,r27               
1002bd4c  48002961    bl 0x1002e6ac                  ; -> 1002e6ac
1002bd50  60000000    ori r0,r0,0x0               
1002bd54  7c731b78    or r19,r3,r3                
1002bd58  7f23cb78    or r3,r25,r25               
1002bd5c  48002961    bl 0x1002e6bc                  ; -> 1002e6bc
1002bd60  60000000    ori r0,r0,0x0               
1002bd64  7f6c0734    extsh r12,r27               
1002bd68  7c721b78    or r18,r3,r3                
1002bd6c  7f230734    extsh r3,r25                
1002bd70  1d8c003c    mulli r12,r12,0x3c          
1002bd74  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1002bd78  7d8c1a14    add r12,r12,r3              
1002bd7c  7d98602e    lwzx r12,r24,r12            
1002bd80  5595063e    rlwinm r21,r12,0x0,0x18,0x1f
1002bd84  7ea40734    extsh r4,r21                
1002bd88  2c040000    cmpwi r4,0x0                
1002bd8c  41820cbc    beq 0x1002ca48                 ; -> 1002ca48
1002bd90  7ea50734    extsh r5,r21                
1002bd94  2c050019    cmpwi r5,0x19               
1002bd98  40810054    ble 0x1002bdec                 ; -> 1002bdec
1002bd9c  7ea60734    extsh r6,r21                
1002bda0  2c060023    cmpwi r6,0x23               
1002bda4  40800048    bge 0x1002bdec                 ; -> 1002bdec
1002bda8  7fc70734    extsh r7,r30                
1002bdac  1ce70070    mulli r7,r7,0x70            
1002bdb0  7cfc3aae    lhax r7,r28,r7              
1002bdb4  3867000c    addi r3,r7,0xc              
1002bdb8  48002915    bl 0x1002e6cc                  ; -> 1002e6cc
1002bdbc  60000000    ori r0,r0,0x0               
1002bdc0  7fc80734    extsh r8,r30                
1002bdc4  1d080070    mulli r8,r8,0x70            
1002bdc8  7c630734    extsh r3,r3                 
1002bdcc  7d1c42ae    lhax r8,r28,r8              
1002bdd0  7c6f1b78    or r15,r3,r3                
1002bdd4  38680012    addi r3,r8,0x12             
1002bdd8  480028f5    bl 0x1002e6cc                  ; -> 1002e6cc
1002bddc  60000000    ori r0,r0,0x0               
1002bde0  7c630734    extsh r3,r3                 
1002bde4  7c037800    cmpw r3,r15                 
1002bde8  40820c60    bne 0x1002ca48                 ; -> 1002ca48
1002bdec  7f690734    extsh r9,r27                
1002bdf0  7f2a0734    extsh r10,r25               
1002bdf4  1d29003c    mulli r9,r9,0x3c            
1002bdf8  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
1002bdfc  7d295214    add r9,r9,r10               
1002be00  7d38482e    lwzx r9,r24,r9              
1002be04  55290528    rlwinm r9,r9,0x0,0x14,0x14  
1002be08  2c090000    cmpwi r9,0x0                
1002be0c  41820c3c    beq 0x1002ca48                 ; -> 1002ca48
1002be10  7eab0734    extsh r11,r21               
1002be14  2c0b0004    cmpwi r11,0x4               
1002be18  4080007c    bge 0x1002be94                 ; -> 1002be94
1002be1c  7fcc0734    extsh r12,r30               
1002be20  1d8c0070    mulli r12,r12,0x70          
1002be24  398c0004    addi r12,r12,0x4            
1002be28  7c7c62ae    lhax r3,r28,r12             
1002be2c  480028cd    bl 0x1002e6f8                  ; -> 1002e6f8
1002be30  60000000    ori r0,r0,0x0               
1002be34  7c630734    extsh r3,r3                 
1002be38  7f2f0734    extsh r15,r25               
1002be3c  7c0f1800    cmpw r15,r3                 
1002be40  40820c08    bne 0x1002ca48                 ; -> 1002ca48
1002be44  7fc40734    extsh r4,r30                
1002be48  7ea30734    extsh r3,r21                
1002be4c  38840001    addi r4,r4,0x1              
1002be50  7c032000    cmpw r3,r4                  
1002be54  41820010    beq 0x1002be64                 ; -> 1002be64
1002be58  7ea50734    extsh r5,r21                
1002be5c  2c050001    cmpwi r5,0x1                
1002be60  40820be8    bne 0x1002ca48                 ; -> 1002ca48
1002be64  7fc70734    extsh r7,r30                
1002be68  1ce70070    mulli r7,r7,0x70            
1002be6c  38c00001    li r6,0x1                   
1002be70  38e70029    addi r7,r7,0x29             
1002be74  7cdc39ae    stbx r6,r28,r7              
1002be78  7fc3f378    or r3,r30,r30               
1002be7c  4bfecb9d    bl 0x10018a18                  ; -> 10018a18
1002be80  60000000    ori r0,r0,0x0               
1002be84  38600027    li r3,0x27                  
1002be88  3880000a    li r4,0xa                   
1002be8c  4bfff195    bl 0x1002b020                  ; -> 1002b020
1002be90  48000bb8    b 0x1002ca48                   ; -> 1002ca48
1002be94  7ea80734    extsh r8,r21                
1002be98  2c080007    cmpwi r8,0x7                
1002be9c  41800bac    blt 0x1002ca48                 ; -> 1002ca48
1002bea0  7ea90734    extsh r9,r21                
1002bea4  2c09000a    cmpwi r9,0xa                
1002bea8  408001ec    bge 0x1002c094                 ; -> 1002c094
1002beac  7eaa0734    extsh r10,r21               
1002beb0  2c0a0006    cmpwi r10,0x6               
1002beb4  408101e0    ble 0x1002c094                 ; -> 1002c094
1002beb8  7fcc0734    extsh r12,r30               
1002bebc  7eab0734    extsh r11,r21               
1002bec0  398c0007    addi r12,r12,0x7            
1002bec4  7c0b6000    cmpw r11,r12                
1002bec8  41820010    beq 0x1002bed8                 ; -> 1002bed8
1002becc  7eaf0734    extsh r15,r21               
1002bed0  2c0f0007    cmpwi r15,0x7               
1002bed4  40820b74    bne 0x1002ca48                 ; -> 1002ca48
1002bed8  38600014    li r3,0x14                  
1002bedc  3880000a    li r4,0xa                   
1002bee0  4bfff141    bl 0x1002b020                  ; -> 1002b020
1002bee4  80760000    lwz r3,0x0(r22)             
1002bee8  7ea4ab78    or r4,r21,r21               
1002beec  7e659b78    or r5,r19,r19               
1002bef0  7e469378    or r6,r18,r18               
1002bef4  4bfd819d    bl 0x10004090                  ; -> 10004090
1002bef8  60000000    ori r0,r0,0x0               
1002befc  80760000    lwz r3,0x0(r22)             
1002bf00  7ea4ab78    or r4,r21,r21               
1002bf04  7e659b78    or r5,r19,r19               
1002bf08  7e469378    or r6,r18,r18               
1002bf0c  38e00000    li r7,0x0                   
1002bf10  3900ffb0    li r8,-0x50                 
1002bf14  39200001    li r9,0x1                   
1002bf18  4bffb9a5    bl 0x100278bc                  ; -> 100278bc
1002bf1c  7f630734    extsh r3,r27                
1002bf20  7f240734    extsh r4,r25                
1002bf24  3cc0ffff    lis r6,-0x1                 
1002bf28  1c63003c    mulli r3,r3,0x3c            
1002bf2c  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002bf30  7c632214    add r3,r3,r4                
1002bf34  7cb8182e    lwzx r5,r24,r3              
1002bf38  38c61000    addi r6,r6,0x1000           
1002bf3c  7ca53038    and r5,r5,r6                
1002bf40  38e269fc    addi r7,r2,0x69fc           
1002bf44  7cb8192e    stwx r5,r24,r3              
1002bf48  88e70000    lbz r7,0x0(r7)              
1002bf4c  28070000    cmplwi r7,0x0               
1002bf50  40820018    bne 0x1002bf68                 ; -> 1002bf68
1002bf54  39000001    li r8,0x1                   
1002bf58  991c0097    stb r8,0x97(r28)            
1002bf5c  39200001    li r9,0x1                   
1002bf60  993c0107    stb r9,0x107(r28)           
1002bf64  48000018    b 0x1002bf7c                   ; -> 1002bf7c
1002bf68  7fcb0734    extsh r11,r30               
1002bf6c  1d6b0070    mulli r11,r11,0x70          
1002bf70  39400001    li r10,0x1                  
1002bf74  396b0027    addi r11,r11,0x27           
1002bf78  7d5c59ae    stbx r10,r28,r11            
1002bf7c  3ba00001    li r29,0x1                  
1002bf80  48000104    b 0x1002c084                   ; -> 1002c084
1002bf84  3be00001    li r31,0x1                  
1002bf88  480000ec    b 0x1002c074                   ; -> 1002c074
1002bf8c  7fac0734    extsh r12,r29               
1002bf90  7fef0734    extsh r15,r31               
1002bf94  1d8c003c    mulli r12,r12,0x3c          
1002bf98  55ef103a    rlwinm r15,r15,0x2,0x0,0x1d 
1002bf9c  7d8c7a14    add r12,r12,r15             
1002bfa0  7d98602e    lwzx r12,r24,r12            
1002bfa4  7ea40734    extsh r4,r21                
1002bfa8  5597063e    rlwinm r23,r12,0x0,0x18,0x1f
1002bfac  7ee30734    extsh r3,r23                
1002bfb0  38630003    addi r3,r3,0x3              
1002bfb4  7c032000    cmpw r3,r4                  
1002bfb8  408200b8    bne 0x1002c070                 ; -> 1002c070
1002bfbc  7fa50734    extsh r5,r29                
1002bfc0  7fe60734    extsh r6,r31                
1002bfc4  1ca5003c    mulli r5,r5,0x3c            
1002bfc8  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002bfcc  7ca53214    add r5,r5,r6                
1002bfd0  7cb8282e    lwzx r5,r24,r5              
1002bfd4  54a50528    rlwinm r5,r5,0x0,0x14,0x14  
1002bfd8  2c050000    cmpwi r5,0x0                
1002bfdc  41820094    beq 0x1002c070                 ; -> 1002c070
1002bfe0  7fe3fb78    or r3,r31,r31               
1002bfe4  480026d9    bl 0x1002e6bc                  ; -> 1002e6bc
1002bfe8  60000000    ori r0,r0,0x0               
1002bfec  7c6f1b78    or r15,r3,r3                
1002bff0  7fa3eb78    or r3,r29,r29               
1002bff4  480026b9    bl 0x1002e6ac                  ; -> 1002e6ac
1002bff8  60000000    ori r0,r0,0x0               
1002bffc  7c6e1b78    or r14,r3,r3                
1002c000  80760000    lwz r3,0x0(r22)             
1002c004  7ee4bb78    or r4,r23,r23               
1002c008  7dc57378    or r5,r14,r14               
1002c00c  7de67b78    or r6,r15,r15               
1002c010  4bfd8081    bl 0x10004090                  ; -> 10004090
1002c014  60000000    ori r0,r0,0x0               
1002c018  7fe3fb78    or r3,r31,r31               
1002c01c  480026a1    bl 0x1002e6bc                  ; -> 1002e6bc
1002c020  60000000    ori r0,r0,0x0               
1002c024  7c6f1b78    or r15,r3,r3                
1002c028  7fa3eb78    or r3,r29,r29               
1002c02c  48002681    bl 0x1002e6ac                  ; -> 1002e6ac
1002c030  60000000    ori r0,r0,0x0               
1002c034  7c6e1b78    or r14,r3,r3                
1002c038  80760000    lwz r3,0x0(r22)             
1002c03c  3897fffd    subi r4,r23,0x3             
1002c040  7dc57378    or r5,r14,r14               
1002c044  7de67b78    or r6,r15,r15               
1002c048  4bfd80c1    bl 0x10004108                  ; -> 10004108
1002c04c  60000000    ori r0,r0,0x0               
1002c050  7fa80734    extsh r8,r29                
1002c054  7fe90734    extsh r9,r31                
1002c058  7ee70734    extsh r7,r23                
1002c05c  1d08003c    mulli r8,r8,0x3c            
1002c060  5529103a    rlwinm r9,r9,0x2,0x0,0x1d   
1002c064  38e708fd    addi r7,r7,0x8fd            
1002c068  7d084a14    add r8,r8,r9                
1002c06c  7cf8412e    stwx r7,r24,r8              
1002c070  3bff0001    addi r31,r31,0x1            
1002c074  7fea0734    extsh r10,r31               
1002c078  2c0a000d    cmpwi r10,0xd               
1002c07c  4081ff10    ble 0x1002bf8c                 ; -> 1002bf8c
1002c080  3bbd0001    addi r29,r29,0x1            
1002c084  7fab0734    extsh r11,r29               
1002c088  2c0b0013    cmpwi r11,0x13              
1002c08c  4081fef8    ble 0x1002bf84                 ; -> 1002bf84
1002c090  480009b8    b 0x1002ca48                   ; -> 1002ca48
1002c094  7eac0734    extsh r12,r21               
1002c098  2c0c001a    cmpwi r12,0x1a              
1002c09c  41800010    blt 0x1002c0ac                 ; -> 1002c0ac
1002c0a0  7eae0734    extsh r14,r21               
1002c0a4  2c0e002d    cmpwi r14,0x2d              
1002c0a8  408103dc    ble 0x1002c484                 ; -> 1002c484
1002c0ac  7eaf0734    extsh r15,r21               
1002c0b0  2c0f00ff    cmpwi r15,0xff              
1002c0b4  40820084    bne 0x1002c138                 ; -> 1002c138
1002c0b8  38826ba4    addi r4,r2,0x6ba4           
1002c0bc  38b30004    addi r5,r19,0x4             
1002c0c0  80640000    lwz r3,0x0(r4)              
1002c0c4  38d20004    addi r6,r18,0x4             
1002c0c8  38800010    li r4,0x10                  
1002c0cc  4bfd7fc5    bl 0x10004090                  ; -> 10004090
1002c0d0  60000000    ori r0,r0,0x0               
1002c0d4  7f660734    extsh r6,r27                
1002c0d8  7f270734    extsh r7,r25                
1002c0dc  38a00001    li r5,0x1                   
1002c0e0  98a10038    stb r5,0x38(r1)                ; -> Stack[-0x58]
1002c0e4  1cc6003c    mulli r6,r6,0x3c            
1002c0e8  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
1002c0ec  7cc63a14    add r6,r6,r7                
1002c0f0  7cd8302e    lwzx r6,r24,r6              
1002c0f4  80760000    lwz r3,0x0(r22)             
1002c0f8  7cd58670    srawi r21,r6,0x10           
1002c0fc  7ea4ab78    or r4,r21,r21               
1002c100  7e659b78    or r5,r19,r19               
1002c104  7e469378    or r6,r18,r18               
1002c108  38e00000    li r7,0x0                   
1002c10c  3900ffb0    li r8,-0x50                 
1002c110  39200001    li r9,0x1                   
1002c114  4bffb7a9    bl 0x100278bc                  ; -> 100278bc
1002c118  7f690734    extsh r9,r27                
1002c11c  7f2a0734    extsh r10,r25               
1002c120  1d29003c    mulli r9,r9,0x3c            
1002c124  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
1002c128  39000000    li r8,0x0                   
1002c12c  7d295214    add r9,r9,r10               
1002c130  7d18492e    stwx r8,r24,r9              
1002c134  48000044    b 0x1002c178                   ; -> 1002c178
1002c138  80760000    lwz r3,0x0(r22)             
1002c13c  7ea4ab78    or r4,r21,r21               
1002c140  7e659b78    or r5,r19,r19               
1002c144  7e469378    or r6,r18,r18               
1002c148  4bfd7f49    bl 0x10004090                  ; -> 10004090
1002c14c  60000000    ori r0,r0,0x0               
1002c150  80760000    lwz r3,0x0(r22)             
1002c154  7ea4ab78    or r4,r21,r21               
1002c158  7e659b78    or r5,r19,r19               
1002c15c  7e469378    or r6,r18,r18               
1002c160  38e00000    li r7,0x0                   
1002c164  3900ffb0    li r8,-0x50                 
1002c168  39200001    li r9,0x1                   
1002c16c  4bffb751    bl 0x100278bc                  ; -> 100278bc
1002c170  39600000    li r11,0x0                  
1002c174  99610038    stb r11,0x38(r1)               ; -> Stack[-0x58]
1002c178  7eac0734    extsh r12,r21               
1002c17c  2c0c000a    cmpwi r12,0xa               
1002c180  4082003c    bne 0x1002c1bc                 ; -> 1002c1bc
1002c184  38600015    li r3,0x15                  
1002c188  3880000a    li r4,0xa                   
1002c18c  4bffee95    bl 0x1002b020                  ; -> 1002b020
1002c190  7e8e0734    extsh r14,r20               
1002c194  1dce0070    mulli r14,r14,0x70          
1002c198  39ce003c    addi r14,r14,0x3c           
1002c19c  7dfc702e    lwzx r15,r28,r14            
1002c1a0  38624e7a    addi r3,r2,0x4e7a           
1002c1a4  39ef01f4    addi r15,r15,0x1f4          
1002c1a8  7dfc712e    stwx r15,r28,r14            
1002c1ac  a8830000    lha r4,0x0(r3)              
1002c1b0  38840001    addi r4,r4,0x1              
1002c1b4  b0830000    sth r4,0x0(r3)              
1002c1b8  48000208    b 0x1002c3c0                   ; -> 1002c3c0
1002c1bc  7ea50734    extsh r5,r21                
1002c1c0  2c05000b    cmpwi r5,0xb                
1002c1c4  40820014    bne 0x1002c1d8                 ; -> 1002c1d8
1002c1c8  38600016    li r3,0x16                  
1002c1cc  3880000a    li r4,0xa                   
1002c1d0  4bffee51    bl 0x1002b020                  ; -> 1002b020
1002c1d4  480001ec    b 0x1002c3c0                   ; -> 1002c3c0
1002c1d8  7ea60734    extsh r6,r21                
1002c1dc  2c06000b    cmpwi r6,0xb                
1002c1e0  40810030    ble 0x1002c210                 ; -> 1002c210
1002c1e4  7ea70734    extsh r7,r21                
1002c1e8  2c070010    cmpwi r7,0x10               
1002c1ec  40800024    bge 0x1002c210                 ; -> 1002c210
1002c1f0  38600017    li r3,0x17                  
1002c1f4  3880000a    li r4,0xa                   
1002c1f8  4bffee29    bl 0x1002b020                  ; -> 1002b020
1002c1fc  7e83a378    or r3,r20,r20               
1002c200  3895fff6    subi r4,r21,0xa             
1002c204  4bfe5225    bl 0x10011428                  ; -> 10011428
1002c208  60000000    ori r0,r0,0x0               
1002c20c  480001b4    b 0x1002c3c0                   ; -> 1002c3c0
1002c210  7ea80734    extsh r8,r21                
1002c214  2c080010    cmpwi r8,0x10               
1002c218  40820024    bne 0x1002c23c                 ; -> 1002c23c
1002c21c  38600018    li r3,0x18                  
1002c220  3880000a    li r4,0xa                   
1002c224  4bffedfd    bl 0x1002b020                  ; -> 1002b020
1002c228  7e83a378    or r3,r20,r20               
1002c22c  38800001    li r4,0x1                   
1002c230  4bfe2799    bl 0x1000e9c8                  ; -> 1000e9c8
1002c234  60000000    ori r0,r0,0x0               
1002c238  48000188    b 0x1002c3c0                   ; -> 1002c3c0
1002c23c  7ea90734    extsh r9,r21                
1002c240  2c090011    cmpwi r9,0x11               
1002c244  40820024    bne 0x1002c268                 ; -> 1002c268
1002c248  38600019    li r3,0x19                  
1002c24c  3880000a    li r4,0xa                   
1002c250  4bffedd1    bl 0x1002b020                  ; -> 1002b020
1002c254  7e83a378    or r3,r20,r20               
1002c258  38800001    li r4,0x1                   
1002c25c  4bfe28d9    bl 0x1000eb34                  ; -> 1000eb34
1002c260  60000000    ori r0,r0,0x0               
1002c264  4800015c    b 0x1002c3c0                   ; -> 1002c3c0
1002c268  7eaa0734    extsh r10,r21               
1002c26c  2c0a0012    cmpwi r10,0x12              
1002c270  40820024    bne 0x1002c294                 ; -> 1002c294
1002c274  3860001a    li r3,0x1a                  
1002c278  3880000a    li r4,0xa                   
1002c27c  4bffeda5    bl 0x1002b020                  ; -> 1002b020
1002c280  7e83a378    or r3,r20,r20               
1002c284  38800001    li r4,0x1                   
1002c288  4bfe29c9    bl 0x1000ec50                  ; -> 1000ec50
1002c28c  60000000    ori r0,r0,0x0               
1002c290  48000130    b 0x1002c3c0                   ; -> 1002c3c0
1002c294  7eab0734    extsh r11,r21               
1002c298  2c0b0012    cmpwi r11,0x12              
1002c29c  40810034    ble 0x1002c2d0                 ; -> 1002c2d0
1002c2a0  7eac0734    extsh r12,r21               
1002c2a4  2c0c0017    cmpwi r12,0x17              
1002c2a8  40800028    bge 0x1002c2d0                 ; -> 1002c2d0
1002c2ac  3860001b    li r3,0x1b                  
1002c2b0  3880000a    li r4,0xa                   
1002c2b4  4bffed6d    bl 0x1002b020                  ; -> 1002b020
1002c2b8  39d5ffee    subi r14,r21,0x12           
1002c2bc  1c8e09c4    mulli r4,r14,0x9c4          
1002c2c0  7e83a378    or r3,r20,r20               
1002c2c4  4bfe312d    bl 0x1000f3f0                  ; -> 1000f3f0
1002c2c8  60000000    ori r0,r0,0x0               
1002c2cc  480000f4    b 0x1002c3c0                   ; -> 1002c3c0
1002c2d0  7eaf0734    extsh r15,r21               
1002c2d4  2c0f0017    cmpwi r15,0x17              
1002c2d8  4082003c    bne 0x1002c314                 ; -> 1002c314
1002c2dc  3860001c    li r3,0x1c                  
1002c2e0  3880000a    li r4,0xa                   
1002c2e4  4bffed3d    bl 0x1002b020                  ; -> 1002b020
1002c2e8  7e830734    extsh r3,r20                
1002c2ec  1c630070    mulli r3,r3,0x70            
1002c2f0  3863003c    addi r3,r3,0x3c             
1002c2f4  7c9c182e    lwzx r4,r28,r3              
1002c2f8  38a24e78    addi r5,r2,0x4e78           
1002c2fc  388403e8    addi r4,r4,0x3e8            
1002c300  7c9c192e    stwx r4,r28,r3              
1002c304  a8c50000    lha r6,0x0(r5)              
1002c308  38c60001    addi r6,r6,0x1              
1002c30c  b0c50000    sth r6,0x0(r5)              
1002c310  480000b0    b 0x1002c3c0                   ; -> 1002c3c0
1002c314  7ea70734    extsh r7,r21                
1002c318  2c070018    cmpwi r7,0x18               
1002c31c  4082003c    bne 0x1002c358                 ; -> 1002c358
1002c320  3860001d    li r3,0x1d                  
1002c324  3880000a    li r4,0xa                   
1002c328  4bffecf9    bl 0x1002b020                  ; -> 1002b020
1002c32c  7e880734    extsh r8,r20                
1002c330  1d080070    mulli r8,r8,0x70            
1002c334  3908003c    addi r8,r8,0x3c             
1002c338  7d3c402e    lwzx r9,r28,r8              
1002c33c  39424e76    addi r10,r2,0x4e76          
1002c340  392907d0    addi r9,r9,0x7d0            
1002c344  7d3c412e    stwx r9,r28,r8              
1002c348  a96a0000    lha r11,0x0(r10)            
1002c34c  396b0001    addi r11,r11,0x1            
1002c350  b16a0000    sth r11,0x0(r10)            
1002c354  4800006c    b 0x1002c3c0                   ; -> 1002c3c0
1002c358  7eac0734    extsh r12,r21               
1002c35c  2c0c0019    cmpwi r12,0x19              
1002c360  4082003c    bne 0x1002c39c                 ; -> 1002c39c
1002c364  3860001e    li r3,0x1e                  
1002c368  3880000a    li r4,0xa                   
1002c36c  4bffecb5    bl 0x1002b020                  ; -> 1002b020
1002c370  7e8e0734    extsh r14,r20               
1002c374  1dce0070    mulli r14,r14,0x70          
1002c378  39ce003c    addi r14,r14,0x3c           
1002c37c  7dfc702e    lwzx r15,r28,r14            
1002c380  38624e74    addi r3,r2,0x4e74           
1002c384  39ef1388    addi r15,r15,0x1388         
1002c388  7dfc712e    stwx r15,r28,r14            
1002c38c  a8830000    lha r4,0x0(r3)              
1002c390  38840001    addi r4,r4,0x1              
1002c394  b0830000    sth r4,0x0(r3)              
1002c398  48000028    b 0x1002c3c0                   ; -> 1002c3c0
1002c39c  7ea50734    extsh r5,r21                
1002c3a0  2c05002e    cmpwi r5,0x2e               
1002c3a4  4082001c    bne 0x1002c3c0                 ; -> 1002c3c0
1002c3a8  3860002b    li r3,0x2b                  
1002c3ac  3880000a    li r4,0xa                   
1002c3b0  4bffec71    bl 0x1002b020                  ; -> 1002b020
1002c3b4  38e27124    addi r7,r2,0x7124           
1002c3b8  38c00258    li r6,0x258                 
1002c3bc  90c70000    stw r6,0x0(r7)              
1002c3c0  7ea80734    extsh r8,r21                
1002c3c4  2c08002f    cmpwi r8,0x2f               
1002c3c8  4082001c    bne 0x1002c3e4                 ; -> 1002c3e4
1002c3cc  38600026    li r3,0x26                  
1002c3d0  3880000a    li r4,0xa                   
1002c3d4  4bffec4d    bl 0x1002b020                  ; -> 1002b020
1002c3d8  4bfea751    bl 0x10016b28                  ; -> 10016b28
1002c3dc  60000000    ori r0,r0,0x0               
1002c3e0  48000078    b 0x1002c458                   ; -> 1002c458
1002c3e4  7ea90734    extsh r9,r21                
1002c3e8  2c090030    cmpwi r9,0x30               
1002c3ec  40820020    bne 0x1002c40c                 ; -> 1002c40c
1002c3f0  38600029    li r3,0x29                  
1002c3f4  3880000a    li r4,0xa                   
1002c3f8  4bffec29    bl 0x1002b020                  ; -> 1002b020
1002c3fc  7fc3f378    or r3,r30,r30               
1002c400  4bfe8829    bl 0x10014c28                  ; -> 10014c28
1002c404  60000000    ori r0,r0,0x0               
1002c408  48000050    b 0x1002c458                   ; -> 1002c458
1002c40c  7eaa0734    extsh r10,r21               
1002c410  2c0a0031    cmpwi r10,0x31              
1002c414  40820020    bne 0x1002c434                 ; -> 1002c434
1002c418  3860002a    li r3,0x2a                  
1002c41c  3880000a    li r4,0xa                   
1002c420  4bffec01    bl 0x1002b020                  ; -> 1002b020
1002c424  7fc3f378    or r3,r30,r30               
1002c428  4bfd9015    bl 0x1000543c                  ; -> 1000543c
1002c42c  60000000    ori r0,r0,0x0               
1002c430  48000028    b 0x1002c458                   ; -> 1002c458
1002c434  7eab0734    extsh r11,r21               
1002c438  2c0b0032    cmpwi r11,0x32              
1002c43c  4082001c    bne 0x1002c458                 ; -> 1002c458
1002c440  38600028    li r3,0x28                  
1002c444  3880000a    li r4,0xa                   
1002c448  4bffebd9    bl 0x1002b020                  ; -> 1002b020
1002c44c  7fc3f378    or r3,r30,r30               
1002c450  4bfe887d    bl 0x10014ccc                  ; -> 10014ccc
1002c454  60000000    ori r0,r0,0x0               
1002c458  7f6c0734    extsh r12,r27               
1002c45c  7f2e0734    extsh r14,r25               
1002c460  3c60ffff    lis r3,-0x1                 
1002c464  1d8c003c    mulli r12,r12,0x3c          
1002c468  55ce103a    rlwinm r14,r14,0x2,0x0,0x1d 
1002c46c  7d8c7214    add r12,r12,r14             
1002c470  7df8602e    lwzx r15,r24,r12            
1002c474  38631000    addi r3,r3,0x1000           
1002c478  7def1838    and r15,r15,r3              
1002c47c  7df8612e    stwx r15,r24,r12            
1002c480  480005c8    b 0x1002ca48                   ; -> 1002ca48
1002c484  7ea40734    extsh r4,r21                
1002c488  2c040023    cmpwi r4,0x23               
1002c48c  40810034    ble 0x1002c4c0                 ; -> 1002c4c0
1002c490  5625063e    rlwinm r5,r17,0x0,0x18,0x1f 
1002c494  28050000    cmplwi r5,0x0               
1002c498  418205b0    beq 0x1002ca48                 ; -> 1002ca48
1002c49c  7ea3ab78    or r3,r21,r21               
1002c4a0  7f64db78    or r4,r27,r27               
1002c4a4  7f25cb78    or r5,r25,r25               
1002c4a8  4bfea09d    bl 0x10016544                  ; -> 10016544
1002c4ac  60000000    ori r0,r0,0x0               
1002c4b0  3860002c    li r3,0x2c                  
1002c4b4  3880000a    li r4,0xa                   
1002c4b8  4bffeb69    bl 0x1002b020                  ; -> 1002b020
1002c4bc  4800058c    b 0x1002ca48                   ; -> 1002ca48
1002c4c0  7ea60734    extsh r6,r21                
1002c4c4  2c06001a    cmpwi r6,0x1a               
1002c4c8  40820114    bne 0x1002c5dc                 ; -> 1002c5dc
1002c4cc  3b400000    li r26,0x0                  
1002c4d0  3ba00001    li r29,0x1                  
1002c4d4  480000ec    b 0x1002c5c0                   ; -> 1002c5c0
1002c4d8  3be00001    li r31,0x1                  
1002c4dc  480000c8    b 0x1002c5a4                   ; -> 1002c5a4
1002c4e0  7fa70734    extsh r7,r29                
1002c4e4  7fe80734    extsh r8,r31                
1002c4e8  1ce7003c    mulli r7,r7,0x3c            
1002c4ec  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
1002c4f0  7ce74214    add r7,r7,r8                
1002c4f4  7cf8382e    lwzx r7,r24,r7              
1002c4f8  54e7063e    rlwinm r7,r7,0x0,0x18,0x1f  
1002c4fc  2c07001b    cmpwi r7,0x1b               
1002c500  408200a0    bne 0x1002c5a0                 ; -> 1002c5a0
1002c504  7fcb0734    extsh r11,r30               
1002c508  7fc90734    extsh r9,r30                
1002c50c  1d6b0070    mulli r11,r11,0x70          
1002c510  1d290070    mulli r9,r9,0x70            
1002c514  396b0004    addi r11,r11,0x4            
1002c518  7d5be850    subf r10,r27,r29            
1002c51c  7d99f850    subf r12,r25,r31            
1002c520  7d3c4aae    lhax r9,r28,r9              
1002c524  554a2834    rlwinm r10,r10,0x5,0x0,0x1a 
1002c528  7d7c5aae    lhax r11,r28,r11            
1002c52c  558c2834    rlwinm r12,r12,0x5,0x0,0x1a 
1002c530  3b400001    li r26,0x1                  
1002c534  7fc3f378    or r3,r30,r30               
1002c538  7c895214    add r4,r9,r10               
1002c53c  7cab6214    add r5,r11,r12              
1002c540  4bfff47d    bl 0x1002b9bc                  ; -> 1002b9bc
1002c544  7fcf0734    extsh r15,r30               
1002c548  1def0070    mulli r15,r15,0x70          
1002c54c  7fc50734    extsh r5,r30                
1002c550  1ca50070    mulli r5,r5,0x70            
1002c554  7ddbe850    subf r14,r27,r29            
1002c558  7fc80734    extsh r8,r30                
1002c55c  1d080070    mulli r8,r8,0x70            
1002c560  7c9be850    subf r4,r27,r29             
1002c564  7cf9f850    subf r7,r25,r31             
1002c568  7c7c7aae    lhax r3,r28,r15             
1002c56c  55ce2834    rlwinm r14,r14,0x5,0x0,0x1a 
1002c570  7c637214    add r3,r3,r14               
1002c574  7c7c7b2e    sthx r3,r28,r15             
1002c578  38a50002    addi r5,r5,0x2              
1002c57c  7cdc2aae    lhax r6,r28,r5              
1002c580  54842834    rlwinm r4,r4,0x5,0x0,0x1a   
1002c584  7cc62214    add r6,r6,r4                
1002c588  7cdc2b2e    sthx r6,r28,r5              
1002c58c  39080004    addi r8,r8,0x4              
1002c590  7d3c42ae    lhax r9,r28,r8              
1002c594  54e72834    rlwinm r7,r7,0x5,0x0,0x1a   
1002c598  7d293a14    add r9,r9,r7                
1002c59c  7d3c432e    sthx r9,r28,r8              
1002c5a0  3bff0001    addi r31,r31,0x1            
1002c5a4  7fea0734    extsh r10,r31               
1002c5a8  2c0a000d    cmpwi r10,0xd               
1002c5ac  41810010    bgt 0x1002c5bc                 ; -> 1002c5bc
1002c5b0  574b063e    rlwinm r11,r26,0x0,0x18,0x1f
1002c5b4  280b0000    cmplwi r11,0x0              
1002c5b8  4182ff28    beq 0x1002c4e0                 ; -> 1002c4e0
1002c5bc  3bbd0001    addi r29,r29,0x1            
1002c5c0  7fac0734    extsh r12,r29               
1002c5c4  2c0c0013    cmpwi r12,0x13              
1002c5c8  41810480    bgt 0x1002ca48                 ; -> 1002ca48
1002c5cc  574e063e    rlwinm r14,r26,0x0,0x18,0x1f
1002c5d0  280e0000    cmplwi r14,0x0              
1002c5d4  4182ff04    beq 0x1002c4d8                 ; -> 1002c4d8
1002c5d8  48000470    b 0x1002ca48                   ; -> 1002ca48
1002c5dc  7eaf0734    extsh r15,r21               
1002c5e0  2c0f001c    cmpwi r15,0x1c              
1002c5e4  40820114    bne 0x1002c6f8                 ; -> 1002c6f8
1002c5e8  3b400000    li r26,0x0                  
1002c5ec  3ba00001    li r29,0x1                  
1002c5f0  480000ec    b 0x1002c6dc                   ; -> 1002c6dc
1002c5f4  3be00001    li r31,0x1                  
1002c5f8  480000c8    b 0x1002c6c0                   ; -> 1002c6c0
1002c5fc  7fa30734    extsh r3,r29                
1002c600  7fe40734    extsh r4,r31                
1002c604  1c63003c    mulli r3,r3,0x3c            
1002c608  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002c60c  7c632214    add r3,r3,r4                
1002c610  7c78182e    lwzx r3,r24,r3              
1002c614  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002c618  2c03001d    cmpwi r3,0x1d               
1002c61c  408200a0    bne 0x1002c6bc                 ; -> 1002c6bc
1002c620  7fc50734    extsh r5,r30                
1002c624  7fc70734    extsh r7,r30                
1002c628  1ca50070    mulli r5,r5,0x70            
1002c62c  1ce70070    mulli r7,r7,0x70            
1002c630  7cdbe850    subf r6,r27,r29             
1002c634  38e70004    addi r7,r7,0x4              
1002c638  7d19f850    subf r8,r25,r31             
1002c63c  7cbc2aae    lhax r5,r28,r5              
1002c640  54c62834    rlwinm r6,r6,0x5,0x0,0x1a   
1002c644  7cfc3aae    lhax r7,r28,r7              
1002c648  7c853214    add r4,r5,r6                
1002c64c  55082834    rlwinm r8,r8,0x5,0x0,0x1a   
1002c650  3b400001    li r26,0x1                  
1002c654  7fc3f378    or r3,r30,r30               
1002c658  7ca74214    add r5,r7,r8                
1002c65c  4bfff361    bl 0x1002b9bc                  ; -> 1002b9bc
1002c660  7fca0734    extsh r10,r30               
1002c664  1d4a0070    mulli r10,r10,0x70          
1002c668  7fce0734    extsh r14,r30               
1002c66c  1dce0070    mulli r14,r14,0x70          
1002c670  7d3be850    subf r9,r27,r29             
1002c674  7fc40734    extsh r4,r30                
1002c678  1c840070    mulli r4,r4,0x70            
1002c67c  7d9be850    subf r12,r27,r29            
1002c680  7c79f850    subf r3,r25,r31             
1002c684  7d7c52ae    lhax r11,r28,r10            
1002c688  55292834    rlwinm r9,r9,0x5,0x0,0x1a   
1002c68c  7d6b4a14    add r11,r11,r9              
1002c690  7d7c532e    sthx r11,r28,r10            
1002c694  39ce0002    addi r14,r14,0x2            
1002c698  7dfc72ae    lhax r15,r28,r14            
1002c69c  558c2834    rlwinm r12,r12,0x5,0x0,0x1a 
1002c6a0  7def6214    add r15,r15,r12             
1002c6a4  7dfc732e    sthx r15,r28,r14            
1002c6a8  38840004    addi r4,r4,0x4              
1002c6ac  7cbc22ae    lhax r5,r28,r4              
1002c6b0  54632834    rlwinm r3,r3,0x5,0x0,0x1a   
1002c6b4  7ca51a14    add r5,r5,r3                
1002c6b8  7cbc232e    sthx r5,r28,r4              
1002c6bc  3bff0001    addi r31,r31,0x1            
1002c6c0  7fe60734    extsh r6,r31                
1002c6c4  2c06000d    cmpwi r6,0xd                
1002c6c8  41810010    bgt 0x1002c6d8                 ; -> 1002c6d8
1002c6cc  5747063e    rlwinm r7,r26,0x0,0x18,0x1f 
1002c6d0  28070000    cmplwi r7,0x0               
1002c6d4  4182ff28    beq 0x1002c5fc                 ; -> 1002c5fc
1002c6d8  3bbd0001    addi r29,r29,0x1            
1002c6dc  7fa80734    extsh r8,r29                
1002c6e0  2c080013    cmpwi r8,0x13               
1002c6e4  41810364    bgt 0x1002ca48                 ; -> 1002ca48
1002c6e8  5749063e    rlwinm r9,r26,0x0,0x18,0x1f 
1002c6ec  28090000    cmplwi r9,0x0               
1002c6f0  4182ff04    beq 0x1002c5f4                 ; -> 1002c5f4
1002c6f4  48000354    b 0x1002ca48                   ; -> 1002ca48
1002c6f8  7eaa0734    extsh r10,r21               
1002c6fc  2c0a001e    cmpwi r10,0x1e              
1002c700  40820114    bne 0x1002c814                 ; -> 1002c814
1002c704  3b400000    li r26,0x0                  
1002c708  3ba00001    li r29,0x1                  
1002c70c  480000ec    b 0x1002c7f8                   ; -> 1002c7f8
1002c710  3be00001    li r31,0x1                  
1002c714  480000c8    b 0x1002c7dc                   ; -> 1002c7dc
1002c718  7fab0734    extsh r11,r29               
1002c71c  7fec0734    extsh r12,r31               
1002c720  1d6b003c    mulli r11,r11,0x3c          
1002c724  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
1002c728  7d6b6214    add r11,r11,r12             
1002c72c  7d78582e    lwzx r11,r24,r11            
1002c730  556b063e    rlwinm r11,r11,0x0,0x18,0x1f
1002c734  2c0b001f    cmpwi r11,0x1f              
1002c738  408200a0    bne 0x1002c7d8                 ; -> 1002c7d8
1002c73c  7fc60734    extsh r6,r30                
1002c740  7fce0734    extsh r14,r30               
1002c744  1cc60070    mulli r6,r6,0x70            
1002c748  1dce0070    mulli r14,r14,0x70          
1002c74c  38c60004    addi r6,r6,0x4              
1002c750  7dfbe850    subf r15,r27,r29            
1002c754  7cf9f850    subf r7,r25,r31             
1002c758  7ddc72ae    lhax r14,r28,r14            
1002c75c  55ef2834    rlwinm r15,r15,0x5,0x0,0x1a 
1002c760  7cdc32ae    lhax r6,r28,r6              
1002c764  54e72834    rlwinm r7,r7,0x5,0x0,0x1a   
1002c768  3b400001    li r26,0x1                  
1002c76c  7fc3f378    or r3,r30,r30               
1002c770  7c8e7a14    add r4,r14,r15              
1002c774  7ca63a14    add r5,r6,r7                
1002c778  4bfff245    bl 0x1002b9bc                  ; -> 1002b9bc
1002c77c  7fc90734    extsh r9,r30                
1002c780  1d290070    mulli r9,r9,0x70            
1002c784  7fcc0734    extsh r12,r30               
1002c788  1d8c0070    mulli r12,r12,0x70          
1002c78c  7d1be850    subf r8,r27,r29             
1002c790  7fc30734    extsh r3,r30                
1002c794  1c630070    mulli r3,r3,0x70            
1002c798  7d7be850    subf r11,r27,r29            
1002c79c  7df9f850    subf r15,r25,r31            
1002c7a0  7d5c4aae    lhax r10,r28,r9             
1002c7a4  55082834    rlwinm r8,r8,0x5,0x0,0x1a   
1002c7a8  7d4a4214    add r10,r10,r8              
1002c7ac  7d5c4b2e    sthx r10,r28,r9             
1002c7b0  398c0002    addi r12,r12,0x2            
1002c7b4  7ddc62ae    lhax r14,r28,r12            
1002c7b8  556b2834    rlwinm r11,r11,0x5,0x0,0x1a 
1002c7bc  7dce5a14    add r14,r14,r11             
1002c7c0  7ddc632e    sthx r14,r28,r12            
1002c7c4  38630004    addi r3,r3,0x4              
1002c7c8  7c9c1aae    lhax r4,r28,r3              
1002c7cc  55ef2834    rlwinm r15,r15,0x5,0x0,0x1a 
1002c7d0  7c847a14    add r4,r4,r15               
1002c7d4  7c9c1b2e    sthx r4,r28,r3              
1002c7d8  3bff0001    addi r31,r31,0x1            
1002c7dc  7fe50734    extsh r5,r31                
1002c7e0  2c05000d    cmpwi r5,0xd                
1002c7e4  41810010    bgt 0x1002c7f4                 ; -> 1002c7f4
1002c7e8  5746063e    rlwinm r6,r26,0x0,0x18,0x1f 
1002c7ec  28060000    cmplwi r6,0x0               
1002c7f0  4182ff28    beq 0x1002c718                 ; -> 1002c718
1002c7f4  3bbd0001    addi r29,r29,0x1            
1002c7f8  7fa70734    extsh r7,r29                
1002c7fc  2c070013    cmpwi r7,0x13               
1002c800  41810248    bgt 0x1002ca48                 ; -> 1002ca48
1002c804  5748063e    rlwinm r8,r26,0x0,0x18,0x1f 
1002c808  28080000    cmplwi r8,0x0               
1002c80c  4182ff04    beq 0x1002c710                 ; -> 1002c710
1002c810  48000238    b 0x1002ca48                   ; -> 1002ca48
1002c814  7ea90734    extsh r9,r21                
1002c818  2c090020    cmpwi r9,0x20               
1002c81c  40820114    bne 0x1002c930                 ; -> 1002c930
1002c820  3b400000    li r26,0x0                  
1002c824  3ba00001    li r29,0x1                  
1002c828  480000ec    b 0x1002c914                   ; -> 1002c914
1002c82c  3be00001    li r31,0x1                  
1002c830  480000c8    b 0x1002c8f8                   ; -> 1002c8f8
1002c834  7faa0734    extsh r10,r29               
1002c838  7feb0734    extsh r11,r31               
1002c83c  1d4a003c    mulli r10,r10,0x3c          
1002c840  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1002c844  7d4a5a14    add r10,r10,r11             
1002c848  7d58502e    lwzx r10,r24,r10            
1002c84c  554a063e    rlwinm r10,r10,0x0,0x18,0x1f
1002c850  2c0a0021    cmpwi r10,0x21              
1002c854  408200a0    bne 0x1002c8f4                 ; -> 1002c8f4
1002c858  7fcf0734    extsh r15,r30               
1002c85c  7fcc0734    extsh r12,r30               
1002c860  1def0070    mulli r15,r15,0x70          
1002c864  1d8c0070    mulli r12,r12,0x70          
1002c868  39ef0004    addi r15,r15,0x4            
1002c86c  7ddbe850    subf r14,r27,r29            
1002c870  7cd9f850    subf r6,r25,r31             
1002c874  7d9c62ae    lhax r12,r28,r12            
1002c878  55ce2834    rlwinm r14,r14,0x5,0x0,0x1a 
1002c87c  7dfc7aae    lhax r15,r28,r15            
1002c880  54c62834    rlwinm r6,r6,0x5,0x0,0x1a   
1002c884  3b400001    li r26,0x1                  
1002c888  7fc3f378    or r3,r30,r30               
1002c88c  7c8c7214    add r4,r12,r14              
1002c890  7caf3214    add r5,r15,r6               
1002c894  4bfff129    bl 0x1002b9bc                  ; -> 1002b9bc
1002c898  7fc80734    extsh r8,r30                
1002c89c  1d080070    mulli r8,r8,0x70            
1002c8a0  7fcb0734    extsh r11,r30               
1002c8a4  1d6b0070    mulli r11,r11,0x70          
1002c8a8  7cfbe850    subf r7,r27,r29             
1002c8ac  7fcf0734    extsh r15,r30               
1002c8b0  1def0070    mulli r15,r15,0x70          
1002c8b4  7d5be850    subf r10,r27,r29            
1002c8b8  7dd9f850    subf r14,r25,r31            
1002c8bc  7d3c42ae    lhax r9,r28,r8              
1002c8c0  54e72834    rlwinm r7,r7,0x5,0x0,0x1a   
1002c8c4  7d293a14    add r9,r9,r7                
1002c8c8  7d3c432e    sthx r9,r28,r8              
1002c8cc  396b0002    addi r11,r11,0x2            
1002c8d0  7d9c5aae    lhax r12,r28,r11            
1002c8d4  554a2834    rlwinm r10,r10,0x5,0x0,0x1a 
1002c8d8  7d8c5214    add r12,r12,r10             
1002c8dc  7d9c5b2e    sthx r12,r28,r11            
1002c8e0  39ef0004    addi r15,r15,0x4            
1002c8e4  7c7c7aae    lhax r3,r28,r15             
1002c8e8  55ce2834    rlwinm r14,r14,0x5,0x0,0x1a 
1002c8ec  7c637214    add r3,r3,r14               
1002c8f0  7c7c7b2e    sthx r3,r28,r15             
1002c8f4  3bff0001    addi r31,r31,0x1            
1002c8f8  7fe40734    extsh r4,r31                
1002c8fc  2c04000d    cmpwi r4,0xd                
1002c900  41810010    bgt 0x1002c910                 ; -> 1002c910
1002c904  5745063e    rlwinm r5,r26,0x0,0x18,0x1f 
1002c908  28050000    cmplwi r5,0x0               
1002c90c  4182ff28    beq 0x1002c834                 ; -> 1002c834
1002c910  3bbd0001    addi r29,r29,0x1            
1002c914  7fa60734    extsh r6,r29                
1002c918  2c060013    cmpwi r6,0x13               
1002c91c  4181012c    bgt 0x1002ca48                 ; -> 1002ca48
1002c920  5747063e    rlwinm r7,r26,0x0,0x18,0x1f 
1002c924  28070000    cmplwi r7,0x0               
1002c928  4182ff04    beq 0x1002c82c                 ; -> 1002c82c
1002c92c  4800011c    b 0x1002ca48                   ; -> 1002ca48
1002c930  7ea80734    extsh r8,r21                
1002c934  2c080022    cmpwi r8,0x22               
1002c938  40820110    bne 0x1002ca48                 ; -> 1002ca48
1002c93c  3b400000    li r26,0x0                  
1002c940  3ba00001    li r29,0x1                  
1002c944  480000ec    b 0x1002ca30                   ; -> 1002ca30
1002c948  3be00001    li r31,0x1                  
1002c94c  480000c8    b 0x1002ca14                   ; -> 1002ca14
1002c950  7fa90734    extsh r9,r29                
1002c954  7fea0734    extsh r10,r31               
1002c958  1d29003c    mulli r9,r9,0x3c            
1002c95c  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
1002c960  7d295214    add r9,r9,r10               
1002c964  7d38482e    lwzx r9,r24,r9              
1002c968  5529063e    rlwinm r9,r9,0x0,0x18,0x1f  
1002c96c  2c090023    cmpwi r9,0x23               
1002c970  408200a0    bne 0x1002ca10                 ; -> 1002ca10
1002c974  7fce0734    extsh r14,r30               
1002c978  7fcb0734    extsh r11,r30               
1002c97c  1dce0070    mulli r14,r14,0x70          
1002c980  1d6b0070    mulli r11,r11,0x70          
1002c984  39ce0004    addi r14,r14,0x4            
1002c988  7d9be850    subf r12,r27,r29            
1002c98c  7df9f850    subf r15,r25,r31            
1002c990  7d7c5aae    lhax r11,r28,r11            
1002c994  558c2834    rlwinm r12,r12,0x5,0x0,0x1a 
1002c998  7ddc72ae    lhax r14,r28,r14            
1002c99c  55ef2834    rlwinm r15,r15,0x5,0x0,0x1a 
1002c9a0  3b400001    li r26,0x1                  
1002c9a4  7fc3f378    or r3,r30,r30               
1002c9a8  7c8b6214    add r4,r11,r12              
1002c9ac  7cae7a14    add r5,r14,r15              
1002c9b0  4bfff00d    bl 0x1002b9bc                  ; -> 1002b9bc
1002c9b4  7fc40734    extsh r4,r30                
1002c9b8  1c840070    mulli r4,r4,0x70            
1002c9bc  7fc70734    extsh r7,r30                
1002c9c0  1ce70070    mulli r7,r7,0x70            
1002c9c4  7c7be850    subf r3,r27,r29             
1002c9c8  7fca0734    extsh r10,r30               
1002c9cc  1d4a0070    mulli r10,r10,0x70          
1002c9d0  7cdbe850    subf r6,r27,r29             
1002c9d4  7d39f850    subf r9,r25,r31             
1002c9d8  7cbc22ae    lhax r5,r28,r4              
1002c9dc  54632834    rlwinm r3,r3,0x5,0x0,0x1a   
1002c9e0  7ca51a14    add r5,r5,r3                
1002c9e4  7cbc232e    sthx r5,r28,r4              
1002c9e8  38e70002    addi r7,r7,0x2              
1002c9ec  7d1c3aae    lhax r8,r28,r7              
1002c9f0  54c62834    rlwinm r6,r6,0x5,0x0,0x1a   
1002c9f4  7d083214    add r8,r8,r6                
1002c9f8  7d1c3b2e    sthx r8,r28,r7              
1002c9fc  394a0004    addi r10,r10,0x4            
1002ca00  7d7c52ae    lhax r11,r28,r10            
1002ca04  55292834    rlwinm r9,r9,0x5,0x0,0x1a   
1002ca08  7d6b4a14    add r11,r11,r9              
1002ca0c  7d7c532e    sthx r11,r28,r10            
1002ca10  3bff0001    addi r31,r31,0x1            
1002ca14  7fec0734    extsh r12,r31               
1002ca18  2c0c000d    cmpwi r12,0xd               
1002ca1c  41810010    bgt 0x1002ca2c                 ; -> 1002ca2c
1002ca20  574e063e    rlwinm r14,r26,0x0,0x18,0x1f
1002ca24  280e0000    cmplwi r14,0x0              
1002ca28  4182ff28    beq 0x1002c950                 ; -> 1002c950
1002ca2c  3bbd0001    addi r29,r29,0x1            
1002ca30  7faf0734    extsh r15,r29               
1002ca34  2c0f0013    cmpwi r15,0x13              
1002ca38  41810010    bgt 0x1002ca48                 ; -> 1002ca48
1002ca3c  5743063e    rlwinm r3,r26,0x0,0x18,0x1f 
1002ca40  28030000    cmplwi r3,0x0               
1002ca44  4182ff04    beq 0x1002c948                 ; -> 1002c948
1002ca48  80010098    lwz r0,0x98(r1)                ; -> Stack[0x8]
1002ca4c  38210090    addi r1,r1,0x90             
1002ca50  7c0803a6    mtspr LR,r0                 
1002ca54  b9c1ffb8    lmw r14,-0x48(r1)              ; -> Stack[-0x48]
1002ca58  4e800020    blr                         
