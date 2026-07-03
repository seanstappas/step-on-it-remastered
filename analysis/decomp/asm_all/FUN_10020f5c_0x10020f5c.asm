; FUN_10020f5c @ 0x10020f5c
10020f5c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10020f60  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10020f64  38825274    addi r4,r2,0x5274           
10020f68  38600000    li r3,0x0                   
10020f6c  38a27538    addi r5,r2,0x7538           
10020f70  98640000    stb r3,0x0(r4)              
10020f74  3be25276    addi r31,r2,0x5276          
10020f78  a8a50000    lha r5,0x0(r5)              
10020f7c  3bc26840    addi r30,r2,0x6840          
10020f80  b0bf0000    sth r5,0x0(r31)             
10020f84  80de00ac    lwz r6,0xac(r30)            
10020f88  90df0006    stw r6,0x6(r31)             
10020f8c  a8fe00b6    lha r7,0xb6(r30)            
10020f90  b0ff000a    sth r7,0xa(r31)             
10020f94  a91e00ba    lha r8,0xba(r30)            
10020f98  b11f000c    sth r8,0xc(r31)             
10020f9c  a93e00bc    lha r9,0xbc(r30)            
10020fa0  b13f000e    sth r9,0xe(r31)             
10020fa4  a95e00a8    lha r10,0xa8(r30)           
10020fa8  b15f0010    sth r10,0x10(r31)           
10020fac  897e009b    lbz r11,0x9b(r30)           
10020fb0  b17f0002    sth r11,0x2(r31)            
10020fb4  899e00b8    lbz r12,0xb8(r30)           
10020fb8  999f0012    stb r12,0x12(r31)           
10020fbc  807e011c    lwz r3,0x11c(r30)           
10020fc0  907f0014    stw r3,0x14(r31)            
10020fc4  a89e0126    lha r4,0x126(r30)           
10020fc8  b09f0018    sth r4,0x18(r31)            
10020fcc  a8be012a    lha r5,0x12a(r30)           
10020fd0  b0bf001a    sth r5,0x1a(r31)            
10020fd4  a8de012c    lha r6,0x12c(r30)           
10020fd8  b0df001c    sth r6,0x1c(r31)            
10020fdc  a8fe0118    lha r7,0x118(r30)           
10020fe0  b0ff001e    sth r7,0x1e(r31)            
10020fe4  891e0128    lbz r8,0x128(r30)           
10020fe8  991f0024    stb r8,0x24(r31)            
10020fec  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10020ff0  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10020ff4  4e800020    blr                         
