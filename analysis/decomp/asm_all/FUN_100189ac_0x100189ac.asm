; FUN_100189ac @ 0x100189ac
100189ac  7c0802a6    mfspr r0,LR                 
100189b0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100189b4  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
100189b8  38624ed9    addi r3,r2,0x4ed9           
100189bc  88630000    lbz r3,0x0(r3)              
100189c0  28030000    cmplwi r3,0x0               
100189c4  41820044    beq 0x10018a08                 ; -> 10018a08
100189c8  38824ed8    addi r4,r2,0x4ed8           
100189cc  88840000    lbz r4,0x0(r4)              
100189d0  28040000    cmplwi r4,0x0               
100189d4  41820034    beq 0x10018a08                 ; -> 10018a08
100189d8  38a24ede    addi r5,r2,0x4ede           
100189dc  a8a50000    lha r5,0x0(r5)              
100189e0  2c050000    cmpwi r5,0x0                
100189e4  41820024    beq 0x10018a08                 ; -> 10018a08
100189e8  38c24ee4    addi r6,r2,0x4ee4           
100189ec  38800000    li r4,0x0                   
100189f0  80660000    lwz r3,0x0(r6)              
100189f4  4801936d    bl 0x10031d60                  ; -> 10031d60
100189f8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
100189fc  39024ed8    addi r8,r2,0x4ed8           
10018a00  38e00000    li r7,0x0                   
10018a04  98e80000    stb r7,0x0(r8)              
10018a08  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10018a0c  38210040    addi r1,r1,0x40             
10018a10  7c0803a6    mtspr LR,r0                 
10018a14  4e800020    blr                         
