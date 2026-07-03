; FUN_100029d4 @ 0x100029d4
100029d4  bee1ffdc    stmw r23,-0x24(r1)             ; -> Stack[-0x24]
100029d8  aae1003a    lha r23,0x3a(r1)               ; -> Stack[0x3a]
100029dc  a961003e    lha r11,0x3e(r1)               ; -> Stack[0x3e]
100029e0  a8010042    lha r0,0x42(r1)                ; -> Stack[0x42]
100029e4  7d6b0734    extsh r11,r11               
100029e8  83690000    lwz r27,0x0(r9)             
100029ec  7c000734    extsh r0,r0                 
100029f0  835b0000    lwz r26,0x0(r27)            
100029f4  7c1e1670    srawi r30,r0,0x2            
100029f8  7c0b2050    subf r0,r11,r4              
100029fc  38800004    li r4,0x4                   
10002a00  7f8b3050    subf r28,r11,r6             
10002a04  7c0023d6    divw r0,r0,r4               
10002a08  7f9c23d6    divw r28,r28,r4             
10002a0c  80830000    lwz r4,0x0(r3)              
10002a10  83a50000    lwz r29,0x0(r5)             
10002a14  80c70000    lwz r6,0x0(r7)              
10002a18  81880000    lwz r12,0x0(r8)             
10002a1c  7effbb78    or r31,r23,r23              
10002a20  7fde0194    addze r30,r30               
10002a24  3b7b0004    addi r27,r27,0x4            
10002a28  39600000    li r11,0x0                  
10002a2c  48000030    b 0x10002a5c                   ; -> 10002a5c
10002a30  575807ff    rlwinm. r24,r26,0x0,0x1f,0x1f
10002a34  41820018    beq 0x10002a4c                 ; -> 10002a4c
10002a38  831d0000    lwz r24,0x0(r29)            
10002a3c  93040000    stw r24,0x0(r4)             
10002a40  3bbd0004    addi r29,r29,0x4            
10002a44  38840004    addi r4,r4,0x4              
10002a48  4800000c    b 0x10002a54                   ; -> 10002a54
10002a4c  38840004    addi r4,r4,0x4              
10002a50  3bbd0004    addi r29,r29,0x4            
10002a54  7f5a0e70    srawi r26,r26,0x1           
10002a58  396b0001    addi r11,r11,0x1            
10002a5c  7d790734    extsh r25,r11               
10002a60  7fd80734    extsh r24,r30               
10002a64  7c19c000    cmpw r25,r24                
10002a68  4180ffc8    blt 0x10002a30                 ; -> 10002a30
10002a6c  a96a0000    lha r11,0x0(r10)            
10002a70  2c0b0001    cmpwi r11,0x1               
10002a74  41820060    beq 0x10002ad4                 ; -> 10002ad4
10002a78  2c0b0002    cmpwi r11,0x2               
10002a7c  418200c0    beq 0x10002b3c                 ; -> 10002b3c
10002a80  2c0b0003    cmpwi r11,0x3               
10002a84  41820110    beq 0x10002b94                 ; -> 10002b94
10002a88  89660000    lbz r11,0x0(r6)             
10002a8c  556b063f    rlwinm. r11,r11,0x0,0x18,0x1f
10002a90  38c60001    addi r6,r6,0x1              
10002a94  408200a8    bne 0x10002b3c                 ; -> 10002b3c
10002a98  4800003c    b 0x10002ad4                   ; -> 10002ad4
10002a9c  575807ff    rlwinm. r24,r26,0x0,0x1f,0x1f
10002aa0  41820018    beq 0x10002ab8                 ; -> 10002ab8
10002aa4  831d0000    lwz r24,0x0(r29)            
10002aa8  93040000    stw r24,0x0(r4)             
10002aac  3bbd0004    addi r29,r29,0x4            
10002ab0  38840004    addi r4,r4,0x4              
10002ab4  4800000c    b 0x10002ac0                   ; -> 10002ac0
10002ab8  38840004    addi r4,r4,0x4              
10002abc  3bbd0004    addi r29,r29,0x4            
10002ac0  7f5a0e70    srawi r26,r26,0x1           
10002ac4  7d785b78    or r24,r11,r11              
10002ac8  5718063f    rlwinm. r24,r24,0x0,0x18,0x1f
10002acc  396bffff    subi r11,r11,0x1            
10002ad0  4082ffcc    bne 0x10002a9c                 ; -> 10002a9c
10002ad4  89660000    lbz r11,0x0(r6)             
10002ad8  557907fe    rlwinm r25,r11,0x0,0x1f,0x1f
10002adc  556b063e    rlwinm r11,r11,0x0,0x18,0x1f
10002ae0  7d6b0e70    srawi r11,r11,0x1           
10002ae4  5578063f    rlwinm. r24,r11,0x0,0x18,0x1f
10002ae8  38c60001    addi r6,r6,0x1              
10002aec  418200d0    beq 0x10002bbc                 ; -> 10002bbc
10002af0  5738063e    rlwinm r24,r25,0x0,0x18,0x1f
10002af4  28180001    cmplwi r24,0x1              
10002af8  41820068    beq 0x10002b60                 ; -> 10002b60
10002afc  5578063e    rlwinm r24,r11,0x0,0x18,0x1f
10002b00  7f5ac630    sraw r26,r26,r24            
10002b04  48000028    b 0x10002b2c                   ; -> 10002b2c
10002b08  832c0000    lwz r25,0x0(r12)            
10002b0c  82fd0000    lwz r23,0x0(r29)            
10002b10  870c0004    lwzu r24,0x4(r12)           
10002b14  7ef7c838    and r23,r23,r25             
10002b18  7ef7c378    or r23,r23,r24              
10002b1c  92e40000    stw r23,0x0(r4)             
10002b20  3bbd0004    addi r29,r29,0x4            
10002b24  398c0004    addi r12,r12,0x4            
10002b28  38840004    addi r4,r4,0x4              
10002b2c  7d785b78    or r24,r11,r11              
10002b30  5718063f    rlwinm. r24,r24,0x0,0x18,0x1f
10002b34  396bffff    subi r11,r11,0x1            
10002b38  4082ffd0    bne 0x10002b08                 ; -> 10002b08
10002b3c  89660000    lbz r11,0x0(r6)             
10002b40  557907fe    rlwinm r25,r11,0x0,0x1f,0x1f
10002b44  556b063e    rlwinm r11,r11,0x0,0x18,0x1f
10002b48  7d6b0e70    srawi r11,r11,0x1           
10002b4c  5578063f    rlwinm. r24,r11,0x0,0x18,0x1f
10002b50  38c60001    addi r6,r6,0x1              
10002b54  418200e8    beq 0x10002c3c                 ; -> 10002c3c
10002b58  5738063f    rlwinm. r24,r25,0x0,0x18,0x1f
10002b5c  4182ff68    beq 0x10002ac4                 ; -> 10002ac4
10002b60  5579063e    rlwinm r25,r11,0x0,0x18,0x1f
10002b64  5738103a    rlwinm r24,r25,0x2,0x0,0x1d 
10002b68  7f5ace30    sraw r26,r26,r25            
10002b6c  7fbdc214    add r29,r29,r24             
10002b70  48000014    b 0x10002b84                   ; -> 10002b84
10002b74  830c0000    lwz r24,0x0(r12)            
10002b78  93040000    stw r24,0x0(r4)             
10002b7c  398c0004    addi r12,r12,0x4            
10002b80  38840004    addi r4,r4,0x4              
10002b84  7d785b78    or r24,r11,r11              
10002b88  5718063f    rlwinm. r24,r24,0x0,0x18,0x1f
10002b8c  396bffff    subi r11,r11,0x1            
10002b90  4082ffe4    bne 0x10002b74                 ; -> 10002b74
10002b94  89660000    lbz r11,0x0(r6)             
10002b98  557907fe    rlwinm r25,r11,0x0,0x1f,0x1f
10002b9c  556b063e    rlwinm r11,r11,0x0,0x18,0x1f
10002ba0  7d6b0e70    srawi r11,r11,0x1           
10002ba4  5578063f    rlwinm. r24,r11,0x0,0x18,0x1f
10002ba8  38c60001    addi r6,r6,0x1              
10002bac  41820114    beq 0x10002cc0                 ; -> 10002cc0
10002bb0  5738063f    rlwinm. r24,r25,0x0,0x18,0x1f
10002bb4  4082ff48    bne 0x10002afc                 ; -> 10002afc
10002bb8  4bffff0c    b 0x10002ac4                   ; -> 10002ac4
10002bbc  572b063f    rlwinm. r11,r25,0x0,0x18,0x1f
10002bc0  41820108    beq 0x10002cc8                 ; -> 10002cc8
10002bc4  3bffffff    subi r31,r31,0x1            
10002bc8  5419103a    rlwinm r25,r0,0x2,0x0,0x1d  
10002bcc  5798103a    rlwinm r24,r28,0x2,0x0,0x1d 
10002bd0  7feb0735    extsh. r11,r31              
10002bd4  7c84ca14    add r4,r4,r25               
10002bd8  7fbdc214    add r29,r29,r24             
10002bdc  40810054    ble 0x10002c30                 ; -> 10002c30
10002be0  835b0000    lwz r26,0x0(r27)            
10002be4  39600000    li r11,0x0                  
10002be8  3b7b0004    addi r27,r27,0x4            
10002bec  48000030    b 0x10002c1c                   ; -> 10002c1c
10002bf0  575807ff    rlwinm. r24,r26,0x0,0x1f,0x1f
10002bf4  41820018    beq 0x10002c0c                 ; -> 10002c0c
10002bf8  831d0000    lwz r24,0x0(r29)            
10002bfc  93040000    stw r24,0x0(r4)             
10002c00  3bbd0004    addi r29,r29,0x4            
10002c04  38840004    addi r4,r4,0x4              
10002c08  4800000c    b 0x10002c14                   ; -> 10002c14
10002c0c  38840004    addi r4,r4,0x4              
10002c10  3bbd0004    addi r29,r29,0x4            
10002c14  7f5a0e70    srawi r26,r26,0x1           
10002c18  396b0001    addi r11,r11,0x1            
10002c1c  7d790734    extsh r25,r11               
10002c20  7fd80734    extsh r24,r30               
10002c24  7c19c000    cmpw r25,r24                
10002c28  4180ffc8    blt 0x10002bf0                 ; -> 10002bf0
10002c2c  4bffff68    b 0x10002b94                   ; -> 10002b94
10002c30  38000003    li r0,0x3                   
10002c34  b00a0000    sth r0,0x0(r10)             
10002c38  48000104    b 0x10002d3c                   ; -> 10002d3c
10002c3c  572b063e    rlwinm r11,r25,0x0,0x18,0x1f
10002c40  280b0001    cmplwi r11,0x1              
10002c44  4182ff80    beq 0x10002bc4                 ; -> 10002bc4
10002c48  3bffffff    subi r31,r31,0x1            
10002c4c  5419103a    rlwinm r25,r0,0x2,0x0,0x1d  
10002c50  5798103a    rlwinm r24,r28,0x2,0x0,0x1d 
10002c54  7feb0735    extsh. r11,r31              
10002c58  7c84ca14    add r4,r4,r25               
10002c5c  7fbdc214    add r29,r29,r24             
10002c60  40810054    ble 0x10002cb4                 ; -> 10002cb4
10002c64  835b0000    lwz r26,0x0(r27)            
10002c68  39600000    li r11,0x0                  
10002c6c  3b7b0004    addi r27,r27,0x4            
10002c70  48000030    b 0x10002ca0                   ; -> 10002ca0
10002c74  575807ff    rlwinm. r24,r26,0x0,0x1f,0x1f
10002c78  41820018    beq 0x10002c90                 ; -> 10002c90
10002c7c  831d0000    lwz r24,0x0(r29)            
10002c80  93040000    stw r24,0x0(r4)             
10002c84  3bbd0004    addi r29,r29,0x4            
10002c88  38840004    addi r4,r4,0x4              
10002c8c  4800000c    b 0x10002c98                   ; -> 10002c98
10002c90  38840004    addi r4,r4,0x4              
10002c94  3bbd0004    addi r29,r29,0x4            
10002c98  7f5a0e70    srawi r26,r26,0x1           
10002c9c  396b0001    addi r11,r11,0x1            
10002ca0  7d790734    extsh r25,r11               
10002ca4  7fd80734    extsh r24,r30               
10002ca8  7c19c000    cmpw r25,r24                
10002cac  4180ffc8    blt 0x10002c74                 ; -> 10002c74
10002cb0  4bfffe24    b 0x10002ad4                   ; -> 10002ad4
10002cb4  38000001    li r0,0x1                   
10002cb8  b00a0000    sth r0,0x0(r10)             
10002cbc  48000080    b 0x10002d3c                   ; -> 10002d3c
10002cc0  572b063f    rlwinm. r11,r25,0x0,0x18,0x1f
10002cc4  4182ff84    beq 0x10002c48                 ; -> 10002c48
10002cc8  3bffffff    subi r31,r31,0x1            
10002ccc  5419103a    rlwinm r25,r0,0x2,0x0,0x1d  
10002cd0  5798103a    rlwinm r24,r28,0x2,0x0,0x1d 
10002cd4  7feb0735    extsh. r11,r31              
10002cd8  7c84ca14    add r4,r4,r25               
10002cdc  7fbdc214    add r29,r29,r24             
10002ce0  40810054    ble 0x10002d34                 ; -> 10002d34
10002ce4  835b0000    lwz r26,0x0(r27)            
10002ce8  39600000    li r11,0x0                  
10002cec  3b7b0004    addi r27,r27,0x4            
10002cf0  48000030    b 0x10002d20                   ; -> 10002d20
10002cf4  575807ff    rlwinm. r24,r26,0x0,0x1f,0x1f
10002cf8  41820018    beq 0x10002d10                 ; -> 10002d10
10002cfc  831d0000    lwz r24,0x0(r29)            
10002d00  93040000    stw r24,0x0(r4)             
10002d04  3bbd0004    addi r29,r29,0x4            
10002d08  38840004    addi r4,r4,0x4              
10002d0c  4800000c    b 0x10002d18                   ; -> 10002d18
10002d10  38840004    addi r4,r4,0x4              
10002d14  3bbd0004    addi r29,r29,0x4            
10002d18  7f5a0e70    srawi r26,r26,0x1           
10002d1c  396b0001    addi r11,r11,0x1            
10002d20  7d780734    extsh r24,r11               
10002d24  7fd90734    extsh r25,r30               
10002d28  7c18c800    cmpw r24,r25                
10002d2c  4180ffc8    blt 0x10002cf4                 ; -> 10002cf4
10002d30  4bfffe0c    b 0x10002b3c                   ; -> 10002b3c
10002d34  38000002    li r0,0x2                   
10002d38  b00a0000    sth r0,0x0(r10)             
10002d3c  90830000    stw r4,0x0(r3)              
10002d40  93a50000    stw r29,0x0(r5)             
10002d44  90c70000    stw r6,0x0(r7)              
10002d48  91880000    stw r12,0x0(r8)             
10002d4c  93690000    stw r27,0x0(r9)             
10002d50  bae1ffdc    lmw r23,-0x24(r1)              ; -> Stack[-0x24]
10002d54  4e800020    blr                         
