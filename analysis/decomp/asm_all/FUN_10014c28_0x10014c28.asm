; FUN_10014c28 @ 0x10014c28
10014c28  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10014c2c  7c650734    extsh r5,r3                 
10014c30  1ca50070    mulli r5,r5,0x70            
10014c34  7c670734    extsh r7,r3                 
10014c38  1ce70070    mulli r7,r7,0x70            
10014c3c  7c690734    extsh r9,r3                 
10014c40  1d290070    mulli r9,r9,0x70            
10014c44  7c6b0734    extsh r11,r3                
10014c48  1d6b0070    mulli r11,r11,0x70          
10014c4c  7c6c0734    extsh r12,r3                
10014c50  1d8c0070    mulli r12,r12,0x70          
10014c54  3be26840    addi r31,r2,0x6840          
10014c58  3880001e    li r4,0x1e                  
10014c5c  38a50064    addi r5,r5,0x64             
10014c60  7c9f2b2e    sthx r4,r31,r5              
10014c64  38c00001    li r6,0x1                   
10014c68  38e70062    addi r7,r7,0x62             
10014c6c  7cdf3b2e    sthx r6,r31,r7              
10014c70  39000258    li r8,0x258                 
10014c74  3929006e    addi r9,r9,0x6e             
10014c78  39426bac    addi r10,r2,0x6bac          
10014c7c  7d1f4b2e    sthx r8,r31,r9              
10014c80  814a0000    lwz r10,0x0(r10)            
10014c84  396b006a    addi r11,r11,0x6a           
10014c88  7d5f592e    stwx r10,r31,r11            
10014c8c  398c005c    addi r12,r12,0x5c           
10014c90  7d9f62ae    lhax r12,r31,r12            
10014c94  2c0c0000    cmpwi r12,0x0               
10014c98  40820018    bne 0x10014cb0                 ; -> 10014cb0
10014c9c  7c650734    extsh r5,r3                 
10014ca0  1ca50070    mulli r5,r5,0x70            
10014ca4  38800000    li r4,0x0                   
10014ca8  38a50060    addi r5,r5,0x60             
10014cac  7c9f2b2e    sthx r4,r31,r5              
10014cb0  7c670734    extsh r7,r3                 
10014cb4  1ce70070    mulli r7,r7,0x70            
10014cb8  38c00002    li r6,0x2                   
10014cbc  38e7005c    addi r7,r7,0x5c             
10014cc0  7cdf3b2e    sthx r6,r31,r7              
10014cc4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10014cc8  4e800020    blr                         
