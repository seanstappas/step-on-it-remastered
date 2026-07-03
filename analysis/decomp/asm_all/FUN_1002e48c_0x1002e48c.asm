; FUN_1002e48c @ 0x1002e48c
1002e48c  7c0802a6    mfspr r0,LR                 
1002e490  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1002e494  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002e498  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002e49c  7c7d1b78    or r29,r3,r3                
1002e4a0  7c9b2378    or r27,r4,r4                
1002e4a4  7cbc2b78    or r28,r5,r5                
1002e4a8  7fa30734    extsh r3,r29                
1002e4ac  2c030063    cmpwi r3,0x63               
1002e4b0  40810010    ble 0x1002e4c0                 ; -> 1002e4c0
1002e4b4  3be00009    li r31,0x9                  
1002e4b8  3bc00009    li r30,0x9                  
1002e4bc  48000018    b 0x1002e4d4                   ; -> 1002e4d4
1002e4c0  7fa40734    extsh r4,r29                
1002e4c4  38a0000a    li r5,0xa                   
1002e4c8  7fe42bd6    divw r31,r4,r5              
1002e4cc  1cdf000a    mulli r6,r31,0xa            
1002e4d0  7fc6e850    subf r30,r6,r29             
1002e4d4  4bffa485    bl 0x10028958                  ; -> 10028958
1002e4d8  38e26bb8    addi r7,r2,0x6bb8           
1002e4dc  389f0005    addi r4,r31,0x5             
1002e4e0  80670000    lwz r3,0x0(r7)              
1002e4e4  7f65db78    or r5,r27,r27               
1002e4e8  7f86e378    or r6,r28,r28               
1002e4ec  4bfd66c9    bl 0x10004bb4                  ; -> 10004bb4
1002e4f0  60000000    ori r0,r0,0x0               
1002e4f4  39026bb8    addi r8,r2,0x6bb8           
1002e4f8  389e0005    addi r4,r30,0x5             
1002e4fc  80680000    lwz r3,0x0(r8)              
1002e500  38bb0008    addi r5,r27,0x8             
1002e504  7f86e378    or r6,r28,r28               
1002e508  4bfd66ad    bl 0x10004bb4                  ; -> 10004bb4
1002e50c  60000000    ori r0,r0,0x0               
1002e510  4bffa4b1    bl 0x100289c0                  ; -> 100289c0
1002e514  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002e518  38210050    addi r1,r1,0x50             
1002e51c  7c0803a6    mtspr LR,r0                 
1002e520  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1002e524  4e800020    blr                         
