; FUN_1002e610 @ 0x1002e610
1002e610  7c0802a6    mfspr r0,LR                 
1002e614  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1002e618  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002e61c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002e620  7c7d1b78    or r29,r3,r3                
1002e624  7c9b2378    or r27,r4,r4                
1002e628  7cbc2b78    or r28,r5,r5                
1002e62c  7fa30734    extsh r3,r29                
1002e630  2c030063    cmpwi r3,0x63               
1002e634  40810010    ble 0x1002e644                 ; -> 1002e644
1002e638  3be00009    li r31,0x9                  
1002e63c  3bc00009    li r30,0x9                  
1002e640  48000018    b 0x1002e658                   ; -> 1002e658
1002e644  7fa40734    extsh r4,r29                
1002e648  38a0000a    li r5,0xa                   
1002e64c  7fe42bd6    divw r31,r4,r5              
1002e650  1cdf000a    mulli r6,r31,0xa            
1002e654  7fc6e850    subf r30,r6,r29             
1002e658  4bffa301    bl 0x10028958                  ; -> 10028958
1002e65c  38e26bb8    addi r7,r2,0x6bb8           
1002e660  389f0005    addi r4,r31,0x5             
1002e664  80670000    lwz r3,0x0(r7)              
1002e668  7f65db78    or r5,r27,r27               
1002e66c  7f86e378    or r6,r28,r28               
1002e670  4bfd6641    bl 0x10004cb0                  ; -> 10004cb0
1002e674  60000000    ori r0,r0,0x0               
1002e678  39026bb8    addi r8,r2,0x6bb8           
1002e67c  389e0005    addi r4,r30,0x5             
1002e680  80680000    lwz r3,0x0(r8)              
1002e684  38bb0008    addi r5,r27,0x8             
1002e688  7f86e378    or r6,r28,r28               
1002e68c  4bfd6625    bl 0x10004cb0                  ; -> 10004cb0
1002e690  60000000    ori r0,r0,0x0               
1002e694  4bffa32d    bl 0x100289c0                  ; -> 100289c0
1002e698  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002e69c  38210050    addi r1,r1,0x50             
1002e6a0  7c0803a6    mtspr LR,r0                 
1002e6a4  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1002e6a8  4e800020    blr                         
