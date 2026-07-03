; FUN_1002d980 @ 0x1002d980
1002d980  7c0802a6    mfspr r0,LR                 
1002d984  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
1002d988  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002d98c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002d990  3b626bf8    addi r27,r2,0x6bf8          
1002d994  3ba23cd8    addi r29,r2,0x3cd8          
1002d998  4bfd7f15    bl 0x100058ac                  ; -> 100058ac
1002d99c  60000000    ori r0,r0,0x0               
1002d9a0  3b800001    li r28,0x1                  
1002d9a4  48000278    b 0x1002dc1c                   ; -> 1002dc1c
1002d9a8  3be00001    li r31,0x1                  
1002d9ac  48000260    b 0x1002dc0c                   ; -> 1002dc0c
1002d9b0  7f850734    extsh r5,r28                
1002d9b4  7f830734    extsh r3,r28                
1002d9b8  7fe60734    extsh r6,r31                
1002d9bc  7fe40734    extsh r4,r31                
1002d9c0  1ca5003c    mulli r5,r5,0x3c            
1002d9c4  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002d9c8  7ca53214    add r5,r5,r6                
1002d9cc  7cbb282e    lwzx r5,r27,r5              
1002d9d0  1c63003c    mulli r3,r3,0x3c            
1002d9d4  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002d9d8  7c632214    add r3,r3,r4                
1002d9dc  54a5056a    rlwinm r5,r5,0x0,0x15,0x15  
1002d9e0  7c7b182e    lwzx r3,r27,r3              
1002d9e4  2c050000    cmpwi r5,0x0                
1002d9e8  547a063e    rlwinm r26,r3,0x0,0x18,0x1f 
1002d9ec  4182021c    beq 0x1002dc08                 ; -> 1002dc08
1002d9f0  4bfd7f59    bl 0x10005948                  ; -> 10005948
1002d9f4  60000000    ori r0,r0,0x0               
1002d9f8  7c7e1b78    or r30,r3,r3                
1002d9fc  7fc80734    extsh r8,r30                
1002da00  1d080046    mulli r8,r8,0x46            
1002da04  7f890734    extsh r9,r28                
1002da08  7fea0734    extsh r10,r31               
1002da0c  1d29003c    mulli r9,r9,0x3c            
1002da10  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
1002da14  38e00000    li r7,0x0                   
1002da18  39080034    addi r8,r8,0x34             
1002da1c  7cfd41ae    stbx r7,r29,r8              
1002da20  7d295214    add r9,r9,r10               
1002da24  7d3b482e    lwzx r9,r27,r9              
1002da28  552904a4    rlwinm r9,r9,0x0,0x12,0x12  
1002da2c  2c090000    cmpwi r9,0x0                
1002da30  4182001c    beq 0x1002da4c                 ; -> 1002da4c
1002da34  7fcc0734    extsh r12,r30               
1002da38  1d8c0046    mulli r12,r12,0x46          
1002da3c  39600004    li r11,0x4                  
1002da40  398c0004    addi r12,r12,0x4            
1002da44  7d7d632e    sthx r11,r29,r12            
1002da48  480000d4    b 0x1002db1c                   ; -> 1002db1c
1002da4c  7f830734    extsh r3,r28                
1002da50  7fe40734    extsh r4,r31                
1002da54  1c63003c    mulli r3,r3,0x3c            
1002da58  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002da5c  7c632214    add r3,r3,r4                
1002da60  7c7b182e    lwzx r3,r27,r3              
1002da64  546305ee    rlwinm r3,r3,0x0,0x17,0x17  
1002da68  2c030000    cmpwi r3,0x0                
1002da6c  41820040    beq 0x1002daac                 ; -> 1002daac
1002da70  7f850734    extsh r5,r28                
1002da74  7fe60734    extsh r6,r31                
1002da78  1ca5003c    mulli r5,r5,0x3c            
1002da7c  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002da80  7ca53214    add r5,r5,r6                
1002da84  7cbb282e    lwzx r5,r27,r5              
1002da88  54a505ac    rlwinm r5,r5,0x0,0x16,0x16  
1002da8c  2c050000    cmpwi r5,0x0                
1002da90  4182001c    beq 0x1002daac                 ; -> 1002daac
1002da94  7fc80734    extsh r8,r30                
1002da98  1d080046    mulli r8,r8,0x46            
1002da9c  38e00003    li r7,0x3                   
1002daa0  39080004    addi r8,r8,0x4              
1002daa4  7cfd432e    sthx r7,r29,r8              
1002daa8  48000074    b 0x1002db1c                   ; -> 1002db1c
1002daac  7f890734    extsh r9,r28                
1002dab0  7fea0734    extsh r10,r31               
1002dab4  1d29003c    mulli r9,r9,0x3c            
1002dab8  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
1002dabc  7d295214    add r9,r9,r10               
1002dac0  7d3b482e    lwzx r9,r27,r9              
1002dac4  552905ee    rlwinm r9,r9,0x0,0x17,0x17  
1002dac8  2c090000    cmpwi r9,0x0                
1002dacc  41820018    beq 0x1002dae4                 ; -> 1002dae4
1002dad0  7fcc0734    extsh r12,r30               
1002dad4  1d8c0046    mulli r12,r12,0x46          
1002dad8  39600001    li r11,0x1                  
1002dadc  398c0004    addi r12,r12,0x4            
1002dae0  7d7d632e    sthx r11,r29,r12            
1002dae4  7f830734    extsh r3,r28                
1002dae8  7fe40734    extsh r4,r31                
1002daec  1c63003c    mulli r3,r3,0x3c            
1002daf0  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002daf4  7c632214    add r3,r3,r4                
1002daf8  7c7b182e    lwzx r3,r27,r3              
1002dafc  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
1002db00  2c030000    cmpwi r3,0x0                
1002db04  41820018    beq 0x1002db1c                 ; -> 1002db1c
1002db08  7fc60734    extsh r6,r30                
1002db0c  1cc60046    mulli r6,r6,0x46            
1002db10  38a00002    li r5,0x2                   
1002db14  38c60004    addi r6,r6,0x4              
1002db18  7cbd332e    sthx r5,r29,r6              
1002db1c  7fc70734    extsh r7,r30                
1002db20  1ce70046    mulli r7,r7,0x46            
1002db24  7fc80734    extsh r8,r30                
1002db28  1d080046    mulli r8,r8,0x46            
1002db2c  38e70002    addi r7,r7,0x2              
1002db30  7f5d3b2e    sthx r26,r29,r7             
1002db34  39080042    addi r8,r8,0x42             
1002db38  7f5d432e    sthx r26,r29,r8             
1002db3c  7f83e378    or r3,r28,r28               
1002db40  48000b6d    bl 0x1002e6ac                  ; -> 1002e6ac
1002db44  60000000    ori r0,r0,0x0               
1002db48  7fc90734    extsh r9,r30                
1002db4c  1d290046    mulli r9,r9,0x46            
1002db50  39290010    addi r9,r9,0x10             
1002db54  7c7d4b2e    sthx r3,r29,r9              
1002db58  7fe3fb78    or r3,r31,r31               
1002db5c  48000b61    bl 0x1002e6bc                  ; -> 1002e6bc
1002db60  60000000    ori r0,r0,0x0               
1002db64  7fca0734    extsh r10,r30               
1002db68  1d4a0046    mulli r10,r10,0x46          
1002db6c  394a0012    addi r10,r10,0x12           
1002db70  7c7d532e    sthx r3,r29,r10             
1002db74  7fcc0734    extsh r12,r30               
1002db78  1d8c0046    mulli r12,r12,0x46          
1002db7c  7f830734    extsh r3,r28                
1002db80  7fe40734    extsh r4,r31                
1002db84  7fc50734    extsh r5,r30                
1002db88  1ca50046    mulli r5,r5,0x46            
1002db8c  7f860734    extsh r6,r28                
1002db90  7fe70734    extsh r7,r31                
1002db94  7fc80734    extsh r8,r30                
1002db98  1d080046    mulli r8,r8,0x46            
1002db9c  7f8a0734    extsh r10,r28               
1002dba0  1c63003c    mulli r3,r3,0x3c            
1002dba4  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002dba8  39600000    li r11,0x0                  
1002dbac  398c0040    addi r12,r12,0x40           
1002dbb0  7d7d632e    sthx r11,r29,r12            
1002dbb4  7c632214    add r3,r3,r4                
1002dbb8  7c7b182e    lwzx r3,r27,r3              
1002dbbc  7feb0734    extsh r11,r31               
1002dbc0  5463021e    rlwinm r3,r3,0x0,0x8,0xf    
1002dbc4  7c638670    srawi r3,r3,0x10            
1002dbc8  1cc6003c    mulli r6,r6,0x3c            
1002dbcc  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
1002dbd0  7c630194    addze r3,r3                 
1002dbd4  38a50006    addi r5,r5,0x6              
1002dbd8  7c7d2b2e    sthx r3,r29,r5              
1002dbdc  7cc63a14    add r6,r6,r7                
1002dbe0  7cdb302e    lwzx r6,r27,r6              
1002dbe4  1d4a003c    mulli r10,r10,0x3c          
1002dbe8  54c6000e    rlwinm r6,r6,0x0,0x0,0x7    
1002dbec  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1002dbf0  54c6463e    rlwinm r6,r6,0x8,0x18,0x1f  
1002dbf4  39080008    addi r8,r8,0x8              
1002dbf8  7cdd432e    sthx r6,r29,r8              
1002dbfc  39200000    li r9,0x0                   
1002dc00  7d4a5a14    add r10,r10,r11             
1002dc04  7d3b512e    stwx r9,r27,r10             
1002dc08  3bff0001    addi r31,r31,0x1            
1002dc0c  7fec0734    extsh r12,r31               
1002dc10  2c0c000d    cmpwi r12,0xd               
1002dc14  4081fd9c    ble 0x1002d9b0                 ; -> 1002d9b0
1002dc18  3b9c0001    addi r28,r28,0x1            
1002dc1c  7f830734    extsh r3,r28                
1002dc20  2c030013    cmpwi r3,0x13               
1002dc24  4081fd84    ble 0x1002d9a8                 ; -> 1002d9a8
1002dc28  4bfe9f41    bl 0x10017b68                  ; -> 10017b68
1002dc2c  60000000    ori r0,r0,0x0               
1002dc30  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002dc34  38210050    addi r1,r1,0x50             
1002dc38  7c0803a6    mtspr LR,r0                 
1002dc3c  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
1002dc40  4e800020    blr                         
