; FUN_1002f1c8 @ 0x1002f1c8
1002f1c8  7c0802a6    mfspr r0,LR                 
1002f1cc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002f1d0  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002f1d4  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1002f1d8  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1002f1dc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002f1e0  9421ff40    stwu r1,-0xc0(r1)              ; -> Stack[-0xc0]
1002f1e4  7c7c1b78    or r28,r3,r3                
1002f1e8  988100df    stb r4,0xdf(r1)                ; -> Stack[0x1f]
1002f1ec  7cbe2b78    or r30,r5,r5                
1002f1f0  7cdd3378    or r29,r6,r6                
1002f1f4  281e0000    cmplwi r30,0x0              
1002f1f8  3be00000    li r31,0x0                  
1002f1fc  41820114    beq 0x1002f310                 ; -> 1002f310
1002f200  281d0000    cmplwi r29,0x0              
1002f204  4182010c    beq 0x1002f310                 ; -> 1002f310
1002f208  3c807072    lis r4,0x7072               
1002f20c  38608000    li r3,-0x8000               
1002f210  38846566    addi r4,r4,0x6566           
1002f214  38a00001    li r5,0x1                   
1002f218  7fc6f378    or r6,r30,r30               
1002f21c  38e100a0    addi r7,r1,0xa0             
1002f220  48002229    bl 0x10031448                  ; -> 10031448
1002f224  80410014    lwz r2,0x14(r1)                ; -> Stack[-0xac]
1002f228  7c7f1b78    or r31,r3,r3                
1002f22c  7fe30734    extsh r3,r31                
1002f230  2c03ffd5    cmpwi r3,-0x2b              
1002f234  40820038    bne 0x1002f26c                 ; -> 1002f26c
1002f238  3c806d61    lis r4,0x6d61               
1002f23c  38608000    li r3,-0x8000               
1002f240  38846373    addi r4,r4,0x6373           
1002f244  38a00000    li r5,0x0                   
1002f248  7fc6f378    or r6,r30,r30               
1002f24c  38e100a0    addi r7,r1,0xa0             
1002f250  480021f9    bl 0x10031448                  ; -> 10031448
1002f254  80410014    lwz r2,0x14(r1)                ; -> Stack[-0xac]
1002f258  7c7f1b78    or r31,r3,r3                
1002f25c  7fe40734    extsh r4,r31                
1002f260  2c040000    cmpwi r4,0x0                
1002f264  41820018    beq 0x1002f27c                 ; -> 1002f27c
1002f268  480000ac    b 0x1002f314                   ; -> 1002f314
1002f26c  7fe50734    extsh r5,r31                
1002f270  2c050000    cmpwi r5,0x0                
1002f274  41820008    beq 0x1002f27c                 ; -> 1002f27c
1002f278  4800009c    b 0x1002f314                   ; -> 1002f314
1002f27c  281c0000    cmplwi r28,0x0              
1002f280  41820084    beq 0x1002f304                 ; -> 1002f304
1002f284  9381004a    stw r28,0x4a(r1)               ; -> Stack[-0x76]
1002f288  a8de0000    lha r6,0x0(r30)             
1002f28c  80e100a0    lwz r7,0xa0(r1)                ; -> Stack[-0x20]
1002f290  b0c1004e    sth r6,0x4e(r1)                ; -> Stack[-0x72]
1002f294  90e10068    stw r7,0x68(r1)                ; -> Stack[-0x58]
1002f298  39000000    li r8,0x0                   
1002f29c  b1010054    sth r8,0x54(r1)                ; -> Stack[-0x6c]
1002f2a0  38610038    addi r3,r1,0x38             
1002f2a4  480022c5    bl 0x10031568                  ; -> 10031568
1002f2a8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0xac]
1002f2ac  7c7f1b78    or r31,r3,r3                
1002f2b0  7fe90734    extsh r9,r31                
1002f2b4  2c090000    cmpwi r9,0x0                
1002f2b8  40820010    bne 0x1002f2c8                 ; -> 1002f2c8
1002f2bc  81410068    lwz r10,0x68(r1)               ; -> Stack[-0x58]
1002f2c0  915d0000    stw r10,0x0(r29)            
1002f2c4  48000050    b 0x1002f314                   ; -> 1002f314
1002f2c8  7feb0734    extsh r11,r31               
1002f2cc  2c0bffd5    cmpwi r11,-0x2b             
1002f2d0  40820030    bne 0x1002f300                 ; -> 1002f300
1002f2d4  898100df    lbz r12,0xdf(r1)               ; -> Stack[0x1f]
1002f2d8  280c0000    cmplwi r12,0x0              
1002f2dc  41820024    beq 0x1002f300                 ; -> 1002f300
1002f2e0  a87e0000    lha r3,0x0(r30)             
1002f2e4  808100a0    lwz r4,0xa0(r1)                ; -> Stack[-0x20]
1002f2e8  7f85e378    or r5,r28,r28               
1002f2ec  7fa6eb78    or r6,r29,r29               
1002f2f0  48002309    bl 0x100315f8                  ; -> 100315f8
1002f2f4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0xac]
1002f2f8  7c7f1b78    or r31,r3,r3                
1002f2fc  48000018    b 0x1002f314                   ; -> 1002f314
1002f300  48000014    b 0x1002f314                   ; -> 1002f314
1002f304  806100a0    lwz r3,0xa0(r1)                ; -> Stack[-0x20]
1002f308  907d0000    stw r3,0x0(r29)             
1002f30c  48000008    b 0x1002f314                   ; -> 1002f314
1002f310  3be0ffce    li r31,-0x32                
1002f314  7fe3fb78    or r3,r31,r31               
1002f318  800100c8    lwz r0,0xc8(r1)                ; -> Stack[0x8]
1002f31c  382100c0    addi r1,r1,0xc0             
1002f320  7c0803a6    mtspr LR,r0                 
1002f324  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002f328  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002f32c  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1002f330  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1002f334  4e800020    blr                         
