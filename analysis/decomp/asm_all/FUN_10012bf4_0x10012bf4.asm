; FUN_10012bf4 @ 0x10012bf4
10012bf4  7c0802a6    mfspr r0,LR                 
10012bf8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10012bfc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10012c00  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10012c04  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10012c08  7c7f1b78    or r31,r3,r3                
10012c0c  3bc26840    addi r30,r2,0x6840          
10012c10  7fe3fb78    or r3,r31,r31               
10012c14  48001b8d    bl 0x100147a0                  ; -> 100147a0
10012c18  60000000    ori r0,r0,0x0               
10012c1c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10012c20  28030000    cmplwi r3,0x0               
10012c24  418200b0    beq 0x10012cd4                 ; -> 10012cd4
10012c28  7fe3fb78    or r3,r31,r31               
10012c2c  48001b19    bl 0x10014744                  ; -> 10014744
10012c30  60000000    ori r0,r0,0x0               
10012c34  7fe30734    extsh r3,r31                
10012c38  1c630070    mulli r3,r3,0x70            
10012c3c  3863001e    addi r3,r3,0x1e             
10012c40  7c7e18ae    lbzx r3,r30,r3              
10012c44  28030000    cmplwi r3,0x0               
10012c48  4082008c    bne 0x10012cd4                 ; -> 10012cd4
10012c4c  7fe40734    extsh r4,r31                
10012c50  1c840070    mulli r4,r4,0x70            
10012c54  3884001f    addi r4,r4,0x1f             
10012c58  7c9e20ae    lbzx r4,r30,r4              
10012c5c  28040000    cmplwi r4,0x0               
10012c60  40820074    bne 0x10012cd4                 ; -> 10012cd4
10012c64  7fe60734    extsh r6,r31                
10012c68  1cc60070    mulli r6,r6,0x70            
10012c6c  7fe80734    extsh r8,r31                
10012c70  1d080070    mulli r8,r8,0x70            
10012c74  7fe90734    extsh r9,r31                
10012c78  1d290070    mulli r9,r9,0x70            
10012c7c  38a00000    li r5,0x0                   
10012c80  38c6001c    addi r6,r6,0x1c             
10012c84  7cbe332e    sthx r5,r30,r6              
10012c88  38e00000    li r7,0x0                   
10012c8c  39080032    addi r8,r8,0x32             
10012c90  7cfe432e    sthx r7,r30,r8              
10012c94  39290034    addi r9,r9,0x34             
10012c98  7d3e4aae    lhax r9,r30,r9              
10012c9c  2c090001    cmpwi r9,0x1                
10012ca0  4082001c    bne 0x10012cbc                 ; -> 10012cbc
10012ca4  7feb0734    extsh r11,r31               
10012ca8  1d6b0070    mulli r11,r11,0x70          
10012cac  3940003d    li r10,0x3d                 
10012cb0  396b000e    addi r11,r11,0xe            
10012cb4  7d5e5b2e    sthx r10,r30,r11            
10012cb8  48000018    b 0x10012cd0                   ; -> 10012cd0
10012cbc  7fe30734    extsh r3,r31                
10012cc0  1c630070    mulli r3,r3,0x70            
10012cc4  39800034    li r12,0x34                 
10012cc8  3863000e    addi r3,r3,0xe              
10012ccc  7d9e1b2e    sthx r12,r30,r3             
10012cd0  4800071c    b 0x100133ec                   ; -> 100133ec
10012cd4  7fe3fb78    or r3,r31,r31               
10012cd8  4bfff671    bl 0x10012348                  ; -> 10012348
10012cdc  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10012ce0  28030000    cmplwi r3,0x0               
10012ce4  4082001c    bne 0x10012d00                 ; -> 10012d00
10012ce8  7fe50734    extsh r5,r31                
10012cec  1ca50070    mulli r5,r5,0x70            
10012cf0  38800003    li r4,0x3                   
10012cf4  38a5001c    addi r5,r5,0x1c             
10012cf8  7c9e2b2e    sthx r4,r30,r5              
10012cfc  480006f0    b 0x100133ec                   ; -> 100133ec
10012d00  7fe60734    extsh r6,r31                
10012d04  1cc60070    mulli r6,r6,0x70            
10012d08  38c60034    addi r6,r6,0x34             
10012d0c  7cde32ae    lhax r6,r30,r6              
10012d10  2c060001    cmpwi r6,0x1                
10012d14  40820364    bne 0x10013078                 ; -> 10013078
10012d18  7fe70734    extsh r7,r31                
10012d1c  1ce70070    mulli r7,r7,0x70            
10012d20  38e70032    addi r7,r7,0x32             
10012d24  7cfe3aae    lhax r7,r30,r7              
10012d28  2c070000    cmpwi r7,0x0                
10012d2c  40820048    bne 0x10012d74                 ; -> 10012d74
10012d30  7fe80734    extsh r8,r31                
10012d34  1d080070    mulli r8,r8,0x70            
10012d38  7d1e42ae    lhax r8,r30,r8              
10012d3c  550807bc    rlwinm r8,r8,0x0,0x1e,0x1e  
10012d40  2c080002    cmpwi r8,0x2                
10012d44  4082001c    bne 0x10012d60                 ; -> 10012d60
10012d48  7fea0734    extsh r10,r31               
10012d4c  1d4a0070    mulli r10,r10,0x70          
10012d50  3920001a    li r9,0x1a                  
10012d54  394a000e    addi r10,r10,0xe            
10012d58  7d3e532e    sthx r9,r30,r10             
10012d5c  48000018    b 0x10012d74                   ; -> 10012d74
10012d60  7fec0734    extsh r12,r31               
10012d64  1d8c0070    mulli r12,r12,0x70          
10012d68  39600019    li r11,0x19                 
10012d6c  398c000e    addi r12,r12,0xe            
10012d70  7d7e632e    sthx r11,r30,r12            
10012d74  7fe30734    extsh r3,r31                
10012d78  1c630070    mulli r3,r3,0x70            
10012d7c  38630020    addi r3,r3,0x20             
10012d80  7c7e18ae    lbzx r3,r30,r3              
10012d84  28030000    cmplwi r3,0x0               
10012d88  41820030    beq 0x10012db8                 ; -> 10012db8
10012d8c  7fe50734    extsh r5,r31                
10012d90  1ca50070    mulli r5,r5,0x70            
10012d94  7fe70734    extsh r7,r31                
10012d98  1ce70070    mulli r7,r7,0x70            
10012d9c  38800002    li r4,0x2                   
10012da0  38a5001c    addi r5,r5,0x1c             
10012da4  7c9e2b2e    sthx r4,r30,r5              
10012da8  38c00000    li r6,0x0                   
10012dac  38e70032    addi r7,r7,0x32             
10012db0  7cde3b2e    sthx r6,r30,r7              
10012db4  48000638    b 0x100133ec                   ; -> 100133ec
10012db8  7fe80734    extsh r8,r31                
10012dbc  1d080070    mulli r8,r8,0x70            
10012dc0  3908001e    addi r8,r8,0x1e             
10012dc4  7d1e40ae    lbzx r8,r30,r8              
10012dc8  28080000    cmplwi r8,0x0               
10012dcc  4082001c    bne 0x10012de8                 ; -> 10012de8
10012dd0  7fe90734    extsh r9,r31                
10012dd4  1d290070    mulli r9,r9,0x70            
10012dd8  7d3e4aae    lhax r9,r30,r9              
10012ddc  552907bc    rlwinm r9,r9,0x0,0x1e,0x1e  
10012de0  2c090000    cmpwi r9,0x0                
10012de4  41820210    beq 0x10012ff4                 ; -> 10012ff4
10012de8  7fe3fb78    or r3,r31,r31               
10012dec  4bfff9f5    bl 0x100127e0                  ; -> 100127e0
10012df0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10012df4  28030000    cmplwi r3,0x0               
10012df8  41820074    beq 0x10012e6c                 ; -> 10012e6c
10012dfc  7fea0734    extsh r10,r31               
10012e00  1d4a0070    mulli r10,r10,0x70          
10012e04  7fec0734    extsh r12,r31               
10012e08  7d7e52ae    lhax r11,r30,r10            
10012e0c  7fe30734    extsh r3,r31                
10012e10  1c630070    mulli r3,r3,0x70            
10012e14  7fe40734    extsh r4,r31                
10012e18  396b0002    addi r11,r11,0x2            
10012e1c  1c840070    mulli r4,r4,0x70            
10012e20  1d8c0070    mulli r12,r12,0x70          
10012e24  7d7e532e    sthx r11,r30,r10            
10012e28  7d9e62ae    lhax r12,r30,r12            
10012e2c  38630002    addi r3,r3,0x2              
10012e30  558c043a    rlwinm r12,r12,0x0,0x10,0x1d
10012e34  7d9e1b2e    sthx r12,r30,r3             
10012e38  3884000e    addi r4,r4,0xe              
10012e3c  7cbe22ae    lhax r5,r30,r4              
10012e40  38a50001    addi r5,r5,0x1              
10012e44  7cbe232e    sthx r5,r30,r4              
10012e48  7ca50734    extsh r5,r5                 
10012e4c  2c050031    cmpwi r5,0x31               
10012e50  41800168    blt 0x10012fb8                 ; -> 10012fb8
10012e54  7fe70734    extsh r7,r31                
10012e58  1ce70070    mulli r7,r7,0x70            
10012e5c  38c00019    li r6,0x19                  
10012e60  38e7000e    addi r7,r7,0xe              
10012e64  7cde3b2e    sthx r6,r30,r7              
10012e68  48000150    b 0x10012fb8                   ; -> 10012fb8
10012e6c  7fe80734    extsh r8,r31                
10012e70  1d080070    mulli r8,r8,0x70            
10012e74  3908001e    addi r8,r8,0x1e             
10012e78  7d1e40ae    lbzx r8,r30,r8              
10012e7c  28080000    cmplwi r8,0x0               
10012e80  40820074    bne 0x10012ef4                 ; -> 10012ef4
10012e84  7fe90734    extsh r9,r31                
10012e88  1d290070    mulli r9,r9,0x70            
10012e8c  7feb0734    extsh r11,r31               
10012e90  7d5e4aae    lhax r10,r30,r9             
10012e94  7fec0734    extsh r12,r31               
10012e98  1d8c0070    mulli r12,r12,0x70          
10012e9c  7fe30734    extsh r3,r31                
10012ea0  394afffe    subi r10,r10,0x2            
10012ea4  1c630070    mulli r3,r3,0x70            
10012ea8  1d6b0070    mulli r11,r11,0x70          
10012eac  7d5e4b2e    sthx r10,r30,r9             
10012eb0  7d7e5aae    lhax r11,r30,r11            
10012eb4  398c0002    addi r12,r12,0x2            
10012eb8  556b043a    rlwinm r11,r11,0x0,0x10,0x1d
10012ebc  7d7e632e    sthx r11,r30,r12            
10012ec0  3863000e    addi r3,r3,0xe              
10012ec4  7c9e1aae    lhax r4,r30,r3              
10012ec8  38840001    addi r4,r4,0x1              
10012ecc  7c9e1b2e    sthx r4,r30,r3              
10012ed0  7c840734    extsh r4,r4                 
10012ed4  2c040031    cmpwi r4,0x31               
10012ed8  418000e0    blt 0x10012fb8                 ; -> 10012fb8
10012edc  7fe60734    extsh r6,r31                
10012ee0  1cc60070    mulli r6,r6,0x70            
10012ee4  38a00019    li r5,0x19                  
10012ee8  38c6000e    addi r6,r6,0xe              
10012eec  7cbe332e    sthx r5,r30,r6              
10012ef0  480000c8    b 0x10012fb8                   ; -> 10012fb8
10012ef4  7fe70734    extsh r7,r31                
10012ef8  1ce70070    mulli r7,r7,0x70            
10012efc  7fe80734    extsh r8,r31                
10012f00  1d080070    mulli r8,r8,0x70            
10012f04  7fe90734    extsh r9,r31                
10012f08  1d290070    mulli r9,r9,0x70            
10012f0c  7cfe3aae    lhax r7,r30,r7              
10012f10  39080002    addi r8,r8,0x2              
10012f14  54e7043a    rlwinm r7,r7,0x0,0x10,0x1d  
10012f18  7cfe432e    sthx r7,r30,r8              
10012f1c  39290032    addi r9,r9,0x32             
10012f20  7d3e4aae    lhax r9,r30,r9              
10012f24  2c090000    cmpwi r9,0x0                
10012f28  41820090    beq 0x10012fb8                 ; -> 10012fb8
10012f2c  7fea0734    extsh r10,r31               
10012f30  1d4a0070    mulli r10,r10,0x70          
10012f34  394a0032    addi r10,r10,0x32           
10012f38  7d5e52ae    lhax r10,r30,r10            
10012f3c  554a07fe    rlwinm r10,r10,0x0,0x1f,0x1f
10012f40  2c0a0000    cmpwi r10,0x0               
10012f44  41820074    beq 0x10012fb8                 ; -> 10012fb8
10012f48  7feb0734    extsh r11,r31               
10012f4c  1d6b0070    mulli r11,r11,0x70          
10012f50  396b000e    addi r11,r11,0xe            
10012f54  7d9e5aae    lhax r12,r30,r11            
10012f58  398c0001    addi r12,r12,0x1            
10012f5c  7d9e5b2e    sthx r12,r30,r11            
10012f60  7d8c0734    extsh r12,r12               
10012f64  2c0c0031    cmpwi r12,0x31              
10012f68  41800018    blt 0x10012f80                 ; -> 10012f80
10012f6c  7fe40734    extsh r4,r31                
10012f70  1c840070    mulli r4,r4,0x70            
10012f74  38600019    li r3,0x19                  
10012f78  3884000e    addi r4,r4,0xe              
10012f7c  7c7e232e    sthx r3,r30,r4              
10012f80  7fe50734    extsh r5,r31                
10012f84  1ca50070    mulli r5,r5,0x70            
10012f88  38a5000e    addi r5,r5,0xe              
10012f8c  7cde2aae    lhax r6,r30,r5              
10012f90  38c60001    addi r6,r6,0x1              
10012f94  7cde2b2e    sthx r6,r30,r5              
10012f98  7cc60734    extsh r6,r6                 
10012f9c  2c060031    cmpwi r6,0x31               
10012fa0  41800018    blt 0x10012fb8                 ; -> 10012fb8
10012fa4  7fe80734    extsh r8,r31                
10012fa8  1d080070    mulli r8,r8,0x70            
10012fac  38e00019    li r7,0x19                  
10012fb0  3908000e    addi r8,r8,0xe              
10012fb4  7cfe432e    sthx r7,r30,r8              
10012fb8  7fe90734    extsh r9,r31                
10012fbc  1d290070    mulli r9,r9,0x70            
10012fc0  39290032    addi r9,r9,0x32             
10012fc4  7fe30734    extsh r3,r31                
10012fc8  7d5e4aae    lhax r10,r30,r9             
10012fcc  1c630070    mulli r3,r3,0x70            
10012fd0  394a0001    addi r10,r10,0x1            
10012fd4  7fec0734    extsh r12,r31               
10012fd8  39626bc4    addi r11,r2,0x6bc4          
10012fdc  7d5e4b2e    sthx r10,r30,r9             
10012fe0  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
10012fe4  7d6b602e    lwzx r11,r11,r12            
10012fe8  38630006    addi r3,r3,0x6              
10012fec  7d7e192e    stwx r11,r30,r3             
10012ff0  480003fc    b 0x100133ec                   ; -> 100133ec
10012ff4  7fe40734    extsh r4,r31                
10012ff8  1c840070    mulli r4,r4,0x70            
10012ffc  3884001f    addi r4,r4,0x1f             
10013000  7c9e20ae    lbzx r4,r30,r4              
10013004  28040000    cmplwi r4,0x0               
10013008  41820044    beq 0x1001304c                 ; -> 1001304c
1001300c  7fe60734    extsh r6,r31                
10013010  1cc60070    mulli r6,r6,0x70            
10013014  7fe80734    extsh r8,r31                
10013018  1d080070    mulli r8,r8,0x70            
1001301c  7fea0734    extsh r10,r31               
10013020  1d4a0070    mulli r10,r10,0x70          
10013024  38a0000b    li r5,0xb                   
10013028  38c6001c    addi r6,r6,0x1c             
1001302c  7cbe332e    sthx r5,r30,r6              
10013030  38e00000    li r7,0x0                   
10013034  39080032    addi r8,r8,0x32             
10013038  7cfe432e    sthx r7,r30,r8              
1001303c  3920ffff    li r9,-0x1                  
10013040  394a0034    addi r10,r10,0x34           
10013044  7d3e532e    sthx r9,r30,r10             
10013048  480003a4    b 0x100133ec                   ; -> 100133ec
1001304c  7fec0734    extsh r12,r31               
10013050  1d8c0070    mulli r12,r12,0x70          
10013054  7fe40734    extsh r4,r31                
10013058  1c840070    mulli r4,r4,0x70            
1001305c  3960000c    li r11,0xc                  
10013060  398c001c    addi r12,r12,0x1c           
10013064  7d7e632e    sthx r11,r30,r12            
10013068  38600000    li r3,0x0                   
1001306c  38840032    addi r4,r4,0x32             
10013070  7c7e232e    sthx r3,r30,r4              
10013074  48000378    b 0x100133ec                   ; -> 100133ec
10013078  7fe50734    extsh r5,r31                
1001307c  1ca50070    mulli r5,r5,0x70            
10013080  38a50034    addi r5,r5,0x34             
10013084  7cbe2aae    lhax r5,r30,r5              
10013088  2c05ffff    cmpwi r5,-0x1               
1001308c  40820360    bne 0x100133ec                 ; -> 100133ec
10013090  7fe60734    extsh r6,r31                
10013094  1cc60070    mulli r6,r6,0x70            
10013098  38c60032    addi r6,r6,0x32             
1001309c  7cde32ae    lhax r6,r30,r6              
100130a0  2c060000    cmpwi r6,0x0                
100130a4  40820048    bne 0x100130ec                 ; -> 100130ec
100130a8  7fe70734    extsh r7,r31                
100130ac  1ce70070    mulli r7,r7,0x70            
100130b0  7cfe3aae    lhax r7,r30,r7              
100130b4  54e707bc    rlwinm r7,r7,0x0,0x1e,0x1e  
100130b8  2c070002    cmpwi r7,0x2                
100130bc  4082001c    bne 0x100130d8                 ; -> 100130d8
100130c0  7fe90734    extsh r9,r31                
100130c4  1d290070    mulli r9,r9,0x70            
100130c8  39000001    li r8,0x1                   
100130cc  3929000e    addi r9,r9,0xe              
100130d0  7d1e4b2e    sthx r8,r30,r9              
100130d4  48000018    b 0x100130ec                   ; -> 100130ec
100130d8  7feb0734    extsh r11,r31               
100130dc  1d6b0070    mulli r11,r11,0x70          
100130e0  39400002    li r10,0x2                  
100130e4  396b000e    addi r11,r11,0xe            
100130e8  7d5e5b2e    sthx r10,r30,r11            
100130ec  7fec0734    extsh r12,r31               
100130f0  1d8c0070    mulli r12,r12,0x70          
100130f4  398c0020    addi r12,r12,0x20           
100130f8  7d9e60ae    lbzx r12,r30,r12            
100130fc  280c0000    cmplwi r12,0x0              
10013100  41820030    beq 0x10013130                 ; -> 10013130
10013104  7fe40734    extsh r4,r31                
10013108  1c840070    mulli r4,r4,0x70            
1001310c  7fe60734    extsh r6,r31                
10013110  1cc60070    mulli r6,r6,0x70            
10013114  38600002    li r3,0x2                   
10013118  3884001c    addi r4,r4,0x1c             
1001311c  7c7e232e    sthx r3,r30,r4              
10013120  38a00000    li r5,0x0                   
10013124  38c60032    addi r6,r6,0x32             
10013128  7cbe332e    sthx r5,r30,r6              
1001312c  480002c0    b 0x100133ec                   ; -> 100133ec
10013130  7fe70734    extsh r7,r31                
10013134  1ce70070    mulli r7,r7,0x70            
10013138  38e7001f    addi r7,r7,0x1f             
1001313c  7cfe38ae    lbzx r7,r30,r7              
10013140  28070000    cmplwi r7,0x0               
10013144  4082001c    bne 0x10013160                 ; -> 10013160
10013148  7fe80734    extsh r8,r31                
1001314c  1d080070    mulli r8,r8,0x70            
10013150  7d1e42ae    lhax r8,r30,r8              
10013154  550807bc    rlwinm r8,r8,0x0,0x1e,0x1e  
10013158  2c080000    cmpwi r8,0x0                
1001315c  41820210    beq 0x1001336c                 ; -> 1001336c
10013160  7fe3fb78    or r3,r31,r31               
10013164  4bfff565    bl 0x100126c8                  ; -> 100126c8
10013168  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1001316c  28030000    cmplwi r3,0x0               
10013170  41820074    beq 0x100131e4                 ; -> 100131e4
10013174  7fe90734    extsh r9,r31                
10013178  1d290070    mulli r9,r9,0x70            
1001317c  7feb0734    extsh r11,r31               
10013180  7d5e4aae    lhax r10,r30,r9             
10013184  7fec0734    extsh r12,r31               
10013188  1d8c0070    mulli r12,r12,0x70          
1001318c  7fe30734    extsh r3,r31                
10013190  394afffe    subi r10,r10,0x2            
10013194  1c630070    mulli r3,r3,0x70            
10013198  1d6b0070    mulli r11,r11,0x70          
1001319c  7d5e4b2e    sthx r10,r30,r9             
100131a0  7d7e5aae    lhax r11,r30,r11            
100131a4  398c0002    addi r12,r12,0x2            
100131a8  556b043a    rlwinm r11,r11,0x0,0x10,0x1d
100131ac  7d7e632e    sthx r11,r30,r12            
100131b0  3863000e    addi r3,r3,0xe              
100131b4  7c9e1aae    lhax r4,r30,r3              
100131b8  38840001    addi r4,r4,0x1              
100131bc  7c9e1b2e    sthx r4,r30,r3              
100131c0  7c840734    extsh r4,r4                 
100131c4  2c040019    cmpwi r4,0x19               
100131c8  41800168    blt 0x10013330                 ; -> 10013330
100131cc  7fe60734    extsh r6,r31                
100131d0  1cc60070    mulli r6,r6,0x70            
100131d4  38a00001    li r5,0x1                   
100131d8  38c6000e    addi r6,r6,0xe              
100131dc  7cbe332e    sthx r5,r30,r6              
100131e0  48000150    b 0x10013330                   ; -> 10013330
100131e4  7fe70734    extsh r7,r31                
100131e8  1ce70070    mulli r7,r7,0x70            
100131ec  38e7001f    addi r7,r7,0x1f             
100131f0  7cfe38ae    lbzx r7,r30,r7              
100131f4  28070000    cmplwi r7,0x0               
100131f8  40820074    bne 0x1001326c                 ; -> 1001326c
100131fc  7fe80734    extsh r8,r31                
10013200  1d080070    mulli r8,r8,0x70            
10013204  7fea0734    extsh r10,r31               
10013208  7d3e42ae    lhax r9,r30,r8              
1001320c  7feb0734    extsh r11,r31               
10013210  1d6b0070    mulli r11,r11,0x70          
10013214  7fec0734    extsh r12,r31               
10013218  39290002    addi r9,r9,0x2              
1001321c  1d8c0070    mulli r12,r12,0x70          
10013220  1d4a0070    mulli r10,r10,0x70          
10013224  7d3e432e    sthx r9,r30,r8              
10013228  7d5e52ae    lhax r10,r30,r10            
1001322c  396b0002    addi r11,r11,0x2            
10013230  554a043a    rlwinm r10,r10,0x0,0x10,0x1d
10013234  7d5e5b2e    sthx r10,r30,r11            
10013238  398c000e    addi r12,r12,0xe            
1001323c  7c7e62ae    lhax r3,r30,r12             
10013240  38630001    addi r3,r3,0x1              
10013244  7c7e632e    sthx r3,r30,r12             
10013248  7c630734    extsh r3,r3                 
1001324c  2c030019    cmpwi r3,0x19               
10013250  418000e0    blt 0x10013330                 ; -> 10013330
10013254  7fe50734    extsh r5,r31                
10013258  1ca50070    mulli r5,r5,0x70            
1001325c  38800001    li r4,0x1                   
10013260  38a5000e    addi r5,r5,0xe              
10013264  7c9e2b2e    sthx r4,r30,r5              
10013268  480000c8    b 0x10013330                   ; -> 10013330
1001326c  7fe60734    extsh r6,r31                
10013270  1cc60070    mulli r6,r6,0x70            
10013274  7fe70734    extsh r7,r31                
10013278  1ce70070    mulli r7,r7,0x70            
1001327c  7fe80734    extsh r8,r31                
10013280  1d080070    mulli r8,r8,0x70            
10013284  7cde32ae    lhax r6,r30,r6              
10013288  38e70002    addi r7,r7,0x2              
1001328c  54c6043a    rlwinm r6,r6,0x0,0x10,0x1d  
10013290  7cde3b2e    sthx r6,r30,r7              
10013294  39080032    addi r8,r8,0x32             
10013298  7d1e42ae    lhax r8,r30,r8              
1001329c  2c080000    cmpwi r8,0x0                
100132a0  41820090    beq 0x10013330                 ; -> 10013330
100132a4  7fe90734    extsh r9,r31                
100132a8  1d290070    mulli r9,r9,0x70            
100132ac  39290032    addi r9,r9,0x32             
100132b0  7d3e4aae    lhax r9,r30,r9              
100132b4  552907fe    rlwinm r9,r9,0x0,0x1f,0x1f  
100132b8  2c090000    cmpwi r9,0x0                
100132bc  41820074    beq 0x10013330                 ; -> 10013330
100132c0  7fea0734    extsh r10,r31               
100132c4  1d4a0070    mulli r10,r10,0x70          
100132c8  394a000e    addi r10,r10,0xe            
100132cc  7d7e52ae    lhax r11,r30,r10            
100132d0  396b0001    addi r11,r11,0x1            
100132d4  7d7e532e    sthx r11,r30,r10            
100132d8  7d6b0734    extsh r11,r11               
100132dc  2c0b0019    cmpwi r11,0x19              
100132e0  41800018    blt 0x100132f8                 ; -> 100132f8
100132e4  7fe30734    extsh r3,r31                
100132e8  1c630070    mulli r3,r3,0x70            
100132ec  39800001    li r12,0x1                  
100132f0  3863000e    addi r3,r3,0xe              
100132f4  7d9e1b2e    sthx r12,r30,r3             
100132f8  7fe40734    extsh r4,r31                
100132fc  1c840070    mulli r4,r4,0x70            
10013300  3884000e    addi r4,r4,0xe              
10013304  7cbe22ae    lhax r5,r30,r4              
10013308  38a50001    addi r5,r5,0x1              
1001330c  7cbe232e    sthx r5,r30,r4              
10013310  7ca50734    extsh r5,r5                 
10013314  2c050019    cmpwi r5,0x19               
10013318  41800018    blt 0x10013330                 ; -> 10013330
1001331c  7fe70734    extsh r7,r31                
10013320  1ce70070    mulli r7,r7,0x70            
10013324  38c00001    li r6,0x1                   
10013328  38e7000e    addi r7,r7,0xe              
1001332c  7cde3b2e    sthx r6,r30,r7              
10013330  7fe80734    extsh r8,r31                
10013334  1d080070    mulli r8,r8,0x70            
10013338  39080032    addi r8,r8,0x32             
1001333c  7fec0734    extsh r12,r31               
10013340  7d3e42ae    lhax r9,r30,r8              
10013344  1d8c0070    mulli r12,r12,0x70          
10013348  39290001    addi r9,r9,0x1              
1001334c  7feb0734    extsh r11,r31               
10013350  39426bc4    addi r10,r2,0x6bc4          
10013354  7d3e432e    sthx r9,r30,r8              
10013358  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1001335c  7d4a582e    lwzx r10,r10,r11            
10013360  398c0006    addi r12,r12,0x6            
10013364  7d5e612e    stwx r10,r30,r12            
10013368  48000084    b 0x100133ec                   ; -> 100133ec
1001336c  7fe30734    extsh r3,r31                
10013370  1c630070    mulli r3,r3,0x70            
10013374  3863001e    addi r3,r3,0x1e             
10013378  7c7e18ae    lbzx r3,r30,r3              
1001337c  28030000    cmplwi r3,0x0               
10013380  41820044    beq 0x100133c4                 ; -> 100133c4
10013384  7fe50734    extsh r5,r31                
10013388  1ca50070    mulli r5,r5,0x70            
1001338c  7fe70734    extsh r7,r31                
10013390  1ce70070    mulli r7,r7,0x70            
10013394  7fe90734    extsh r9,r31                
10013398  1d290070    mulli r9,r9,0x70            
1001339c  3880000b    li r4,0xb                   
100133a0  38a5001c    addi r5,r5,0x1c             
100133a4  7c9e2b2e    sthx r4,r30,r5              
100133a8  38c00000    li r6,0x0                   
100133ac  38e70032    addi r7,r7,0x32             
100133b0  7cde3b2e    sthx r6,r30,r7              
100133b4  39000001    li r8,0x1                   
100133b8  39290034    addi r9,r9,0x34             
100133bc  7d1e4b2e    sthx r8,r30,r9              
100133c0  4800002c    b 0x100133ec                   ; -> 100133ec
100133c4  7feb0734    extsh r11,r31               
100133c8  1d6b0070    mulli r11,r11,0x70          
100133cc  7fe30734    extsh r3,r31                
100133d0  1c630070    mulli r3,r3,0x70            
100133d4  3940000c    li r10,0xc                  
100133d8  396b001c    addi r11,r11,0x1c           
100133dc  7d5e5b2e    sthx r10,r30,r11            
100133e0  39800000    li r12,0x0                  
100133e4  38630032    addi r3,r3,0x32             
100133e8  7d9e1b2e    sthx r12,r30,r3             
100133ec  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
100133f0  38210040    addi r1,r1,0x40             
100133f4  7c0803a6    mtspr LR,r0                 
100133f8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100133fc  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10013400  4e800020    blr                         
