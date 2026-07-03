; FUN_10003828 @ 0x10003828
10003828  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000382c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10003830  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10003834  38823702    addi r4,r2,0x3702           
10003838  38600000    li r3,0x0                   
1000383c  3ba23704    addi r29,r2,0x3704          
10003840  3bc2372e    addi r30,r2,0x372e          
10003844  b0640000    sth r3,0x0(r4)              
10003848  3be00000    li r31,0x0                  
1000384c  4800001c    b 0x10003868                   ; -> 10003868
10003850  7fe60734    extsh r6,r31                
10003854  1cc60014    mulli r6,r6,0x14            
10003858  38bf0001    addi r5,r31,0x1             
1000385c  38c60002    addi r6,r6,0x2              
10003860  7cbe332e    sthx r5,r30,r6              
10003864  3bff0001    addi r31,r31,0x1            
10003868  7fe70734    extsh r7,r31                
1000386c  2c07003c    cmpwi r7,0x3c               
10003870  4180ffe0    blt 0x10003850                 ; -> 10003850
10003874  3900ffff    li r8,-0x1                  
10003878  b11e049e    sth r8,0x49e(r30)           
1000387c  3be00000    li r31,0x0                  
10003880  48000018    b 0x10003898                   ; -> 10003898
10003884  7fea0734    extsh r10,r31               
10003888  3920ffff    li r9,-0x1                  
1000388c  554a083c    rlwinm r10,r10,0x1,0x0,0x1e 
10003890  7d3d532e    sthx r9,r29,r10             
10003894  3bff0001    addi r31,r31,0x1            
10003898  7feb0734    extsh r11,r31               
1000389c  2c0b0013    cmpwi r11,0x13              
100038a0  4081ffe4    ble 0x10003884                 ; -> 10003884
100038a4  3980ffff    li r12,-0x1                 
100038a8  388233b4    addi r4,r2,0x33b4           
100038ac  b19d0028    sth r12,0x28(r29)           
100038b0  38600000    li r3,0x0                   
100038b4  b0640000    sth r3,0x0(r4)              
100038b8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100038bc  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100038c0  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100038c4  4e800020    blr                         
