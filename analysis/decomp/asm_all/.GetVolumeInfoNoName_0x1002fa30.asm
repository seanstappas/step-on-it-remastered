; .GetVolumeInfoNoName @ 0x1002fa30
1002fa30  7c0802a6    mfspr r0,LR                 
1002fa34  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002fa38  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002fa3c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1002fa40  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002fa44  9421feb0    stwu r1,-0x150(r1)             ; -> Stack[-0x150]
1002fa48  7c7d1b78    or r29,r3,r3                
1002fa4c  b081016e    sth r4,0x16e(r1)               ; -> Stack[0x1e]
1002fa50  7cbf2b78    or r31,r5,r5                
1002fa54  281f0000    cmplwi r31,0x0              
1002fa58  4182006c    beq 0x1002fac4                 ; -> 1002fac4
1002fa5c  a861016e    lha r3,0x16e(r1)               ; -> Stack[0x1e]
1002fa60  b07f0016    sth r3,0x16(r31)            
1002fa64  281d0000    cmplwi r29,0x0              
1002fa68  40820018    bne 0x1002fa80                 ; -> 1002fa80
1002fa6c  38800000    li r4,0x0                   
1002fa70  909f0012    stw r4,0x12(r31)            
1002fa74  38a00000    li r5,0x0                   
1002fa78  b0bf001c    sth r5,0x1c(r31)            
1002fa7c  4800002c    b 0x1002faa8                   ; -> 1002faa8
1002fa80  7fa3eb78    or r3,r29,r29               
1002fa84  38810038    addi r4,r1,0x38             
1002fa88  88dd0000    lbz r6,0x0(r29)             
1002fa8c  38a60001    addi r5,r6,0x1              
1002fa90  480019d1    bl 0x10031460                  ; -> 10031460
1002fa94  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x13c]
1002fa98  38e10038    addi r7,r1,0x38             
1002fa9c  90ff0012    stw r7,0x12(r31)            
1002faa0  3900ffff    li r8,-0x1                  
1002faa4  b11f001c    sth r8,0x1c(r31)            
1002faa8  7fe3fb78    or r3,r31,r31               
1002faac  480019cd    bl 0x10031478                  ; -> 10031478
1002fab0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x13c]
1002fab4  7c7e1b78    or r30,r3,r3                
1002fab8  39200000    li r9,0x0                   
1002fabc  913f0012    stw r9,0x12(r31)            
1002fac0  48000008    b 0x1002fac8                   ; -> 1002fac8
1002fac4  3bc0ffce    li r30,-0x32                
1002fac8  7fc3f378    or r3,r30,r30               
1002facc  80010158    lwz r0,0x158(r1)               ; -> Stack[0x8]
1002fad0  38210150    addi r1,r1,0x150            
1002fad4  7c0803a6    mtspr LR,r0                 
1002fad8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002fadc  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002fae0  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1002fae4  4e800020    blr                         
