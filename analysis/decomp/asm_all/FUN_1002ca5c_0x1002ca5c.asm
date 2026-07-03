; FUN_1002ca5c @ 0x1002ca5c
1002ca5c  7c0802a6    mfspr r0,LR                 
1002ca60  bf01ffe0    stmw r24,-0x20(r1)             ; -> Stack[-0x20]
1002ca64  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002ca68  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1002ca6c  7c7a1b78    or r26,r3,r3                
1002ca70  7c9b2378    or r27,r4,r4                
1002ca74  3b026bf8    addi r24,r2,0x6bf8          
1002ca78  3b826bc0    addi r28,r2,0x6bc0          
1002ca7c  7f43d378    or r3,r26,r26               
1002ca80  48001c2d    bl 0x1002e6ac                  ; -> 1002e6ac
1002ca84  60000000    ori r0,r0,0x0               
1002ca88  7c7e1b78    or r30,r3,r3                
1002ca8c  7f63db78    or r3,r27,r27               
1002ca90  48001c2d    bl 0x1002e6bc                  ; -> 1002e6bc
1002ca94  60000000    ori r0,r0,0x0               
1002ca98  7c7d1b78    or r29,r3,r3                
1002ca9c  7f430734    extsh r3,r26                
1002caa0  7f450734    extsh r5,r26                
1002caa4  7f640734    extsh r4,r27                
1002caa8  7f660734    extsh r6,r27                
1002caac  1c63003c    mulli r3,r3,0x3c            
1002cab0  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002cab4  7c632214    add r3,r3,r4                
1002cab8  7f38182e    lwzx r25,r24,r3             
1002cabc  1ca5003c    mulli r5,r5,0x3c            
1002cac0  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002cac4  7ca53214    add r5,r5,r6                
1002cac8  572705ee    rlwinm r7,r25,0x0,0x17,0x17 
1002cacc  7cb8282e    lwzx r5,r24,r5              
1002cad0  2c070000    cmpwi r7,0x0                
1002cad4  54bf063e    rlwinm r31,r5,0x0,0x18,0x1f 
1002cad8  40820124    bne 0x1002cbfc                 ; -> 1002cbfc
1002cadc  7fe80734    extsh r8,r31                
1002cae0  2c080000    cmpwi r8,0x0                
1002cae4  41820118    beq 0x1002cbfc                 ; -> 1002cbfc
1002cae8  57290528    rlwinm r9,r25,0x0,0x14,0x14 
1002caec  2c090000    cmpwi r9,0x0                
1002caf0  4082010c    bne 0x1002cbfc                 ; -> 1002cbfc
1002caf4  572a0462    rlwinm r10,r25,0x0,0x11,0x11
1002caf8  2c0a0000    cmpwi r10,0x0               
1002cafc  40820064    bne 0x1002cb60                 ; -> 1002cb60
1002cb00  38600023    li r3,0x23                  
1002cb04  38800007    li r4,0x7                   
1002cb08  4bffe519    bl 0x1002b020                  ; -> 1002b020
1002cb0c  807c0000    lwz r3,0x0(r28)             
1002cb10  7fe4fb78    or r4,r31,r31               
1002cb14  7fc5f378    or r5,r30,r30               
1002cb18  7fa6eb78    or r6,r29,r29               
1002cb1c  4bfd7575    bl 0x10004090                  ; -> 10004090
1002cb20  60000000    ori r0,r0,0x0               
1002cb24  807c0000    lwz r3,0x0(r28)             
1002cb28  389f0001    addi r4,r31,0x1             
1002cb2c  7fc5f378    or r5,r30,r30               
1002cb30  7fa6eb78    or r6,r29,r29               
1002cb34  4bfd75d5    bl 0x10004108                  ; -> 10004108
1002cb38  60000000    ori r0,r0,0x0               
1002cb3c  7f4b0734    extsh r11,r26               
1002cb40  7f6c0734    extsh r12,r27               
1002cb44  1d6b003c    mulli r11,r11,0x3c          
1002cb48  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
1002cb4c  7d6b6214    add r11,r11,r12             
1002cb50  7c78582e    lwzx r3,r24,r11             
1002cb54  38634000    addi r3,r3,0x4000           
1002cb58  7c78592e    stwx r3,r24,r11             
1002cb5c  480000a0    b 0x1002cbfc                   ; -> 1002cbfc
1002cb60  38600024    li r3,0x24                  
1002cb64  38800007    li r4,0x7                   
1002cb68  4bffe4b9    bl 0x1002b020                  ; -> 1002b020
1002cb6c  7f43d378    or r3,r26,r26               
1002cb70  7f64db78    or r4,r27,r27               
1002cb74  4800009d    bl 0x1002cc10                  ; -> 1002cc10
1002cb78  60000000    ori r0,r0,0x0               
1002cb7c  807c0000    lwz r3,0x0(r28)             
1002cb80  389f0002    addi r4,r31,0x2             
1002cb84  7fc5f378    or r5,r30,r30               
1002cb88  7fa6eb78    or r6,r29,r29               
1002cb8c  38e0ffd8    li r7,-0x28                 
1002cb90  3900ffb0    li r8,-0x50                 
1002cb94  39200001    li r9,0x1                   
1002cb98  4bffad25    bl 0x100278bc                  ; -> 100278bc
1002cb9c  807c0000    lwz r3,0x0(r28)             
1002cba0  389f0003    addi r4,r31,0x3             
1002cba4  38be0010    addi r5,r30,0x10            
1002cba8  7fa6eb78    or r6,r29,r29               
1002cbac  38e00028    li r7,0x28                  
1002cbb0  3900ffb0    li r8,-0x50                 
1002cbb4  39200001    li r9,0x1                   
1002cbb8  4bffad05    bl 0x100278bc                  ; -> 100278bc
1002cbbc  807c0000    lwz r3,0x0(r28)             
1002cbc0  389f0004    addi r4,r31,0x4             
1002cbc4  38be0010    addi r5,r30,0x10            
1002cbc8  38dd0010    addi r6,r29,0x10            
1002cbcc  38e0003c    li r7,0x3c                  
1002cbd0  3900ffba    li r8,-0x46                 
1002cbd4  39200001    li r9,0x1                   
1002cbd8  4bfface5    bl 0x100278bc                  ; -> 100278bc
1002cbdc  807c0000    lwz r3,0x0(r28)             
1002cbe0  389f0005    addi r4,r31,0x5             
1002cbe4  7fc5f378    or r5,r30,r30               
1002cbe8  38dd0010    addi r6,r29,0x10            
1002cbec  38e0ffc4    li r7,-0x3c                 
1002cbf0  3900ffba    li r8,-0x46                 
1002cbf4  39200001    li r9,0x1                   
1002cbf8  4bffacc5    bl 0x100278bc                  ; -> 100278bc
1002cbfc  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1002cc00  38210060    addi r1,r1,0x60             
1002cc04  7c0803a6    mtspr LR,r0                 
1002cc08  bb01ffe0    lmw r24,-0x20(r1)              ; -> Stack[-0x20]
1002cc0c  4e800020    blr                         
