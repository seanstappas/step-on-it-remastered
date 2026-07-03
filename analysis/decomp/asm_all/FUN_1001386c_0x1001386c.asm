; FUN_1001386c @ 0x1001386c
1001386c  7c0802a6    mfspr r0,LR                 
10013870  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10013874  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10013878  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001387c  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10013880  7c7f1b78    or r31,r3,r3                
10013884  3bc26840    addi r30,r2,0x6840          
10013888  7fe3fb78    or r3,r31,r31               
1001388c  48000eb9    bl 0x10014744                  ; -> 10014744
10013890  60000000    ori r0,r0,0x0               
10013894  7fe3fb78    or r3,r31,r31               
10013898  4bffecbd    bl 0x10012554                  ; -> 10012554
1001389c  7fe30734    extsh r3,r31                
100138a0  1c630070    mulli r3,r3,0x70            
100138a4  7fe40734    extsh r4,r31                
100138a8  1c840070    mulli r4,r4,0x70            
100138ac  7fe70734    extsh r7,r31                
100138b0  7c7e1aae    lhax r3,r30,r3              
100138b4  1ce70070    mulli r7,r7,0x70            
100138b8  7fe80734    extsh r8,r31                
100138bc  1d080070    mulli r8,r8,0x70            
100138c0  7fe60734    extsh r6,r31                
100138c4  5463043a    rlwinm r3,r3,0x0,0x10,0x1d  
100138c8  38840002    addi r4,r4,0x2              
100138cc  38a26bc4    addi r5,r2,0x6bc4           
100138d0  7c7e232e    sthx r3,r30,r4              
100138d4  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
100138d8  7ca5302e    lwzx r5,r5,r6               
100138dc  38e70006    addi r7,r7,0x6              
100138e0  7cbe392e    stwx r5,r30,r7              
100138e4  39080034    addi r8,r8,0x34             
100138e8  7d1e42ae    lhax r8,r30,r8              
100138ec  2c080001    cmpwi r8,0x1                
100138f0  4082001c    bne 0x1001390c                 ; -> 1001390c
100138f4  7fea0734    extsh r10,r31               
100138f8  1d4a0070    mulli r10,r10,0x70          
100138fc  3920003d    li r9,0x3d                  
10013900  394a000e    addi r10,r10,0xe            
10013904  7d3e532e    sthx r9,r30,r10             
10013908  48000018    b 0x10013920                   ; -> 10013920
1001390c  7fec0734    extsh r12,r31               
10013910  1d8c0070    mulli r12,r12,0x70          
10013914  39600034    li r11,0x34                 
10013918  398c000e    addi r12,r12,0xe            
1001391c  7d7e632e    sthx r11,r30,r12            
10013920  7fe30734    extsh r3,r31                
10013924  1c630070    mulli r3,r3,0x70            
10013928  38630004    addi r3,r3,0x4              
1001392c  7c9e1aae    lhax r4,r30,r3              
10013930  38840004    addi r4,r4,0x4              
10013934  7c9e1b2e    sthx r4,r30,r3              
10013938  7fe3fb78    or r3,r31,r31               
1001393c  4bffea0d    bl 0x10012348                  ; -> 10012348
10013940  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10013944  28030000    cmplwi r3,0x0               
10013948  41820020    beq 0x10013968                 ; -> 10013968
1001394c  7fe3fb78    or r3,r31,r31               
10013950  4bfffea9    bl 0x100137f8                  ; -> 100137f8
10013954  7fe60734    extsh r6,r31                
10013958  1cc60070    mulli r6,r6,0x70            
1001395c  38a00000    li r5,0x0                   
10013960  38c6001c    addi r6,r6,0x1c             
10013964  7cbe332e    sthx r5,r30,r6              
10013968  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1001396c  38210040    addi r1,r1,0x40             
10013970  7c0803a6    mtspr LR,r0                 
10013974  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10013978  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001397c  4e800020    blr                         
