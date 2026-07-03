; FUN_1000195c @ 0x1000195c
1000195c  7c0802a6    mfspr r0,LR                 
10001960  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10001964  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10001968  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000196c  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10001970  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10001974  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10001978  7cdc3378    or r28,r6,r6                
1000197c  7cfd3b78    or r29,r7,r7                
10001980  7d1e4378    or r30,r8,r8                
10001984  b0a10072    sth r5,0x72(r1)                ; -> Stack[0x22]
10001988  7c850734    extsh r5,r4                 
1000198c  2c050001    cmpwi r5,0x1                
10001990  80c30000    lwz r6,0x0(r3)              
10001994  418001bc    blt 0x10001b50                 ; -> 10001b50
10001998  a8060000    lha r0,0x0(r6)              
1000199c  7c050000    cmpw r5,r0                  
100019a0  40810008    ble 0x100019a8                 ; -> 100019a8
100019a4  480001ac    b 0x10001b50                   ; -> 10001b50
100019a8  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
100019ac  38050008    addi r0,r5,0x8              
100019b0  7c06002e    lwzx r0,r6,r0               
100019b4  38a10072    addi r5,r1,0x72             
100019b8  7fe60214    add r31,r6,r0               
100019bc  38c10038    addi r6,r1,0x38             
100019c0  4bfff989    bl 0x10001348                  ; -> 10001348
100019c4  81010038    lwz r8,0x38(r1)                ; -> Stack[-0x18]
100019c8  a81f0000    lha r0,0x0(r31)             
100019cc  38a80008    addi r5,r8,0x8              
100019d0  88c50000    lbz r6,0x0(r5)              
100019d4  80e80000    lwz r7,0x0(r8)              
100019d8  7c000734    extsh r0,r0                 
100019dc  7fc90734    extsh r9,r30                
100019e0  7f830734    extsh r3,r28                
100019e4  7c004850    subf r0,r0,r9               
100019e8  38800004    li r4,0x4                   
100019ec  7c0023d6    divw r0,r0,r4               
100019f0  7d2349d6    mullw r9,r3,r9              
100019f4  a8810072    lha r4,0x72(r1)                ; -> Stack[0x22]
100019f8  54c3063f    rlwinm. r3,r6,0x0,0x18,0x1f 
100019fc  7c692214    add r3,r9,r4                
10001a00  a89f0002    lha r4,0x2(r31)             
10001a04  7c7d1a14    add r3,r29,r3               
10001a08  7ce83a14    add r7,r8,r7                
10001a0c  38a50001    addi r5,r5,0x1              
10001a10  40820070    bne 0x10001a80                 ; -> 10001a80
10001a14  48000010    b 0x10001a24                   ; -> 10001a24
10001a18  54c6063e    rlwinm r6,r6,0x0,0x18,0x1f  
10001a1c  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
10001a20  7c633214    add r3,r3,r6                
10001a24  88c50000    lbz r6,0x0(r5)              
10001a28  54c907fe    rlwinm r9,r6,0x0,0x1f,0x1f  
10001a2c  54c6063e    rlwinm r6,r6,0x0,0x18,0x1f  
10001a30  7cc60e70    srawi r6,r6,0x1             
10001a34  54c8063f    rlwinm. r8,r6,0x0,0x18,0x1f 
10001a38  38a50001    addi r5,r5,0x1              
10001a3c  418200b4    beq 0x10001af0                 ; -> 10001af0
10001a40  5528063e    rlwinm r8,r9,0x0,0x18,0x1f  
10001a44  28080001    cmplwi r8,0x1               
10001a48  41820070    beq 0x10001ab8                 ; -> 10001ab8
10001a4c  48000024    b 0x10001a70                   ; -> 10001a70
10001a50  81270000    lwz r9,0x0(r7)              
10001a54  81430000    lwz r10,0x0(r3)             
10001a58  85070004    lwzu r8,0x4(r7)             
10001a5c  7d4a4838    and r10,r10,r9              
10001a60  7d4a4378    or r10,r10,r8               
10001a64  91430000    stw r10,0x0(r3)             
10001a68  38e70004    addi r7,r7,0x4              
10001a6c  38630004    addi r3,r3,0x4              
10001a70  7cc83378    or r8,r6,r6                 
10001a74  5508063f    rlwinm. r8,r8,0x0,0x18,0x1f 
10001a78  38c6ffff    subi r6,r6,0x1              
10001a7c  4082ffd4    bne 0x10001a50                 ; -> 10001a50
10001a80  88c50000    lbz r6,0x0(r5)              
10001a84  54c907fe    rlwinm r9,r6,0x0,0x1f,0x1f  
10001a88  54c6063e    rlwinm r6,r6,0x0,0x18,0x1f  
10001a8c  7cc60e70    srawi r6,r6,0x1             
10001a90  54c8063f    rlwinm. r8,r6,0x0,0x18,0x1f 
10001a94  38a50001    addi r5,r5,0x1              
10001a98  41820078    beq 0x10001b10                 ; -> 10001b10
10001a9c  5528063f    rlwinm. r8,r9,0x0,0x18,0x1f 
10001aa0  4182ff78    beq 0x10001a18                 ; -> 10001a18
10001aa4  48000014    b 0x10001ab8                   ; -> 10001ab8
10001aa8  81070000    lwz r8,0x0(r7)              
10001aac  91030000    stw r8,0x0(r3)              
10001ab0  38e70004    addi r7,r7,0x4              
10001ab4  38630004    addi r3,r3,0x4              
10001ab8  7cc83378    or r8,r6,r6                 
10001abc  5508063f    rlwinm. r8,r8,0x0,0x18,0x1f 
10001ac0  38c6ffff    subi r6,r6,0x1              
10001ac4  4082ffe4    bne 0x10001aa8                 ; -> 10001aa8
10001ac8  88c50000    lbz r6,0x0(r5)              
10001acc  54c907fe    rlwinm r9,r6,0x0,0x1f,0x1f  
10001ad0  54c6063e    rlwinm r6,r6,0x0,0x18,0x1f  
10001ad4  7cc60e70    srawi r6,r6,0x1             
10001ad8  54c8063f    rlwinm. r8,r6,0x0,0x18,0x1f 
10001adc  38a50001    addi r5,r5,0x1              
10001ae0  41820054    beq 0x10001b34                 ; -> 10001b34
10001ae4  5528063f    rlwinm. r8,r9,0x0,0x18,0x1f 
10001ae8  4082ff88    bne 0x10001a70                 ; -> 10001a70
10001aec  4bffff2c    b 0x10001a18                   ; -> 10001a18
10001af0  5526063f    rlwinm. r6,r9,0x0,0x18,0x1f 
10001af4  41820048    beq 0x10001b3c                 ; -> 10001b3c
10001af8  3884ffff    subi r4,r4,0x1              
10001afc  5408103a    rlwinm r8,r0,0x2,0x0,0x1d   
10001b00  7c860735    extsh. r6,r4                
10001b04  7c634214    add r3,r3,r8                
10001b08  40810048    ble 0x10001b50                 ; -> 10001b50
10001b0c  4bffffbc    b 0x10001ac8                   ; -> 10001ac8
10001b10  5526063e    rlwinm r6,r9,0x0,0x18,0x1f  
10001b14  28060001    cmplwi r6,0x1               
10001b18  4182ffe0    beq 0x10001af8                 ; -> 10001af8
10001b1c  3884ffff    subi r4,r4,0x1              
10001b20  5408103a    rlwinm r8,r0,0x2,0x0,0x1d   
10001b24  7c860735    extsh. r6,r4                
10001b28  7c634214    add r3,r3,r8                
10001b2c  40810024    ble 0x10001b50                 ; -> 10001b50
10001b30  4bfffef4    b 0x10001a24                   ; -> 10001a24
10001b34  5526063f    rlwinm. r6,r9,0x0,0x18,0x1f 
10001b38  4182ffe4    beq 0x10001b1c                 ; -> 10001b1c
10001b3c  3884ffff    subi r4,r4,0x1              
10001b40  5408103a    rlwinm r8,r0,0x2,0x0,0x1d   
10001b44  7c860735    extsh. r6,r4                
10001b48  7c634214    add r3,r3,r8                
10001b4c  4181ff34    bgt 0x10001a80                 ; -> 10001a80
10001b50  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10001b54  38210050    addi r1,r1,0x50             
10001b58  7c0803a6    mtspr LR,r0                 
10001b5c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10001b60  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10001b64  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10001b68  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10001b6c  4e800020    blr                         
