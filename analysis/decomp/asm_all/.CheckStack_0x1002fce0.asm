; .CheckStack @ 0x1002fce0
1002fce0  7c0802a6    mfspr r0,LR                 
1002fce4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002fce8  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002fcec  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1002fcf0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002fcf4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002fcf8  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
1002fcfc  7c9d2378    or r29,r4,r4                
1002fd00  7cbe2b78    or r30,r5,r5                
1002fd04  807e0000    lwz r3,0x0(r30)             
1002fd08  3880000a    li r4,0xa                   
1002fd0c  7c632396    divwu r3,r3,r4              
1002fd10  a0a1006a    lhz r5,0x6a(r1)                ; -> Stack[0x1a]
1002fd14  38a50001    addi r5,r5,0x1              
1002fd18  7c032840    cmplw r3,r5                 
1002fd1c  40820038    bne 0x1002fd54                 ; -> 1002fd54
1002fd20  7fa3eb78    or r3,r29,r29               
1002fd24  80de0000    lwz r6,0x0(r30)             
1002fd28  388600c8    addi r4,r6,0xc8             
1002fd2c  4800186d    bl 0x10031598                  ; -> 10031598
1002fd30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1002fd34  4800187d    bl 0x100315b0                  ; -> 100315b0
1002fd38  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1002fd3c  7c7f1b78    or r31,r3,r3                
1002fd40  7fa3eb78    or r3,r29,r29               
1002fd44  4800180d    bl 0x10031550                  ; -> 10031550
1002fd48  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1002fd4c  907e0000    stw r3,0x0(r30)             
1002fd50  48000008    b 0x1002fd58                   ; -> 1002fd58
1002fd54  3be00000    li r31,0x0                  
1002fd58  7fe3fb78    or r3,r31,r31               
1002fd5c  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002fd60  38210050    addi r1,r1,0x50             
1002fd64  7c0803a6    mtspr LR,r0                 
1002fd68  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002fd6c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002fd70  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1002fd74  4e800020    blr                         
