; FUN_1001bdd4 @ 0x1001bdd4
1001bdd4  7c0802a6    mfspr r0,LR                 
1001bdd8  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
1001bddc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001bde0  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
1001bde4  3be2757c    addi r31,r2,0x757c          
1001bde8  3b827544    addi r28,r2,0x7544          
1001bdec  3bc27530    addi r30,r2,0x7530          
1001bdf0  48011fa1    bl 0x1002dd90                  ; -> 1002dd90
1001bdf4  60000000    ori r0,r0,0x0               
1001bdf8  38e251e8    addi r7,r2,0x51e8           
1001bdfc  807e0000    lwz r3,0x0(r30)             
1001be00  80e70000    lwz r7,0x0(r7)              
1001be04  809e0000    lwz r4,0x0(r30)             
1001be08  80e70000    lwz r7,0x0(r7)              
1001be0c  80be0000    lwz r5,0x0(r30)             
1001be10  83a70016    lwz r29,0x16(r7)            
1001be14  80de0000    lwz r6,0x0(r30)             
1001be18  811d0000    lwz r8,0x0(r29)             
1001be1c  a8630012    lha r3,0x12(r3)             
1001be20  a8840016    lha r4,0x16(r4)             
1001be24  a8a50010    lha r5,0x10(r5)             
1001be28  a8c60014    lha r6,0x14(r6)             
1001be2c  7f632050    subf r27,r3,r4              
1001be30  7f453050    subf r26,r5,r6              
1001be34  81280006    lwz r9,0x6(r8)              
1001be38  8148000a    lwz r10,0xa(r8)             
1001be3c  39627534    addi r11,r2,0x7534          
1001be40  91210038    stw r9,0x38(r1)                ; -> Stack[-0x28]
1001be44  9141003c    stw r10,0x3c(r1)               ; -> Stack[-0x24]
1001be48  806b0000    lwz r3,0x0(r11)             
1001be4c  38800000    li r4,0x0                   
1001be50  38a00000    li r5,0x0                   
1001be54  38c00000    li r6,0x0                   
1001be58  48015ea9    bl 0x10031d00                  ; -> 10031d00
1001be5c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001be60  39827534    addi r12,r2,0x7534          
1001be64  a8a1003a    lha r5,0x3a(r1)                ; -> Stack[-0x26]
1001be68  a8c1003e    lha r6,0x3e(r1)                ; -> Stack[-0x22]
1001be6c  a8e10038    lha r7,0x38(r1)                ; -> Stack[-0x28]
1001be70  7c853050    subf r4,r5,r6               
1001be74  a901003c    lha r8,0x3c(r1)                ; -> Stack[-0x24]
1001be78  806c0000    lwz r3,0x0(r12)             
1001be7c  7ca74050    subf r5,r7,r8               
1001be80  38c00001    li r6,0x1                   
1001be84  48015e65    bl 0x10031ce8                  ; -> 10031ce8
1001be88  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001be8c  a941003e    lha r10,0x3e(r1)               ; -> Stack[-0x22]
1001be90  a961003a    lha r11,0x3a(r1)               ; -> Stack[-0x26]
1001be94  7f690734    extsh r9,r27                
1001be98  7d4a5a14    add r10,r10,r11             
1001be9c  7d295050    subf r9,r9,r10              
1001bea0  7d240e70    srawi r4,r9,0x1             
1001bea4  a8c1003c    lha r6,0x3c(r1)                ; -> Stack[-0x24]
1001bea8  a8e10038    lha r7,0x38(r1)                ; -> Stack[-0x28]
1001beac  7f4c0734    extsh r12,r26               
1001beb0  7cc63a14    add r6,r6,r7                
1001beb4  7d8c3050    subf r12,r12,r6             
1001beb8  7c840194    addze r4,r4                 
1001bebc  7d850e70    srawi r5,r12,0x1            
1001bec0  807e0000    lwz r3,0x0(r30)             
1001bec4  7ca50194    addze r5,r5                 
1001bec8  38c00000    li r6,0x0                   
1001becc  48015e35    bl 0x10031d00                  ; -> 10031d00
1001bed0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x4c]
1001bed4  811d0000    lwz r8,0x0(r29)             
1001bed8  38c26bd4    addi r6,r2,0x6bd4           
1001bedc  81280006    lwz r9,0x6(r8)              
1001bee0  8148000a    lwz r10,0xa(r8)             
1001bee4  913c0000    stw r9,0x0(r28)             
1001bee8  915c0004    stw r10,0x4(r28)            
1001beec  a97c0006    lha r11,0x6(r28)            
1001bef0  39026bd0    addi r8,r2,0x6bd0           
1001bef4  396bfd80    subi r11,r11,0x280          
1001bef8  7d6b0e70    srawi r11,r11,0x1           
1001befc  7d6b0194    addze r11,r11               
1001bf00  b17f0002    sth r11,0x2(r31)            
1001bf04  a99c0004    lha r12,0x4(r28)            
1001bf08  39426bd0    addi r10,r2,0x6bd0          
1001bf0c  398cfe20    subi r12,r12,0x1e0          
1001bf10  7d8c0e70    srawi r12,r12,0x1           
1001bf14  7d8c0194    addze r12,r12               
1001bf18  b19f0000    sth r12,0x0(r31)            
1001bf1c  a87f0002    lha r3,0x2(r31)             
1001bf20  39826bd4    addi r12,r2,0x6bd4          
1001bf24  38630280    addi r3,r3,0x280            
1001bf28  b07f0006    sth r3,0x6(r31)             
1001bf2c  a89f0000    lha r4,0x0(r31)             
1001bf30  388401e0    addi r4,r4,0x1e0            
1001bf34  b09f0004    sth r4,0x4(r31)             
1001bf38  80bd0000    lwz r5,0x0(r29)             
1001bf3c  80a50000    lwz r5,0x0(r5)              
1001bf40  90a60000    stw r5,0x0(r6)              
1001bf44  80fd0000    lwz r7,0x0(r29)             
1001bf48  a8e70004    lha r7,0x4(r7)              
1001bf4c  54e7047e    rlwinm r7,r7,0x0,0x11,0x1f  
1001bf50  b0e80000    sth r7,0x0(r8)              
1001bf54  a94a0000    lha r10,0x0(r10)            
1001bf58  a97f0000    lha r11,0x0(r31)            
1001bf5c  a93f0002    lha r9,0x2(r31)             
1001bf60  7d4b51d6    mullw r10,r11,r10           
1001bf64  806c0000    lwz r3,0x0(r12)             
1001bf68  7d295214    add r9,r9,r10               
1001bf6c  7c634a14    add r3,r3,r9                
1001bf70  906c0000    stw r3,0x0(r12)             
1001bf74  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
1001bf78  38210060    addi r1,r1,0x60             
1001bf7c  7c0803a6    mtspr LR,r0                 
1001bf80  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
1001bf84  4e800020    blr                         
