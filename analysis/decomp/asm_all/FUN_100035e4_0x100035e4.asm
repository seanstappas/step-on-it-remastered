; FUN_100035e4 @ 0x100035e4
100035e4  7c0802a6    mfspr r0,LR                 
100035e8  bf01ffe0    stmw r24,-0x20(r1)             ; -> Stack[-0x20]
100035ec  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100035f0  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
100035f4  3bc270fc    addi r30,r2,0x70fc          
100035f8  3b422fb4    addi r26,r2,0x2fb4          
100035fc  3ba00000    li r29,0x0                  
10003600  4800001c    b 0x1000361c                   ; -> 1000361c
10003604  7fa30734    extsh r3,r29                
10003608  7fa40734    extsh r4,r29                
1000360c  5463c00e    rlwinm r3,r3,0x18,0x0,0x7   
10003610  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10003614  7c7a212e    stwx r3,r26,r4              
10003618  3bbd0001    addi r29,r29,0x1            
1000361c  7fa50734    extsh r5,r29                
10003620  2c0500df    cmpwi r5,0xdf               
10003624  4180ffe0    blt 0x10003604                 ; -> 10003604
10003628  3ba000df    li r29,0xdf                 
1000362c  4800010c    b 0x10003738                   ; -> 10003738
10003630  3f600003    lis r27,0x3                 
10003634  3b7bfffd    subi r27,r27,0x3            
10003638  3be00000    li r31,0x0                  
1000363c  480000ec    b 0x10003728                   ; -> 10003728
10003640  80de0000    lwz r6,0x0(r30)             
10003644  811e0000    lwz r8,0x0(r30)             
10003648  80c60000    lwz r6,0x0(r6)              
1000364c  81080000    lwz r8,0x0(r8)              
10003650  7fe70734    extsh r7,r31                
10003654  7fa90734    extsh r9,r29                
10003658  54e71838    rlwinm r7,r7,0x3,0x0,0x1c   
1000365c  38c6000e    addi r6,r6,0xe              
10003660  55291838    rlwinm r9,r9,0x3,0x0,0x1c   
10003664  3908000e    addi r8,r8,0xe              
10003668  7cc63a2e    lhzx r6,r6,r7               
1000366c  7d084a2e    lhzx r8,r8,r9               
10003670  7c664050    subf r3,r6,r8               
10003674  480000ed    bl 0x10003760                  ; -> 10003760
10003678  60000000    ori r0,r0,0x0               
1000367c  815e0000    lwz r10,0x0(r30)            
10003680  819e0000    lwz r12,0x0(r30)            
10003684  814a0000    lwz r10,0x0(r10)            
10003688  818c0000    lwz r12,0x0(r12)            
1000368c  7feb0734    extsh r11,r31               
10003690  7fa40734    extsh r4,r29                
10003694  556b1838    rlwinm r11,r11,0x3,0x0,0x1c 
10003698  394a000c    addi r10,r10,0xc            
1000369c  54841838    rlwinm r4,r4,0x3,0x0,0x1c   
100036a0  398c000c    addi r12,r12,0xc            
100036a4  7d4a5a2e    lhzx r10,r10,r11            
100036a8  7d8c222e    lhzx r12,r12,r4             
100036ac  7c791b78    or r25,r3,r3                
100036b0  7c6a6050    subf r3,r10,r12             
100036b4  480000ad    bl 0x10003760                  ; -> 10003760
100036b8  60000000    ori r0,r0,0x0               
100036bc  80be0000    lwz r5,0x0(r30)             
100036c0  80fe0000    lwz r7,0x0(r30)             
100036c4  80a50000    lwz r5,0x0(r5)              
100036c8  80e70000    lwz r7,0x0(r7)              
100036cc  7fe60734    extsh r6,r31                
100036d0  7fa80734    extsh r8,r29                
100036d4  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
100036d8  38a5000a    addi r5,r5,0xa              
100036dc  55081838    rlwinm r8,r8,0x3,0x0,0x1c   
100036e0  38e7000a    addi r7,r7,0xa              
100036e4  7ca5322e    lhzx r5,r5,r6               
100036e8  7ce7422e    lhzx r7,r7,r8               
100036ec  7c781b78    or r24,r3,r3                
100036f0  7c653850    subf r3,r5,r7               
100036f4  4800006d    bl 0x10003760                  ; -> 10003760
100036f8  60000000    ori r0,r0,0x0               
100036fc  7f18ca14    add r24,r24,r25             
10003700  7f83c214    add r28,r3,r24              
10003704  7c1cd800    cmpw r28,r27                
10003708  4080001c    bge 0x10003724                 ; -> 10003724
1000370c  7fe90734    extsh r9,r31                
10003710  7faa0734    extsh r10,r29               
10003714  5529c00e    rlwinm r9,r9,0x18,0x0,0x7   
10003718  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
1000371c  7f9be378    or r27,r28,r28              
10003720  7d3a512e    stwx r9,r26,r10             
10003724  3bff0001    addi r31,r31,0x1            
10003728  7feb0734    extsh r11,r31               
1000372c  2c0b00df    cmpwi r11,0xdf              
10003730  4180ff10    blt 0x10003640                 ; -> 10003640
10003734  3bbd0001    addi r29,r29,0x1            
10003738  7fac0734    extsh r12,r29               
1000373c  2c0c0100    cmpwi r12,0x100             
10003740  4180fef0    blt 0x10003630                 ; -> 10003630
10003744  3f00ff00    lis r24,-0x100              
10003748  931a03fc    stw r24,0x3fc(r26)          
1000374c  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10003750  38210060    addi r1,r1,0x60             
10003754  7c0803a6    mtspr LR,r0                 
10003758  bb01ffe0    lmw r24,-0x20(r1)              ; -> Stack[-0x20]
1000375c  4e800020    blr                         
