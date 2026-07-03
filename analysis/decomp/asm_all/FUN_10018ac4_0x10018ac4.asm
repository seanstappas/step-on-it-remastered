; FUN_10018ac4 @ 0x10018ac4
10018ac4  7c0802a6    mfspr r0,LR                 
10018ac8  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10018acc  9421ffc0    stwu r1,-0x40(r1)              ; -> Stack[-0x40]
10018ad0  38624ed9    addi r3,r2,0x4ed9           
10018ad4  88630000    lbz r3,0x0(r3)              
10018ad8  28030000    cmplwi r3,0x0               
10018adc  41820038    beq 0x10018b14                 ; -> 10018b14
10018ae0  38824fe5    addi r4,r2,0x4fe5           
10018ae4  88840000    lbz r4,0x0(r4)              
10018ae8  28040000    cmplwi r4,0x0               
10018aec  41820028    beq 0x10018b14                 ; -> 10018b14
10018af0  38a24ede    addi r5,r2,0x4ede           
10018af4  a8a50000    lha r5,0x0(r5)              
10018af8  2c050000    cmpwi r5,0x0                
10018afc  41820018    beq 0x10018b14                 ; -> 10018b14
10018b00  38c24ee4    addi r6,r2,0x4ee4           
10018b04  3c800001    lis r4,0x1                  
10018b08  80660000    lwz r3,0x0(r6)              
10018b0c  48019255    bl 0x10031d60                  ; -> 10031d60
10018b10  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2c]
10018b14  80010048    lwz r0,0x48(r1)                ; -> Stack[0x8]
10018b18  38210040    addi r1,r1,0x40             
10018b1c  7c0803a6    mtspr LR,r0                 
10018b20  4e800020    blr                         
