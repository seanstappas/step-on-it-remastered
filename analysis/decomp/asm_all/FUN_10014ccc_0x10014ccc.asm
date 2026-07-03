; FUN_10014ccc @ 0x10014ccc
10014ccc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10014cd0  7c650734    extsh r5,r3                 
10014cd4  1ca50070    mulli r5,r5,0x70            
10014cd8  7c670734    extsh r7,r3                 
10014cdc  1ce70070    mulli r7,r7,0x70            
10014ce0  7c690734    extsh r9,r3                 
10014ce4  1d290070    mulli r9,r9,0x70            
10014ce8  7c6b0734    extsh r11,r3                
10014cec  1d6b0070    mulli r11,r11,0x70          
10014cf0  7c6c0734    extsh r12,r3                
10014cf4  1d8c0070    mulli r12,r12,0x70          
10014cf8  3be26840    addi r31,r2,0x6840          
10014cfc  3880003c    li r4,0x3c                  
10014d00  38a50064    addi r5,r5,0x64             
10014d04  7c9f2b2e    sthx r4,r31,r5              
10014d08  38c0001f    li r6,0x1f                  
10014d0c  38e70062    addi r7,r7,0x62             
10014d10  7cdf3b2e    sthx r6,r31,r7              
10014d14  390004b0    li r8,0x4b0                 
10014d18  3929006e    addi r9,r9,0x6e             
10014d1c  39426bac    addi r10,r2,0x6bac          
10014d20  7d1f4b2e    sthx r8,r31,r9              
10014d24  814a0000    lwz r10,0x0(r10)            
10014d28  396b006a    addi r11,r11,0x6a           
10014d2c  7d5f592e    stwx r10,r31,r11            
10014d30  398c005c    addi r12,r12,0x5c           
10014d34  7d9f62ae    lhax r12,r31,r12            
10014d38  2c0c0000    cmpwi r12,0x0               
10014d3c  40820018    bne 0x10014d54                 ; -> 10014d54
10014d40  7c650734    extsh r5,r3                 
10014d44  1ca50070    mulli r5,r5,0x70            
10014d48  38800000    li r4,0x0                   
10014d4c  38a50060    addi r5,r5,0x60             
10014d50  7c9f2b2e    sthx r4,r31,r5              
10014d54  7c670734    extsh r7,r3                 
10014d58  1ce70070    mulli r7,r7,0x70            
10014d5c  38c00001    li r6,0x1                   
10014d60  38e7005c    addi r7,r7,0x5c             
10014d64  7cdf3b2e    sthx r6,r31,r7              
10014d68  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10014d6c  4e800020    blr                         
