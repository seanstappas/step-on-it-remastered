; FUN_10016b28 @ 0x10016b28
10016b28  7c0802a6    mfspr r0,LR                 
10016b2c  bf01ffe0    stmw r24,-0x20(r1)             ; -> Stack[-0x20]
10016b30  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10016b34  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10016b38  3b826bbc    addi r28,r2,0x6bbc          
10016b3c  3ba26bf8    addi r29,r2,0x6bf8          
10016b40  3bc00001    li r30,0x1                  
10016b44  4800007c    b 0x10016bc0                   ; -> 10016bc0
10016b48  3be00001    li r31,0x1                  
10016b4c  48000064    b 0x10016bb0                   ; -> 10016bb0
10016b50  7fc30734    extsh r3,r30                
10016b54  7fe40734    extsh r4,r31                
10016b58  1c63003c    mulli r3,r3,0x3c            
10016b5c  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10016b60  7c632214    add r3,r3,r4                
10016b64  7c7d182e    lwzx r3,r29,r3              
10016b68  546304e6    rlwinm r3,r3,0x0,0x13,0x13  
10016b6c  2c030000    cmpwi r3,0x0                
10016b70  4182003c    beq 0x10016bac                 ; -> 10016bac
10016b74  7fe3fb78    or r3,r31,r31               
10016b78  48017b45    bl 0x1002e6bc                  ; -> 1002e6bc
10016b7c  60000000    ori r0,r0,0x0               
10016b80  7c791b78    or r25,r3,r3                
10016b84  7fc3f378    or r3,r30,r30               
10016b88  48017b25    bl 0x1002e6ac                  ; -> 1002e6ac
10016b8c  60000000    ori r0,r0,0x0               
10016b90  7c781b78    or r24,r3,r3                
10016b94  807c0000    lwz r3,0x0(r28)             
10016b98  38800033    li r4,0x33                  
10016b9c  7f05c378    or r5,r24,r24               
10016ba0  7f26cb78    or r6,r25,r25               
10016ba4  4bfee011    bl 0x10004bb4                  ; -> 10004bb4
10016ba8  60000000    ori r0,r0,0x0               
10016bac  3bff0001    addi r31,r31,0x1            
10016bb0  7fe50734    extsh r5,r31                
10016bb4  2c05000d    cmpwi r5,0xd                
10016bb8  4081ff98    ble 0x10016b50                 ; -> 10016b50
10016bbc  3bde0001    addi r30,r30,0x1            
10016bc0  7fc60734    extsh r6,r30                
10016bc4  2c060013    cmpwi r6,0x13               
10016bc8  4081ff80    ble 0x10016b48                 ; -> 10016b48
10016bcc  4801a3fd    bl 0x10030fc8                  ; -> 10030fc8
10016bd0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10016bd4  3b63012c    addi r27,r3,0x12c           
10016bd8  48000008    b 0x10016be0                   ; -> 10016be0
10016bdc  7f7adb78    or r26,r27,r27              
10016be0  4801a3e9    bl 0x10030fc8                  ; -> 10030fc8
10016be4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
10016be8  7c1b1840    cmplw r27,r3                
10016bec  4181fff0    bgt 0x10016bdc                 ; -> 10016bdc
10016bf0  3bc00001    li r30,0x1                  
10016bf4  4800007c    b 0x10016c70                   ; -> 10016c70
10016bf8  3be00001    li r31,0x1                  
10016bfc  48000064    b 0x10016c60                   ; -> 10016c60
10016c00  7fc70734    extsh r7,r30                
10016c04  7fe80734    extsh r8,r31                
10016c08  1ce7003c    mulli r7,r7,0x3c            
10016c0c  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
10016c10  7ce74214    add r7,r7,r8                
10016c14  7cfd382e    lwzx r7,r29,r7              
10016c18  54e704e6    rlwinm r7,r7,0x0,0x13,0x13  
10016c1c  2c070000    cmpwi r7,0x0                
10016c20  4182003c    beq 0x10016c5c                 ; -> 10016c5c
10016c24  7fe3fb78    or r3,r31,r31               
10016c28  48017a95    bl 0x1002e6bc                  ; -> 1002e6bc
10016c2c  60000000    ori r0,r0,0x0               
10016c30  7c791b78    or r25,r3,r3                
10016c34  7fc3f378    or r3,r30,r30               
10016c38  48017a75    bl 0x1002e6ac                  ; -> 1002e6ac
10016c3c  60000000    ori r0,r0,0x0               
10016c40  7c781b78    or r24,r3,r3                
10016c44  807c0000    lwz r3,0x0(r28)             
10016c48  38800033    li r4,0x33                  
10016c4c  7f05c378    or r5,r24,r24               
10016c50  7f26cb78    or r6,r25,r25               
10016c54  4bfee05d    bl 0x10004cb0                  ; -> 10004cb0
10016c58  60000000    ori r0,r0,0x0               
10016c5c  3bff0001    addi r31,r31,0x1            
10016c60  7fe90734    extsh r9,r31                
10016c64  2c09000d    cmpwi r9,0xd                
10016c68  4081ff98    ble 0x10016c00                 ; -> 10016c00
10016c6c  3bde0001    addi r30,r30,0x1            
10016c70  7fca0734    extsh r10,r30               
10016c74  2c0a0013    cmpwi r10,0x13              
10016c78  4081ff80    ble 0x10016bf8                 ; -> 10016bf8
10016c7c  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10016c80  38210060    addi r1,r1,0x60             
10016c84  7c0803a6    mtspr LR,r0                 
10016c88  bb01ffe0    lmw r24,-0x20(r1)              ; -> Stack[-0x20]
10016c8c  4e800020    blr                         
