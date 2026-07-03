; FUN_1002cc10 @ 0x1002cc10
1002cc10  7c0802a6    mfspr r0,LR                 
1002cc14  bee1ffdc    stmw r23,-0x24(r1)             ; -> Stack[-0x24]
1002cc18  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002cc1c  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1002cc20  7c7e1b78    or r30,r3,r3                
1002cc24  7c9f2378    or r31,r4,r4                
1002cc28  3ba26bf8    addi r29,r2,0x6bf8          
1002cc2c  3b426bc0    addi r26,r2,0x6bc0          
1002cc30  7fc3f378    or r3,r30,r30               
1002cc34  48001a79    bl 0x1002e6ac                  ; -> 1002e6ac
1002cc38  60000000    ori r0,r0,0x0               
1002cc3c  7c7c1b78    or r28,r3,r3                
1002cc40  7fe3fb78    or r3,r31,r31               
1002cc44  48001a79    bl 0x1002e6bc                  ; -> 1002e6bc
1002cc48  60000000    ori r0,r0,0x0               
1002cc4c  7c7b1b78    or r27,r3,r3                
1002cc50  7fc30734    extsh r3,r30                
1002cc54  7fe40734    extsh r4,r31                
1002cc58  1c63003c    mulli r3,r3,0x3c            
1002cc5c  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002cc60  7c632214    add r3,r3,r4                
1002cc64  7c7d182e    lwzx r3,r29,r3              
1002cc68  546305ee    rlwinm r3,r3,0x0,0x17,0x17  
1002cc6c  2c030000    cmpwi r3,0x0                
1002cc70  40820284    bne 0x1002cef4                 ; -> 1002cef4
1002cc74  7fc50734    extsh r5,r30                
1002cc78  7fe60734    extsh r6,r31                
1002cc7c  1ca5003c    mulli r5,r5,0x3c            
1002cc80  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002cc84  7ca53214    add r5,r5,r6                
1002cc88  7cbd282e    lwzx r5,r29,r5              
1002cc8c  54a5063e    rlwinm r5,r5,0x0,0x18,0x1f  
1002cc90  2c050000    cmpwi r5,0x0                
1002cc94  41820260    beq 0x1002cef4                 ; -> 1002cef4
1002cc98  7fc90734    extsh r9,r30                
1002cc9c  7fc70734    extsh r7,r30                
1002cca0  7fea0734    extsh r10,r31               
1002cca4  7fe80734    extsh r8,r31                
1002cca8  1d29003c    mulli r9,r9,0x3c            
1002ccac  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
1002ccb0  7d295214    add r9,r9,r10               
1002ccb4  7d3d482e    lwzx r9,r29,r9              
1002ccb8  1ce7003c    mulli r7,r7,0x3c            
1002ccbc  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
1002ccc0  7ce74214    add r7,r7,r8                
1002ccc4  552904e6    rlwinm r9,r9,0x0,0x13,0x13  
1002ccc8  7cfd382e    lwzx r7,r29,r7              
1002cccc  2c090000    cmpwi r9,0x0                
1002ccd0  54f9063e    rlwinm r25,r7,0x0,0x18,0x1f 
1002ccd4  40820098    bne 0x1002cd6c                 ; -> 1002cd6c
1002ccd8  7fcb0734    extsh r11,r30               
1002ccdc  7fec0734    extsh r12,r31               
1002cce0  1d6b003c    mulli r11,r11,0x3c          
1002cce4  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
1002cce8  7d6b6214    add r11,r11,r12             
1002ccec  7d7d582e    lwzx r11,r29,r11            
1002ccf0  556b0462    rlwinm r11,r11,0x0,0x11,0x11
1002ccf4  2c0b0000    cmpwi r11,0x0               
1002ccf8  4182003c    beq 0x1002cd34                 ; -> 1002cd34
1002ccfc  7fc50734    extsh r5,r30                
1002cd00  7fe60734    extsh r6,r31                
1002cd04  1ca5003c    mulli r5,r5,0x3c            
1002cd08  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002cd0c  7ca53214    add r5,r5,r6                
1002cd10  7cbd282e    lwzx r5,r29,r5              
1002cd14  807a0000    lwz r3,0x0(r26)             
1002cd18  54a5063e    rlwinm r5,r5,0x0,0x18,0x1f  
1002cd1c  38850001    addi r4,r5,0x1              
1002cd20  7f85e378    or r5,r28,r28               
1002cd24  7f66db78    or r6,r27,r27               
1002cd28  4bfd7369    bl 0x10004090                  ; -> 10004090
1002cd2c  60000000    ori r0,r0,0x0               
1002cd30  4800001c    b 0x1002cd4c                   ; -> 1002cd4c
1002cd34  807a0000    lwz r3,0x0(r26)             
1002cd38  7f24cb78    or r4,r25,r25               
1002cd3c  7f85e378    or r5,r28,r28               
1002cd40  7f66db78    or r6,r27,r27               
1002cd44  4bfd734d    bl 0x10004090                  ; -> 10004090
1002cd48  60000000    ori r0,r0,0x0               
1002cd4c  7fc80734    extsh r8,r30                
1002cd50  7fe90734    extsh r9,r31                
1002cd54  1d08003c    mulli r8,r8,0x3c            
1002cd58  5529103a    rlwinm r9,r9,0x2,0x0,0x1d   
1002cd5c  38e00000    li r7,0x0                   
1002cd60  7d084a14    add r8,r8,r9                
1002cd64  7cfd412e    stwx r7,r29,r8              
1002cd68  4800018c    b 0x1002cef4                   ; -> 1002cef4
1002cd6c  7fcc0734    extsh r12,r30               
1002cd70  7fe30734    extsh r3,r31                
1002cd74  7fca0734    extsh r10,r30               
1002cd78  7feb0734    extsh r11,r31               
1002cd7c  1d8c003c    mulli r12,r12,0x3c          
1002cd80  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1002cd84  7d8c1a14    add r12,r12,r3              
1002cd88  7d9d602e    lwzx r12,r29,r12            
1002cd8c  1d4a003c    mulli r10,r10,0x3c          
1002cd90  7d978670    srawi r23,r12,0x10          
1002cd94  7ef70194    addze r23,r23               
1002cd98  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1002cd9c  7ee40734    extsh r4,r23                
1002cda0  7d4a5a14    add r10,r10,r11             
1002cda4  54840528    rlwinm r4,r4,0x0,0x14,0x14  
1002cda8  7d5d502e    lwzx r10,r29,r10            
1002cdac  2c040000    cmpwi r4,0x0                
1002cdb0  5559063e    rlwinm r25,r10,0x0,0x18,0x1f
1002cdb4  56f8063e    rlwinm r24,r23,0x0,0x18,0x1f
1002cdb8  41820098    beq 0x1002ce50                 ; -> 1002ce50
1002cdbc  7fc50734    extsh r5,r30                
1002cdc0  7fe60734    extsh r6,r31                
1002cdc4  1ca5003c    mulli r5,r5,0x3c            
1002cdc8  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002cdcc  7ca53214    add r5,r5,r6                
1002cdd0  7cbd282e    lwzx r5,r29,r5              
1002cdd4  54a50462    rlwinm r5,r5,0x0,0x11,0x11  
1002cdd8  2c050000    cmpwi r5,0x0                
1002cddc  4182003c    beq 0x1002ce18                 ; -> 1002ce18
1002cde0  807a0000    lwz r3,0x0(r26)             
1002cde4  38990001    addi r4,r25,0x1             
1002cde8  7f85e378    or r5,r28,r28               
1002cdec  7f66db78    or r6,r27,r27               
1002cdf0  4bfd72a1    bl 0x10004090                  ; -> 10004090
1002cdf4  60000000    ori r0,r0,0x0               
1002cdf8  38e26bbc    addi r7,r2,0x6bbc           
1002cdfc  7f04c378    or r4,r24,r24               
1002ce00  80670000    lwz r3,0x0(r7)              
1002ce04  7f85e378    or r5,r28,r28               
1002ce08  7f66db78    or r6,r27,r27               
1002ce0c  4bfd72fd    bl 0x10004108                  ; -> 10004108
1002ce10  60000000    ori r0,r0,0x0               
1002ce14  480000c4    b 0x1002ced8                   ; -> 1002ced8
1002ce18  807a0000    lwz r3,0x0(r26)             
1002ce1c  7f24cb78    or r4,r25,r25               
1002ce20  7f85e378    or r5,r28,r28               
1002ce24  7f66db78    or r6,r27,r27               
1002ce28  4bfd7269    bl 0x10004090                  ; -> 10004090
1002ce2c  60000000    ori r0,r0,0x0               
1002ce30  39026bbc    addi r8,r2,0x6bbc           
1002ce34  7f04c378    or r4,r24,r24               
1002ce38  80680000    lwz r3,0x0(r8)              
1002ce3c  7f85e378    or r5,r28,r28               
1002ce40  7f66db78    or r6,r27,r27               
1002ce44  4bfd72c5    bl 0x10004108                  ; -> 10004108
1002ce48  60000000    ori r0,r0,0x0               
1002ce4c  4800008c    b 0x1002ced8                   ; -> 1002ced8
1002ce50  7fc90734    extsh r9,r30                
1002ce54  7fea0734    extsh r10,r31               
1002ce58  1d29003c    mulli r9,r9,0x3c            
1002ce5c  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
1002ce60  7d295214    add r9,r9,r10               
1002ce64  7d3d482e    lwzx r9,r29,r9              
1002ce68  55290462    rlwinm r9,r9,0x0,0x11,0x11  
1002ce6c  2c090000    cmpwi r9,0x0                
1002ce70  41820038    beq 0x1002cea8                 ; -> 1002cea8
1002ce74  807a0000    lwz r3,0x0(r26)             
1002ce78  38990001    addi r4,r25,0x1             
1002ce7c  7f85e378    or r5,r28,r28               
1002ce80  7f66db78    or r6,r27,r27               
1002ce84  4bfd720d    bl 0x10004090                  ; -> 10004090
1002ce88  60000000    ori r0,r0,0x0               
1002ce8c  807a0000    lwz r3,0x0(r26)             
1002ce90  7f04c378    or r4,r24,r24               
1002ce94  7f85e378    or r5,r28,r28               
1002ce98  7f66db78    or r6,r27,r27               
1002ce9c  4bfd726d    bl 0x10004108                  ; -> 10004108
1002cea0  60000000    ori r0,r0,0x0               
1002cea4  48000034    b 0x1002ced8                   ; -> 1002ced8
1002cea8  807a0000    lwz r3,0x0(r26)             
1002ceac  7f24cb78    or r4,r25,r25               
1002ceb0  7f85e378    or r5,r28,r28               
1002ceb4  7f66db78    or r6,r27,r27               
1002ceb8  4bfd71d9    bl 0x10004090                  ; -> 10004090
1002cebc  60000000    ori r0,r0,0x0               
1002cec0  807a0000    lwz r3,0x0(r26)             
1002cec4  7f04c378    or r4,r24,r24               
1002cec8  7f85e378    or r5,r28,r28               
1002cecc  7f66db78    or r6,r27,r27               
1002ced0  4bfd7239    bl 0x10004108                  ; -> 10004108
1002ced4  60000000    ori r0,r0,0x0               
1002ced8  7fcc0734    extsh r12,r30               
1002cedc  7fe30734    extsh r3,r31                
1002cee0  1d8c003c    mulli r12,r12,0x3c          
1002cee4  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1002cee8  7eeb0734    extsh r11,r23               
1002ceec  7d8c1a14    add r12,r12,r3              
1002cef0  7d7d612e    stwx r11,r29,r12            
1002cef4  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1002cef8  38210060    addi r1,r1,0x60             
1002cefc  7c0803a6    mtspr LR,r0                 
1002cf00  bae1ffdc    lmw r23,-0x24(r1)              ; -> Stack[-0x24]
1002cf04  4e800020    blr                         
