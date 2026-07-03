; FUN_1002dc44 @ 0x1002dc44
1002dc44  7c0802a6    mfspr r0,LR                 
1002dc48  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1002dc4c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002dc50  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1002dc54  3bc27934    addi r30,r2,0x7934          
1002dc58  3be27534    addi r31,r2,0x7534          
1002dc5c  38600001    li r3,0x1                   
1002dc60  4bff3cd9    bl 0x10021938                  ; -> 10021938
1002dc64  60000000    ori r0,r0,0x0               
1002dc68  388270f4    addi r4,r2,0x70f4           
1002dc6c  80640000    lwz r3,0x0(r4)              
1002dc70  4bff41f1    bl 0x10021e60                  ; -> 10021e60
1002dc74  60000000    ori r0,r0,0x0               
1002dc78  48003e91    bl 0x10031b08                  ; -> 10031b08
1002dc7c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dc80  a8be0056    lha r5,0x56(r30)            
1002dc84  7c7c1b78    or r28,r3,r3                
1002dc88  7cbb2b78    or r27,r5,r5                
1002dc8c  a89e0058    lha r4,0x58(r30)            
1002dc90  a8be0056    lha r5,0x56(r30)            
1002dc94  a8de005c    lha r6,0x5c(r30)            
1002dc98  3861003e    addi r3,r1,0x3e             
1002dc9c  7cfbe214    add r7,r27,r28              
1002dca0  48003e99    bl 0x10031b38                  ; -> 10031b38
1002dca4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dca8  48003ea9    bl 0x10031b50                  ; -> 10031b50
1002dcac  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dcb0  7c7d1b78    or r29,r3,r3                
1002dcb4  7fa3eb78    or r3,r29,r29               
1002dcb8  3881003e    addi r4,r1,0x3e             
1002dcbc  48003d5d    bl 0x10031a18                  ; -> 10031a18
1002dcc0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dcc4  80df0000    lwz r6,0x0(r31)             
1002dcc8  80ff0000    lwz r7,0x0(r31)             
1002dccc  80660018    lwz r3,0x18(r6)             
1002dcd0  38870010    addi r4,r7,0x10             
1002dcd4  48003d45    bl 0x10031a18                  ; -> 10031a18
1002dcd8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dcdc  811f0000    lwz r8,0x0(r31)             
1002dce0  813f0000    lwz r9,0x0(r31)             
1002dce4  80680018    lwz r3,0x18(r8)             
1002dce8  80a90018    lwz r5,0x18(r9)             
1002dcec  7fa4eb78    or r4,r29,r29               
1002dcf0  48003e79    bl 0x10031b68                  ; -> 10031b68
1002dcf4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dcf8  7fa3eb78    or r3,r29,r29               
1002dcfc  48003e85    bl 0x10031b80                  ; -> 10031b80
1002dd00  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dd04  807f0000    lwz r3,0x0(r31)             
1002dd08  480034b9    bl 0x100311c0                  ; -> 100311c0
1002dd0c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dd10  39400000    li r10,0x0                  
1002dd14  b141003c    sth r10,0x3c(r1)               ; -> Stack[-0x24]
1002dd18  b141003a    sth r10,0x3a(r1)               ; -> Stack[-0x26]
1002dd1c  b1410038    sth r10,0x38(r1)               ; -> Stack[-0x28]
1002dd20  38610038    addi r3,r1,0x38             
1002dd24  48003e75    bl 0x10031b98                  ; -> 10031b98
1002dd28  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dd2c  817f0000    lwz r11,0x0(r31)            
1002dd30  386b0010    addi r3,r11,0x10            
1002dd34  48003e7d    bl 0x10031bb0                  ; -> 10031bb0
1002dd38  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dd3c  39827530    addi r12,r2,0x7530          
1002dd40  806c0000    lwz r3,0x0(r12)             
1002dd44  48004545    bl 0x10032288                  ; -> 10032288
1002dd48  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dd4c  3b627530    addi r27,r2,0x7530          
1002dd50  807b0000    lwz r3,0x0(r27)             
1002dd54  4800439d    bl 0x100320f0                  ; -> 100320f0
1002dd58  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dd5c  3b82752c    addi r28,r2,0x752c          
1002dd60  a87c0000    lha r3,0x0(r28)             
1002dd64  48003325    bl 0x10031088                  ; -> 10031088
1002dd68  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dd6c  48003ba5    bl 0x10031910                  ; -> 10031910
1002dd70  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1002dd74  4bfea40d    bl 0x10018180                  ; -> 10018180
1002dd78  60000000    ori r0,r0,0x0               
1002dd7c  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1002dd80  38210060    addi r1,r1,0x60             
1002dd84  7c0803a6    mtspr LR,r0                 
1002dd88  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1002dd8c  4e800020    blr                         
