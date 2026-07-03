; FUN_1002af74 @ 0x1002af74
1002af74  7c0802a6    mfspr r0,LR                 
1002af78  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002af7c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002af80  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1002af84  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002af88  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002af8c  38827574    addi r4,r2,0x7574           
1002af90  38600000    li r3,0x0                   
1002af94  3ba22f04    addi r29,r2,0x2f04          
1002af98  3bc26a7c    addi r30,r2,0x6a7c          
1002af9c  b0640000    sth r3,0x0(r4)              
1002afa0  3be00001    li r31,0x1                  
1002afa4  48000054    b 0x1002aff8                   ; -> 1002aff8
1002afa8  7fe50734    extsh r5,r31                
1002afac  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1002afb0  7c7d2aae    lhax r3,r29,r5              
1002afb4  3880002a    li r4,0x2a                  
1002afb8  4bfee8dd    bl 0x10019894                  ; -> 10019894
1002afbc  60000000    ori r0,r0,0x0               
1002afc0  7fe60734    extsh r6,r31                
1002afc4  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002afc8  7fe70734    extsh r7,r31                
1002afcc  7c7e312e    stwx r3,r30,r6              
1002afd0  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
1002afd4  7cfe382e    lwzx r7,r30,r7              
1002afd8  28070000    cmplwi r7,0x0               
1002afdc  40820010    bne 0x1002afec                 ; -> 1002afec
1002afe0  38600006    li r3,0x6                   
1002afe4  4bfee315    bl 0x100192f8                  ; -> 100192f8
1002afe8  60000000    ori r0,r0,0x0               
1002afec  4bff8e85    bl 0x10023e70                  ; -> 10023e70
1002aff0  60000000    ori r0,r0,0x0               
1002aff4  3bff0001    addi r31,r31,0x1            
1002aff8  7fe80734    extsh r8,r31                
1002affc  2c080034    cmpwi r8,0x34               
1002b000  4081ffa8    ble 0x1002afa8                 ; -> 1002afa8
1002b004  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002b008  38210050    addi r1,r1,0x50             
1002b00c  7c0803a6    mtspr LR,r0                 
1002b010  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002b014  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002b018  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1002b01c  4e800020    blr                         
