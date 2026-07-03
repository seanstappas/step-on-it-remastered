; FUN_10024d5c @ 0x10024d5c
10024d5c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10024d60  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10024d64  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10024d68  3ba26996    addi r29,r2,0x6996          
10024d6c  3bc26140    addi r30,r2,0x6140          
10024d70  3be00001    li r31,0x1                  
10024d74  480000e0    b 0x10024e54                   ; -> 10024e54
10024d78  7fe30734    extsh r3,r31                
10024d7c  1c63001c    mulli r3,r3,0x1c            
10024d80  7fe40734    extsh r4,r31                
10024d84  7fe50734    extsh r5,r31                
10024d88  1ca5001c    mulli r5,r5,0x1c            
10024d8c  7fe60734    extsh r6,r31                
10024d90  1cc6001c    mulli r6,r6,0x1c            
10024d94  7fe70734    extsh r7,r31                
10024d98  1ce7001c    mulli r7,r7,0x1c            
10024d9c  7fe80734    extsh r8,r31                
10024da0  1d08001c    mulli r8,r8,0x1c            
10024da4  7fe90734    extsh r9,r31                
10024da8  1d29001c    mulli r9,r9,0x1c            
10024dac  7fea0734    extsh r10,r31               
10024db0  1d4a001c    mulli r10,r10,0x1c          
10024db4  7feb0734    extsh r11,r31               
10024db8  1d6b001c    mulli r11,r11,0x1c          
10024dbc  7fec0734    extsh r12,r31               
10024dc0  1d8c001c    mulli r12,r12,0x1c          
10024dc4  1c84001c    mulli r4,r4,0x1c            
10024dc8  7c7d182e    lwzx r3,r29,r3              
10024dcc  38a50004    addi r5,r5,0x4              
10024dd0  7c7e212e    stwx r3,r30,r4              
10024dd4  7fe30734    extsh r3,r31                
10024dd8  1c63001c    mulli r3,r3,0x1c            
10024ddc  7fe40734    extsh r4,r31                
10024de0  1c84001c    mulli r4,r4,0x1c            
10024de4  7cbd282e    lwzx r5,r29,r5              
10024de8  38c60004    addi r6,r6,0x4              
10024dec  7cbe312e    stwx r5,r30,r6              
10024df0  38e70008    addi r7,r7,0x8              
10024df4  7fe50734    extsh r5,r31                
10024df8  7fe60734    extsh r6,r31                
10024dfc  1ca5001c    mulli r5,r5,0x1c            
10024e00  1cc6001c    mulli r6,r6,0x1c            
10024e04  7cfd382e    lwzx r7,r29,r7              
10024e08  39080008    addi r8,r8,0x8              
10024e0c  7cfe412e    stwx r7,r30,r8              
10024e10  3929000c    addi r9,r9,0xc              
10024e14  7d3d482e    lwzx r9,r29,r9              
10024e18  394a000c    addi r10,r10,0xc            
10024e1c  7d3e512e    stwx r9,r30,r10             
10024e20  396b0010    addi r11,r11,0x10           
10024e24  7d7d582e    lwzx r11,r29,r11            
10024e28  398c0010    addi r12,r12,0x10           
10024e2c  7d7e612e    stwx r11,r30,r12            
10024e30  38630014    addi r3,r3,0x14             
10024e34  7c7d182e    lwzx r3,r29,r3              
10024e38  38840014    addi r4,r4,0x14             
10024e3c  7c7e212e    stwx r3,r30,r4              
10024e40  38a50018    addi r5,r5,0x18             
10024e44  7cbd282e    lwzx r5,r29,r5              
10024e48  38c60018    addi r6,r6,0x18             
10024e4c  7cbe312e    stwx r5,r30,r6              
10024e50  3bff0001    addi r31,r31,0x1            
10024e54  7fe70734    extsh r7,r31                
10024e58  2c070003    cmpwi r7,0x3                
10024e5c  4180ff1c    blt 0x10024d78                 ; -> 10024d78
10024e60  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10024e64  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10024e68  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10024e6c  4e800020    blr                         
