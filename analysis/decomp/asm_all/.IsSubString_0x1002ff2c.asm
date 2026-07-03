; .IsSubString @ 0x1002ff2c
1002ff2c  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
1002ff30  3ba00000    li r29,0x0                  
1002ff34  8b230000    lbz r25,0x0(r3)             
1002ff38  8b640000    lbz r27,0x0(r4)             
1002ff3c  7f650734    extsh r5,r27                
1002ff40  7f260734    extsh r6,r25                
1002ff44  7c053000    cmpw r5,r6                  
1002ff48  41810080    bgt 0x1002ffc8                 ; -> 1002ffc8
1002ff4c  3b400001    li r26,0x1                  
1002ff50  7cfbc850    subf r7,r27,r25             
1002ff54  3b870001    addi r28,r7,0x1             
1002ff58  7f5ed378    or r30,r26,r26              
1002ff5c  3be00001    li r31,0x1                  
1002ff60  48000024    b 0x1002ff84                   ; -> 1002ff84
1002ff64  7fe80734    extsh r8,r31                
1002ff68  7f690734    extsh r9,r27                
1002ff6c  7c084800    cmpw r8,r9                  
1002ff70  4082000c    bne 0x1002ff7c                 ; -> 1002ff7c
1002ff74  3ba00001    li r29,0x1                  
1002ff78  4800000c    b 0x1002ff84                   ; -> 1002ff84
1002ff7c  3bff0001    addi r31,r31,0x1            
1002ff80  3bde0001    addi r30,r30,0x1            
1002ff84  57aa063f    rlwinm. r10,r29,0x0,0x18,0x1f
1002ff88  40820020    bne 0x1002ffa8                 ; -> 1002ffa8
1002ff8c  7fcb0734    extsh r11,r30               
1002ff90  7d6358ae    lbzx r11,r3,r11             
1002ff94  556b063e    rlwinm r11,r11,0x0,0x18,0x1f
1002ff98  7fec0734    extsh r12,r31               
1002ff9c  7d8460ae    lbzx r12,r4,r12             
1002ffa0  7c0b6040    cmplw r11,r12               
1002ffa4  4182ffc0    beq 0x1002ff64                 ; -> 1002ff64
1002ffa8  57a5063f    rlwinm. r5,r29,0x0,0x18,0x1f
1002ffac  4082000c    bne 0x1002ffb8                 ; -> 1002ffb8
1002ffb0  3b5a0001    addi r26,r26,0x1            
1002ffb4  3b9cffff    subi r28,r28,0x1            
1002ffb8  7f860735    extsh. r6,r28               
1002ffbc  4182000c    beq 0x1002ffc8                 ; -> 1002ffc8
1002ffc0  57a7063f    rlwinm. r7,r29,0x0,0x18,0x1f
1002ffc4  4182ff94    beq 0x1002ff58                 ; -> 1002ff58
1002ffc8  7fa3eb78    or r3,r29,r29               
1002ffcc  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
1002ffd0  4e800020    blr                         
