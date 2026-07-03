; FUN_1002a09c @ 0x1002a09c
1002a09c  7c0802a6    mfspr r0,LR                 
1002a0a0  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002a0a4  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002a0a8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002a0ac  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
1002a0b0  3c60444d    lis r3,0x444d               
1002a0b4  3bc2755c    addi r30,r2,0x755c          
1002a0b8  3be27560    addi r31,r2,0x7560          
1002a0bc  38634b59    addi r3,r3,0x4b59           
1002a0c0  388003e8    li r4,0x3e8                 
1002a0c4  48007bad    bl 0x10031c70                  ; -> 10031c70
1002a0c8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1002a0cc  907f0000    stw r3,0x0(r31)             
1002a0d0  807f0000    lwz r3,0x0(r31)             
1002a0d4  28030000    cmplwi r3,0x0               
1002a0d8  40820010    bne 0x1002a0e8                 ; -> 1002a0e8
1002a0dc  38600005    li r3,0x5                   
1002a0e0  4bfef219    bl 0x100192f8                  ; -> 100192f8
1002a0e4  60000000    ori r0,r0,0x0               
1002a0e8  807f0000    lwz r3,0x0(r31)             
1002a0ec  480076bd    bl 0x100317a8                  ; -> 100317a8
1002a0f0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1002a0f4  807f0000    lwz r3,0x0(r31)             
1002a0f8  48006f01    bl 0x10030ff8                  ; -> 10030ff8
1002a0fc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
1002a100  809f0000    lwz r4,0x0(r31)             
1002a104  38c27558    addi r6,r2,0x7558           
1002a108  80840000    lwz r4,0x0(r4)              
1002a10c  39227559    addi r9,r2,0x7559           
1002a110  909e0000    stw r4,0x0(r30)             
1002a114  80be0000    lwz r5,0x0(r30)             
1002a118  88a50000    lbz r5,0x0(r5)              
1002a11c  98a60000    stb r5,0x0(r6)              
1002a120  80fe0000    lwz r7,0x0(r30)             
1002a124  38e70001    addi r7,r7,0x1              
1002a128  90fe0000    stw r7,0x0(r30)             
1002a12c  811e0000    lwz r8,0x0(r30)             
1002a130  89080000    lbz r8,0x0(r8)              
1002a134  99090000    stb r8,0x0(r9)              
1002a138  815e0000    lwz r10,0x0(r30)            
1002a13c  394a0001    addi r10,r10,0x1            
1002a140  915e0000    stw r10,0x0(r30)            
1002a144  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
1002a148  38210040    addi r1,r1,0x40             
1002a14c  7c0803a6    mtspr LR,r0                 
1002a150  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002a154  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002a158  4e800020    blr                         
