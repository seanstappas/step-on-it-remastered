; FUN_1000c680 @ 0x1000c680
1000c680  7c0802a6    mfspr r0,LR                 
1000c684  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
1000c688  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000c68c  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1000c690  7c7c1b78    or r28,r3,r3                
1000c694  7c9d2378    or r29,r4,r4                
1000c698  3b626bf8    addi r27,r2,0x6bf8          
1000c69c  48025b15    bl 0x100321b0                  ; -> 100321b0
1000c6a0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1000c6a4  547e06be    rlwinm r30,r3,0x0,0x1a,0x1f 
1000c6a8  7fc30734    extsh r3,r30                
1000c6ac  2c03003f    cmpwi r3,0x3f               
1000c6b0  4081000c    ble 0x1000c6bc                 ; -> 1000c6bc
1000c6b4  3be00032    li r31,0x32                 
1000c6b8  480000f8    b 0x1000c7b0                   ; -> 1000c7b0
1000c6bc  7fc40734    extsh r4,r30                
1000c6c0  2c04003d    cmpwi r4,0x3d               
1000c6c4  4081000c    ble 0x1000c6d0                 ; -> 1000c6d0
1000c6c8  3be00030    li r31,0x30                 
1000c6cc  480000e4    b 0x1000c7b0                   ; -> 1000c7b0
1000c6d0  7fc50734    extsh r5,r30                
1000c6d4  2c05003b    cmpwi r5,0x3b               
1000c6d8  4081000c    ble 0x1000c6e4                 ; -> 1000c6e4
1000c6dc  3be0000f    li r31,0xf                  
1000c6e0  480000d0    b 0x1000c7b0                   ; -> 1000c7b0
1000c6e4  7fc60734    extsh r6,r30                
1000c6e8  2c060039    cmpwi r6,0x39               
1000c6ec  4081000c    ble 0x1000c6f8                 ; -> 1000c6f8
1000c6f0  3be0000e    li r31,0xe                  
1000c6f4  480000bc    b 0x1000c7b0                   ; -> 1000c7b0
1000c6f8  7fc70734    extsh r7,r30                
1000c6fc  2c070035    cmpwi r7,0x35               
1000c700  4081000c    ble 0x1000c70c                 ; -> 1000c70c
1000c704  3be0000d    li r31,0xd                  
1000c708  480000a8    b 0x1000c7b0                   ; -> 1000c7b0
1000c70c  7fc80734    extsh r8,r30                
1000c710  2c08002d    cmpwi r8,0x2d               
1000c714  4081000c    ble 0x1000c720                 ; -> 1000c720
1000c718  3be0000c    li r31,0xc                  
1000c71c  48000094    b 0x1000c7b0                   ; -> 1000c7b0
1000c720  7fc90734    extsh r9,r30                
1000c724  2c09002b    cmpwi r9,0x2b               
1000c728  4081000c    ble 0x1000c734                 ; -> 1000c734
1000c72c  3be00013    li r31,0x13                 
1000c730  48000080    b 0x1000c7b0                   ; -> 1000c7b0
1000c734  7fca0734    extsh r10,r30               
1000c738  2c0a002a    cmpwi r10,0x2a              
1000c73c  4081000c    ble 0x1000c748                 ; -> 1000c748
1000c740  3be00010    li r31,0x10                 
1000c744  4800006c    b 0x1000c7b0                   ; -> 1000c7b0
1000c748  7fcb0734    extsh r11,r30               
1000c74c  2c0b0029    cmpwi r11,0x29              
1000c750  4081000c    ble 0x1000c75c                 ; -> 1000c75c
1000c754  3be00011    li r31,0x11                 
1000c758  48000058    b 0x1000c7b0                   ; -> 1000c7b0
1000c75c  7fcc0734    extsh r12,r30               
1000c760  2c0c0028    cmpwi r12,0x28              
1000c764  4081000c    ble 0x1000c770                 ; -> 1000c770
1000c768  3be00012    li r31,0x12                 
1000c76c  48000044    b 0x1000c7b0                   ; -> 1000c7b0
1000c770  7fc30734    extsh r3,r30                
1000c774  2c030026    cmpwi r3,0x26               
1000c778  4081000c    ble 0x1000c784                 ; -> 1000c784
1000c77c  3be00019    li r31,0x19                 
1000c780  48000030    b 0x1000c7b0                   ; -> 1000c7b0
1000c784  7fc40734    extsh r4,r30                
1000c788  2c040022    cmpwi r4,0x22               
1000c78c  4081000c    ble 0x1000c798                 ; -> 1000c798
1000c790  3be00018    li r31,0x18                 
1000c794  4800001c    b 0x1000c7b0                   ; -> 1000c7b0
1000c798  7fc50734    extsh r5,r30                
1000c79c  2c05001a    cmpwi r5,0x1a               
1000c7a0  4081000c    ble 0x1000c7ac                 ; -> 1000c7ac
1000c7a4  3be00017    li r31,0x17                 
1000c7a8  48000008    b 0x1000c7b0                   ; -> 1000c7b0
1000c7ac  3be0000a    li r31,0xa                  
1000c7b0  7f860734    extsh r6,r28                
1000c7b4  7fa70734    extsh r7,r29                
1000c7b8  1cc6003c    mulli r6,r6,0x3c            
1000c7bc  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
1000c7c0  7cc63a14    add r6,r6,r7                
1000c7c4  7cdb302e    lwzx r6,r27,r6              
1000c7c8  2c060000    cmpwi r6,0x0                
1000c7cc  40820078    bne 0x1000c844                 ; -> 1000c844
1000c7d0  7f83e378    or r3,r28,r28               
1000c7d4  7fa4eb78    or r4,r29,r29               
1000c7d8  48020439    bl 0x1002cc10                  ; -> 1002cc10
1000c7dc  60000000    ori r0,r0,0x0               
1000c7e0  7fa3eb78    or r3,r29,r29               
1000c7e4  48021ed9    bl 0x1002e6bc                  ; -> 1002e6bc
1000c7e8  60000000    ori r0,r0,0x0               
1000c7ec  7c7a1b78    or r26,r3,r3                
1000c7f0  7f83e378    or r3,r28,r28               
1000c7f4  48021eb9    bl 0x1002e6ac                  ; -> 1002e6ac
1000c7f8  60000000    ori r0,r0,0x0               
1000c7fc  7c791b78    or r25,r3,r3                
1000c800  39026ba4    addi r8,r2,0x6ba4           
1000c804  38800010    li r4,0x10                  
1000c808  80680000    lwz r3,0x0(r8)              
1000c80c  38b90004    addi r5,r25,0x4             
1000c810  38da0004    addi r6,r26,0x4             
1000c814  4bff78f5    bl 0x10004108                  ; -> 10004108
1000c818  60000000    ori r0,r0,0x0               
1000c81c  7f8a0734    extsh r10,r28               
1000c820  7fe90734    extsh r9,r31                
1000c824  7fab0734    extsh r11,r29               
1000c828  5529801e    rlwinm r9,r9,0x10,0x0,0xf   
1000c82c  1d4a003c    mulli r10,r10,0x3c          
1000c830  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1000c834  392909ff    addi r9,r9,0x9ff            
1000c838  7d4a5a14    add r10,r10,r11             
1000c83c  7d3b512e    stwx r9,r27,r10             
1000c840  48000068    b 0x1000c8a8                   ; -> 1000c8a8
1000c844  7f990734    extsh r25,r28               
1000c848  7fec0734    extsh r12,r31               
1000c84c  398c0900    addi r12,r12,0x900          
1000c850  7fba0734    extsh r26,r29               
1000c854  558c801e    rlwinm r12,r12,0x10,0x0,0xf 
1000c858  1f39003c    mulli r25,r25,0x3c          
1000c85c  575a103a    rlwinm r26,r26,0x2,0x0,0x1d 
1000c860  398c1291    addi r12,r12,0x1291         
1000c864  7f39d214    add r25,r25,r26             
1000c868  7d9bc92e    stwx r12,r27,r25            
1000c86c  7fa3eb78    or r3,r29,r29               
1000c870  48021e4d    bl 0x1002e6bc                  ; -> 1002e6bc
1000c874  60000000    ori r0,r0,0x0               
1000c878  7c7a1b78    or r26,r3,r3                
1000c87c  7f83e378    or r3,r28,r28               
1000c880  48021e2d    bl 0x1002e6ac                  ; -> 1002e6ac
1000c884  60000000    ori r0,r0,0x0               
1000c888  7c791b78    or r25,r3,r3                
1000c88c  38826bc0    addi r4,r2,0x6bc0           
1000c890  7f25cb78    or r5,r25,r25               
1000c894  80640000    lwz r3,0x0(r4)              
1000c898  7f46d378    or r6,r26,r26               
1000c89c  38800091    li r4,0x91                  
1000c8a0  4bff7869    bl 0x10004108                  ; -> 10004108
1000c8a4  60000000    ori r0,r0,0x0               
1000c8a8  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1000c8ac  38210060    addi r1,r1,0x60             
1000c8b0  7c0803a6    mtspr LR,r0                 
1000c8b4  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
1000c8b8  4e800020    blr                         
