; FUN_10022d2c @ 0x10022d2c
10022d2c  7c0802a6    mfspr r0,LR                 
10022d30  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10022d34  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10022d38  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10022d3c  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10022d40  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10022d44  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10022d48  7c7d1b78    or r29,r3,r3                
10022d4c  3bc25612    addi r30,r2,0x5612          
10022d50  3be0000a    li r31,0xa                  
10022d54  48000050    b 0x10022da4                   ; -> 10022da4
10022d58  7fe40734    extsh r4,r31                
10022d5c  3884ffff    subi r4,r4,0x1              
10022d60  1c840104    mulli r4,r4,0x104           
10022d64  7fe50734    extsh r5,r31                
10022d68  1ca50104    mulli r5,r5,0x104           
10022d6c  7c7e2214    add r3,r30,r4               
10022d70  7c9e2a14    add r4,r30,r5               
10022d74  48004265    bl 0x10026fd8                  ; -> 10026fd8
10022d78  60000000    ori r0,r0,0x0               
10022d7c  7fe60734    extsh r6,r31                
10022d80  7fe70734    extsh r7,r31                
10022d84  38c6ffff    subi r6,r6,0x1              
10022d88  1cc60104    mulli r6,r6,0x104           
10022d8c  1ce70104    mulli r7,r7,0x104           
10022d90  38c60100    addi r6,r6,0x100            
10022d94  7cde302e    lwzx r6,r30,r6              
10022d98  38e70100    addi r7,r7,0x100            
10022d9c  7cde392e    stwx r6,r30,r7              
10022da0  3bffffff    subi r31,r31,0x1            
10022da4  7fe80734    extsh r8,r31                
10022da8  7fa90734    extsh r9,r29                
10022dac  7c084800    cmpw r8,r9                  
10022db0  4181ffa8    bgt 0x10022d58                 ; -> 10022d58
10022db4  7fab0734    extsh r11,r29               
10022db8  1d6b0104    mulli r11,r11,0x104         
10022dbc  7fac0734    extsh r12,r29               
10022dc0  1d8c0104    mulli r12,r12,0x104         
10022dc4  39400000    li r10,0x0                  
10022dc8  396b0100    addi r11,r11,0x100          
10022dcc  7d5e592e    stwx r10,r30,r11            
10022dd0  7f9e6214    add r28,r30,r12             
10022dd4  38600000    li r3,0x0                   
10022dd8  987c0000    stb r3,0x0(r28)             
10022ddc  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10022de0  38210050    addi r1,r1,0x50             
10022de4  7c0803a6    mtspr LR,r0                 
10022de8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10022dec  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10022df0  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10022df4  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10022df8  4e800020    blr                         
