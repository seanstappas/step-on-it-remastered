; .VerifyUserPB @ 0x1002fd98
1002fd98  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002fd9c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002fda0  83e30028    lwz r31,0x28(r3)            
1002fda4  83c3002c    lwz r30,0x2c(r3)            
1002fda8  80e30018    lwz r7,0x18(r3)             
1002fdac  28070000    cmplwi r7,0x0               
1002fdb0  4182014c    beq 0x1002fefc                 ; -> 1002fefc
1002fdb4  281f0000    cmplwi r31,0x0              
1002fdb8  41820144    beq 0x1002fefc                 ; -> 1002fefc
1002fdbc  81030024    lwz r8,0x24(r3)             
1002fdc0  3920bffc    li r9,-0x4004               
1002fdc4  7d084839    and. r8,r8,r9               
1002fdc8  4182000c    beq 0x1002fdd4                 ; -> 1002fdd4
1002fdcc  281e0000    cmplwi r30,0x0              
1002fdd0  4182012c    beq 0x1002fefc                 ; -> 1002fefc
1002fdd4  39400000    li r10,0x0                  
1002fdd8  99440000    stb r10,0x0(r4)             
1002fddc  39600000    li r11,0x0                  
1002fde0  99650000    stb r11,0x0(r5)             
1002fde4  39800000    li r12,0x0                  
1002fde8  99860000    stb r12,0x0(r6)             
1002fdec  80e30024    lwz r7,0x24(r3)             
1002fdf0  54e707bf    rlwinm. r7,r7,0x0,0x1e,0x1f 
1002fdf4  41820038    beq 0x1002fe2c                 ; -> 1002fe2c
1002fdf8  811f0012    lwz r8,0x12(r31)            
1002fdfc  28080000    cmplwi r8,0x0               
1002fe00  418200fc    beq 0x1002fefc                 ; -> 1002fefc
1002fe04  813f0012    lwz r9,0x12(r31)            
1002fe08  89290000    lbz r9,0x0(r9)              
1002fe0c  28090000    cmplwi r9,0x0               
1002fe10  418200ec    beq 0x1002fefc                 ; -> 1002fefc
1002fe14  815f0012    lwz r10,0x12(r31)           
1002fe18  894a0000    lbz r10,0x0(r10)            
1002fe1c  280a003f    cmplwi r10,0x3f             
1002fe20  418100dc    bgt 0x1002fefc                 ; -> 1002fefc
1002fe24  39600001    li r11,0x1                  
1002fe28  99660000    stb r11,0x0(r6)             
1002fe2c  81830024    lwz r12,0x24(r3)            
1002fe30  558c077b    rlwinm. r12,r12,0x0,0x1d,0x1d
1002fe34  4182005c    beq 0x1002fe90                 ; -> 1002fe90
1002fe38  88fe001e    lbz r7,0x1e(r30)            
1002fe3c  7ce70774    extsb r7,r7                 
1002fe40  3900ffee    li r8,-0x12                 
1002fe44  7ce74039    and. r7,r7,r8               
1002fe48  408200b4    bne 0x1002fefc                 ; -> 1002fefc
1002fe4c  893e001e    lbz r9,0x1e(r30)            
1002fe50  552906f7    rlwinm. r9,r9,0x0,0x1b,0x1b 
1002fe54  41820028    beq 0x1002fe7c                 ; -> 1002fe7c
1002fe58  895f001e    lbz r10,0x1e(r31)           
1002fe5c  554a06f7    rlwinm. r10,r10,0x0,0x1b,0x1b
1002fe60  41820010    beq 0x1002fe70                 ; -> 1002fe70
1002fe64  39600001    li r11,0x1                  
1002fe68  99650000    stb r11,0x0(r5)             
1002fe6c  48000034    b 0x1002fea0                   ; -> 1002fea0
1002fe70  39800001    li r12,0x1                  
1002fe74  99840000    stb r12,0x0(r4)             
1002fe78  48000028    b 0x1002fea0                   ; -> 1002fea0
1002fe7c  38e00001    li r7,0x1                   
1002fe80  98e50000    stb r7,0x0(r5)              
1002fe84  39000001    li r8,0x1                   
1002fe88  99040000    stb r8,0x0(r4)              
1002fe8c  48000014    b 0x1002fea0                   ; -> 1002fea0
1002fe90  39200001    li r9,0x1                   
1002fe94  99250000    stb r9,0x0(r5)              
1002fe98  39400001    li r10,0x1                  
1002fe9c  99440000    stb r10,0x0(r4)             
1002fea0  89650000    lbz r11,0x0(r5)             
1002fea4  280b0000    cmplwi r11,0x0              
1002fea8  4182001c    beq 0x1002fec4                 ; -> 1002fec4
1002feac  81830024    lwz r12,0x24(r3)            
1002feb0  558c077b    rlwinm. r12,r12,0x0,0x1d,0x1d
1002feb4  41820010    beq 0x1002fec4                 ; -> 1002fec4
1002feb8  88fe001e    lbz r7,0x1e(r30)            
1002febc  54e707ff    rlwinm. r7,r7,0x0,0x1f,0x1f 
1002fec0  4082003c    bne 0x1002fefc                 ; -> 1002fefc
1002fec4  89040000    lbz r8,0x0(r4)              
1002fec8  28080000    cmplwi r8,0x0               
1002fecc  41820010    beq 0x1002fedc                 ; -> 1002fedc
1002fed0  81230024    lwz r9,0x24(r3)             
1002fed4  552906f7    rlwinm. r9,r9,0x0,0x1b,0x1b 
1002fed8  40820024    bne 0x1002fefc                 ; -> 1002fefc
1002fedc  89450000    lbz r10,0x0(r5)             
1002fee0  280a0000    cmplwi r10,0x0              
1002fee4  41820010    beq 0x1002fef4                 ; -> 1002fef4
1002fee8  81630024    lwz r11,0x24(r3)            
1002feec  556b05f5    rlwinm. r11,r11,0x0,0x17,0x1a
1002fef0  4082000c    bne 0x1002fefc                 ; -> 1002fefc
1002fef4  38600000    li r3,0x0                   
1002fef8  48000008    b 0x1002ff00                   ; -> 1002ff00
1002fefc  3860ffce    li r3,-0x32                 
1002ff00  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002ff04  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002ff08  4e800020    blr                         
