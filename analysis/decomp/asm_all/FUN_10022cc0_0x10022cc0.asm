; FUN_10022cc0 @ 0x10022cc0
10022cc0  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10022cc4  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10022cc8  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10022ccc  3bc25612    addi r30,r2,0x5612          
10022cd0  3be00001    li r31,0x1                  
10022cd4  48000030    b 0x10022d04                   ; -> 10022d04
10022cd8  7fe30734    extsh r3,r31                
10022cdc  7fe60734    extsh r6,r31                
10022ce0  1c630104    mulli r3,r3,0x104           
10022ce4  1cc60104    mulli r6,r6,0x104           
10022ce8  7fbe1a14    add r29,r30,r3              
10022cec  38800000    li r4,0x0                   
10022cf0  989d0000    stb r4,0x0(r29)             
10022cf4  38a01388    li r5,0x1388                
10022cf8  38c60100    addi r6,r6,0x100            
10022cfc  7cbe312e    stwx r5,r30,r6              
10022d00  3bff0001    addi r31,r31,0x1            
10022d04  7fe70734    extsh r7,r31                
10022d08  2c07000b    cmpwi r7,0xb                
10022d0c  4180ffcc    blt 0x10022cd8                 ; -> 10022cd8
10022d10  3922523e    addi r9,r2,0x523e           
10022d14  39000001    li r8,0x1                   
10022d18  99090000    stb r8,0x0(r9)              
10022d1c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10022d20  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10022d24  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10022d28  4e800020    blr                         
