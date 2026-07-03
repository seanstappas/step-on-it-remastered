; FUN_1000cc50 @ 0x1000cc50
1000cc50  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000cc54  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000cc58  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000cc5c  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1000cc60  7c650734    extsh r5,r3                 
1000cc64  38a5ffff    subi r5,r5,0x1              
1000cc68  7c860734    extsh r6,r4                 
1000cc6c  1ca5003c    mulli r5,r5,0x3c            
1000cc70  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1000cc74  3b826bf8    addi r28,r2,0x6bf8          
1000cc78  7ca53214    add r5,r5,r6                
1000cc7c  7ffc282e    lwzx r31,r28,r5             
1000cc80  3bc0040d    li r30,0x40d                
1000cc84  7c1ff000    cmpw r31,r30                
1000cc88  3ba0040e    li r29,0x40e                
1000cc8c  4182000c    beq 0x1000cc98                 ; -> 1000cc98
1000cc90  7c1fe800    cmpw r31,r29                
1000cc94  4082000c    bne 0x1000cca0                 ; -> 1000cca0
1000cc98  38600000    li r3,0x0                   
1000cc9c  48000184    b 0x1000ce20                   ; -> 1000ce20
1000cca0  7c670734    extsh r7,r3                 
1000cca4  38e70001    addi r7,r7,0x1              
1000cca8  7c880734    extsh r8,r4                 
1000ccac  1ce7003c    mulli r7,r7,0x3c            
1000ccb0  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
1000ccb4  7ce74214    add r7,r7,r8                
1000ccb8  7ffc382e    lwzx r31,r28,r7             
1000ccbc  7c1ff000    cmpw r31,r30                
1000ccc0  4182000c    beq 0x1000cccc                 ; -> 1000cccc
1000ccc4  7c1fe800    cmpw r31,r29                
1000ccc8  4082000c    bne 0x1000ccd4                 ; -> 1000ccd4
1000cccc  38600000    li r3,0x0                   
1000ccd0  48000150    b 0x1000ce20                   ; -> 1000ce20
1000ccd4  7c690734    extsh r9,r3                 
1000ccd8  3929ffff    subi r9,r9,0x1              
1000ccdc  7c8a0734    extsh r10,r4                
1000cce0  394a0001    addi r10,r10,0x1            
1000cce4  1d29003c    mulli r9,r9,0x3c            
1000cce8  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
1000ccec  7d295214    add r9,r9,r10               
1000ccf0  7ffc482e    lwzx r31,r28,r9             
1000ccf4  7c1ff000    cmpw r31,r30                
1000ccf8  4182000c    beq 0x1000cd04                 ; -> 1000cd04
1000ccfc  7c1fe800    cmpw r31,r29                
1000cd00  4082000c    bne 0x1000cd0c                 ; -> 1000cd0c
1000cd04  38600000    li r3,0x0                   
1000cd08  48000118    b 0x1000ce20                   ; -> 1000ce20
1000cd0c  7c6b0734    extsh r11,r3                
1000cd10  7c8c0734    extsh r12,r4                
1000cd14  398c0001    addi r12,r12,0x1            
1000cd18  1d6b003c    mulli r11,r11,0x3c          
1000cd1c  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
1000cd20  7d6b6214    add r11,r11,r12             
1000cd24  7ffc582e    lwzx r31,r28,r11            
1000cd28  7c1ff000    cmpw r31,r30                
1000cd2c  4182000c    beq 0x1000cd38                 ; -> 1000cd38
1000cd30  7c1fe800    cmpw r31,r29                
1000cd34  4082000c    bne 0x1000cd40                 ; -> 1000cd40
1000cd38  38600000    li r3,0x0                   
1000cd3c  480000e4    b 0x1000ce20                   ; -> 1000ce20
1000cd40  7c650734    extsh r5,r3                 
1000cd44  38a50001    addi r5,r5,0x1              
1000cd48  7c860734    extsh r6,r4                 
1000cd4c  38c60001    addi r6,r6,0x1              
1000cd50  1ca5003c    mulli r5,r5,0x3c            
1000cd54  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1000cd58  7ca53214    add r5,r5,r6                
1000cd5c  7ffc282e    lwzx r31,r28,r5             
1000cd60  7c1ff000    cmpw r31,r30                
1000cd64  4182000c    beq 0x1000cd70                 ; -> 1000cd70
1000cd68  7c1fe800    cmpw r31,r29                
1000cd6c  4082000c    bne 0x1000cd78                 ; -> 1000cd78
1000cd70  38600000    li r3,0x0                   
1000cd74  480000ac    b 0x1000ce20                   ; -> 1000ce20
1000cd78  7c670734    extsh r7,r3                 
1000cd7c  38e7ffff    subi r7,r7,0x1              
1000cd80  7c880734    extsh r8,r4                 
1000cd84  39080002    addi r8,r8,0x2              
1000cd88  1ce7003c    mulli r7,r7,0x3c            
1000cd8c  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
1000cd90  7ce74214    add r7,r7,r8                
1000cd94  7ffc382e    lwzx r31,r28,r7             
1000cd98  7c1ff000    cmpw r31,r30                
1000cd9c  4182000c    beq 0x1000cda8                 ; -> 1000cda8
1000cda0  7c1fe800    cmpw r31,r29                
1000cda4  4082000c    bne 0x1000cdb0                 ; -> 1000cdb0
1000cda8  38600000    li r3,0x0                   
1000cdac  48000074    b 0x1000ce20                   ; -> 1000ce20
1000cdb0  7c690734    extsh r9,r3                 
1000cdb4  7c8a0734    extsh r10,r4                
1000cdb8  394a0002    addi r10,r10,0x2            
1000cdbc  1d29003c    mulli r9,r9,0x3c            
1000cdc0  554a103a    rlwinm r10,r10,0x2,0x0,0x1d 
1000cdc4  7d295214    add r9,r9,r10               
1000cdc8  7ffc482e    lwzx r31,r28,r9             
1000cdcc  7c1ff000    cmpw r31,r30                
1000cdd0  4182000c    beq 0x1000cddc                 ; -> 1000cddc
1000cdd4  7c1fe800    cmpw r31,r29                
1000cdd8  4082000c    bne 0x1000cde4                 ; -> 1000cde4
1000cddc  38600000    li r3,0x0                   
1000cde0  48000040    b 0x1000ce20                   ; -> 1000ce20
1000cde4  7c6b0734    extsh r11,r3                
1000cde8  396b0001    addi r11,r11,0x1            
1000cdec  7c8c0734    extsh r12,r4                
1000cdf0  398c0002    addi r12,r12,0x2            
1000cdf4  1d6b003c    mulli r11,r11,0x3c          
1000cdf8  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
1000cdfc  7d6b6214    add r11,r11,r12             
1000ce00  7ffc582e    lwzx r31,r28,r11            
1000ce04  7c1ff000    cmpw r31,r30                
1000ce08  4182000c    beq 0x1000ce14                 ; -> 1000ce14
1000ce0c  7c1fe800    cmpw r31,r29                
1000ce10  4082000c    bne 0x1000ce1c                 ; -> 1000ce1c
1000ce14  38600000    li r3,0x0                   
1000ce18  48000008    b 0x1000ce20                   ; -> 1000ce20
1000ce1c  38600001    li r3,0x1                   
1000ce20  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000ce24  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000ce28  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000ce2c  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1000ce30  4e800020    blr                         
