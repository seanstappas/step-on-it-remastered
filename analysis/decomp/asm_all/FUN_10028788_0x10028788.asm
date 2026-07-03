; FUN_10028788 @ 0x10028788
10028788  7c0802a6    mfspr r0,LR                 
1002878c  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10028790  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10028794  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10028798  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002879c  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
100287a0  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
100287a4  7c9d2378    or r29,r4,r4                
100287a8  a861006a    lha r3,0x6a(r1)                ; -> Stack[0x1a]
100287ac  48008edd    bl 0x10031688                  ; -> 10031688
100287b0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
100287b4  3bc00000    li r30,0x0                  
100287b8  3c60424f    lis r3,0x424f               
100287bc  38635244    addi r3,r3,0x5244           
100287c0  7c9df214    add r4,r29,r30              
100287c4  48008f0d    bl 0x100316d0                  ; -> 100316d0
100287c8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
100287cc  7c7f1b78    or r31,r3,r3                
100287d0  4800002c    b 0x100287fc                   ; -> 100287fc
100287d4  7fe3fb78    or r3,r31,r31               
100287d8  48008f89    bl 0x10031760                  ; -> 10031760
100287dc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
100287e0  3bde0001    addi r30,r30,0x1            
100287e4  3c60424f    lis r3,0x424f               
100287e8  38635244    addi r3,r3,0x5244           
100287ec  7c9df214    add r4,r29,r30              
100287f0  48008ee1    bl 0x100316d0                  ; -> 100316d0
100287f4  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
100287f8  7c7f1b78    or r31,r3,r3                
100287fc  281f0000    cmplwi r31,0x0              
10028800  4082ffd4    bne 0x100287d4                 ; -> 100287d4
10028804  7fc3f378    or r3,r30,r30               
10028808  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002880c  38210050    addi r1,r1,0x50             
10028810  7c0803a6    mtspr LR,r0                 
10028814  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10028818  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002881c  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10028820  4e800020    blr                         
