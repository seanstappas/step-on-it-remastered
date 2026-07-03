; FUN_10005c64 @ 0x10005c64
10005c64  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10005c68  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10005c6c  7c650734    extsh r5,r3                 
10005c70  1ca50046    mulli r5,r5,0x46            
10005c74  7c640734    extsh r4,r3                 
10005c78  7c660734    extsh r6,r3                 
10005c7c  3be23cd8    addi r31,r2,0x3cd8          
10005c80  38a5003e    addi r5,r5,0x3e             
10005c84  1c840046    mulli r4,r4,0x46            
10005c88  7cbf2aae    lhax r5,r31,r5              
10005c8c  1cc60046    mulli r6,r6,0x46            
10005c90  1ca50046    mulli r5,r5,0x46            
10005c94  7c9f22ae    lhax r4,r31,r4              
10005c98  3bc261f8    addi r30,r2,0x61f8          
10005c9c  7c9f2b2e    sthx r4,r31,r5              
10005ca0  7cdf32ae    lhax r6,r31,r6              
10005ca4  2c060000    cmpwi r6,0x0                
10005ca8  40820020    bne 0x10005cc8                 ; -> 10005cc8
10005cac  7c670734    extsh r7,r3                 
10005cb0  1ce70046    mulli r7,r7,0x46            
10005cb4  38e7003e    addi r7,r7,0x3e             
10005cb8  7cff3aae    lhax r7,r31,r7              
10005cbc  390261fa    addi r8,r2,0x61fa           
10005cc0  b0e80000    sth r7,0x0(r8)              
10005cc4  4800002c    b 0x10005cf0                   ; -> 10005cf0
10005cc8  7c6a0734    extsh r10,r3                
10005ccc  1d4a0046    mulli r10,r10,0x46          
10005cd0  7c690734    extsh r9,r3                 
10005cd4  1d290046    mulli r9,r9,0x46            
10005cd8  7d5f52ae    lhax r10,r31,r10            
10005cdc  3929003e    addi r9,r9,0x3e             
10005ce0  1d4a0046    mulli r10,r10,0x46          
10005ce4  7d3f4aae    lhax r9,r31,r9              
10005ce8  394a003e    addi r10,r10,0x3e           
10005cec  7d3f532e    sthx r9,r31,r10             
10005cf0  a97e0000    lha r11,0x0(r30)            
10005cf4  7c640734    extsh r4,r3                 
10005cf8  1d6b0046    mulli r11,r11,0x46          
10005cfc  7c660734    extsh r6,r3                 
10005d00  1cc60046    mulli r6,r6,0x46            
10005d04  1c840046    mulli r4,r4,0x46            
10005d08  7c7f5b2e    sthx r3,r31,r11             
10005d0c  39800000    li r12,0x0                  
10005d10  7d9f232e    sthx r12,r31,r4             
10005d14  a8be0000    lha r5,0x0(r30)             
10005d18  38c6003e    addi r6,r6,0x3e             
10005d1c  7cbf332e    sthx r5,r31,r6              
10005d20  b07e0000    sth r3,0x0(r30)             
10005d24  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10005d28  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10005d2c  4e800020    blr                         
