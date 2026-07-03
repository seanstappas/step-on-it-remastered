; FUN_10020d74 @ 0x10020d74
10020d74  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10020d78  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10020d7c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10020d80  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10020d84  38824fe5    addi r4,r2,0x4fe5           
10020d88  38600000    li r3,0x0                   
10020d8c  98640000    stb r3,0x0(r4)              
10020d90  38c24fe4    addi r6,r2,0x4fe4           
10020d94  38a00000    li r5,0x0                   
10020d98  98a60000    stb r5,0x0(r6)              
10020d9c  390251e6    addi r8,r2,0x51e6           
10020da0  38e00000    li r7,0x0                   
10020da4  98e80000    stb r7,0x0(r8)              
10020da8  39424edc    addi r10,r2,0x4edc          
10020dac  39200200    li r9,0x200                 
10020db0  b12a0000    sth r9,0x0(r10)             
10020db4  39824f4c    addi r12,r2,0x4f4c          
10020db8  39600003    li r11,0x3                  
10020dbc  916c0000    stw r11,0x0(r12)            
10020dc0  38827100    addi r4,r2,0x7100           
10020dc4  3860000e    li r3,0xe                   
10020dc8  90640016    stw r3,0x16(r4)             
10020dcc  38c2342e    addi r6,r2,0x342e           
10020dd0  38a00001    li r5,0x1                   
10020dd4  98a60000    stb r5,0x0(r6)              
10020dd8  3902523d    addi r8,r2,0x523d           
10020ddc  38e00000    li r7,0x0                   
10020de0  98e80000    stb r7,0x0(r8)              
10020de4  3b826996    addi r28,r2,0x6996          
10020de8  39202600    li r9,0x2600                
10020dec  913c001c    stw r9,0x1c(r28)            
10020df0  39402500    li r10,0x2500               
10020df4  915c0020    stw r10,0x20(r28)           
10020df8  39602200    li r11,0x2200               
10020dfc  917c0024    stw r11,0x24(r28)           
10020e00  39800000    li r12,0x0                  
10020e04  919c0028    stw r12,0x28(r28)           
10020e08  38600600    li r3,0x600                 
10020e0c  907c002c    stw r3,0x2c(r28)            
10020e10  38800100    li r4,0x100                 
10020e14  909c0030    stw r4,0x30(r28)            
10020e18  38a00700    li r5,0x700                 
10020e1c  90bc0034    stw r5,0x34(r28)            
10020e20  38c05300    li r6,0x5300                
10020e24  90dc0038    stw r6,0x38(r28)            
10020e28  38e05500    li r7,0x5500                
10020e2c  90fc003c    stw r7,0x3c(r28)            
10020e30  39005700    li r8,0x5700                
10020e34  911c0040    stw r8,0x40(r28)            
10020e38  39207300    li r9,0x7300                
10020e3c  913c0044    stw r9,0x44(r28)            
10020e40  39407700    li r10,0x7700               
10020e44  915c0048    stw r10,0x48(r28)           
10020e48  39607400    li r11,0x7400               
10020e4c  3bc25612    addi r30,r2,0x5612          
10020e50  917c004c    stw r11,0x4c(r28)           
10020e54  39807900    li r12,0x7900               
10020e58  919c0050    stw r12,0x50(r28)           
10020e5c  3be00001    li r31,0x1                  
10020e60  48000030    b 0x10020e90                   ; -> 10020e90
10020e64  7fe30734    extsh r3,r31                
10020e68  7fe60734    extsh r6,r31                
10020e6c  1c630104    mulli r3,r3,0x104           
10020e70  1cc60104    mulli r6,r6,0x104           
10020e74  7fbe1a14    add r29,r30,r3              
10020e78  38800000    li r4,0x0                   
10020e7c  989d0000    stb r4,0x0(r29)             
10020e80  38a01388    li r5,0x1388                
10020e84  38c60100    addi r6,r6,0x100            
10020e88  7cbe312e    stwx r5,r30,r6              
10020e8c  3bff0001    addi r31,r31,0x1            
10020e90  7fe70734    extsh r7,r31                
10020e94  2c07000b    cmpwi r7,0xb                
10020e98  4180ffcc    blt 0x10020e64                 ; -> 10020e64
10020e9c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10020ea0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10020ea4  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10020ea8  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10020eac  4e800020    blr                         
