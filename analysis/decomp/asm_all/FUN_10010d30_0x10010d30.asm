; FUN_10010d30 @ 0x10010d30
10010d30  7c0802a6    mfspr r0,LR                 
10010d34  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10010d38  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10010d3c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10010d40  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10010d44  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10010d48  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10010d4c  7c7e1b78    or r30,r3,r3                
10010d50  38622f74    addi r3,r2,0x2f74           
10010d54  3be26840    addi r31,r2,0x6840          
10010d58  88630000    lbz r3,0x0(r3)              
10010d5c  28030000    cmplwi r3,0x0               
10010d60  4082000c    bne 0x10010d6c                 ; -> 10010d6c
10010d64  3ba00001    li r29,0x1                  
10010d68  48000008    b 0x10010d70                   ; -> 10010d70
10010d6c  7fddf378    or r29,r30,r30              
10010d70  7fc40734    extsh r4,r30                
10010d74  1c840070    mulli r4,r4,0x70            
10010d78  3884004e    addi r4,r4,0x4e             
10010d7c  7c9f22ae    lhax r4,r31,r4              
10010d80  2c040000    cmpwi r4,0x0                
10010d84  40820310    bne 0x10011094                 ; -> 10011094
10010d88  7fa50734    extsh r5,r29                
10010d8c  1ca50070    mulli r5,r5,0x70            
10010d90  38a5004c    addi r5,r5,0x4c             
10010d94  7cbf2aae    lhax r5,r31,r5              
10010d98  2c050000    cmpwi r5,0x0                
10010d9c  408102f8    ble 0x10011094                 ; -> 10011094
10010da0  38600002    li r3,0x2                   
10010da4  38800007    li r4,0x7                   
10010da8  4801a279    bl 0x1002b020                  ; -> 1002b020
10010dac  60000000    ori r0,r0,0x0               
10010db0  7fa3eb78    or r3,r29,r29               
10010db4  4bffe0dd    bl 0x1000ee90                  ; -> 1000ee90
10010db8  7fa70734    extsh r7,r29                
10010dbc  1ce70070    mulli r7,r7,0x70            
10010dc0  7fc80734    extsh r8,r30                
10010dc4  1d080070    mulli r8,r8,0x70            
10010dc8  38c00000    li r6,0x0                   
10010dcc  38e70042    addi r7,r7,0x42             
10010dd0  7cdf3b2e    sthx r6,r31,r7              
10010dd4  39080004    addi r8,r8,0x4              
10010dd8  7d1f42ae    lhax r8,r31,r8              
10010ddc  38680010    addi r3,r8,0x10             
10010de0  4801d8ed    bl 0x1002e6cc                  ; -> 1002e6cc
10010de4  60000000    ori r0,r0,0x0               
10010de8  7c7c1b78    or r28,r3,r3                
10010dec  7f83e378    or r3,r28,r28               
10010df0  4801d8bd    bl 0x1002e6ac                  ; -> 1002e6ac
10010df4  60000000    ori r0,r0,0x0               
10010df8  7fc90734    extsh r9,r30                
10010dfc  1d290070    mulli r9,r9,0x70            
10010e00  7fcb0734    extsh r11,r30               
10010e04  1d6b0070    mulli r11,r11,0x70          
10010e08  7fdc0734    extsh r28,r30               
10010e0c  1f9c0070    mulli r28,r28,0x70          
10010e10  7fc40734    extsh r4,r30                
10010e14  1c840070    mulli r4,r4,0x70            
10010e18  7fc50734    extsh r5,r30                
10010e1c  1ca50070    mulli r5,r5,0x70            
10010e20  38630008    addi r3,r3,0x8              
10010e24  39290050    addi r9,r9,0x50             
10010e28  7c7f4b2e    sthx r3,r31,r9              
10010e2c  39400001    li r10,0x1                  
10010e30  396b005a    addi r11,r11,0x5a           
10010e34  7d5f5b2e    sthx r10,r31,r11            
10010e38  39800000    li r12,0x0                  
10010e3c  3b9c0056    addi r28,r28,0x56           
10010e40  7d9fe32e    sthx r12,r31,r28            
10010e44  38600000    li r3,0x0                   
10010e48  38840058    addi r4,r4,0x58             
10010e4c  7c7f21ae    stbx r3,r31,r4              
10010e50  38a50034    addi r5,r5,0x34             
10010e54  7cbf2aae    lhax r5,r31,r5              
10010e58  2c050001    cmpwi r5,0x1                
10010e5c  40820124    bne 0x10010f80                 ; -> 10010f80
10010e60  7fc60734    extsh r6,r30                
10010e64  1cc60070    mulli r6,r6,0x70            
10010e68  7fc70734    extsh r7,r30                
10010e6c  1ce70070    mulli r7,r7,0x70            
10010e70  7fc80734    extsh r8,r30                
10010e74  1d080070    mulli r8,r8,0x70            
10010e78  7cdf32ae    lhax r6,r31,r6              
10010e7c  38e7004e    addi r7,r7,0x4e             
10010e80  38c60014    addi r6,r6,0x14             
10010e84  7cdf3b2e    sthx r6,r31,r7              
10010e88  39080050    addi r8,r8,0x50             
10010e8c  7c7f42ae    lhax r3,r31,r8              
10010e90  4801d869    bl 0x1002e6f8                  ; -> 1002e6f8
10010e94  60000000    ori r0,r0,0x0               
10010e98  7fc90734    extsh r9,r30                
10010e9c  1d290070    mulli r9,r9,0x70            
10010ea0  7c630734    extsh r3,r3                 
10010ea4  3929004e    addi r9,r9,0x4e             
10010ea8  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010eac  7d3f4aae    lhax r9,r31,r9              
10010eb0  7c7c1b78    or r28,r3,r3                
10010eb4  38690018    addi r3,r9,0x18             
10010eb8  4801d815    bl 0x1002e6cc                  ; -> 1002e6cc
10010ebc  60000000    ori r0,r0,0x0               
10010ec0  7c630734    extsh r3,r3                 
10010ec4  1c63003c    mulli r3,r3,0x3c            
10010ec8  39426bf8    addi r10,r2,0x6bf8          
10010ecc  7c63e214    add r3,r3,r28               
10010ed0  7d4a182e    lwzx r10,r10,r3             
10010ed4  554a05ac    rlwinm r10,r10,0x0,0x16,0x16
10010ed8  2c0a0000    cmpwi r10,0x0               
10010edc  41820044    beq 0x10010f20                 ; -> 10010f20
10010ee0  7fcb0734    extsh r11,r30               
10010ee4  1d6b0070    mulli r11,r11,0x70          
10010ee8  396b004e    addi r11,r11,0x4e           
10010eec  7d7f5aae    lhax r11,r31,r11            
10010ef0  386bfff8    subi r3,r11,0x8             
10010ef4  4801d7d9    bl 0x1002e6cc                  ; -> 1002e6cc
10010ef8  60000000    ori r0,r0,0x0               
10010efc  7c7c1b78    or r28,r3,r3                
10010f00  7f83e378    or r3,r28,r28               
10010f04  4801d7a9    bl 0x1002e6ac                  ; -> 1002e6ac
10010f08  60000000    ori r0,r0,0x0               
10010f0c  7fcc0734    extsh r12,r30               
10010f10  1d8c0070    mulli r12,r12,0x70          
10010f14  38630008    addi r3,r3,0x8              
10010f18  398c004e    addi r12,r12,0x4e           
10010f1c  7c7f632e    sthx r3,r31,r12             
10010f20  7fc30734    extsh r3,r30                
10010f24  1c630070    mulli r3,r3,0x70            
10010f28  7fc50734    extsh r5,r30                
10010f2c  1ca50070    mulli r5,r5,0x70            
10010f30  7fc70734    extsh r7,r30                
10010f34  7fc80734    extsh r8,r30                
10010f38  1ce70070    mulli r7,r7,0x70            
10010f3c  1d080070    mulli r8,r8,0x70            
10010f40  3b800003    li r28,0x3                  
10010f44  38630052    addi r3,r3,0x52             
10010f48  7f9f1b2e    sthx r28,r31,r3             
10010f4c  38800002    li r4,0x2                   
10010f50  38a50054    addi r5,r5,0x54             
10010f54  7c9f2b2e    sthx r4,r31,r5              
10010f58  38c26bb0    addi r6,r2,0x6bb0           
10010f5c  38e7004e    addi r7,r7,0x4e             
10010f60  80660000    lwz r3,0x0(r6)              
10010f64  39080050    addi r8,r8,0x50             
10010f68  7cbf3aae    lhax r5,r31,r7              
10010f6c  7cdf42ae    lhax r6,r31,r8              
10010f70  38800001    li r4,0x1                   
10010f74  4bff3c41    bl 0x10004bb4                  ; -> 10004bb4
10010f78  60000000    ori r0,r0,0x0               
10010f7c  48000118    b 0x10011094                   ; -> 10011094
10010f80  7fc90734    extsh r9,r30                
10010f84  1d290070    mulli r9,r9,0x70            
10010f88  7fca0734    extsh r10,r30               
10010f8c  1d4a0070    mulli r10,r10,0x70          
10010f90  7fcb0734    extsh r11,r30               
10010f94  1d6b0070    mulli r11,r11,0x70          
10010f98  7d3f4aae    lhax r9,r31,r9              
10010f9c  394a004e    addi r10,r10,0x4e           
10010fa0  3929fff2    subi r9,r9,0xe              
10010fa4  7d3f532e    sthx r9,r31,r10             
10010fa8  396b0050    addi r11,r11,0x50           
10010fac  7c7f5aae    lhax r3,r31,r11             
10010fb0  4801d749    bl 0x1002e6f8                  ; -> 1002e6f8
10010fb4  60000000    ori r0,r0,0x0               
10010fb8  7fcc0734    extsh r12,r30               
10010fbc  1d8c0070    mulli r12,r12,0x70          
10010fc0  7c630734    extsh r3,r3                 
10010fc4  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010fc8  7c7c1b78    or r28,r3,r3                
10010fcc  398c004e    addi r12,r12,0x4e           
10010fd0  7c7f62ae    lhax r3,r31,r12             
10010fd4  4801d6f9    bl 0x1002e6cc                  ; -> 1002e6cc
10010fd8  60000000    ori r0,r0,0x0               
10010fdc  7c630734    extsh r3,r3                 
10010fe0  1c63003c    mulli r3,r3,0x3c            
10010fe4  38826bf8    addi r4,r2,0x6bf8           
10010fe8  7c63e214    add r3,r3,r28               
10010fec  7c84182e    lwzx r4,r4,r3               
10010ff0  548405ac    rlwinm r4,r4,0x0,0x16,0x16  
10010ff4  2c040000    cmpwi r4,0x0                
10010ff8  41820040    beq 0x10011038                 ; -> 10011038
10010ffc  7fc50734    extsh r5,r30                
10011000  1ca50070    mulli r5,r5,0x70            
10011004  38a5004e    addi r5,r5,0x4e             
10011008  7cbf2aae    lhax r5,r31,r5              
1001100c  38650020    addi r3,r5,0x20             
10011010  4801d6bd    bl 0x1002e6cc                  ; -> 1002e6cc
10011014  60000000    ori r0,r0,0x0               
10011018  7c7c1b78    or r28,r3,r3                
1001101c  7f83e378    or r3,r28,r28               
10011020  4801d68d    bl 0x1002e6ac                  ; -> 1002e6ac
10011024  60000000    ori r0,r0,0x0               
10011028  7fc60734    extsh r6,r30                
1001102c  1cc60070    mulli r6,r6,0x70            
10011030  38c6004e    addi r6,r6,0x4e             
10011034  7c7f332e    sthx r3,r31,r6              
10011038  7fc80734    extsh r8,r30                
1001103c  1d080070    mulli r8,r8,0x70            
10011040  7fca0734    extsh r10,r30               
10011044  1d4a0070    mulli r10,r10,0x70          
10011048  7fcc0734    extsh r12,r30               
1001104c  7fdc0734    extsh r28,r30               
10011050  1d8c0070    mulli r12,r12,0x70          
10011054  1f9c0070    mulli r28,r28,0x70          
10011058  38e00001    li r7,0x1                   
1001105c  39080052    addi r8,r8,0x52             
10011060  7cff432e    sthx r7,r31,r8              
10011064  39200003    li r9,0x3                   
10011068  394a0054    addi r10,r10,0x54           
1001106c  39626bb0    addi r11,r2,0x6bb0          
10011070  7d3f532e    sthx r9,r31,r10             
10011074  398c004e    addi r12,r12,0x4e           
10011078  3b9c0050    addi r28,r28,0x50           
1001107c  806b0000    lwz r3,0x0(r11)             
10011080  7cbf62ae    lhax r5,r31,r12             
10011084  7cdfe2ae    lhax r6,r31,r28             
10011088  38800001    li r4,0x1                   
1001108c  4bff3b29    bl 0x10004bb4                  ; -> 10004bb4
10011090  60000000    ori r0,r0,0x0               
10011094  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10011098  38210050    addi r1,r1,0x50             
1001109c  7c0803a6    mtspr LR,r0                 
100110a0  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100110a4  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100110a8  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100110ac  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
100110b0  4e800020    blr                         
