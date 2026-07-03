; FUN_1002b708 @ 0x1002b708
1002b708  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002b70c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002b710  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1002b714  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1002b718  3b827134    addi r28,r2,0x7134          
1002b71c  3ba26bf8    addi r29,r2,0x6bf8          
1002b720  3bc00001    li r30,0x1                  
1002b724  4800005c    b 0x1002b780                   ; -> 1002b780
1002b728  3be00001    li r31,0x1                  
1002b72c  48000044    b 0x1002b770                   ; -> 1002b770
1002b730  7fe30734    extsh r3,r31                
1002b734  7fe50734    extsh r5,r31                
1002b738  3863ffff    subi r3,r3,0x1              
1002b73c  7fc40734    extsh r4,r30                
1002b740  3884ffff    subi r4,r4,0x1              
1002b744  7fc60734    extsh r6,r30                
1002b748  1c630034    mulli r3,r3,0x34            
1002b74c  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
1002b750  7c632214    add r3,r3,r4                
1002b754  38630018    addi r3,r3,0x18             
1002b758  1ca5003c    mulli r5,r5,0x3c            
1002b75c  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1002b760  7c7c182e    lwzx r3,r28,r3              
1002b764  7ca53214    add r5,r5,r6                
1002b768  7c7d292e    stwx r3,r29,r5              
1002b76c  3bff0001    addi r31,r31,0x1            
1002b770  7fe70734    extsh r7,r31                
1002b774  2c070013    cmpwi r7,0x13               
1002b778  4081ffb8    ble 0x1002b730                 ; -> 1002b730
1002b77c  3bde0001    addi r30,r30,0x1            
1002b780  7fc80734    extsh r8,r30                
1002b784  2c08000d    cmpwi r8,0xd                
1002b788  4081ffa0    ble 0x1002b728                 ; -> 1002b728
1002b78c  3bc00000    li r30,0x0                  
1002b790  48000028    b 0x1002b7b8                   ; -> 1002b7b8
1002b794  7fca0734    extsh r10,r30               
1002b798  7fcb0734    extsh r11,r30               
1002b79c  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
1002b7a0  39200300    li r9,0x300                 
1002b7a4  394a04b0    addi r10,r10,0x4b0          
1002b7a8  7d3d512e    stwx r9,r29,r10             
1002b7ac  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
1002b7b0  7d3d592e    stwx r9,r29,r11             
1002b7b4  3bde0001    addi r30,r30,0x1            
1002b7b8  7fcc0734    extsh r12,r30               
1002b7bc  2c0c000e    cmpwi r12,0xe               
1002b7c0  4081ffd4    ble 0x1002b794                 ; -> 1002b794
1002b7c4  3be00001    li r31,0x1                  
1002b7c8  48000028    b 0x1002b7f0                   ; -> 1002b7f0
1002b7cc  7fe40734    extsh r4,r31                
1002b7d0  7fe50734    extsh r5,r31                
1002b7d4  1c84003c    mulli r4,r4,0x3c            
1002b7d8  1ca5003c    mulli r5,r5,0x3c            
1002b7dc  38600300    li r3,0x300                 
1002b7e0  38840038    addi r4,r4,0x38             
1002b7e4  7c7d212e    stwx r3,r29,r4              
1002b7e8  7c7d292e    stwx r3,r29,r5              
1002b7ec  3bff0001    addi r31,r31,0x1            
1002b7f0  7fe60734    extsh r6,r31                
1002b7f4  2c060013    cmpwi r6,0x13               
1002b7f8  4081ffd4    ble 0x1002b7cc                 ; -> 1002b7cc
1002b7fc  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002b800  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002b804  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1002b808  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1002b80c  4e800020    blr                         
