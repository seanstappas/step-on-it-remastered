; FUN_10016c90 @ 0x10016c90  (188 instructions)
10016c90  7c0802a6    mfspr r0,LR                 
10016c94  bf01ffe0    stmw r24,-0x20(r1)             ; -> Stack[-0x20]
10016c98  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10016c9c  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
10016ca0  7c7a1b78    or r26,r3,r3                
10016ca4  7f430734    extsh r3,r26                
10016ca8  1c630070    mulli r3,r3,0x70            
10016cac  7f450734    extsh r5,r26                
10016cb0  1ca50070    mulli r5,r5,0x70            
10016cb4  7f470734    extsh r7,r26                
10016cb8  1ce70070    mulli r7,r7,0x70            
10016cbc  7f490734    extsh r9,r26                
10016cc0  1d290070    mulli r9,r9,0x70            
10016cc4  3ba26840    addi r29,r2,0x6840          
10016cc8  3863003c    addi r3,r3,0x3c             
10016ccc  7c7d182e    lwzx r3,r29,r3              
10016cd0  38824e84    addi r4,r2,0x4e84           
10016cd4  38a50046    addi r5,r5,0x46             
10016cd8  90640000    stw r3,0x0(r4)              
10016cdc  7cbd2aae    lhax r5,r29,r5              
10016ce0  38c24e80    addi r6,r2,0x4e80           
10016ce4  38e7004a    addi r7,r7,0x4a             
10016ce8  b0a60000    sth r5,0x0(r6)              
10016cec  7cfd3aae    lhax r7,r29,r7              
10016cf0  39024e7e    addi r8,r2,0x4e7e           
10016cf4  3929004c    addi r9,r9,0x4c             
10016cf8  b0e80000    sth r7,0x0(r8)              
10016cfc  7d3d4aae    lhax r9,r29,r9              
10016d00  39424e7c    addi r10,r2,0x4e7c          
10016d04  39824e7a    addi r12,r2,0x4e7a          
10016d08  b12a0000    sth r9,0x0(r10)             
10016d0c  39600000    li r11,0x0                  
10016d10  38824e78    addi r4,r2,0x4e78           
10016d14  b16c0000    sth r11,0x0(r12)            
10016d18  38600000    li r3,0x0                   
10016d1c  38c24e76    addi r6,r2,0x4e76           
10016d20  b0640000    sth r3,0x0(r4)              
10016d24  38a00000    li r5,0x0                   
10016d28  39024e74    addi r8,r2,0x4e74           
10016d2c  3be27534    addi r31,r2,0x7534          
10016d30  3b827934    addi r28,r2,0x7934          
10016d34  b0a60000    sth r5,0x0(r6)              
10016d38  38e00000    li r7,0x0                   
10016d3c  b0e80000    sth r7,0x0(r8)              
10016d40  48001399    bl 0x100180d8                  ; -> 100180d8
10016d44  60000000    ori r0,r0,0x0               
10016d48  39425346    addi r10,r2,0x5346          
10016d4c  39200000    li r9,0x0                   
10016d50  992a0000    stb r9,0x0(r10)             
10016d54  4801703d    bl 0x1002dd90                  ; -> 1002dd90
10016d58  60000000    ori r0,r0,0x0               
10016d5c  38600001    li r3,0x1                   
10016d60  4800abd9    bl 0x10021938                  ; -> 10021938
10016d64  60000000    ori r0,r0,0x0               
10016d68  39627530    addi r11,r2,0x7530          
10016d6c  806b0000    lwz r3,0x0(r11)             
10016d70  4801b3c9    bl 0x10032138                  ; -> 10032138
10016d74  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016d78  4801ad91    bl 0x10031b08                  ; -> 10031b08
10016d7c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016d80  a99c0056    lha r12,0x56(r28)           
10016d84  7c791b78    or r25,r3,r3                
10016d88  7d986378    or r24,r12,r12              
10016d8c  a89c0058    lha r4,0x58(r28)            
10016d90  a8bc0056    lha r5,0x56(r28)            
10016d94  a8dc005c    lha r6,0x5c(r28)            
10016d98  38610046    addi r3,r1,0x46             
10016d9c  7cf8ca14    add r7,r24,r25              
10016da0  4801ad99    bl 0x10031b38                  ; -> 10031b38
10016da4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016da8  4801ada9    bl 0x10031b50                  ; -> 10031b50
10016dac  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016db0  7c7b1b78    or r27,r3,r3                
10016db4  7f63db78    or r3,r27,r27               
10016db8  38810046    addi r4,r1,0x46             
10016dbc  4801ac5d    bl 0x10031a18                  ; -> 10031a18
10016dc0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016dc4  831f0000    lwz r24,0x0(r31)            
10016dc8  833f0000    lwz r25,0x0(r31)            
10016dcc  80780018    lwz r3,0x18(r24)            
10016dd0  38990010    addi r4,r25,0x10            
10016dd4  4801ac45    bl 0x10031a18                  ; -> 10031a18
10016dd8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016ddc  809f0000    lwz r4,0x0(r31)             
10016de0  80df0000    lwz r6,0x0(r31)             
10016de4  80640018    lwz r3,0x18(r4)             
10016de8  80a60018    lwz r5,0x18(r6)             
10016dec  7f64db78    or r4,r27,r27               
10016df0  4801ad79    bl 0x10031b68                  ; -> 10031b68
10016df4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016df8  7f63db78    or r3,r27,r27               
10016dfc  4801ad85    bl 0x10031b80                  ; -> 10031b80
10016e00  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016e04  807f0000    lwz r3,0x0(r31)             
10016e08  4801a3b9    bl 0x100311c0                  ; -> 100311c0
10016e0c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016e10  38e00000    li r7,0x0                   
10016e14  b0e10044    sth r7,0x44(r1)                ; -> Stack[-0x2c]
10016e18  b0e10042    sth r7,0x42(r1)                ; -> Stack[-0x2e]
10016e1c  b0e10040    sth r7,0x40(r1)                ; -> Stack[-0x30]
10016e20  38610040    addi r3,r1,0x40             
10016e24  4801ad75    bl 0x10031b98                  ; -> 10031b98
10016e28  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016e2c  811f0000    lwz r8,0x0(r31)             
10016e30  38680010    addi r3,r8,0x10             
10016e34  4801ad7d    bl 0x10031bb0                  ; -> 10031bb0
10016e38  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016e3c  392270fc    addi r9,r2,0x70fc           
10016e40  80690000    lwz r3,0x0(r9)              
10016e44  4800b01d    bl 0x10021e60                  ; -> 10021e60
10016e48  60000000    ori r0,r0,0x0               
10016e4c  4bfedc7d    bl 0x10004ac8                  ; -> 10004ac8
10016e50  60000000    ori r0,r0,0x0               
10016e54  3860012c    li r3,0x12c                 
10016e58  4801ad71    bl 0x10031bc8                  ; -> 10031bc8
10016e5c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016e60  7c7e1b78    or r30,r3,r3                
10016e64  281e0000    cmplwi r30,0x0              
10016e68  40820010    bne 0x10016e78                 ; -> 10016e78
10016e6c  38600005    li r3,0x5                   
10016e70  48002489    bl 0x100192f8                  ; -> 100192f8
10016e74  60000000    ori r0,r0,0x0               
10016e78  4bfe9bd5    bl 0x10000a4c                  ; -> 10000a4c
10016e7c  60000000    ori r0,r0,0x0               
10016e80  39427570    addi r10,r2,0x7570          
10016e84  806a0000    lwz r3,0x0(r10)             
10016e88  4801a339    bl 0x100311c0                  ; -> 100311c0
10016e8c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016e90  3962756c    addi r11,r2,0x756c          
10016e94  806b0000    lwz r3,0x0(r11)             
10016e98  4801ac29    bl 0x10031ac0                  ; -> 10031ac0
10016e9c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016ea0  38610040    addi r3,r1,0x40             
10016ea4  4801acf5    bl 0x10031b98                  ; -> 10031b98
10016ea8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016eac  38627584    addi r3,r2,0x7584           
10016eb0  4801ad01    bl 0x10031bb0                  ; -> 10031bb0
10016eb4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016eb8  819e0000    lwz r12,0x0(r30)            
10016ebc  7fc3f378    or r3,r30,r30               
10016ec0  830c0002    lwz r24,0x2(r12)            
10016ec4  832c0006    lwz r25,0x6(r12)            
10016ec8  38810038    addi r4,r1,0x38             
10016ecc  93010038    stw r24,0x38(r1)               ; -> Stack[-0x38]
10016ed0  9321003c    stw r25,0x3c(r1)               ; -> Stack[-0x34]
10016ed4  4801ad0d    bl 0x10031be0                  ; -> 10031be0
10016ed8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016edc  7fc3f378    or r3,r30,r30               
10016ee0  4801a881    bl 0x10031760                  ; -> 10031760
10016ee4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016ee8  807f0000    lwz r3,0x0(r31)             
10016eec  4801a2d5    bl 0x100311c0                  ; -> 100311c0
10016ef0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016ef4  38827564    addi r4,r2,0x7564           
10016ef8  80640000    lwz r3,0x0(r4)              
10016efc  4801abc5    bl 0x10031ac0                  ; -> 10031ac0
10016f00  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016f04  38a27570    addi r5,r2,0x7570           
10016f08  80df0000    lwz r6,0x0(r31)             
10016f0c  80a50000    lwz r5,0x0(r5)              
10016f10  813f0000    lwz r9,0x0(r31)             
10016f14  38860002    addi r4,r6,0x2              
10016f18  38650002    addi r3,r5,0x2              
10016f1c  38c2757c    addi r6,r2,0x757c           
10016f20  81090018    lwz r8,0x18(r9)             
10016f24  38a10038    addi r5,r1,0x38             
10016f28  38e00000    li r7,0x0                   
10016f2c  4801ae1d    bl 0x10031d48                  ; -> 10031d48
10016f30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
10016f34  4800ace1    bl 0x10021c14                  ; -> 10021c14
10016f38  60000000    ori r0,r0,0x0               
10016f3c  38600035    li r3,0x35                  
10016f40  480012d5    bl 0x10018214                  ; -> 10018214
10016f44  60000000    ori r0,r0,0x0               
10016f48  38600035    li r3,0x35                  
10016f4c  38800064    li r4,0x64                  
10016f50  480140d1    bl 0x1002b020                  ; -> 1002b020
10016f54  60000000    ori r0,r0,0x0               
10016f58  4800a8fd    bl 0x10021854                  ; -> 10021854
10016f5c  60000000    ori r0,r0,0x0               
10016f60  38600035    li r3,0x35                  
10016f64  48002d55    bl 0x10019cb8                  ; -> 10019cb8
10016f68  60000000    ori r0,r0,0x0               
10016f6c  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
10016f70  38210070    addi r1,r1,0x70             
10016f74  7c0803a6    mtspr LR,r0                 
10016f78  bb01ffe0    lmw r24,-0x20(r1)              ; -> Stack[-0x20]
10016f7c  4e800020    blr                         
