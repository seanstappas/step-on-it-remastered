; FUN_10011fcc @ 0x10011fcc
10011fcc  7c0802a6    mfspr r0,LR                 
10011fd0  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10011fd4  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10011fd8  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10011fdc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10011fe0  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10011fe4  7c7f1b78    or r31,r3,r3                
10011fe8  7fe30734    extsh r3,r31                
10011fec  1c630070    mulli r3,r3,0x70            
10011ff0  3bc26840    addi r30,r2,0x6840          
10011ff4  38630028    addi r3,r3,0x28             
10011ff8  7c7e18ae    lbzx r3,r30,r3              
10011ffc  28030001    cmplwi r3,0x1               
10012000  4082020c    bne 0x1001220c                 ; -> 1001220c
10012004  7fe60734    extsh r6,r31                
10012008  1cc60070    mulli r6,r6,0x70            
1001200c  7fe70734    extsh r7,r31                
10012010  1ce70070    mulli r7,r7,0x70            
10012014  7fe50734    extsh r5,r31                
10012018  7fea0734    extsh r10,r31               
1001201c  1d4a0070    mulli r10,r10,0x70          
10012020  7feb0734    extsh r11,r31               
10012024  1d6b0070    mulli r11,r11,0x70          
10012028  7fec0734    extsh r12,r31               
1001202c  7fe30734    extsh r3,r31                
10012030  1d8c0070    mulli r12,r12,0x70          
10012034  1c630070    mulli r3,r3,0x70            
10012038  38826bc4    addi r4,r2,0x6bc4           
1001203c  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
10012040  7c84282e    lwzx r4,r4,r5               
10012044  38c60006    addi r6,r6,0x6              
10012048  7fe50734    extsh r5,r31                
1001204c  1ca50070    mulli r5,r5,0x70            
10012050  7c9e312e    stwx r4,r30,r6              
10012054  38e70032    addi r7,r7,0x32             
10012058  7d1e3aae    lhax r8,r30,r7              
1001205c  39200000    li r9,0x0                   
10012060  39080001    addi r8,r8,0x1              
10012064  7d1e3b2e    sthx r8,r30,r7              
10012068  394a0022    addi r10,r10,0x22           
1001206c  7d3e51ae    stbx r9,r30,r10             
10012070  396b0021    addi r11,r11,0x21           
10012074  7d3e59ae    stbx r9,r30,r11             
10012078  398c002e    addi r12,r12,0x2e           
1001207c  3863000e    addi r3,r3,0xe              
10012080  7d9e62ae    lhax r12,r30,r12            
10012084  7c9e1aae    lhax r4,r30,r3              
10012088  38a5000e    addi r5,r5,0xe              
1001208c  7c846214    add r4,r4,r12               
10012090  7c9e1b2e    sthx r4,r30,r3              
10012094  7cbe2aae    lhax r5,r30,r5              
10012098  2c05007d    cmpwi r5,0x7d               
1001209c  40810030    ble 0x100120cc                 ; -> 100120cc
100120a0  7fe70734    extsh r7,r31                
100120a4  1ce70070    mulli r7,r7,0x70            
100120a8  7fe90734    extsh r9,r31                
100120ac  1d290070    mulli r9,r9,0x70            
100120b0  38c0007c    li r6,0x7c                  
100120b4  38e7000e    addi r7,r7,0xe              
100120b8  7cde3b2e    sthx r6,r30,r7              
100120bc  3900ffff    li r8,-0x1                  
100120c0  3929002e    addi r9,r9,0x2e             
100120c4  7d1e4b2e    sthx r8,r30,r9              
100120c8  48000044    b 0x1001210c                   ; -> 1001210c
100120cc  7fea0734    extsh r10,r31               
100120d0  1d4a0070    mulli r10,r10,0x70          
100120d4  394a000e    addi r10,r10,0xe            
100120d8  7d5e52ae    lhax r10,r30,r10            
100120dc  2c0a0075    cmpwi r10,0x75              
100120e0  4080002c    bge 0x1001210c                 ; -> 1001210c
100120e4  7fec0734    extsh r12,r31               
100120e8  1d8c0070    mulli r12,r12,0x70          
100120ec  7fe40734    extsh r4,r31                
100120f0  1c840070    mulli r4,r4,0x70            
100120f4  39600076    li r11,0x76                 
100120f8  398c000e    addi r12,r12,0xe            
100120fc  7d7e632e    sthx r11,r30,r12            
10012100  38600001    li r3,0x1                   
10012104  3884002e    addi r4,r4,0x2e             
10012108  7c7e232e    sthx r3,r30,r4              
1001210c  7fe70734    extsh r7,r31                
10012110  7fe80734    extsh r8,r31                
10012114  1ce70070    mulli r7,r7,0x70            
10012118  1d080070    mulli r8,r8,0x70            
1001211c  7fe60734    extsh r6,r31                
10012120  7fe50734    extsh r5,r31                
10012124  1cc60070    mulli r6,r6,0x70            
10012128  1ca50070    mulli r5,r5,0x70            
1001212c  38e70032    addi r7,r7,0x32             
10012130  39080032    addi r8,r8,0x32             
10012134  38c60032    addi r6,r6,0x32             
10012138  38a50034    addi r5,r5,0x34             
1001213c  7cde32ae    lhax r6,r30,r6              
10012140  7cbe2aae    lhax r5,r30,r5              
10012144  7cfe3aae    lhax r7,r30,r7              
10012148  7d1e42ae    lhax r8,r30,r8              
1001214c  1cc6ffe2    mulli r6,r6,-0x1e           
10012150  7ce839d6    mullw r7,r8,r7              
10012154  7ce70e70    srawi r7,r7,0x1             
10012158  7ce70194    addze r7,r7                 
1001215c  1ca5000a    mulli r5,r5,0xa             
10012160  7cc63a14    add r6,r6,r7                
10012164  7ca53214    add r5,r5,r6                
10012168  3920000a    li r9,0xa                   
1001216c  7fa54bd6    divw r29,r5,r9              
10012170  7faa0734    extsh r10,r29               
10012174  2c0a0030    cmpwi r10,0x30              
10012178  40800008    bge 0x10012180                 ; -> 10012180
1001217c  3ba00030    li r29,0x30                 
10012180  7fab0734    extsh r11,r29               
10012184  2c0b01bd    cmpwi r11,0x1bd             
10012188  40810074    ble 0x100121fc                 ; -> 100121fc
1001218c  7fe30734    extsh r3,r31                
10012190  1c630070    mulli r3,r3,0x70            
10012194  39800001    li r12,0x1                  
10012198  3863003a    addi r3,r3,0x3a             
1001219c  7d9e19ae    stbx r12,r30,r3             
100121a0  480167b9    bl 0x10028958                  ; -> 10028958
100121a4  60000000    ori r0,r0,0x0               
100121a8  7fe40734    extsh r4,r31                
100121ac  1c840070    mulli r4,r4,0x70            
100121b0  7fe50734    extsh r5,r31                
100121b4  1ca50070    mulli r5,r5,0x70            
100121b8  7fe60734    extsh r6,r31                
100121bc  1cc60070    mulli r6,r6,0x70            
100121c0  3884000a    addi r4,r4,0xa              
100121c4  7fe70734    extsh r7,r31                
100121c8  1ce70070    mulli r7,r7,0x70            
100121cc  7c7e202e    lwzx r3,r30,r4              
100121d0  38a50018    addi r5,r5,0x18             
100121d4  7c9e2aae    lhax r4,r30,r5              
100121d8  38c60014    addi r6,r6,0x14             
100121dc  7cbe32ae    lhax r5,r30,r6              
100121e0  38e70016    addi r7,r7,0x16             
100121e4  7cde3aae    lhax r6,r30,r7              
100121e8  4bff2ac9    bl 0x10004cb0                  ; -> 10004cb0
100121ec  60000000    ori r0,r0,0x0               
100121f0  480167d1    bl 0x100289c0                  ; -> 100289c0
100121f4  60000000    ori r0,r0,0x0               
100121f8  48000014    b 0x1001220c                   ; -> 1001220c
100121fc  7fe80734    extsh r8,r31                
10012200  1d080070    mulli r8,r8,0x70            
10012204  39080004    addi r8,r8,0x4              
10012208  7fbe432e    sthx r29,r30,r8             
1001220c  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10012210  38210050    addi r1,r1,0x50             
10012214  7c0803a6    mtspr LR,r0                 
10012218  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001221c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10012220  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10012224  4e800020    blr                         
