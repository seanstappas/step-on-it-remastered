; FUN_10017a1c @ 0x10017a1c
10017a1c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10017a20  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10017a24  3bc24e88    addi r30,r2,0x4e88          
10017a28  3be00001    li r31,0x1                  
10017a2c  4800002c    b 0x10017a58                   ; -> 10017a58
10017a30  7fe40734    extsh r4,r31                
10017a34  7fe50734    extsh r5,r31                
10017a38  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
10017a3c  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
10017a40  38600000    li r3,0x0                   
10017a44  38840002    addi r4,r4,0x2              
10017a48  7c7e21ae    stbx r3,r30,r4              
10017a4c  38a50001    addi r5,r5,0x1              
10017a50  7c7e29ae    stbx r3,r30,r5              
10017a54  3bff0001    addi r31,r31,0x1            
10017a58  7fe60734    extsh r6,r31                
10017a5c  2c060013    cmpwi r6,0x13               
10017a60  4081ffd0    ble 0x10017a30                 ; -> 10017a30
10017a64  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10017a68  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10017a6c  4e800020    blr                         
