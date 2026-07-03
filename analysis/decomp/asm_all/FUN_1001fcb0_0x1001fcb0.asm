; FUN_1001fcb0 @ 0x1001fcb0
1001fcb0  7c0802a6    mfspr r0,LR                 
1001fcb4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001fcb8  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001fcbc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001fcc0  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1001fcc4  480112ed    bl 0x10030fb0                  ; -> 10030fb0
1001fcc8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001fccc  7c7f1b78    or r31,r3,r3                
1001fcd0  386251e8    addi r3,r2,0x51e8           
1001fcd4  38800008    li r4,0x8                   
1001fcd8  93e30000    stw r31,0x0(r3)             
1001fcdc  7fe3fb78    or r3,r31,r31               
1001fce0  38a00001    li r5,0x1                   
1001fce4  38c00001    li r6,0x1                   
1001fce8  48011701    bl 0x100313e8                  ; -> 100313e8
1001fcec  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001fcf0  7c630734    extsh r3,r3                 
1001fcf4  2c030000    cmpwi r3,0x0                
1001fcf8  40820010    bne 0x1001fd08                 ; -> 1001fd08
1001fcfc  3860000a    li r3,0xa                   
1001fd00  4bff95f9    bl 0x100192f8                  ; -> 100192f8
1001fd04  60000000    ori r0,r0,0x0               
1001fd08  809f0000    lwz r4,0x0(r31)             
1001fd0c  83c40016    lwz r30,0x16(r4)            
1001fd10  80be0000    lwz r5,0x0(r30)             
1001fd14  80c50006    lwz r6,0x6(r5)              
1001fd18  80e5000a    lwz r7,0xa(r5)              
1001fd1c  90c10040    stw r6,0x40(r1)                ; -> Stack[-0x20]
1001fd20  90e10044    stw r7,0x44(r1)                ; -> Stack[-0x1c]
1001fd24  a9010046    lha r8,0x46(r1)                ; -> Stack[-0x1a]
1001fd28  2c080280    cmpwi r8,0x280              
1001fd2c  41800010    blt 0x1001fd3c                 ; -> 1001fd3c
1001fd30  a9210044    lha r9,0x44(r1)                ; -> Stack[-0x1c]
1001fd34  2c0901e0    cmpwi r9,0x1e0              
1001fd38  40800010    bge 0x1001fd48                 ; -> 1001fd48
1001fd3c  3860000a    li r3,0xa                   
1001fd40  4bff95b9    bl 0x100192f8                  ; -> 100192f8
1001fd44  60000000    ori r0,r0,0x0               
1001fd48  815e0000    lwz r10,0x0(r30)            
1001fd4c  396251ee    addi r11,r2,0x51ee          
1001fd50  a94a0020    lha r10,0x20(r10)           
1001fd54  398251ee    addi r12,r2,0x51ee          
1001fd58  b14b0000    sth r10,0x0(r11)            
1001fd5c  a98c0000    lha r12,0x0(r12)            
1001fd60  2c0c0008    cmpwi r12,0x8               
1001fd64  41820054    beq 0x1001fdb8                 ; -> 1001fdb8
1001fd68  7fe3fb78    or r3,r31,r31               
1001fd6c  38800008    li r4,0x8                   
1001fd70  38a00001    li r5,0x1                   
1001fd74  38c00001    li r6,0x1                   
1001fd78  48011671    bl 0x100313e8                  ; -> 100313e8
1001fd7c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001fd80  7c630734    extsh r3,r3                 
1001fd84  2c030000    cmpwi r3,0x0                
1001fd88  40820014    bne 0x1001fd9c                 ; -> 1001fd9c
1001fd8c  3860000a    li r3,0xa                   
1001fd90  4bff9569    bl 0x100192f8                  ; -> 100192f8
1001fd94  60000000    ori r0,r0,0x0               
1001fd98  48000020    b 0x1001fdb8                   ; -> 1001fdb8
1001fd9c  7fe3fb78    or r3,r31,r31               
1001fda0  38800008    li r4,0x8                   
1001fda4  38a00001    li r5,0x1                   
1001fda8  38c00001    li r6,0x1                   
1001fdac  48011655    bl 0x10031400                  ; -> 10031400
1001fdb0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001fdb4  b0610048    sth r3,0x48(r1)                ; -> Stack[-0x18]
1001fdb8  3861003c    addi r3,r1,0x3c             
1001fdbc  4801165d    bl 0x10031418                  ; -> 10031418
1001fdc0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001fdc4  8861003c    lbz r3,0x3c(r1)                ; -> Stack[-0x24]
1001fdc8  28030003    cmplwi r3,0x3               
1001fdcc  40800010    bge 0x1001fddc                 ; -> 1001fddc
1001fdd0  3860000b    li r3,0xb                   
1001fdd4  4bff9525    bl 0x100192f8                  ; -> 100192f8
1001fdd8  60000000    ori r0,r0,0x0               
1001fddc  48000155    bl 0x1001ff30                  ; -> 1001ff30
1001fde0  60000000    ori r0,r0,0x0               
1001fde4  38824eda    addi r4,r2,0x4eda           
1001fde8  98640000    stb r3,0x0(r4)              
1001fdec  48000069    bl 0x1001fe54                  ; -> 1001fe54
1001fdf0  60000000    ori r0,r0,0x0               
1001fdf4  38a24ed9    addi r5,r2,0x4ed9           
1001fdf8  98650000    stb r3,0x0(r5)              
1001fdfc  480115d5    bl 0x100313d0                  ; -> 100313d0
1001fe00  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001fe04  90610038    stw r3,0x38(r1)                ; -> Stack[-0x28]
1001fe08  480115c9    bl 0x100313d0                  ; -> 100313d0
1001fe0c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001fe10  3cc0003a    lis r6,0x3a                 
1001fe14  38c61670    addi r6,r6,0x1670           
1001fe18  7c033000    cmpw r3,r6                  
1001fe1c  40810014    ble 0x1001fe30                 ; -> 1001fe30
1001fe20  3902523c    addi r8,r2,0x523c           
1001fe24  38e00001    li r7,0x1                   
1001fe28  98e80000    stb r7,0x0(r8)              
1001fe2c  48000010    b 0x1001fe3c                   ; -> 1001fe3c
1001fe30  3942523c    addi r10,r2,0x523c          
1001fe34  39200000    li r9,0x0                   
1001fe38  992a0000    stb r9,0x0(r10)             
1001fe3c  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1001fe40  38210060    addi r1,r1,0x60             
1001fe44  7c0803a6    mtspr LR,r0                 
1001fe48  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001fe4c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001fe50  4e800020    blr                         
