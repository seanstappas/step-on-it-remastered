; FUN_1000a780 @ 0x1000a780
1000a780  7c0802a6    mfspr r0,LR                 
1000a784  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1000a788  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000a78c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000a790  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
1000a794  a881006a    lha r4,0x6a(r1)                ; -> Stack[0x1a]
1000a798  38623cd8    addi r3,r2,0x3cd8           
1000a79c  1c840046    mulli r4,r4,0x46            
1000a7a0  7fe32214    add r31,r3,r4               
1000a7a4  88bf001f    lbz r5,0x1f(r31)            
1000a7a8  3ba203c0    addi r29,r2,0x3c0           
1000a7ac  28050000    cmplwi r5,0x0               
1000a7b0  3bc20400    addi r30,r2,0x400           
1000a7b4  418200a0    beq 0x1000a854                 ; -> 1000a854
1000a7b8  38c00000    li r6,0x0                   
1000a7bc  98df001f    stb r6,0x1f(r31)            
1000a7c0  38e00001    li r7,0x1                   
1000a7c4  390261a4    addi r8,r2,0x61a4           
1000a7c8  b0ff0024    sth r7,0x24(r31)            
1000a7cc  8108003c    lwz r8,0x3c(r8)             
1000a7d0  39200000    li r9,0x0                   
1000a7d4  911f000a    stw r8,0xa(r31)             
1000a7d8  913f0014    stw r9,0x14(r31)            
1000a7dc  a95f0004    lha r10,0x4(r31)            
1000a7e0  2c0a0002    cmpwi r10,0x2               
1000a7e4  40820028    bne 0x1000a80c                 ; -> 1000a80c
1000a7e8  a97f0010    lha r11,0x10(r31)           
1000a7ec  7d6c2e70    srawi r12,r11,0x5           
1000a7f0  7d8c0194    addze r12,r12               
1000a7f4  558c2834    rlwinm r12,r12,0x5,0x0,0x1a 
1000a7f8  7d8c5810    subfc r12,r12,r11           
1000a7fc  558c083c    rlwinm r12,r12,0x1,0x0,0x1e 
1000a800  7d9e62ae    lhax r12,r30,r12            
1000a804  b19f000e    sth r12,0xe(r31)            
1000a808  48000024    b 0x1000a82c                   ; -> 1000a82c
1000a80c  a87f0010    lha r3,0x10(r31)            
1000a810  7c642e70    srawi r4,r3,0x5             
1000a814  7c840194    addze r4,r4                 
1000a818  54842834    rlwinm r4,r4,0x5,0x0,0x1a   
1000a81c  7c841810    subfc r4,r4,r3              
1000a820  5484083c    rlwinm r4,r4,0x1,0x0,0x1e   
1000a824  7c9d22ae    lhax r4,r29,r4              
1000a828  b09f000e    sth r4,0xe(r31)             
1000a82c  a8bf0012    lha r5,0x12(r31)            
1000a830  38c00001    li r6,0x1                   
1000a834  38a50001    addi r5,r5,0x1              
1000a838  b0bf0012    sth r5,0x12(r31)            
1000a83c  98df001e    stb r6,0x1e(r31)            
1000a840  38e00000    li r7,0x0                   
1000a844  b0ff0026    sth r7,0x26(r31)            
1000a848  390003e8    li r8,0x3e8                 
1000a84c  b11f0042    sth r8,0x42(r31)            
1000a850  48000560    b 0x1000adb0                   ; -> 1000adb0
1000a854  a93f0024    lha r9,0x24(r31)            
1000a858  7d2a4b78    or r10,r9,r9                
1000a85c  7d4a0734    extsh r10,r10               
1000a860  3929ffff    subi r9,r9,0x1              
1000a864  2c0a0000    cmpwi r10,0x0               
1000a868  b13f0024    sth r9,0x24(r31)            
1000a86c  41810544    bgt 0x1000adb0                 ; -> 1000adb0
1000a870  39600001    li r11,0x1                  
1000a874  997f001e    stb r11,0x1e(r31)           
1000a878  a99f0040    lha r12,0x40(r31)           
1000a87c  2c0c0000    cmpwi r12,0x0               
1000a880  40810058    ble 0x1000a8d8                 ; -> 1000a8d8
1000a884  3860000a    li r3,0xa                   
1000a888  38800005    li r4,0x5                   
1000a88c  48020795    bl 0x1002b020                  ; -> 1002b020
1000a890  60000000    ori r0,r0,0x0               
1000a894  38600001    li r3,0x1                   
1000a898  987f0020    stb r3,0x20(r31)            
1000a89c  807f000a    lwz r3,0xa(r31)             
1000a8a0  a89f000e    lha r4,0xe(r31)             
1000a8a4  a8bf0010    lha r5,0x10(r31)            
1000a8a8  a8df0012    lha r6,0x12(r31)            
1000a8ac  38e00001    li r7,0x1                   
1000a8b0  4801d765    bl 0x10028014                  ; -> 10028014
1000a8b4  60000000    ori r0,r0,0x0               
1000a8b8  a8df0040    lha r6,0x40(r31)            
1000a8bc  38a26840    addi r5,r2,0x6840           
1000a8c0  1cc60070    mulli r6,r6,0x70            
1000a8c4  38a5003c    addi r5,r5,0x3c             
1000a8c8  a89f0042    lha r4,0x42(r31)            
1000a8cc  7ce5302e    lwzx r7,r5,r6               
1000a8d0  7ce72214    add r7,r7,r4                
1000a8d4  7ce5312e    stwx r7,r5,r6               
1000a8d8  39000001    li r8,0x1                   
1000a8dc  b11f0024    sth r8,0x24(r31)            
1000a8e0  a93f0010    lha r9,0x10(r31)            
1000a8e4  a95f0010    lha r10,0x10(r31)           
1000a8e8  a97f0012    lha r11,0x12(r31)           
1000a8ec  38690006    addi r3,r9,0x6              
1000a8f0  388a001a    addi r4,r10,0x1a            
1000a8f4  38ab001f    addi r5,r11,0x1f            
1000a8f8  4bffae59    bl 0x10005750                  ; -> 10005750
1000a8fc  60000000    ori r0,r0,0x0               
1000a900  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a904  28030000    cmplwi r3,0x0               
1000a908  418200f8    beq 0x1000aa00                 ; -> 1000aa00
1000a90c  a99f0044    lha r12,0x44(r31)           
1000a910  2c0c0000    cmpwi r12,0x0               
1000a914  40820018    bne 0x1000a92c                 ; -> 1000a92c
1000a918  a87f0010    lha r3,0x10(r31)            
1000a91c  a89f0012    lha r4,0x12(r31)            
1000a920  4bffaefd    bl 0x1000581c                  ; -> 1000581c
1000a924  60000000    ori r0,r0,0x0               
1000a928  b07f0044    sth r3,0x44(r31)            
1000a92c  a87f0012    lha r3,0x12(r31)            
1000a930  38630004    addi r3,r3,0x4              
1000a934  b07f0012    sth r3,0x12(r31)            
1000a938  a89f000e    lha r4,0xe(r31)             
1000a93c  38840002    addi r4,r4,0x2              
1000a940  b09f000e    sth r4,0xe(r31)             
1000a944  a8bf0004    lha r5,0x4(r31)             
1000a948  2c050002    cmpwi r5,0x2                
1000a94c  4082001c    bne 0x1000a968                 ; -> 1000a968
1000a950  a8df000e    lha r6,0xe(r31)             
1000a954  2c060030    cmpwi r6,0x30               
1000a958  40810024    ble 0x1000a97c                 ; -> 1000a97c
1000a95c  38e00021    li r7,0x21                  
1000a960  b0ff000e    sth r7,0xe(r31)             
1000a964  48000018    b 0x1000a97c                   ; -> 1000a97c
1000a968  a91f000e    lha r8,0xe(r31)             
1000a96c  2c080050    cmpwi r8,0x50               
1000a970  4081000c    ble 0x1000a97c                 ; -> 1000a97c
1000a974  39200041    li r9,0x41                  
1000a978  b13f000e    sth r9,0xe(r31)             
1000a97c  a95f0010    lha r10,0x10(r31)           
1000a980  a97f0010    lha r11,0x10(r31)           
1000a984  a99f0012    lha r12,0x12(r31)           
1000a988  386a0006    addi r3,r10,0x6             
1000a98c  388b001a    addi r4,r11,0x1a            
1000a990  38ac001f    addi r5,r12,0x1f            
1000a994  4bffadbd    bl 0x10005750                  ; -> 10005750
1000a998  60000000    ori r0,r0,0x0               
1000a99c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000a9a0  28030000    cmplwi r3,0x0               
1000a9a4  408203dc    bne 0x1000ad80                 ; -> 1000ad80
1000a9a8  3860000a    li r3,0xa                   
1000a9ac  38800005    li r4,0x5                   
1000a9b0  48020671    bl 0x1002b020                  ; -> 1002b020
1000a9b4  60000000    ori r0,r0,0x0               
1000a9b8  a8bf0044    lha r5,0x44(r31)            
1000a9bc  38826840    addi r4,r2,0x6840           
1000a9c0  1ca50070    mulli r5,r5,0x70            
1000a9c4  3884003c    addi r4,r4,0x3c             
1000a9c8  a87f0042    lha r3,0x42(r31)            
1000a9cc  7cc4282e    lwzx r6,r4,r5               
1000a9d0  38e00001    li r7,0x1                   
1000a9d4  7cc61a14    add r6,r6,r3                
1000a9d8  7cc4292e    stwx r6,r4,r5               
1000a9dc  98ff0020    stb r7,0x20(r31)            
1000a9e0  807f000a    lwz r3,0xa(r31)             
1000a9e4  a89f000e    lha r4,0xe(r31)             
1000a9e8  a8bf0010    lha r5,0x10(r31)            
1000a9ec  a8df0012    lha r6,0x12(r31)            
1000a9f0  38e00001    li r7,0x1                   
1000a9f4  4801d621    bl 0x10028014                  ; -> 10028014
1000a9f8  60000000    ori r0,r0,0x0               
1000a9fc  48000384    b 0x1000ad80                   ; -> 1000ad80
1000aa00  a91f0026    lha r8,0x26(r31)            
1000aa04  2c080000    cmpwi r8,0x0                
1000aa08  40810154    ble 0x1000ab5c                 ; -> 1000ab5c
1000aa0c  a93f0004    lha r9,0x4(r31)             
1000aa10  2c090002    cmpwi r9,0x2                
1000aa14  408200a8    bne 0x1000aabc                 ; -> 1000aabc
1000aa18  a95f0026    lha r10,0x26(r31)           
1000aa1c  394a0001    addi r10,r10,0x1            
1000aa20  b15f0026    sth r10,0x26(r31)           
1000aa24  7d4a0734    extsh r10,r10               
1000aa28  2c0a0020    cmpwi r10,0x20              
1000aa2c  40810030    ble 0x1000aa5c                 ; -> 1000aa5c
1000aa30  39600000    li r11,0x0                  
1000aa34  b17f0026    sth r11,0x26(r31)           
1000aa38  a99f0010    lha r12,0x10(r31)           
1000aa3c  7d832e70    srawi r3,r12,0x5            
1000aa40  7c630194    addze r3,r3                 
1000aa44  54632834    rlwinm r3,r3,0x5,0x0,0x1a   
1000aa48  7c636010    subfc r3,r3,r12             
1000aa4c  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
1000aa50  7c7e1aae    lhax r3,r30,r3              
1000aa54  b07f000e    sth r3,0xe(r31)             
1000aa58  48000328    b 0x1000ad80                   ; -> 1000ad80
1000aa5c  a89f0026    lha r4,0x26(r31)            
1000aa60  b09f000e    sth r4,0xe(r31)             
1000aa64  a8bf000e    lha r5,0xe(r31)             
1000aa68  2c050018    cmpwi r5,0x18               
1000aa6c  40820314    bne 0x1000ad80                 ; -> 1000ad80
1000aa70  a8df0012    lha r6,0x12(r31)            
1000aa74  3866000a    addi r3,r6,0xa              
1000aa78  48023c81    bl 0x1002e6f8                  ; -> 1002e6f8
1000aa7c  60000000    ori r0,r0,0x0               
1000aa80  a8ff0010    lha r7,0x10(r31)            
1000aa84  7c7c1b78    or r28,r3,r3                
1000aa88  38670020    addi r3,r7,0x20             
1000aa8c  48023c41    bl 0x1002e6cc                  ; -> 1002e6cc
1000aa90  60000000    ori r0,r0,0x0               
1000aa94  7c7b1b78    or r27,r3,r3                
1000aa98  7f63db78    or r3,r27,r27               
1000aa9c  7f84e378    or r4,r28,r28               
1000aaa0  4801d2e5    bl 0x10027d84                  ; -> 10027d84
1000aaa4  60000000    ori r0,r0,0x0               
1000aaa8  38600011    li r3,0x11                  
1000aaac  38800004    li r4,0x4                   
1000aab0  48020571    bl 0x1002b020                  ; -> 1002b020
1000aab4  60000000    ori r0,r0,0x0               
1000aab8  480002c8    b 0x1000ad80                   ; -> 1000ad80
1000aabc  a91f0026    lha r8,0x26(r31)            
1000aac0  39080001    addi r8,r8,0x1              
1000aac4  b11f0026    sth r8,0x26(r31)            
1000aac8  7d080734    extsh r8,r8                 
1000aacc  2c080010    cmpwi r8,0x10               
1000aad0  40810030    ble 0x1000ab00                 ; -> 1000ab00
1000aad4  39200000    li r9,0x0                   
1000aad8  b13f0026    sth r9,0x26(r31)            
1000aadc  a95f0010    lha r10,0x10(r31)           
1000aae0  7d4b2e70    srawi r11,r10,0x5           
1000aae4  7d6b0194    addze r11,r11               
1000aae8  556b2834    rlwinm r11,r11,0x5,0x0,0x1a 
1000aaec  7d6b5010    subfc r11,r11,r10           
1000aaf0  556b083c    rlwinm r11,r11,0x1,0x0,0x1e 
1000aaf4  7d7d5aae    lhax r11,r29,r11            
1000aaf8  b17f000e    sth r11,0xe(r31)            
1000aafc  48000284    b 0x1000ad80                   ; -> 1000ad80
1000ab00  a99f0026    lha r12,0x26(r31)           
1000ab04  b19f000e    sth r12,0xe(r31)            
1000ab08  ab7f000e    lha r27,0xe(r31)            
1000ab0c  2c1b0008    cmpwi r27,0x8               
1000ab10  40820270    bne 0x1000ad80                 ; -> 1000ad80
1000ab14  ab9f0012    lha r28,0x12(r31)           
1000ab18  387c000a    addi r3,r28,0xa             
1000ab1c  48023bdd    bl 0x1002e6f8                  ; -> 1002e6f8
1000ab20  60000000    ori r0,r0,0x0               
1000ab24  7c7c1b78    or r28,r3,r3                
1000ab28  a87f0010    lha r3,0x10(r31)            
1000ab2c  48023ba1    bl 0x1002e6cc                  ; -> 1002e6cc
1000ab30  60000000    ori r0,r0,0x0               
1000ab34  7c7b1b78    or r27,r3,r3                
1000ab38  7f63db78    or r3,r27,r27               
1000ab3c  7f84e378    or r4,r28,r28               
1000ab40  4801d38d    bl 0x10027ecc                  ; -> 10027ecc
1000ab44  60000000    ori r0,r0,0x0               
1000ab48  38600011    li r3,0x11                  
1000ab4c  38800004    li r4,0x4                   
1000ab50  480204d1    bl 0x1002b020                  ; -> 1002b020
1000ab54  60000000    ori r0,r0,0x0               
1000ab58  48000228    b 0x1000ad80                   ; -> 1000ad80
1000ab5c  a87f0004    lha r3,0x4(r31)             
1000ab60  2c030002    cmpwi r3,0x2                
1000ab64  408200dc    bne 0x1000ac40                 ; -> 1000ac40
1000ab68  a89f0010    lha r4,0x10(r31)            
1000ab6c  a8bf0012    lha r5,0x12(r31)            
1000ab70  3864001c    addi r3,r4,0x1c             
1000ab74  3885000a    addi r4,r5,0xa              
1000ab78  4bffa9d5    bl 0x1000554c                  ; -> 1000554c
1000ab7c  60000000    ori r0,r0,0x0               
1000ab80  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000ab84  28030000    cmplwi r3,0x0               
1000ab88  41820050    beq 0x1000abd8                 ; -> 1000abd8
1000ab8c  a8df0010    lha r6,0x10(r31)            
1000ab90  a8ff0012    lha r7,0x12(r31)            
1000ab94  3866001c    addi r3,r6,0x1c             
1000ab98  3887000a    addi r4,r7,0xa              
1000ab9c  4bffab39    bl 0x100056d4                  ; -> 100056d4
1000aba0  60000000    ori r0,r0,0x0               
1000aba4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000aba8  28030000    cmplwi r3,0x0               
1000abac  41820018    beq 0x1000abc4                 ; -> 1000abc4
1000abb0  39000005    li r8,0x5                   
1000abb4  b11f0004    sth r8,0x4(r31)             
1000abb8  39200031    li r9,0x31                  
1000abbc  b13f000e    sth r9,0xe(r31)             
1000abc0  480001c0    b 0x1000ad80                   ; -> 1000ad80
1000abc4  39400011    li r10,0x11                 
1000abc8  b15f0026    sth r10,0x26(r31)           
1000abcc  a97f0026    lha r11,0x26(r31)           
1000abd0  b17f000e    sth r11,0xe(r31)            
1000abd4  480001ac    b 0x1000ad80                   ; -> 1000ad80
1000abd8  a99f0010    lha r12,0x10(r31)           
1000abdc  ab7f0012    lha r27,0x12(r31)           
1000abe0  386c001c    addi r3,r12,0x1c            
1000abe4  389b001f    addi r4,r27,0x1f            
1000abe8  4bffa965    bl 0x1000554c                  ; -> 1000554c
1000abec  60000000    ori r0,r0,0x0               
1000abf0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000abf4  28030000    cmplwi r3,0x0               
1000abf8  40820018    bne 0x1000ac10                 ; -> 1000ac10
1000abfc  3b800005    li r28,0x5                  
1000ac00  b39f0004    sth r28,0x4(r31)            
1000ac04  38600031    li r3,0x31                  
1000ac08  b07f000e    sth r3,0xe(r31)             
1000ac0c  48000174    b 0x1000ad80                   ; -> 1000ad80
1000ac10  a89f0010    lha r4,0x10(r31)            
1000ac14  38840002    addi r4,r4,0x2              
1000ac18  b09f0010    sth r4,0x10(r31)            
1000ac1c  a8bf0010    lha r5,0x10(r31)            
1000ac20  7ca62e70    srawi r6,r5,0x5             
1000ac24  7cc60194    addze r6,r6                 
1000ac28  54c62834    rlwinm r6,r6,0x5,0x0,0x1a   
1000ac2c  7cc62810    subfc r6,r6,r5              
1000ac30  54c6083c    rlwinm r6,r6,0x1,0x0,0x1e   
1000ac34  7cde32ae    lhax r6,r30,r6              
1000ac38  b0df000e    sth r6,0xe(r31)             
1000ac3c  48000144    b 0x1000ad80                   ; -> 1000ad80
1000ac40  a8ff0004    lha r7,0x4(r31)             
1000ac44  2c070001    cmpwi r7,0x1                
1000ac48  408200dc    bne 0x1000ad24                 ; -> 1000ad24
1000ac4c  a91f0010    lha r8,0x10(r31)            
1000ac50  a93f0012    lha r9,0x12(r31)            
1000ac54  38680004    addi r3,r8,0x4              
1000ac58  3889000a    addi r4,r9,0xa              
1000ac5c  4bffa8f1    bl 0x1000554c                  ; -> 1000554c
1000ac60  60000000    ori r0,r0,0x0               
1000ac64  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000ac68  28030000    cmplwi r3,0x0               
1000ac6c  41820050    beq 0x1000acbc                 ; -> 1000acbc
1000ac70  a95f0010    lha r10,0x10(r31)           
1000ac74  a97f0012    lha r11,0x12(r31)           
1000ac78  386a0004    addi r3,r10,0x4             
1000ac7c  388b000a    addi r4,r11,0xa             
1000ac80  4bffaa55    bl 0x100056d4                  ; -> 100056d4
1000ac84  60000000    ori r0,r0,0x0               
1000ac88  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000ac8c  28030000    cmplwi r3,0x0               
1000ac90  41820018    beq 0x1000aca8                 ; -> 1000aca8
1000ac94  39800006    li r12,0x6                  
1000ac98  b19f0004    sth r12,0x4(r31)            
1000ac9c  3b600040    li r27,0x40                 
1000aca0  b37f000e    sth r27,0xe(r31)            
1000aca4  480000dc    b 0x1000ad80                   ; -> 1000ad80
1000aca8  3b800001    li r28,0x1                  
1000acac  b39f0026    sth r28,0x26(r31)           
1000acb0  a87f0026    lha r3,0x26(r31)            
1000acb4  b07f000e    sth r3,0xe(r31)             
1000acb8  480000c8    b 0x1000ad80                   ; -> 1000ad80
1000acbc  a89f0010    lha r4,0x10(r31)            
1000acc0  a8bf0012    lha r5,0x12(r31)            
1000acc4  38640004    addi r3,r4,0x4              
1000acc8  3885001f    addi r4,r5,0x1f             
1000accc  4bffa881    bl 0x1000554c                  ; -> 1000554c
1000acd0  60000000    ori r0,r0,0x0               
1000acd4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000acd8  28030000    cmplwi r3,0x0               
1000acdc  40820018    bne 0x1000acf4                 ; -> 1000acf4
1000ace0  38c00006    li r6,0x6                   
1000ace4  b0df0004    sth r6,0x4(r31)             
1000ace8  38e00040    li r7,0x40                  
1000acec  b0ff000e    sth r7,0xe(r31)             
1000acf0  48000090    b 0x1000ad80                   ; -> 1000ad80
1000acf4  a91f0010    lha r8,0x10(r31)            
1000acf8  3908fffe    subi r8,r8,0x2              
1000acfc  b11f0010    sth r8,0x10(r31)            
1000ad00  a93f0010    lha r9,0x10(r31)            
1000ad04  7d2a2e70    srawi r10,r9,0x5            
1000ad08  7d4a0194    addze r10,r10               
1000ad0c  554a2834    rlwinm r10,r10,0x5,0x0,0x1a 
1000ad10  7d4a4810    subfc r10,r10,r9            
1000ad14  554a083c    rlwinm r10,r10,0x1,0x0,0x1e 
1000ad18  7d5d52ae    lhax r10,r29,r10            
1000ad1c  b15f000e    sth r10,0xe(r31)            
1000ad20  48000060    b 0x1000ad80                   ; -> 1000ad80
1000ad24  a97f0004    lha r11,0x4(r31)            
1000ad28  2c0b0006    cmpwi r11,0x6               
1000ad2c  40820028    bne 0x1000ad54                 ; -> 1000ad54
1000ad30  a99f000e    lha r12,0xe(r31)            
1000ad34  398cffff    subi r12,r12,0x1            
1000ad38  b19f000e    sth r12,0xe(r31)            
1000ad3c  7d8c0734    extsh r12,r12               
1000ad40  2c0c0031    cmpwi r12,0x31              
1000ad44  4181003c    bgt 0x1000ad80                 ; -> 1000ad80
1000ad48  3b600002    li r27,0x2                  
1000ad4c  b37f0004    sth r27,0x4(r31)            
1000ad50  48000030    b 0x1000ad80                   ; -> 1000ad80
1000ad54  ab9f0004    lha r28,0x4(r31)            
1000ad58  2c1c0005    cmpwi r28,0x5               
1000ad5c  40820024    bne 0x1000ad80                 ; -> 1000ad80
1000ad60  a87f000e    lha r3,0xe(r31)             
1000ad64  38630001    addi r3,r3,0x1              
1000ad68  b07f000e    sth r3,0xe(r31)             
1000ad6c  7c630734    extsh r3,r3                 
1000ad70  2c030040    cmpwi r3,0x40               
1000ad74  4180000c    blt 0x1000ad80                 ; -> 1000ad80
1000ad78  38800001    li r4,0x1                   
1000ad7c  b09f0004    sth r4,0x4(r31)             
1000ad80  a8bf0010    lha r5,0x10(r31)            
1000ad84  38a50009    addi r5,r5,0x9              
1000ad88  b0bf003a    sth r5,0x3a(r31)            
1000ad8c  a8df0010    lha r6,0x10(r31)            
1000ad90  38c60019    addi r6,r6,0x19             
1000ad94  b0df003c    sth r6,0x3c(r31)            
1000ad98  a8ff0012    lha r7,0x12(r31)            
1000ad9c  38e70006    addi r7,r7,0x6              
1000ada0  b0ff0038    sth r7,0x38(r31)            
1000ada4  a91f0012    lha r8,0x12(r31)            
1000ada8  3908001e    addi r8,r8,0x1e             
1000adac  b11f0036    sth r8,0x36(r31)            
1000adb0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000adb4  38210050    addi r1,r1,0x50             
1000adb8  7c0803a6    mtspr LR,r0                 
1000adbc  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1000adc0  4e800020    blr                         
