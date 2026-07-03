; FUN_1000d8c4 @ 0x1000d8c4
1000d8c4  7c0802a6    mfspr r0,LR                 
1000d8c8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000d8cc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000d8d0  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000d8d4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000d8d8  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000d8dc  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
1000d8e0  a881006a    lha r4,0x6a(r1)                ; -> Stack[0x1a]
1000d8e4  38623cd8    addi r3,r2,0x3cd8           
1000d8e8  1c840046    mulli r4,r4,0x46            
1000d8ec  7fe32214    add r31,r3,r4               
1000d8f0  88bf001f    lbz r5,0x1f(r31)            
1000d8f4  28050000    cmplwi r5,0x0               
1000d8f8  41820088    beq 0x1000d980                 ; -> 1000d980
1000d8fc  38c00000    li r6,0x0                   
1000d900  98df001f    stb r6,0x1f(r31)            
1000d904  38e00001    li r7,0x1                   
1000d908  b0ff0024    sth r7,0x24(r31)            
1000d90c  39000000    li r8,0x0                   
1000d910  b11f002e    sth r8,0x2e(r31)            
1000d914  a93f0004    lha r9,0x4(r31)             
1000d918  2c090002    cmpwi r9,0x2                
1000d91c  4082002c    bne 0x1000d948                 ; -> 1000d948
1000d920  a97f0010    lha r11,0x10(r31)           
1000d924  3942047c    addi r10,r2,0x47c           
1000d928  7d6c2e70    srawi r12,r11,0x5           
1000d92c  7d8c0194    addze r12,r12               
1000d930  558c2834    rlwinm r12,r12,0x5,0x0,0x1a 
1000d934  7d8c5810    subfc r12,r12,r11           
1000d938  558c083c    rlwinm r12,r12,0x1,0x0,0x1e 
1000d93c  7d4a62ae    lhax r10,r10,r12            
1000d940  b15f000e    sth r10,0xe(r31)            
1000d944  48000028    b 0x1000d96c                   ; -> 1000d96c
1000d948  a89f0010    lha r4,0x10(r31)            
1000d94c  386204bc    addi r3,r2,0x4bc            
1000d950  7c852e70    srawi r5,r4,0x5             
1000d954  7ca50194    addze r5,r5                 
1000d958  54a52834    rlwinm r5,r5,0x5,0x0,0x1a   
1000d95c  7ca52010    subfc r5,r5,r4              
1000d960  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1000d964  7c632aae    lhax r3,r3,r5               
1000d968  b07f000e    sth r3,0xe(r31)             
1000d96c  38c00001    li r6,0x1                   
1000d970  98df001e    stb r6,0x1e(r31)            
1000d974  38e005dc    li r7,0x5dc                 
1000d978  b0ff0042    sth r7,0x42(r31)            
1000d97c  480003b4    b 0x1000dd30                   ; -> 1000dd30
1000d980  a91f0024    lha r8,0x24(r31)            
1000d984  7d094378    or r9,r8,r8                 
1000d988  7d290734    extsh r9,r9                 
1000d98c  3908ffff    subi r8,r8,0x1              
1000d990  2c090000    cmpwi r9,0x0                
1000d994  b11f0024    sth r8,0x24(r31)            
1000d998  40820398    bne 0x1000dd30                 ; -> 1000dd30
1000d99c  39400001    li r10,0x1                  
1000d9a0  995f001e    stb r10,0x1e(r31)           
1000d9a4  a97f002c    lha r11,0x2c(r31)           
1000d9a8  396bffff    subi r11,r11,0x1            
1000d9ac  b17f002c    sth r11,0x2c(r31)           
1000d9b0  7d6b0734    extsh r11,r11               
1000d9b4  2c0b0000    cmpwi r11,0x0               
1000d9b8  4080000c    bge 0x1000d9c4                 ; -> 1000d9c4
1000d9bc  39800001    li r12,0x1                  
1000d9c0  999f0020    stb r12,0x20(r31)           
1000d9c4  a87f0040    lha r3,0x40(r31)            
1000d9c8  2c030000    cmpwi r3,0x0                
1000d9cc  40810058    ble 0x1000da24                 ; -> 1000da24
1000d9d0  38600008    li r3,0x8                   
1000d9d4  38800005    li r4,0x5                   
1000d9d8  4801d649    bl 0x1002b020                  ; -> 1002b020
1000d9dc  60000000    ori r0,r0,0x0               
1000d9e0  38800001    li r4,0x1                   
1000d9e4  989f0020    stb r4,0x20(r31)            
1000d9e8  807f000a    lwz r3,0xa(r31)             
1000d9ec  a89f000e    lha r4,0xe(r31)             
1000d9f0  a8bf0010    lha r5,0x10(r31)            
1000d9f4  a8df0012    lha r6,0x12(r31)            
1000d9f8  38e00001    li r7,0x1                   
1000d9fc  4801a619    bl 0x10028014                  ; -> 10028014
1000da00  60000000    ori r0,r0,0x0               
1000da04  a8ff0040    lha r7,0x40(r31)            
1000da08  38c26840    addi r6,r2,0x6840           
1000da0c  1ce70070    mulli r7,r7,0x70            
1000da10  38c6003c    addi r6,r6,0x3c             
1000da14  a8bf0042    lha r5,0x42(r31)            
1000da18  7d06382e    lwzx r8,r6,r7               
1000da1c  7d082a14    add r8,r8,r5                
1000da20  7d06392e    stwx r8,r6,r7               
1000da24  39200001    li r9,0x1                   
1000da28  b13f0024    sth r9,0x24(r31)            
1000da2c  a95f0010    lha r10,0x10(r31)           
1000da30  a97f0010    lha r11,0x10(r31)           
1000da34  a99f0012    lha r12,0x12(r31)           
1000da38  386a0006    addi r3,r10,0x6             
1000da3c  388b001e    addi r4,r11,0x1e            
1000da40  38ac001c    addi r5,r12,0x1c            
1000da44  4bff7d0d    bl 0x10005750                  ; -> 10005750
1000da48  60000000    ori r0,r0,0x0               
1000da4c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000da50  28030000    cmplwi r3,0x0               
1000da54  418200ac    beq 0x1000db00                 ; -> 1000db00
1000da58  a87f0012    lha r3,0x12(r31)            
1000da5c  38630004    addi r3,r3,0x4              
1000da60  b07f0012    sth r3,0x12(r31)            
1000da64  a89f0010    lha r4,0x10(r31)            
1000da68  a8bf0010    lha r5,0x10(r31)            
1000da6c  38640006    addi r3,r4,0x6              
1000da70  a8df0012    lha r6,0x12(r31)            
1000da74  3885001e    addi r4,r5,0x1e             
1000da78  38a6001c    addi r5,r6,0x1c             
1000da7c  4bff7cd5    bl 0x10005750                  ; -> 10005750
1000da80  60000000    ori r0,r0,0x0               
1000da84  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000da88  28030000    cmplwi r3,0x0               
1000da8c  40820274    bne 0x1000dd00                 ; -> 1000dd00
1000da90  a8ff0004    lha r7,0x4(r31)             
1000da94  2c070002    cmpwi r7,0x2                
1000da98  40820030    bne 0x1000dac8                 ; -> 1000dac8
1000da9c  a87f0010    lha r3,0x10(r31)            
1000daa0  4bff7a05    bl 0x100054a4                  ; -> 100054a4
1000daa4  60000000    ori r0,r0,0x0               
1000daa8  7c630734    extsh r3,r3                 
1000daac  2c030001    cmpwi r3,0x1                
1000dab0  40820018    bne 0x1000dac8                 ; -> 1000dac8
1000dab4  39000005    li r8,0x5                   
1000dab8  b11f0004    sth r8,0x4(r31)             
1000dabc  39200012    li r9,0x12                  
1000dac0  b13f000e    sth r9,0xe(r31)             
1000dac4  4800023c    b 0x1000dd00                   ; -> 1000dd00
1000dac8  a95f0004    lha r10,0x4(r31)            
1000dacc  2c0a0001    cmpwi r10,0x1               
1000dad0  40820230    bne 0x1000dd00                 ; -> 1000dd00
1000dad4  a87f0010    lha r3,0x10(r31)            
1000dad8  4bff79cd    bl 0x100054a4                  ; -> 100054a4
1000dadc  60000000    ori r0,r0,0x0               
1000dae0  7c630734    extsh r3,r3                 
1000dae4  2c030002    cmpwi r3,0x2                
1000dae8  40820218    bne 0x1000dd00                 ; -> 1000dd00
1000daec  39600006    li r11,0x6                  
1000daf0  b17f0004    sth r11,0x4(r31)            
1000daf4  39800021    li r12,0x21                 
1000daf8  b19f000e    sth r12,0xe(r31)            
1000dafc  48000204    b 0x1000dd00                   ; -> 1000dd00
1000db00  a87f0004    lha r3,0x4(r31)             
1000db04  2c030002    cmpwi r3,0x2                
1000db08  408200d0    bne 0x1000dbd8                 ; -> 1000dbd8
1000db0c  a89f0010    lha r4,0x10(r31)            
1000db10  a8bf0012    lha r5,0x12(r31)            
1000db14  38640024    addi r3,r4,0x24             
1000db18  3885000a    addi r4,r5,0xa              
1000db1c  4bff7a31    bl 0x1000554c                  ; -> 1000554c
1000db20  60000000    ori r0,r0,0x0               
1000db24  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000db28  28030000    cmplwi r3,0x0               
1000db2c  41820078    beq 0x1000dba4                 ; -> 1000dba4
1000db30  a8df0010    lha r6,0x10(r31)            
1000db34  a8ff0012    lha r7,0x12(r31)            
1000db38  38660024    addi r3,r6,0x24             
1000db3c  3887000a    addi r4,r7,0xa              
1000db40  4bff7b95    bl 0x100056d4                  ; -> 100056d4
1000db44  60000000    ori r0,r0,0x0               
1000db48  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000db4c  28030000    cmplwi r3,0x0               
1000db50  41820018    beq 0x1000db68                 ; -> 1000db68
1000db54  39000005    li r8,0x5                   
1000db58  b11f0004    sth r8,0x4(r31)             
1000db5c  39200012    li r9,0x12                  
1000db60  b13f000e    sth r9,0xe(r31)             
1000db64  4800019c    b 0x1000dd00                   ; -> 1000dd00
1000db68  a95f0012    lha r10,0x12(r31)           
1000db6c  386a000a    addi r3,r10,0xa             
1000db70  48020b89    bl 0x1002e6f8                  ; -> 1002e6f8
1000db74  60000000    ori r0,r0,0x0               
1000db78  a97f0010    lha r11,0x10(r31)           
1000db7c  7c7e1b78    or r30,r3,r3                
1000db80  386b0024    addi r3,r11,0x24            
1000db84  48020b49    bl 0x1002e6cc                  ; -> 1002e6cc
1000db88  60000000    ori r0,r0,0x0               
1000db8c  7c7d1b78    or r29,r3,r3                
1000db90  7fa3eb78    or r3,r29,r29               
1000db94  7fc4f378    or r4,r30,r30               
1000db98  48019e2d    bl 0x100279c4                  ; -> 100279c4
1000db9c  60000000    ori r0,r0,0x0               
1000dba0  48000160    b 0x1000dd00                   ; -> 1000dd00
1000dba4  a99f0010    lha r12,0x10(r31)           
1000dba8  3ba2047c    addi r29,r2,0x47c           
1000dbac  398c0002    addi r12,r12,0x2            
1000dbb0  b19f0010    sth r12,0x10(r31)           
1000dbb4  abdf0010    lha r30,0x10(r31)           
1000dbb8  7fc32e70    srawi r3,r30,0x5            
1000dbbc  7c630194    addze r3,r3                 
1000dbc0  54632834    rlwinm r3,r3,0x5,0x0,0x1a   
1000dbc4  7c63f010    subfc r3,r3,r30             
1000dbc8  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
1000dbcc  7fbd1aae    lhax r29,r29,r3             
1000dbd0  b3bf000e    sth r29,0xe(r31)            
1000dbd4  4800012c    b 0x1000dd00                   ; -> 1000dd00
1000dbd8  a89f0004    lha r4,0x4(r31)             
1000dbdc  2c040001    cmpwi r4,0x1                
1000dbe0  408200c4    bne 0x1000dca4                 ; -> 1000dca4
1000dbe4  a8bf0012    lha r5,0x12(r31)            
1000dbe8  a87f0010    lha r3,0x10(r31)            
1000dbec  3885000a    addi r4,r5,0xa              
1000dbf0  4bff795d    bl 0x1000554c                  ; -> 1000554c
1000dbf4  60000000    ori r0,r0,0x0               
1000dbf8  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000dbfc  28030000    cmplwi r3,0x0               
1000dc00  41820070    beq 0x1000dc70                 ; -> 1000dc70
1000dc04  a8df0012    lha r6,0x12(r31)            
1000dc08  a87f0010    lha r3,0x10(r31)            
1000dc0c  3886000a    addi r4,r6,0xa              
1000dc10  4bff7ac5    bl 0x100056d4                  ; -> 100056d4
1000dc14  60000000    ori r0,r0,0x0               
1000dc18  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1000dc1c  28030000    cmplwi r3,0x0               
1000dc20  41820018    beq 0x1000dc38                 ; -> 1000dc38
1000dc24  38e00006    li r7,0x6                   
1000dc28  b0ff0004    sth r7,0x4(r31)             
1000dc2c  39000021    li r8,0x21                  
1000dc30  b11f000e    sth r8,0xe(r31)             
1000dc34  480000cc    b 0x1000dd00                   ; -> 1000dd00
1000dc38  a93f0012    lha r9,0x12(r31)            
1000dc3c  3869000a    addi r3,r9,0xa              
1000dc40  48020ab9    bl 0x1002e6f8                  ; -> 1002e6f8
1000dc44  60000000    ori r0,r0,0x0               
1000dc48  7c7e1b78    or r30,r3,r3                
1000dc4c  a87f0010    lha r3,0x10(r31)            
1000dc50  48020a7d    bl 0x1002e6cc                  ; -> 1002e6cc
1000dc54  60000000    ori r0,r0,0x0               
1000dc58  7c7d1b78    or r29,r3,r3                
1000dc5c  7fa3eb78    or r3,r29,r29               
1000dc60  7fc4f378    or r4,r30,r30               
1000dc64  48019d61    bl 0x100279c4                  ; -> 100279c4
1000dc68  60000000    ori r0,r0,0x0               
1000dc6c  48000094    b 0x1000dd00                   ; -> 1000dd00
1000dc70  a95f0010    lha r10,0x10(r31)           
1000dc74  396204bc    addi r11,r2,0x4bc           
1000dc78  394afffe    subi r10,r10,0x2            
1000dc7c  b15f0010    sth r10,0x10(r31)           
1000dc80  a99f0010    lha r12,0x10(r31)           
1000dc84  7d9d2e70    srawi r29,r12,0x5           
1000dc88  7fbd0194    addze r29,r29               
1000dc8c  57bd2834    rlwinm r29,r29,0x5,0x0,0x1a 
1000dc90  7fbd6010    subfc r29,r29,r12           
1000dc94  57bd083c    rlwinm r29,r29,0x1,0x0,0x1e 
1000dc98  7d6beaae    lhax r11,r11,r29            
1000dc9c  b17f000e    sth r11,0xe(r31)            
1000dca0  48000060    b 0x1000dd00                   ; -> 1000dd00
1000dca4  abdf0004    lha r30,0x4(r31)            
1000dca8  2c1e0006    cmpwi r30,0x6               
1000dcac  40820028    bne 0x1000dcd4                 ; -> 1000dcd4
1000dcb0  a87f000e    lha r3,0xe(r31)             
1000dcb4  3863ffff    subi r3,r3,0x1              
1000dcb8  b07f000e    sth r3,0xe(r31)             
1000dcbc  7c630734    extsh r3,r3                 
1000dcc0  2c030012    cmpwi r3,0x12               
1000dcc4  4080003c    bge 0x1000dd00                 ; -> 1000dd00
1000dcc8  38800002    li r4,0x2                   
1000dccc  b09f0004    sth r4,0x4(r31)             
1000dcd0  48000030    b 0x1000dd00                   ; -> 1000dd00
1000dcd4  a8bf0004    lha r5,0x4(r31)             
1000dcd8  2c050005    cmpwi r5,0x5                
1000dcdc  40820024    bne 0x1000dd00                 ; -> 1000dd00
1000dce0  a8df000e    lha r6,0xe(r31)             
1000dce4  38c60001    addi r6,r6,0x1              
1000dce8  b0df000e    sth r6,0xe(r31)             
1000dcec  7cc60734    extsh r6,r6                 
1000dcf0  2c060021    cmpwi r6,0x21               
1000dcf4  4081000c    ble 0x1000dd00                 ; -> 1000dd00
1000dcf8  38e00001    li r7,0x1                   
1000dcfc  b0ff0004    sth r7,0x4(r31)             
1000dd00  a91f0010    lha r8,0x10(r31)            
1000dd04  39080006    addi r8,r8,0x6              
1000dd08  b11f003a    sth r8,0x3a(r31)            
1000dd0c  a93f0010    lha r9,0x10(r31)            
1000dd10  39290020    addi r9,r9,0x20             
1000dd14  b13f003c    sth r9,0x3c(r31)            
1000dd18  a95f0012    lha r10,0x12(r31)           
1000dd1c  394a0004    addi r10,r10,0x4            
1000dd20  b15f0038    sth r10,0x38(r31)           
1000dd24  a97f0012    lha r11,0x12(r31)           
1000dd28  396b001b    addi r11,r11,0x1b           
1000dd2c  b17f0036    sth r11,0x36(r31)           
1000dd30  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000dd34  38210050    addi r1,r1,0x50             
1000dd38  7c0803a6    mtspr LR,r0                 
1000dd3c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000dd40  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000dd44  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000dd48  4e800020    blr                         
