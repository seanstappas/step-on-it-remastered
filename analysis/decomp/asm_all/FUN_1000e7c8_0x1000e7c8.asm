; FUN_1000e7c8 @ 0x1000e7c8
1000e7c8  7c0802a6    mfspr r0,LR                 
1000e7cc  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
1000e7d0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000e7d4  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1000e7d8  b061007a    sth r3,0x7a(r1)                ; -> Stack[0x1a]
1000e7dc  a881007a    lha r4,0x7a(r1)                ; -> Stack[0x1a]
1000e7e0  38623cd8    addi r3,r2,0x3cd8           
1000e7e4  1c840046    mulli r4,r4,0x46            
1000e7e8  7fe32214    add r31,r3,r4               
1000e7ec  a8bf0026    lha r5,0x26(r31)            
1000e7f0  3b226bf8    addi r25,r2,0x6bf8          
1000e7f4  2c050000    cmpwi r5,0x0                
1000e7f8  4081000c    ble 0x1000e804                 ; -> 1000e804
1000e7fc  38600000    li r3,0x0                   
1000e800  480001b4    b 0x1000e9b4                   ; -> 1000e9b4
1000e804  38c23be4    addi r6,r2,0x3be4           
1000e808  a8ff0012    lha r7,0x12(r31)            
1000e80c  a8c60000    lha r6,0x0(r6)              
1000e810  7f863850    subf r28,r6,r7              
1000e814  7f880734    extsh r8,r28                
1000e818  2c080000    cmpwi r8,0x0                
1000e81c  40800008    bge 0x1000e824                 ; -> 1000e824
1000e820  7f9c00d0    neg r28,r28                 
1000e824  39223be0    addi r9,r2,0x3be0           
1000e828  a95f0012    lha r10,0x12(r31)           
1000e82c  a9290000    lha r9,0x0(r9)              
1000e830  7f695050    subf r27,r9,r10             
1000e834  7f6b0734    extsh r11,r27               
1000e838  2c0b0000    cmpwi r11,0x0               
1000e83c  40800008    bge 0x1000e844                 ; -> 1000e844
1000e840  7f7b00d0    neg r27,r27                 
1000e844  7f6c0734    extsh r12,r27               
1000e848  2c0c0028    cmpwi r12,0x28              
1000e84c  41800010    blt 0x1000e85c                 ; -> 1000e85c
1000e850  7f830734    extsh r3,r28                
1000e854  2c030028    cmpwi r3,0x28               
1000e858  4080000c    bge 0x1000e864                 ; -> 1000e864
1000e85c  38600001    li r3,0x1                   
1000e860  48000154    b 0x1000e9b4                   ; -> 1000e9b4
1000e864  a89f0010    lha r4,0x10(r31)            
1000e868  3864fff8    subi r3,r4,0x8              
1000e86c  4801fe61    bl 0x1002e6cc                  ; -> 1002e6cc
1000e870  60000000    ori r0,r0,0x0               
1000e874  7c7d1b78    or r29,r3,r3                
1000e878  a87f0012    lha r3,0x12(r31)            
1000e87c  4801fe7d    bl 0x1002e6f8                  ; -> 1002e6f8
1000e880  60000000    ori r0,r0,0x0               
1000e884  7fa50734    extsh r5,r29                
1000e888  7c7a1b78    or r26,r3,r3                
1000e88c  7f460734    extsh r6,r26                
1000e890  7fa70734    extsh r7,r29                
1000e894  1ca5003c    mulli r5,r5,0x3c            
1000e898  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1000e89c  7ca53214    add r5,r5,r6                
1000e8a0  2c070000    cmpwi r7,0x0                
1000e8a4  7fd9282e    lwzx r30,r25,r5             
1000e8a8  40810024    ble 0x1000e8cc                 ; -> 1000e8cc
1000e8ac  57c805ee    rlwinm r8,r30,0x0,0x17,0x17 
1000e8b0  2c080000    cmpwi r8,0x0                
1000e8b4  40820018    bne 0x1000e8cc                 ; -> 1000e8cc
1000e8b8  57c905ac    rlwinm r9,r30,0x0,0x16,0x16 
1000e8bc  2c090000    cmpwi r9,0x0                
1000e8c0  4182000c    beq 0x1000e8cc                 ; -> 1000e8cc
1000e8c4  38600001    li r3,0x1                   
1000e8c8  480000ec    b 0x1000e9b4                   ; -> 1000e9b4
1000e8cc  7faa0734    extsh r10,r29               
1000e8d0  394affff    subi r10,r10,0x1            
1000e8d4  7f4b0734    extsh r11,r26               
1000e8d8  7fac0734    extsh r12,r29               
1000e8dc  398cffff    subi r12,r12,0x1            
1000e8e0  1d4a003c    mulli r10,r10,0x3c          
1000e8e4  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1000e8e8  7d4a5a14    add r10,r10,r11             
1000e8ec  2c0c0000    cmpwi r12,0x0               
1000e8f0  7fd9502e    lwzx r30,r25,r10            
1000e8f4  40810024    ble 0x1000e918                 ; -> 1000e918
1000e8f8  57c305ee    rlwinm r3,r30,0x0,0x17,0x17 
1000e8fc  2c030000    cmpwi r3,0x0                
1000e900  40820018    bne 0x1000e918                 ; -> 1000e918
1000e904  57c405ac    rlwinm r4,r30,0x0,0x16,0x16 
1000e908  2c040000    cmpwi r4,0x0                
1000e90c  4182000c    beq 0x1000e918                 ; -> 1000e918
1000e910  38600001    li r3,0x1                   
1000e914  480000a0    b 0x1000e9b4                   ; -> 1000e9b4
1000e918  7fa50734    extsh r5,r29                
1000e91c  38a5fffe    subi r5,r5,0x2              
1000e920  7f460734    extsh r6,r26                
1000e924  7fa70734    extsh r7,r29                
1000e928  38e7fffe    subi r7,r7,0x2              
1000e92c  1ca5003c    mulli r5,r5,0x3c            
1000e930  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1000e934  7ca53214    add r5,r5,r6                
1000e938  2c070000    cmpwi r7,0x0                
1000e93c  7fd9282e    lwzx r30,r25,r5             
1000e940  40810024    ble 0x1000e964                 ; -> 1000e964
1000e944  57c805ee    rlwinm r8,r30,0x0,0x17,0x17 
1000e948  2c080000    cmpwi r8,0x0                
1000e94c  40820018    bne 0x1000e964                 ; -> 1000e964
1000e950  57c905ac    rlwinm r9,r30,0x0,0x16,0x16 
1000e954  2c090000    cmpwi r9,0x0                
1000e958  4182000c    beq 0x1000e964                 ; -> 1000e964
1000e95c  38600001    li r3,0x1                   
1000e960  48000054    b 0x1000e9b4                   ; -> 1000e9b4
1000e964  7faa0734    extsh r10,r29               
1000e968  394afffd    subi r10,r10,0x3            
1000e96c  7f4b0734    extsh r11,r26               
1000e970  7fac0734    extsh r12,r29               
1000e974  398cfffd    subi r12,r12,0x3            
1000e978  1d4a003c    mulli r10,r10,0x3c          
1000e97c  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1000e980  7d4a5a14    add r10,r10,r11             
1000e984  2c0c0000    cmpwi r12,0x0               
1000e988  7fd9502e    lwzx r30,r25,r10            
1000e98c  40810024    ble 0x1000e9b0                 ; -> 1000e9b0
1000e990  57c305ee    rlwinm r3,r30,0x0,0x17,0x17 
1000e994  2c030000    cmpwi r3,0x0                
1000e998  40820018    bne 0x1000e9b0                 ; -> 1000e9b0
1000e99c  57c405ac    rlwinm r4,r30,0x0,0x16,0x16 
1000e9a0  2c040000    cmpwi r4,0x0                
1000e9a4  4182000c    beq 0x1000e9b0                 ; -> 1000e9b0
1000e9a8  38600001    li r3,0x1                   
1000e9ac  48000008    b 0x1000e9b4                   ; -> 1000e9b4
1000e9b0  38600000    li r3,0x0                   
1000e9b4  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1000e9b8  38210060    addi r1,r1,0x60             
1000e9bc  7c0803a6    mtspr LR,r0                 
1000e9c0  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
1000e9c4  4e800020    blr                         
