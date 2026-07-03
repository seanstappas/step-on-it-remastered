; FUN_10003b68 @ 0x10003b68
10003b68  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10003b6c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10003b70  386261fa    addi r3,r2,0x61fa           
10003b74  3bc23cd8    addi r30,r2,0x3cd8          
10003b78  abe30000    lha r31,0x0(r3)             
10003b7c  48000028    b 0x10003ba4                   ; -> 10003ba4
10003b80  7fe50734    extsh r5,r31                
10003b84  1ca50046    mulli r5,r5,0x46            
10003b88  7fe60734    extsh r6,r31                
10003b8c  1cc60046    mulli r6,r6,0x46            
10003b90  38800000    li r4,0x0                   
10003b94  38a50021    addi r5,r5,0x21             
10003b98  7c9e29ae    stbx r4,r30,r5              
10003b9c  38c6003e    addi r6,r6,0x3e             
10003ba0  7ffe32ae    lhax r31,r30,r6             
10003ba4  7fe70734    extsh r7,r31                
10003ba8  2c070000    cmpwi r7,0x0                
10003bac  4082ffd4    bne 0x10003b80                 ; -> 10003b80
10003bb0  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10003bb4  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10003bb8  4e800020    blr                         
