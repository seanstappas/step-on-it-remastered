; FUN_1002b810 @ 0x1002b810
1002b810  7c0802a6    mfspr r0,LR                 
1002b814  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1002b818  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002b81c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002b820  7c7b1b78    or r27,r3,r3                
1002b824  7c9c2378    or r28,r4,r4                
1002b828  7cbd2b78    or r29,r5,r5                
1002b82c  3bc26bb8    addi r30,r2,0x6bb8          
1002b830  3be00009    li r31,0x9                  
1002b834  48000034    b 0x1002b868                   ; -> 1002b868
1002b838  7fe50734    extsh r5,r31                
1002b83c  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1002b840  7cbb2aae    lhax r5,r27,r5              
1002b844  20df0009    subfic r6,r31,0x9           
1002b848  38850005    addi r4,r5,0x5              
1002b84c  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
1002b850  7cbc3214    add r5,r28,r6               
1002b854  807e0000    lwz r3,0x0(r30)             
1002b858  7fa6eb78    or r6,r29,r29               
1002b85c  4bfd9359    bl 0x10004bb4                  ; -> 10004bb4
1002b860  60000000    ori r0,r0,0x0               
1002b864  3bffffff    subi r31,r31,0x1            
1002b868  7fe70734    extsh r7,r31                
1002b86c  2c070000    cmpwi r7,0x0                
1002b870  4080ffc8    bge 0x1002b838                 ; -> 1002b838
1002b874  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002b878  38210050    addi r1,r1,0x50             
1002b87c  7c0803a6    mtspr LR,r0                 
1002b880  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1002b884  4e800020    blr                         
