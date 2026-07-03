; FUN_1000b7dc @ 0x1000b7dc
1000b7dc  7c0802a6    mfspr r0,LR                 
1000b7e0  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
1000b7e4  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000b7e8  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000b7ec  7c7d1b78    or r29,r3,r3                
1000b7f0  7c9c2378    or r28,r4,r4                
1000b7f4  3b6261a4    addi r27,r2,0x61a4          
1000b7f8  3bc23cd8    addi r30,r2,0x3cd8          
1000b7fc  7fa3eb78    or r3,r29,r29               
1000b800  7f84e378    or r4,r28,r28               
1000b804  4802140d    bl 0x1002cc10                  ; -> 1002cc10
1000b808  60000000    ori r0,r0,0x0               
1000b80c  3862711e    addi r3,r2,0x711e           
1000b810  a8630000    lha r3,0x0(r3)              
1000b814  3863fffb    subi r3,r3,0x5              
1000b818  2803000e    cmplwi r3,0xe               
1000b81c  4181064c    bgt 0x1000be68                 ; -> 1000be68
1000b820  38820440    addi r4,r2,0x440            
1000b824  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1000b828  7c84182e    lwzx r4,r4,r3               
1000b82c  7c8903a6    mtspr CTR,r4                
1000b830  4e800420    bctr                        
1000be68  4bff9ae1    bl 0x10005948                  ; -> 10005948
1000be6c  60000000    ori r0,r0,0x0               
1000be70  7c7f1b78    or r31,r3,r3                
1000be74  7fa3eb78    or r3,r29,r29               
1000be78  48022835    bl 0x1002e6ac                  ; -> 1002e6ac
1000be7c  60000000    ori r0,r0,0x0               
1000be80  7c7a1b78    or r26,r3,r3                
1000be84  7f43d378    or r3,r26,r26               
1000be88  4bff961d    bl 0x100054a4                  ; -> 100054a4
1000be8c  60000000    ori r0,r0,0x0               
1000be90  7fec0734    extsh r12,r31               
1000be94  1d8c0046    mulli r12,r12,0x46          
1000be98  398c0004    addi r12,r12,0x4            
1000be9c  7c7e632e    sthx r3,r30,r12             
1000bea0  7fa3eb78    or r3,r29,r29               
1000bea4  48022809    bl 0x1002e6ac                  ; -> 1002e6ac
1000bea8  60000000    ori r0,r0,0x0               
1000beac  7ffa0734    extsh r26,r31               
1000beb0  1f5a0046    mulli r26,r26,0x46          
1000beb4  3b5a0010    addi r26,r26,0x10           
1000beb8  7c7ed32e    sthx r3,r30,r26             
1000bebc  7f83e378    or r3,r28,r28               
1000bec0  480227fd    bl 0x1002e6bc                  ; -> 1002e6bc
1000bec4  60000000    ori r0,r0,0x0               
1000bec8  7fe40734    extsh r4,r31                
1000becc  1c840046    mulli r4,r4,0x46            
1000bed0  7fe60734    extsh r6,r31                
1000bed4  1cc60046    mulli r6,r6,0x46            
1000bed8  7fe80734    extsh r8,r31                
1000bedc  1d080046    mulli r8,r8,0x46            
1000bee0  7fea0734    extsh r10,r31               
1000bee4  1d4a0046    mulli r10,r10,0x46          
1000bee8  7fec0734    extsh r12,r31               
1000beec  1d8c0046    mulli r12,r12,0x46          
1000bef0  38630002    addi r3,r3,0x2              
1000bef4  38840012    addi r4,r4,0x12             
1000bef8  7c7e232e    sthx r3,r30,r4              
1000befc  7fe30734    extsh r3,r31                
1000bf00  1c630046    mulli r3,r3,0x46            
1000bf04  38a00076    li r5,0x76                  
1000bf08  38c60002    addi r6,r6,0x2              
1000bf0c  7cbe332e    sthx r5,r30,r6              
1000bf10  80fb0048    lwz r7,0x48(r27)            
1000bf14  3908000a    addi r8,r8,0xa              
1000bf18  7cfe412e    stwx r7,r30,r8              
1000bf1c  39200000    li r9,0x0                   
1000bf20  394a0014    addi r10,r10,0x14           
1000bf24  7d3e512e    stwx r9,r30,r10             
1000bf28  39600000    li r11,0x0                  
1000bf2c  398c001e    addi r12,r12,0x1e           
1000bf30  7d7e61ae    stbx r11,r30,r12            
1000bf34  3b400190    li r26,0x190                
1000bf38  3863002c    addi r3,r3,0x2c             
1000bf3c  7f5e1b2e    sthx r26,r30,r3             
1000bf40  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000bf44  38210050    addi r1,r1,0x50             
1000bf48  7c0803a6    mtspr LR,r0                 
1000bf4c  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
1000bf50  4e800020    blr                         
