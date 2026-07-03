; FUN_10002d58 @ 0x10002d58
10002d58  bee1ffdc    stmw r23,-0x24(r1)             ; -> Stack[-0x24]
10002d5c  ab01003a    lha r24,0x3a(r1)               ; -> Stack[0x3a]
10002d60  a961003e    lha r11,0x3e(r1)               ; -> Stack[0x3e]
10002d64  a8010042    lha r0,0x42(r1)                ; -> Stack[0x42]
10002d68  7d6c0734    extsh r12,r11               
10002d6c  7c000734    extsh r0,r0                 
10002d70  83690000    lwz r27,0x0(r9)             
10002d74  a96a0000    lha r11,0x0(r10)            
10002d78  7c1e1670    srawi r30,r0,0x2            
10002d7c  7fde0194    addze r30,r30               
10002d80  835b0000    lwz r26,0x0(r27)            
10002d84  7fd70734    extsh r23,r30               
10002d88  7c0c2050    subf r0,r12,r4              
10002d8c  38800004    li r4,0x4                   
10002d90  7f8c3050    subf r28,r12,r6             
10002d94  7c0023d6    divw r0,r0,r4               
10002d98  7f9c23d6    divw r28,r28,r4             
10002d9c  2c0b0001    cmpwi r11,0x1               
10002da0  80830000    lwz r4,0x0(r3)              
10002da4  83a50000    lwz r29,0x0(r5)             
10002da8  80c70000    lwz r6,0x0(r7)              
10002dac  81880000    lwz r12,0x0(r8)             
10002db0  7f1fc378    or r31,r24,r24              
10002db4  3b7b0004    addi r27,r27,0x4            
10002db8  7f5ab830    slw r26,r26,r23             
10002dbc  41820060    beq 0x10002e1c                 ; -> 10002e1c
10002dc0  2c0b0002    cmpwi r11,0x2               
10002dc4  418200c0    beq 0x10002e84                 ; -> 10002e84
10002dc8  2c0b0003    cmpwi r11,0x3               
10002dcc  41820110    beq 0x10002edc                 ; -> 10002edc
10002dd0  89660000    lbz r11,0x0(r6)             
10002dd4  556b063f    rlwinm. r11,r11,0x0,0x18,0x1f
10002dd8  38c60001    addi r6,r6,0x1              
10002ddc  408200a8    bne 0x10002e84                 ; -> 10002e84
10002de0  4800003c    b 0x10002e1c                   ; -> 10002e1c
10002de4  575707ff    rlwinm. r23,r26,0x0,0x1f,0x1f
10002de8  41820018    beq 0x10002e00                 ; -> 10002e00
10002dec  82fd0000    lwz r23,0x0(r29)            
10002df0  92e40000    stw r23,0x0(r4)             
10002df4  3bbd0004    addi r29,r29,0x4            
10002df8  38840004    addi r4,r4,0x4              
10002dfc  4800000c    b 0x10002e08                   ; -> 10002e08
10002e00  38840004    addi r4,r4,0x4              
10002e04  3bbd0004    addi r29,r29,0x4            
10002e08  7f5a0e70    srawi r26,r26,0x1           
10002e0c  7d775b78    or r23,r11,r11              
10002e10  56f7063f    rlwinm. r23,r23,0x0,0x18,0x1f
10002e14  396bffff    subi r11,r11,0x1            
10002e18  4082ffcc    bne 0x10002de4                 ; -> 10002de4
10002e1c  89660000    lbz r11,0x0(r6)             
10002e20  557807fe    rlwinm r24,r11,0x0,0x1f,0x1f
10002e24  556b063e    rlwinm r11,r11,0x0,0x18,0x1f
10002e28  7d6b0e70    srawi r11,r11,0x1           
10002e2c  5577063f    rlwinm. r23,r11,0x0,0x18,0x1f
10002e30  38c60001    addi r6,r6,0x1              
10002e34  418200d0    beq 0x10002f04                 ; -> 10002f04
10002e38  5717063e    rlwinm r23,r24,0x0,0x18,0x1f
10002e3c  28170001    cmplwi r23,0x1              
10002e40  41820068    beq 0x10002ea8                 ; -> 10002ea8
10002e44  5577063e    rlwinm r23,r11,0x0,0x18,0x1f
10002e48  7f5abe30    sraw r26,r26,r23            
10002e4c  48000028    b 0x10002e74                   ; -> 10002e74
10002e50  830c0000    lwz r24,0x0(r12)            
10002e54  833d0000    lwz r25,0x0(r29)            
10002e58  86ec0004    lwzu r23,0x4(r12)           
10002e5c  7f39c038    and r25,r25,r24             
10002e60  7f39bb78    or r25,r25,r23              
10002e64  93240000    stw r25,0x0(r4)             
10002e68  3bbd0004    addi r29,r29,0x4            
10002e6c  398c0004    addi r12,r12,0x4            
10002e70  38840004    addi r4,r4,0x4              
10002e74  7d775b78    or r23,r11,r11              
10002e78  56f7063f    rlwinm. r23,r23,0x0,0x18,0x1f
10002e7c  396bffff    subi r11,r11,0x1            
10002e80  4082ffd0    bne 0x10002e50                 ; -> 10002e50
10002e84  89660000    lbz r11,0x0(r6)             
10002e88  557807fe    rlwinm r24,r11,0x0,0x1f,0x1f
10002e8c  556b063e    rlwinm r11,r11,0x0,0x18,0x1f
10002e90  7d6b0e70    srawi r11,r11,0x1           
10002e94  5577063f    rlwinm. r23,r11,0x0,0x18,0x1f
10002e98  38c60001    addi r6,r6,0x1              
10002e9c  418200ec    beq 0x10002f88                 ; -> 10002f88
10002ea0  5717063f    rlwinm. r23,r24,0x0,0x18,0x1f
10002ea4  4182ff68    beq 0x10002e0c                 ; -> 10002e0c
10002ea8  5578063e    rlwinm r24,r11,0x0,0x18,0x1f
10002eac  5717103a    rlwinm r23,r24,0x2,0x0,0x1d 
10002eb0  7f5ac630    sraw r26,r26,r24            
10002eb4  7fbdba14    add r29,r29,r23             
10002eb8  48000014    b 0x10002ecc                   ; -> 10002ecc
10002ebc  82ec0000    lwz r23,0x0(r12)            
10002ec0  92e40000    stw r23,0x0(r4)             
10002ec4  398c0004    addi r12,r12,0x4            
10002ec8  38840004    addi r4,r4,0x4              
10002ecc  7d775b78    or r23,r11,r11              
10002ed0  56f7063f    rlwinm. r23,r23,0x0,0x18,0x1f
10002ed4  396bffff    subi r11,r11,0x1            
10002ed8  4082ffe4    bne 0x10002ebc                 ; -> 10002ebc
10002edc  89660000    lbz r11,0x0(r6)             
10002ee0  557807fe    rlwinm r24,r11,0x0,0x1f,0x1f
10002ee4  556b063e    rlwinm r11,r11,0x0,0x18,0x1f
10002ee8  7d6b0e70    srawi r11,r11,0x1           
10002eec  5577063f    rlwinm. r23,r11,0x0,0x18,0x1f
10002ef0  38c60001    addi r6,r6,0x1              
10002ef4  4182011c    beq 0x10003010                 ; -> 10003010
10002ef8  5717063f    rlwinm. r23,r24,0x0,0x18,0x1f
10002efc  4082ff48    bne 0x10002e44                 ; -> 10002e44
10002f00  4bffff0c    b 0x10002e0c                   ; -> 10002e0c
10002f04  570b063f    rlwinm. r11,r24,0x0,0x18,0x1f
10002f08  41820110    beq 0x10003018                 ; -> 10003018
10002f0c  39600000    li r11,0x0                  
10002f10  48000030    b 0x10002f40                   ; -> 10002f40
10002f14  575707ff    rlwinm. r23,r26,0x0,0x1f,0x1f
10002f18  41820018    beq 0x10002f30                 ; -> 10002f30
10002f1c  82fd0000    lwz r23,0x0(r29)            
10002f20  92e40000    stw r23,0x0(r4)             
10002f24  3bbd0004    addi r29,r29,0x4            
10002f28  38840004    addi r4,r4,0x4              
10002f2c  4800000c    b 0x10002f38                   ; -> 10002f38
10002f30  38840004    addi r4,r4,0x4              
10002f34  3bbd0004    addi r29,r29,0x4            
10002f38  7f5a0e70    srawi r26,r26,0x1           
10002f3c  396b0001    addi r11,r11,0x1            
10002f40  7d770734    extsh r23,r11               
10002f44  7fd90734    extsh r25,r30               
10002f48  7c17c800    cmpw r23,r25                
10002f4c  4180ffc8    blt 0x10002f14                 ; -> 10002f14
10002f50  3bffffff    subi r31,r31,0x1            
10002f54  5418103a    rlwinm r24,r0,0x2,0x0,0x1d  
10002f58  5797103a    rlwinm r23,r28,0x2,0x0,0x1d 
10002f5c  7feb0735    extsh. r11,r31              
10002f60  7c84c214    add r4,r4,r24               
10002f64  7fbdba14    add r29,r29,r23             
10002f68  40810014    ble 0x10002f7c                 ; -> 10002f7c
10002f6c  835b0000    lwz r26,0x0(r27)            
10002f70  3b7b0004    addi r27,r27,0x4            
10002f74  7f5ac830    slw r26,r26,r25             
10002f78  4bffff64    b 0x10002edc                   ; -> 10002edc
10002f7c  38000003    li r0,0x3                   
10002f80  b00a0000    sth r0,0x0(r10)             
10002f84  4800010c    b 0x10003090                   ; -> 10003090
10002f88  570b063e    rlwinm r11,r24,0x0,0x18,0x1f
10002f8c  280b0001    cmplwi r11,0x1              
10002f90  4182ff7c    beq 0x10002f0c                 ; -> 10002f0c
10002f94  39600000    li r11,0x0                  
10002f98  48000030    b 0x10002fc8                   ; -> 10002fc8
10002f9c  575707ff    rlwinm. r23,r26,0x0,0x1f,0x1f
10002fa0  41820018    beq 0x10002fb8                 ; -> 10002fb8
10002fa4  82fd0000    lwz r23,0x0(r29)            
10002fa8  92e40000    stw r23,0x0(r4)             
10002fac  3bbd0004    addi r29,r29,0x4            
10002fb0  38840004    addi r4,r4,0x4              
10002fb4  4800000c    b 0x10002fc0                   ; -> 10002fc0
10002fb8  38840004    addi r4,r4,0x4              
10002fbc  3bbd0004    addi r29,r29,0x4            
10002fc0  7f5a0e70    srawi r26,r26,0x1           
10002fc4  396b0001    addi r11,r11,0x1            
10002fc8  7d780734    extsh r24,r11               
10002fcc  7fd70734    extsh r23,r30               
10002fd0  7c18b800    cmpw r24,r23                
10002fd4  4180ffc8    blt 0x10002f9c                 ; -> 10002f9c
10002fd8  3bffffff    subi r31,r31,0x1            
10002fdc  5419103a    rlwinm r25,r0,0x2,0x0,0x1d  
10002fe0  5798103a    rlwinm r24,r28,0x2,0x0,0x1d 
10002fe4  7feb0735    extsh. r11,r31              
10002fe8  7c84ca14    add r4,r4,r25               
10002fec  7fbdc214    add r29,r29,r24             
10002ff0  40810014    ble 0x10003004                 ; -> 10003004
10002ff4  835b0000    lwz r26,0x0(r27)            
10002ff8  3b7b0004    addi r27,r27,0x4            
10002ffc  7f5ab830    slw r26,r26,r23             
10003000  4bfffe1c    b 0x10002e1c                   ; -> 10002e1c
10003004  38000001    li r0,0x1                   
10003008  b00a0000    sth r0,0x0(r10)             
1000300c  48000084    b 0x10003090                   ; -> 10003090
10003010  570b063f    rlwinm. r11,r24,0x0,0x18,0x1f
10003014  4182ff80    beq 0x10002f94                 ; -> 10002f94
10003018  39600000    li r11,0x0                  
1000301c  48000030    b 0x1000304c                   ; -> 1000304c
10003020  575807ff    rlwinm. r24,r26,0x0,0x1f,0x1f
10003024  41820018    beq 0x1000303c                 ; -> 1000303c
10003028  831d0000    lwz r24,0x0(r29)            
1000302c  93040000    stw r24,0x0(r4)             
10003030  3bbd0004    addi r29,r29,0x4            
10003034  38840004    addi r4,r4,0x4              
10003038  4800000c    b 0x10003044                   ; -> 10003044
1000303c  38840004    addi r4,r4,0x4              
10003040  3bbd0004    addi r29,r29,0x4            
10003044  7f5a0e70    srawi r26,r26,0x1           
10003048  396b0001    addi r11,r11,0x1            
1000304c  7d790734    extsh r25,r11               
10003050  7fd80734    extsh r24,r30               
10003054  7c19c000    cmpw r25,r24                
10003058  4180ffc8    blt 0x10003020                 ; -> 10003020
1000305c  3bffffff    subi r31,r31,0x1            
10003060  5419103a    rlwinm r25,r0,0x2,0x0,0x1d  
10003064  579a103a    rlwinm r26,r28,0x2,0x0,0x1d 
10003068  7feb0735    extsh. r11,r31              
1000306c  7c84ca14    add r4,r4,r25               
10003070  7fbdd214    add r29,r29,r26             
10003074  40810014    ble 0x10003088                 ; -> 10003088
10003078  835b0000    lwz r26,0x0(r27)            
1000307c  3b7b0004    addi r27,r27,0x4            
10003080  7f5ac030    slw r26,r26,r24             
10003084  4bfffe00    b 0x10002e84                   ; -> 10002e84
10003088  38000002    li r0,0x2                   
1000308c  b00a0000    sth r0,0x0(r10)             
10003090  90830000    stw r4,0x0(r3)              
10003094  93a50000    stw r29,0x0(r5)             
10003098  90c70000    stw r6,0x0(r7)              
1000309c  91880000    stw r12,0x0(r8)             
100030a0  93690000    stw r27,0x0(r9)             
100030a4  bae1ffdc    lmw r23,-0x24(r1)              ; -> Stack[-0x24]
100030a8  4e800020    blr                         
