; FUN_10021938 @ 0x10021938
10021938  7c0802a6    mfspr r0,LR                 
1002193c  bf01ffe0    stmw r24,-0x20(r1)             ; -> Stack[-0x20]
10021940  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10021944  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10021948  7c7a1b78    or r26,r3,r3                
1002194c  38625324    addi r3,r2,0x5324           
10021950  3b625328    addi r27,r2,0x5328          
10021954  88630000    lbz r3,0x0(r3)              
10021958  28030000    cmplwi r3,0x0               
1002195c  408202a4    bne 0x10021c00                 ; -> 10021c00
10021960  38827564    addi r4,r2,0x7564           
10021964  80640000    lwz r3,0x0(r4)              
10021968  48010159    bl 0x10031ac0                  ; -> 10031ac0
1002196c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021970  38a27568    addi r5,r2,0x7568           
10021974  80650000    lwz r3,0x0(r5)              
10021978  4800f849    bl 0x100311c0                  ; -> 100311c0
1002197c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021980  4800f631    bl 0x10030fb0                  ; -> 10030fb0
10021984  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021988  38c27564    addi r6,r2,0x7564           
1002198c  90610038    stw r3,0x38(r1)                ; -> Stack[-0x28]
10021990  80c60000    lwz r6,0x0(r6)              
10021994  7f63db78    or r3,r27,r27               
10021998  80c60000    lwz r6,0x0(r6)              
1002199c  83260016    lwz r25,0x16(r6)            
100219a0  80f90000    lwz r7,0x0(r25)             
100219a4  80e7002a    lwz r7,0x2a(r7)             
100219a8  90fb0000    stw r7,0x0(r27)             
100219ac  81190000    lwz r8,0x0(r25)             
100219b0  8108002a    lwz r8,0x2a(r8)             
100219b4  81080000    lwz r8,0x0(r8)              
100219b8  83080000    lwz r24,0x0(r8)             
100219bc  4800f625    bl 0x10030fe0                  ; -> 10030fe0
100219c0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
100219c4  807b0000    lwz r3,0x0(r27)             
100219c8  4800fde1    bl 0x100317a8                  ; -> 100317a8
100219cc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
100219d0  807b0000    lwz r3,0x0(r27)             
100219d4  4800f625    bl 0x10030ff8                  ; -> 10030ff8
100219d8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
100219dc  3be00000    li r31,0x0                  
100219e0  48000020    b 0x10021a00                   ; -> 10021a00
100219e4  813b0000    lwz r9,0x0(r27)             
100219e8  7fea0734    extsh r10,r31               
100219ec  81290000    lwz r9,0x0(r9)              
100219f0  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
100219f4  39290008    addi r9,r9,0x8              
100219f8  7fe9532e    sthx r31,r9,r10             
100219fc  3bff0001    addi r31,r31,0x1            
10021a00  819b0000    lwz r12,0x0(r27)            
10021a04  7feb0734    extsh r11,r31               
10021a08  818c0000    lwz r12,0x0(r12)            
10021a0c  a98c0006    lha r12,0x6(r12)            
10021a10  7c0b6000    cmpw r11,r12                
10021a14  4081ffd0    ble 0x100219e4                 ; -> 100219e4
10021a18  807b0000    lwz r3,0x0(r27)             
10021a1c  4800f5f5    bl 0x10031010                  ; -> 10031010
10021a20  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021a24  4800f5a5    bl 0x10030fc8                  ; -> 10030fc8
10021a28  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021a2c  3ba30001    addi r29,r3,0x1             
10021a30  3bc0000a    li r30,0xa                  
10021a34  480001a4    b 0x10021bd8                   ; -> 10021bd8
10021a38  807b0000    lwz r3,0x0(r27)             
10021a3c  9061003c    stw r3,0x3c(r1)                ; -> Stack[-0x24]
10021a40  3861003c    addi r3,r1,0x3c             
10021a44  4800f59d    bl 0x10030fe0                  ; -> 10030fe0
10021a48  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021a4c  8061003c    lwz r3,0x3c(r1)                ; -> Stack[-0x24]
10021a50  4800f5a9    bl 0x10030ff8                  ; -> 10030ff8
10021a54  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021a58  3be00000    li r31,0x0                  
10021a5c  480000bc    b 0x10021b18                   ; -> 10021b18
10021a60  8081003c    lwz r4,0x3c(r1)                ; -> Stack[-0x24]
10021a64  7fe50734    extsh r5,r31                
10021a68  80840000    lwz r4,0x0(r4)              
10021a6c  80e1003c    lwz r7,0x3c(r1)                ; -> Stack[-0x24]
10021a70  54a51838    rlwinm r5,r5,0x3,0x0,0x1c   
10021a74  3884000a    addi r4,r4,0xa              
10021a78  7c842a2e    lhzx r4,r4,r5               
10021a7c  38c0000a    li r6,0xa                   
10021a80  7c8433d6    divw r4,r4,r6               
10021a84  7c84f1d6    mullw r4,r4,r30             
10021a88  80e70000    lwz r7,0x0(r7)              
10021a8c  7fe80734    extsh r8,r31                
10021a90  55081838    rlwinm r8,r8,0x3,0x0,0x1c   
10021a94  38e7000a    addi r7,r7,0xa              
10021a98  7c87432e    sthx r4,r7,r8               
10021a9c  8121003c    lwz r9,0x3c(r1)                ; -> Stack[-0x24]
10021aa0  7fea0734    extsh r10,r31               
10021aa4  81290000    lwz r9,0x0(r9)              
10021aa8  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
10021aac  3929000c    addi r9,r9,0xc              
10021ab0  7d29522e    lhzx r9,r9,r10              
10021ab4  3960000a    li r11,0xa                  
10021ab8  7d295bd6    divw r9,r9,r11              
10021abc  8181003c    lwz r12,0x3c(r1)               ; -> Stack[-0x24]
10021ac0  7fe30734    extsh r3,r31                
10021ac4  818c0000    lwz r12,0x0(r12)            
10021ac8  7d29f1d6    mullw r9,r9,r30             
10021acc  7fe50734    extsh r5,r31                
10021ad0  54631838    rlwinm r3,r3,0x3,0x0,0x1c   
10021ad4  398c000c    addi r12,r12,0xc            
10021ad8  7d2c1b2e    sthx r9,r12,r3              
10021adc  8081003c    lwz r4,0x3c(r1)                ; -> Stack[-0x24]
10021ae0  54a51838    rlwinm r5,r5,0x3,0x0,0x1c   
10021ae4  80840000    lwz r4,0x0(r4)              
10021ae8  38c0000a    li r6,0xa                   
10021aec  3884000e    addi r4,r4,0xe              
10021af0  7c842a2e    lhzx r4,r4,r5               
10021af4  7fe80734    extsh r8,r31                
10021af8  7c8433d6    divw r4,r4,r6               
10021afc  80e1003c    lwz r7,0x3c(r1)                ; -> Stack[-0x24]
10021b00  7c84f1d6    mullw r4,r4,r30             
10021b04  80e70000    lwz r7,0x0(r7)              
10021b08  55081838    rlwinm r8,r8,0x3,0x0,0x1c   
10021b0c  38e7000e    addi r7,r7,0xe              
10021b10  7c87432e    sthx r4,r7,r8               
10021b14  3bff0001    addi r31,r31,0x1            
10021b18  8141003c    lwz r10,0x3c(r1)               ; -> Stack[-0x24]
10021b1c  7fe90734    extsh r9,r31                
10021b20  814a0000    lwz r10,0x0(r10)            
10021b24  a94a0006    lha r10,0x6(r10)            
10021b28  7c095000    cmpw r9,r10                 
10021b2c  4081ff34    ble 0x10021a60                 ; -> 10021a60
10021b30  8061003c    lwz r3,0x3c(r1)                ; -> Stack[-0x24]
10021b34  4800f4dd    bl 0x10031010                  ; -> 10031010
10021b38  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021b3c  48000008    b 0x10021b44                   ; -> 10021b44
10021b40  3b800000    li r28,0x0                  
10021b44  4800f485    bl 0x10030fc8                  ; -> 10030fc8
10021b48  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021b4c  7c1d1840    cmplw r29,r3                
10021b50  4181fff0    bgt 0x10021b40                 ; -> 10021b40
10021b54  4800f475    bl 0x10030fc8                  ; -> 10030fc8
10021b58  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021b5c  8161003c    lwz r11,0x3c(r1)               ; -> Stack[-0x24]
10021b60  8181003c    lwz r12,0x3c(r1)               ; -> Stack[-0x24]
10021b64  816b0000    lwz r11,0x0(r11)            
10021b68  818c0000    lwz r12,0x0(r12)            
10021b6c  3ba30001    addi r29,r3,0x1             
10021b70  a88b0006    lha r4,0x6(r11)             
10021b74  38600000    li r3,0x0                   
10021b78  38ac0008    addi r5,r12,0x8             
10021b7c  4800f4ad    bl 0x10031028                  ; -> 10031028
10021b80  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021b84  8061003c    lwz r3,0x3c(r1)                ; -> Stack[-0x24]
10021b88  4800f4d1    bl 0x10031058                  ; -> 10031058
10021b8c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021b90  5743063e    rlwinm r3,r26,0x0,0x18,0x1f 
10021b94  28030000    cmplwi r3,0x0               
10021b98  4182001c    beq 0x10021bb4                 ; -> 10021bb4
10021b9c  7fc40734    extsh r4,r30                
10021ba0  5484402e    rlwinm r4,r4,0x8,0x0,0x17   
10021ba4  38a0000a    li r5,0xa                   
10021ba8  7c642bd6    divw r3,r4,r5               
10021bac  4bff6b0d    bl 0x100186b8                  ; -> 100186b8
10021bb0  60000000    ori r0,r0,0x0               
10021bb4  4800ff3d    bl 0x10031af0                  ; -> 10031af0
10021bb8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10021bbc  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10021bc0  28030000    cmplwi r3,0x0               
10021bc4  41820010    beq 0x10021bd4                 ; -> 10021bd4
10021bc8  38600000    li r3,0x0                   
10021bcc  4bff6aed    bl 0x100186b8                  ; -> 100186b8
10021bd0  60000000    ori r0,r0,0x0               
10021bd4  3bdeffff    subi r30,r30,0x1            
10021bd8  7fc60734    extsh r6,r30                
10021bdc  2c060000    cmpwi r6,0x0                
10021be0  4080fe58    bge 0x10021a38                 ; -> 10021a38
10021be4  80f90000    lwz r7,0x0(r25)             
10021be8  39225324    addi r9,r2,0x5324           
10021bec  80e7002a    lwz r7,0x2a(r7)             
10021bf0  39000001    li r8,0x1                   
10021bf4  80e70000    lwz r7,0x0(r7)              
10021bf8  93070000    stw r24,0x0(r7)             
10021bfc  99090000    stb r8,0x0(r9)              
10021c00  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10021c04  38210060    addi r1,r1,0x60             
10021c08  7c0803a6    mtspr LR,r0                 
10021c0c  bb01ffe0    lmw r24,-0x20(r1)              ; -> Stack[-0x20]
10021c10  4e800020    blr                         
