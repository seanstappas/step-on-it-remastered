; FUN_1001a76c @ 0x1001a76c
1001a76c  7c0802a6    mfspr r0,LR                 
1001a770  be01ffc0    stmw r16,-0x40(r1)             ; -> Stack[-0x40]
1001a774  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001a778  9421ff50    stwu r1,-0xb0(r1)              ; -> Stack[-0xb0]
1001a77c  3a625234    addi r19,r2,0x5234          
1001a780  3a825230    addi r20,r2,0x5230          
1001a784  3aa25238    addi r21,r2,0x5238          
1001a788  3ac2522c    addi r22,r2,0x522c          
1001a78c  3b225214    addi r25,r2,0x5214          
1001a790  3b425218    addi r26,r2,0x5218          
1001a794  3b625228    addi r27,r2,0x5228          
1001a798  3b82521c    addi r28,r2,0x521c          
1001a79c  3ba25220    addi r29,r2,0x5220          
1001a7a0  3ae251f4    addi r23,r2,0x51f4          
1001a7a4  3b0251f8    addi r24,r2,0x51f8          
1001a7a8  3bc25224    addi r30,r2,0x5224          
1001a7ac  3be251f2    addi r31,r2,0x51f2          
1001a7b0  3860aa68    li r3,-0x5598               
1001a7b4  48000999    bl 0x1001b14c                  ; -> 1001b14c
1001a7b8  60000000    ori r0,r0,0x0               
1001a7bc  987f0000    stb r3,0x0(r31)             
1001a7c0  38600190    li r3,0x190                 
1001a7c4  38800000    li r4,0x0                   
1001a7c8  38a0ffff    li r5,-0x1                  
1001a7cc  480169c5    bl 0x10031190                  ; -> 10031190
1001a7d0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a7d4  907e0000    stw r3,0x0(r30)             
1001a7d8  807e0000    lwz r3,0x0(r30)             
1001a7dc  28030000    cmplwi r3,0x0               
1001a7e0  40820010    bne 0x1001a7f0                 ; -> 1001a7f0
1001a7e4  38600005    li r3,0x5                   
1001a7e8  4bffeb11    bl 0x100192f8                  ; -> 100192f8
1001a7ec  60000000    ori r0,r0,0x0               
1001a7f0  8062fe1c    lwz r3,-0x1e4(r2)              ; -> 10033f8c
1001a7f4  38800fd0    li r4,0xfd0                 
1001a7f8  38a00001    li r5,0x1                   
1001a7fc  48016ab5    bl 0x100312b0                  ; -> 100312b0
1001a800  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a804  3882520c    addi r4,r2,0x520c           
1001a808  38a00001    li r5,0x1                   
1001a80c  90640000    stw r3,0x0(r4)              
1001a810  8062fe14    lwz r3,-0x1ec(r2)              ; -> 10033f84
1001a814  388002c0    li r4,0x2c0                 
1001a818  48016a99    bl 0x100312b0                  ; -> 100312b0
1001a81c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a820  90780000    stw r3,0x0(r24)             
1001a824  8062fe0c    lwz r3,-0x1f4(r2)              ; -> 10033f7c
1001a828  388002c0    li r4,0x2c0                 
1001a82c  38a00001    li r5,0x1                   
1001a830  48016a81    bl 0x100312b0                  ; -> 100312b0
1001a834  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a838  90770000    stw r3,0x0(r23)             
1001a83c  88bf0000    lbz r5,0x0(r31)             
1001a840  28050000    cmplwi r5,0x0               
1001a844  418200b8    beq 0x1001a8fc                 ; -> 1001a8fc
1001a848  807e0000    lwz r3,0x0(r30)             
1001a84c  38800001    li r4,0x1                   
1001a850  48016ac1    bl 0x10031310                  ; -> 10031310
1001a854  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a858  807e0000    lwz r3,0x0(r30)             
1001a85c  38800002    li r4,0x2                   
1001a860  48016ac9    bl 0x10031328                  ; -> 10031328
1001a864  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a868  807e0000    lwz r3,0x0(r30)             
1001a86c  38800001    li r4,0x1                   
1001a870  48016ad1    bl 0x10031340                  ; -> 10031340
1001a874  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a878  3c606469    lis r3,0x6469               
1001a87c  3863746c    addi r3,r3,0x746c           
1001a880  38810052    addi r4,r1,0x52             
1001a884  48016ad5    bl 0x10031358                  ; -> 10031358
1001a888  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a88c  7c721b78    or r18,r3,r3                
1001a890  7e460734    extsh r6,r18                
1001a894  2c060000    cmpwi r6,0x0                
1001a898  40820028    bne 0x1001a8c0                 ; -> 1001a8c0
1001a89c  80e10052    lwz r7,0x52(r1)                ; -> Stack[-0x5e]
1001a8a0  54e707fe    rlwinm r7,r7,0x0,0x1f,0x1f  
1001a8a4  2c070000    cmpwi r7,0x0                
1001a8a8  41820018    beq 0x1001a8c0                 ; -> 1001a8c0
1001a8ac  807e0000    lwz r3,0x0(r30)             
1001a8b0  38800001    li r4,0x1                   
1001a8b4  48016abd    bl 0x10031370                  ; -> 10031370
1001a8b8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a8bc  48000078    b 0x1001a934                   ; -> 1001a934
1001a8c0  807e0000    lwz r3,0x0(r30)             
1001a8c4  38800005    li r4,0x5                   
1001a8c8  38a1005a    addi r5,r1,0x5a             
1001a8cc  38c10056    addi r6,r1,0x56             
1001a8d0  38e1005c    addi r7,r1,0x5c             
1001a8d4  48016905    bl 0x100311d8                  ; -> 100311d8
1001a8d8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a8dc  807e0000    lwz r3,0x0(r30)             
1001a8e0  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[-0x56]
1001a8e4  80d80000    lwz r6,0x0(r24)             
1001a8e8  38800005    li r4,0x5                   
1001a8ec  38e1005c    addi r7,r1,0x5c             
1001a8f0  48016a99    bl 0x10031388                  ; -> 10031388
1001a8f4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a8f8  4800003c    b 0x1001a934                   ; -> 1001a934
1001a8fc  807e0000    lwz r3,0x0(r30)             
1001a900  38800005    li r4,0x5                   
1001a904  38a1005a    addi r5,r1,0x5a             
1001a908  38c10056    addi r6,r1,0x56             
1001a90c  38e1005c    addi r7,r1,0x5c             
1001a910  480168c9    bl 0x100311d8                  ; -> 100311d8
1001a914  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a918  807e0000    lwz r3,0x0(r30)             
1001a91c  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[-0x56]
1001a920  80d70000    lwz r6,0x0(r23)             
1001a924  38800005    li r4,0x5                   
1001a928  38e1005c    addi r7,r1,0x5c             
1001a92c  48016a5d    bl 0x10031388                  ; -> 10031388
1001a930  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a934  386001f4    li r3,0x1f4                 
1001a938  38800000    li r4,0x0                   
1001a93c  38a0ffff    li r5,-0x1                  
1001a940  48016851    bl 0x10031190                  ; -> 10031190
1001a944  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a948  907d0000    stw r3,0x0(r29)             
1001a94c  811d0000    lwz r8,0x0(r29)             
1001a950  28080000    cmplwi r8,0x0               
1001a954  40820010    bne 0x1001a964                 ; -> 1001a964
1001a958  38600005    li r3,0x5                   
1001a95c  4bffe99d    bl 0x100192f8                  ; -> 100192f8
1001a960  60000000    ori r0,r0,0x0               
1001a964  8062fe04    lwz r3,-0x1fc(r2)              ; -> 10033f74
1001a968  38800fd0    li r4,0xfd0                 
1001a96c  38a00001    li r5,0x1                   
1001a970  48016941    bl 0x100312b0                  ; -> 100312b0
1001a974  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a978  3922520c    addi r9,r2,0x520c           
1001a97c  388002c0    li r4,0x2c0                 
1001a980  90690000    stw r3,0x0(r9)              
1001a984  8062fe14    lwz r3,-0x1ec(r2)              ; -> 10033f84
1001a988  38a00001    li r5,0x1                   
1001a98c  48016925    bl 0x100312b0                  ; -> 100312b0
1001a990  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a994  90780000    stw r3,0x0(r24)             
1001a998  8062fe0c    lwz r3,-0x1f4(r2)              ; -> 10033f7c
1001a99c  388002c0    li r4,0x2c0                 
1001a9a0  38a00001    li r5,0x1                   
1001a9a4  4801690d    bl 0x100312b0                  ; -> 100312b0
1001a9a8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a9ac  90770000    stw r3,0x0(r23)             
1001a9b0  895f0000    lbz r10,0x0(r31)            
1001a9b4  280a0000    cmplwi r10,0x0              
1001a9b8  418200b8    beq 0x1001aa70                 ; -> 1001aa70
1001a9bc  807d0000    lwz r3,0x0(r29)             
1001a9c0  38800001    li r4,0x1                   
1001a9c4  4801694d    bl 0x10031310                  ; -> 10031310
1001a9c8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a9cc  807d0000    lwz r3,0x0(r29)             
1001a9d0  38800002    li r4,0x2                   
1001a9d4  48016955    bl 0x10031328                  ; -> 10031328
1001a9d8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a9dc  807d0000    lwz r3,0x0(r29)             
1001a9e0  38800001    li r4,0x1                   
1001a9e4  4801695d    bl 0x10031340                  ; -> 10031340
1001a9e8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001a9ec  3c606469    lis r3,0x6469               
1001a9f0  3863746c    addi r3,r3,0x746c           
1001a9f4  3881004e    addi r4,r1,0x4e             
1001a9f8  48016961    bl 0x10031358                  ; -> 10031358
1001a9fc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aa00  7c711b78    or r17,r3,r3                
1001aa04  7e2b0734    extsh r11,r17               
1001aa08  2c0b0000    cmpwi r11,0x0               
1001aa0c  40820028    bne 0x1001aa34                 ; -> 1001aa34
1001aa10  8181004e    lwz r12,0x4e(r1)               ; -> Stack[-0x62]
1001aa14  558c07fe    rlwinm r12,r12,0x0,0x1f,0x1f
1001aa18  2c0c0000    cmpwi r12,0x0               
1001aa1c  41820018    beq 0x1001aa34                 ; -> 1001aa34
1001aa20  807d0000    lwz r3,0x0(r29)             
1001aa24  38800001    li r4,0x1                   
1001aa28  48016949    bl 0x10031370                  ; -> 10031370
1001aa2c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aa30  48000078    b 0x1001aaa8                   ; -> 1001aaa8
1001aa34  807d0000    lwz r3,0x0(r29)             
1001aa38  38800009    li r4,0x9                   
1001aa3c  38a1005a    addi r5,r1,0x5a             
1001aa40  38c10056    addi r6,r1,0x56             
1001aa44  38e1005c    addi r7,r1,0x5c             
1001aa48  48016791    bl 0x100311d8                  ; -> 100311d8
1001aa4c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aa50  807d0000    lwz r3,0x0(r29)             
1001aa54  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[-0x56]
1001aa58  80d80000    lwz r6,0x0(r24)             
1001aa5c  38800009    li r4,0x9                   
1001aa60  38e1005c    addi r7,r1,0x5c             
1001aa64  48016925    bl 0x10031388                  ; -> 10031388
1001aa68  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aa6c  4800003c    b 0x1001aaa8                   ; -> 1001aaa8
1001aa70  807d0000    lwz r3,0x0(r29)             
1001aa74  38800009    li r4,0x9                   
1001aa78  38a1005a    addi r5,r1,0x5a             
1001aa7c  38c10056    addi r6,r1,0x56             
1001aa80  38e1005c    addi r7,r1,0x5c             
1001aa84  48016755    bl 0x100311d8                  ; -> 100311d8
1001aa88  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aa8c  807d0000    lwz r3,0x0(r29)             
1001aa90  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[-0x56]
1001aa94  80d70000    lwz r6,0x0(r23)             
1001aa98  38800009    li r4,0x9                   
1001aa9c  38e1005c    addi r7,r1,0x5c             
1001aaa0  480168e9    bl 0x10031388                  ; -> 10031388
1001aaa4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aaa8  38600191    li r3,0x191                 
1001aaac  38800000    li r4,0x0                   
1001aab0  38a0ffff    li r5,-0x1                  
1001aab4  480166dd    bl 0x10031190                  ; -> 10031190
1001aab8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aabc  907c0000    stw r3,0x0(r28)             
1001aac0  807c0000    lwz r3,0x0(r28)             
1001aac4  28030000    cmplwi r3,0x0               
1001aac8  40820010    bne 0x1001aad8                 ; -> 1001aad8
1001aacc  38600005    li r3,0x5                   
1001aad0  4bffe829    bl 0x100192f8                  ; -> 100192f8
1001aad4  60000000    ori r0,r0,0x0               
1001aad8  8062fdf8    lwz r3,-0x208(r2)              ; -> 10033f68
1001aadc  38800fd0    li r4,0xfd0                 
1001aae0  38a00001    li r5,0x1                   
1001aae4  480167cd    bl 0x100312b0                  ; -> 100312b0
1001aae8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aaec  38825204    addi r4,r2,0x5204           
1001aaf0  90640000    stw r3,0x0(r4)              
1001aaf4  88bf0000    lbz r5,0x0(r31)             
1001aaf8  28050000    cmplwi r5,0x0               
1001aafc  418200b8    beq 0x1001abb4                 ; -> 1001abb4
1001ab00  807c0000    lwz r3,0x0(r28)             
1001ab04  38800001    li r4,0x1                   
1001ab08  48016809    bl 0x10031310                  ; -> 10031310
1001ab0c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ab10  807c0000    lwz r3,0x0(r28)             
1001ab14  38800002    li r4,0x2                   
1001ab18  48016811    bl 0x10031328                  ; -> 10031328
1001ab1c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ab20  807c0000    lwz r3,0x0(r28)             
1001ab24  38800001    li r4,0x1                   
1001ab28  48016819    bl 0x10031340                  ; -> 10031340
1001ab2c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ab30  3c606469    lis r3,0x6469               
1001ab34  3863746c    addi r3,r3,0x746c           
1001ab38  3881004a    addi r4,r1,0x4a             
1001ab3c  4801681d    bl 0x10031358                  ; -> 10031358
1001ab40  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ab44  7c701b78    or r16,r3,r3                
1001ab48  7e060734    extsh r6,r16                
1001ab4c  2c060000    cmpwi r6,0x0                
1001ab50  40820028    bne 0x1001ab78                 ; -> 1001ab78
1001ab54  80e1004a    lwz r7,0x4a(r1)                ; -> Stack[-0x66]
1001ab58  54e707fe    rlwinm r7,r7,0x0,0x1f,0x1f  
1001ab5c  2c070000    cmpwi r7,0x0                
1001ab60  41820018    beq 0x1001ab78                 ; -> 1001ab78
1001ab64  807c0000    lwz r3,0x0(r28)             
1001ab68  38800001    li r4,0x1                   
1001ab6c  48016805    bl 0x10031370                  ; -> 10031370
1001ab70  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ab74  48000078    b 0x1001abec                   ; -> 1001abec
1001ab78  807c0000    lwz r3,0x0(r28)             
1001ab7c  38800005    li r4,0x5                   
1001ab80  38a1005a    addi r5,r1,0x5a             
1001ab84  38c10056    addi r6,r1,0x56             
1001ab88  38e1005c    addi r7,r1,0x5c             
1001ab8c  4801664d    bl 0x100311d8                  ; -> 100311d8
1001ab90  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ab94  807c0000    lwz r3,0x0(r28)             
1001ab98  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[-0x56]
1001ab9c  80d80000    lwz r6,0x0(r24)             
1001aba0  38800005    li r4,0x5                   
1001aba4  38e1005c    addi r7,r1,0x5c             
1001aba8  480167e1    bl 0x10031388                  ; -> 10031388
1001abac  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001abb0  4800003c    b 0x1001abec                   ; -> 1001abec
1001abb4  807c0000    lwz r3,0x0(r28)             
1001abb8  38800005    li r4,0x5                   
1001abbc  38a1005a    addi r5,r1,0x5a             
1001abc0  38c10056    addi r6,r1,0x56             
1001abc4  38e1005c    addi r7,r1,0x5c             
1001abc8  48016611    bl 0x100311d8                  ; -> 100311d8
1001abcc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001abd0  807c0000    lwz r3,0x0(r28)             
1001abd4  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[-0x56]
1001abd8  80d70000    lwz r6,0x0(r23)             
1001abdc  38800005    li r4,0x5                   
1001abe0  38e1005c    addi r7,r1,0x5c             
1001abe4  480167a5    bl 0x10031388                  ; -> 10031388
1001abe8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001abec  38600194    li r3,0x194                 
1001abf0  38800000    li r4,0x0                   
1001abf4  38a0ffff    li r5,-0x1                  
1001abf8  48016599    bl 0x10031190                  ; -> 10031190
1001abfc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ac00  907b0000    stw r3,0x0(r27)             
1001ac04  811b0000    lwz r8,0x0(r27)             
1001ac08  28080000    cmplwi r8,0x0               
1001ac0c  40820010    bne 0x1001ac1c                 ; -> 1001ac1c
1001ac10  38600005    li r3,0x5                   
1001ac14  4bffe6e5    bl 0x100192f8                  ; -> 100192f8
1001ac18  60000000    ori r0,r0,0x0               
1001ac1c  8062fdf8    lwz r3,-0x208(r2)              ; -> 10033f68
1001ac20  38800fd0    li r4,0xfd0                 
1001ac24  38a00001    li r5,0x1                   
1001ac28  48016689    bl 0x100312b0                  ; -> 100312b0
1001ac2c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ac30  392251fc    addi r9,r2,0x51fc           
1001ac34  90690000    stw r3,0x0(r9)              
1001ac38  895f0000    lbz r10,0x0(r31)            
1001ac3c  280a0000    cmplwi r10,0x0              
1001ac40  418200b8    beq 0x1001acf8                 ; -> 1001acf8
1001ac44  807b0000    lwz r3,0x0(r27)             
1001ac48  38800001    li r4,0x1                   
1001ac4c  480166c5    bl 0x10031310                  ; -> 10031310
1001ac50  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ac54  807b0000    lwz r3,0x0(r27)             
1001ac58  38800002    li r4,0x2                   
1001ac5c  480166cd    bl 0x10031328                  ; -> 10031328
1001ac60  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ac64  807b0000    lwz r3,0x0(r27)             
1001ac68  38800001    li r4,0x1                   
1001ac6c  480166d5    bl 0x10031340                  ; -> 10031340
1001ac70  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ac74  3c606469    lis r3,0x6469               
1001ac78  3863746c    addi r3,r3,0x746c           
1001ac7c  38810046    addi r4,r1,0x46             
1001ac80  480166d9    bl 0x10031358                  ; -> 10031358
1001ac84  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ac88  b0610044    sth r3,0x44(r1)                ; -> Stack[-0x6c]
1001ac8c  a9610044    lha r11,0x44(r1)               ; -> Stack[-0x6c]
1001ac90  2c0b0000    cmpwi r11,0x0               
1001ac94  40820028    bne 0x1001acbc                 ; -> 1001acbc
1001ac98  81810046    lwz r12,0x46(r1)               ; -> Stack[-0x6a]
1001ac9c  558c07fe    rlwinm r12,r12,0x0,0x1f,0x1f
1001aca0  2c0c0000    cmpwi r12,0x0               
1001aca4  41820018    beq 0x1001acbc                 ; -> 1001acbc
1001aca8  807b0000    lwz r3,0x0(r27)             
1001acac  38800001    li r4,0x1                   
1001acb0  480166c1    bl 0x10031370                  ; -> 10031370
1001acb4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001acb8  48000078    b 0x1001ad30                   ; -> 1001ad30
1001acbc  807b0000    lwz r3,0x0(r27)             
1001acc0  38800006    li r4,0x6                   
1001acc4  38a1005a    addi r5,r1,0x5a             
1001acc8  38c10056    addi r6,r1,0x56             
1001accc  38e1005c    addi r7,r1,0x5c             
1001acd0  48016509    bl 0x100311d8                  ; -> 100311d8
1001acd4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001acd8  807b0000    lwz r3,0x0(r27)             
1001acdc  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[-0x56]
1001ace0  80d80000    lwz r6,0x0(r24)             
1001ace4  38800006    li r4,0x6                   
1001ace8  38e1005c    addi r7,r1,0x5c             
1001acec  4801669d    bl 0x10031388                  ; -> 10031388
1001acf0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001acf4  4800003c    b 0x1001ad30                   ; -> 1001ad30
1001acf8  807b0000    lwz r3,0x0(r27)             
1001acfc  38800005    li r4,0x5                   
1001ad00  38a1005a    addi r5,r1,0x5a             
1001ad04  38c10056    addi r6,r1,0x56             
1001ad08  38e1005c    addi r7,r1,0x5c             
1001ad0c  480164cd    bl 0x100311d8                  ; -> 100311d8
1001ad10  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ad14  807b0000    lwz r3,0x0(r27)             
1001ad18  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[-0x56]
1001ad1c  80d70000    lwz r6,0x0(r23)             
1001ad20  38800005    li r4,0x5                   
1001ad24  38e1005c    addi r7,r1,0x5c             
1001ad28  48016661    bl 0x10031388                  ; -> 10031388
1001ad2c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ad30  38600192    li r3,0x192                 
1001ad34  38800000    li r4,0x0                   
1001ad38  38a0ffff    li r5,-0x1                  
1001ad3c  48016455    bl 0x10031190                  ; -> 10031190
1001ad40  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ad44  907a0000    stw r3,0x0(r26)             
1001ad48  807a0000    lwz r3,0x0(r26)             
1001ad4c  28030000    cmplwi r3,0x0               
1001ad50  40820010    bne 0x1001ad60                 ; -> 1001ad60
1001ad54  38600005    li r3,0x5                   
1001ad58  4bffe5a1    bl 0x100192f8                  ; -> 100192f8
1001ad5c  60000000    ori r0,r0,0x0               
1001ad60  8062fde4    lwz r3,-0x21c(r2)              ; -> 10033f54
1001ad64  38800fd0    li r4,0xfd0                 
1001ad68  38a00001    li r5,0x1                   
1001ad6c  48016545    bl 0x100312b0                  ; -> 100312b0
1001ad70  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ad74  38825200    addi r4,r2,0x5200           
1001ad78  90640000    stw r3,0x0(r4)              
1001ad7c  88bf0000    lbz r5,0x0(r31)             
1001ad80  28050000    cmplwi r5,0x0               
1001ad84  418200b8    beq 0x1001ae3c                 ; -> 1001ae3c
1001ad88  807a0000    lwz r3,0x0(r26)             
1001ad8c  38800001    li r4,0x1                   
1001ad90  48016581    bl 0x10031310                  ; -> 10031310
1001ad94  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ad98  807a0000    lwz r3,0x0(r26)             
1001ad9c  38800002    li r4,0x2                   
1001ada0  48016589    bl 0x10031328                  ; -> 10031328
1001ada4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ada8  807a0000    lwz r3,0x0(r26)             
1001adac  38800001    li r4,0x1                   
1001adb0  48016591    bl 0x10031340                  ; -> 10031340
1001adb4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001adb8  3c606469    lis r3,0x6469               
1001adbc  3863746c    addi r3,r3,0x746c           
1001adc0  38810040    addi r4,r1,0x40             
1001adc4  48016595    bl 0x10031358                  ; -> 10031358
1001adc8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001adcc  b061003e    sth r3,0x3e(r1)                ; -> Stack[-0x72]
1001add0  a8c1003e    lha r6,0x3e(r1)                ; -> Stack[-0x72]
1001add4  2c060000    cmpwi r6,0x0                
1001add8  40820028    bne 0x1001ae00                 ; -> 1001ae00
1001addc  80e10040    lwz r7,0x40(r1)                ; -> Stack[-0x70]
1001ade0  54e707fe    rlwinm r7,r7,0x0,0x1f,0x1f  
1001ade4  2c070000    cmpwi r7,0x0                
1001ade8  41820018    beq 0x1001ae00                 ; -> 1001ae00
1001adec  807a0000    lwz r3,0x0(r26)             
1001adf0  38800001    li r4,0x1                   
1001adf4  4801657d    bl 0x10031370                  ; -> 10031370
1001adf8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001adfc  48000078    b 0x1001ae74                   ; -> 1001ae74
1001ae00  807a0000    lwz r3,0x0(r26)             
1001ae04  38800005    li r4,0x5                   
1001ae08  38a1005a    addi r5,r1,0x5a             
1001ae0c  38c10056    addi r6,r1,0x56             
1001ae10  38e1005c    addi r7,r1,0x5c             
1001ae14  480163c5    bl 0x100311d8                  ; -> 100311d8
1001ae18  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ae1c  807a0000    lwz r3,0x0(r26)             
1001ae20  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[-0x56]
1001ae24  80d80000    lwz r6,0x0(r24)             
1001ae28  38800005    li r4,0x5                   
1001ae2c  38e1005c    addi r7,r1,0x5c             
1001ae30  48016559    bl 0x10031388                  ; -> 10031388
1001ae34  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ae38  4800003c    b 0x1001ae74                   ; -> 1001ae74
1001ae3c  807a0000    lwz r3,0x0(r26)             
1001ae40  38800005    li r4,0x5                   
1001ae44  38a1005a    addi r5,r1,0x5a             
1001ae48  38c10056    addi r6,r1,0x56             
1001ae4c  38e1005c    addi r7,r1,0x5c             
1001ae50  48016389    bl 0x100311d8                  ; -> 100311d8
1001ae54  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ae58  807a0000    lwz r3,0x0(r26)             
1001ae5c  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[-0x56]
1001ae60  80d70000    lwz r6,0x0(r23)             
1001ae64  38800005    li r4,0x5                   
1001ae68  38e1005c    addi r7,r1,0x5c             
1001ae6c  4801651d    bl 0x10031388                  ; -> 10031388
1001ae70  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ae74  38600193    li r3,0x193                 
1001ae78  38800000    li r4,0x0                   
1001ae7c  38a0ffff    li r5,-0x1                  
1001ae80  48016311    bl 0x10031190                  ; -> 10031190
1001ae84  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001ae88  90790000    stw r3,0x0(r25)             
1001ae8c  81190000    lwz r8,0x0(r25)             
1001ae90  28080000    cmplwi r8,0x0               
1001ae94  40820010    bne 0x1001aea4                 ; -> 1001aea4
1001ae98  38600005    li r3,0x5                   
1001ae9c  4bffe45d    bl 0x100192f8                  ; -> 100192f8
1001aea0  60000000    ori r0,r0,0x0               
1001aea4  893f0000    lbz r9,0x0(r31)             
1001aea8  28090000    cmplwi r9,0x0               
1001aeac  418200b8    beq 0x1001af64                 ; -> 1001af64
1001aeb0  80790000    lwz r3,0x0(r25)             
1001aeb4  38800001    li r4,0x1                   
1001aeb8  48016459    bl 0x10031310                  ; -> 10031310
1001aebc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aec0  80790000    lwz r3,0x0(r25)             
1001aec4  38800002    li r4,0x2                   
1001aec8  48016461    bl 0x10031328                  ; -> 10031328
1001aecc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aed0  80790000    lwz r3,0x0(r25)             
1001aed4  38800001    li r4,0x1                   
1001aed8  48016469    bl 0x10031340                  ; -> 10031340
1001aedc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aee0  3c606469    lis r3,0x6469               
1001aee4  3863746c    addi r3,r3,0x746c           
1001aee8  3881003a    addi r4,r1,0x3a             
1001aeec  4801646d    bl 0x10031358                  ; -> 10031358
1001aef0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aef4  b0610038    sth r3,0x38(r1)                ; -> Stack[-0x78]
1001aef8  a9410038    lha r10,0x38(r1)               ; -> Stack[-0x78]
1001aefc  2c0a0000    cmpwi r10,0x0               
1001af00  40820028    bne 0x1001af28                 ; -> 1001af28
1001af04  8161003a    lwz r11,0x3a(r1)               ; -> Stack[-0x76]
1001af08  556b07fe    rlwinm r11,r11,0x0,0x1f,0x1f
1001af0c  2c0b0000    cmpwi r11,0x0               
1001af10  41820018    beq 0x1001af28                 ; -> 1001af28
1001af14  80790000    lwz r3,0x0(r25)             
1001af18  38800001    li r4,0x1                   
1001af1c  48016455    bl 0x10031370                  ; -> 10031370
1001af20  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001af24  48000078    b 0x1001af9c                   ; -> 1001af9c
1001af28  80790000    lwz r3,0x0(r25)             
1001af2c  38800005    li r4,0x5                   
1001af30  38a1005a    addi r5,r1,0x5a             
1001af34  38c10056    addi r6,r1,0x56             
1001af38  38e1005c    addi r7,r1,0x5c             
1001af3c  4801629d    bl 0x100311d8                  ; -> 100311d8
1001af40  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001af44  80790000    lwz r3,0x0(r25)             
1001af48  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[-0x56]
1001af4c  80d80000    lwz r6,0x0(r24)             
1001af50  38800005    li r4,0x5                   
1001af54  38e1005c    addi r7,r1,0x5c             
1001af58  48016431    bl 0x10031388                  ; -> 10031388
1001af5c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001af60  4800003c    b 0x1001af9c                   ; -> 1001af9c
1001af64  80790000    lwz r3,0x0(r25)             
1001af68  38800005    li r4,0x5                   
1001af6c  38a1005a    addi r5,r1,0x5a             
1001af70  38c10056    addi r6,r1,0x56             
1001af74  38e1005c    addi r7,r1,0x5c             
1001af78  48016261    bl 0x100311d8                  ; -> 100311d8
1001af7c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001af80  80790000    lwz r3,0x0(r25)             
1001af84  a8a1005a    lha r5,0x5a(r1)                ; -> Stack[-0x56]
1001af88  80d70000    lwz r6,0x0(r23)             
1001af8c  38800005    li r4,0x5                   
1001af90  38e1005c    addi r7,r1,0x5c             
1001af94  480163f5    bl 0x10031388                  ; -> 10031388
1001af98  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001af9c  38600195    li r3,0x195                 
1001afa0  38800000    li r4,0x0                   
1001afa4  38a0ffff    li r5,-0x1                  
1001afa8  480161e9    bl 0x10031190                  ; -> 10031190
1001afac  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001afb0  90760000    stw r3,0x0(r22)             
1001afb4  81960000    lwz r12,0x0(r22)            
1001afb8  280c0000    cmplwi r12,0x0              
1001afbc  40820010    bne 0x1001afcc                 ; -> 1001afcc
1001afc0  38600005    li r3,0x5                   
1001afc4  4bffe335    bl 0x100192f8                  ; -> 100192f8
1001afc8  60000000    ori r0,r0,0x0               
1001afcc  887f0000    lbz r3,0x0(r31)             
1001afd0  28030000    cmplwi r3,0x0               
1001afd4  41820034    beq 0x1001b008                 ; -> 1001b008
1001afd8  80760000    lwz r3,0x0(r22)             
1001afdc  38800001    li r4,0x1                   
1001afe0  48016331    bl 0x10031310                  ; -> 10031310
1001afe4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001afe8  80760000    lwz r3,0x0(r22)             
1001afec  38800002    li r4,0x2                   
1001aff0  48016339    bl 0x10031328                  ; -> 10031328
1001aff4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001aff8  80760000    lwz r3,0x0(r22)             
1001affc  38800001    li r4,0x1                   
1001b000  48016341    bl 0x10031340                  ; -> 10031340
1001b004  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001b008  38600197    li r3,0x197                 
1001b00c  38800000    li r4,0x0                   
1001b010  38a0ffff    li r5,-0x1                  
1001b014  4801617d    bl 0x10031190                  ; -> 10031190
1001b018  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001b01c  90750000    stw r3,0x0(r21)             
1001b020  80950000    lwz r4,0x0(r21)             
1001b024  28040000    cmplwi r4,0x0               
1001b028  40820010    bne 0x1001b038                 ; -> 1001b038
1001b02c  38600005    li r3,0x5                   
1001b030  4bffe2c9    bl 0x100192f8                  ; -> 100192f8
1001b034  60000000    ori r0,r0,0x0               
1001b038  88bf0000    lbz r5,0x0(r31)             
1001b03c  28050000    cmplwi r5,0x0               
1001b040  41820034    beq 0x1001b074                 ; -> 1001b074
1001b044  80750000    lwz r3,0x0(r21)             
1001b048  38800001    li r4,0x1                   
1001b04c  480162c5    bl 0x10031310                  ; -> 10031310
1001b050  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001b054  80750000    lwz r3,0x0(r21)             
1001b058  38800002    li r4,0x2                   
1001b05c  480162cd    bl 0x10031328                  ; -> 10031328
1001b060  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001b064  80750000    lwz r3,0x0(r21)             
1001b068  38800001    li r4,0x1                   
1001b06c  480162d5    bl 0x10031340                  ; -> 10031340
1001b070  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001b074  38600196    li r3,0x196                 
1001b078  38800000    li r4,0x0                   
1001b07c  38a0ffff    li r5,-0x1                  
1001b080  48016111    bl 0x10031190                  ; -> 10031190
1001b084  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001b088  90740000    stw r3,0x0(r20)             
1001b08c  80d40000    lwz r6,0x0(r20)             
1001b090  28060000    cmplwi r6,0x0               
1001b094  40820010    bne 0x1001b0a4                 ; -> 1001b0a4
1001b098  38600005    li r3,0x5                   
1001b09c  4bffe25d    bl 0x100192f8                  ; -> 100192f8
1001b0a0  60000000    ori r0,r0,0x0               
1001b0a4  88ff0000    lbz r7,0x0(r31)             
1001b0a8  28070000    cmplwi r7,0x0               
1001b0ac  41820024    beq 0x1001b0d0                 ; -> 1001b0d0
1001b0b0  80740000    lwz r3,0x0(r20)             
1001b0b4  38800001    li r4,0x1                   
1001b0b8  48016259    bl 0x10031310                  ; -> 10031310
1001b0bc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001b0c0  80740000    lwz r3,0x0(r20)             
1001b0c4  38800001    li r4,0x1                   
1001b0c8  48016279    bl 0x10031340                  ; -> 10031340
1001b0cc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001b0d0  38601388    li r3,0x1388                
1001b0d4  38800000    li r4,0x0                   
1001b0d8  38a0ffff    li r5,-0x1                  
1001b0dc  480160b5    bl 0x10031190                  ; -> 10031190
1001b0e0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001b0e4  90730000    stw r3,0x0(r19)             
1001b0e8  81130000    lwz r8,0x0(r19)             
1001b0ec  28080000    cmplwi r8,0x0               
1001b0f0  40820010    bne 0x1001b100                 ; -> 1001b100
1001b0f4  38600005    li r3,0x5                   
1001b0f8  4bffe201    bl 0x100192f8                  ; -> 100192f8
1001b0fc  60000000    ori r0,r0,0x0               
1001b100  8062fdc8    lwz r3,-0x238(r2)              ; -> 10033f38
1001b104  38800fd0    li r4,0xfd0                 
1001b108  38a00001    li r5,0x1                   
1001b10c  480161a5    bl 0x100312b0                  ; -> 100312b0
1001b110  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001b114  39225210    addi r9,r2,0x5210           
1001b118  90690000    stw r3,0x0(r9)              
1001b11c  895f0000    lbz r10,0x0(r31)            
1001b120  280a0000    cmplwi r10,0x0              
1001b124  41820014    beq 0x1001b138                 ; -> 1001b138
1001b128  80730000    lwz r3,0x0(r19)             
1001b12c  38800001    li r4,0x1                   
1001b130  48016211    bl 0x10031340                  ; -> 10031340
1001b134  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x9c]
1001b138  800100b8    lwz r0,0xb8(r1)                ; -> Stack[0x8]
1001b13c  382100b0    addi r1,r1,0xb0             
1001b140  7c0803a6    mtspr LR,r0                 
1001b144  ba01ffc0    lmw r16,-0x40(r1)              ; -> Stack[-0x40]
1001b148  4e800020    blr                         
