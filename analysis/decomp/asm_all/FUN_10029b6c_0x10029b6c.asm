; FUN_10029b6c @ 0x10029b6c
10029b6c  7c0802a6    mfspr r0,LR                 
10029b70  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10029b74  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10029b78  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10029b7c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10029b80  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10029b84  3be27560    addi r31,r2,0x7560          
10029b88  3882755c    addi r4,r2,0x755c           
10029b8c  807f0000    lwz r3,0x0(r31)             
10029b90  80840000    lwz r4,0x0(r4)              
10029b94  80630000    lwz r3,0x0(r3)              
10029b98  7c632050    subf r3,r3,r4               
10029b9c  3bc30004    addi r30,r3,0x4             
10029ba0  807f0000    lwz r3,0x0(r31)             
10029ba4  4800746d    bl 0x10031010                  ; -> 10031010
10029ba8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10029bac  807f0000    lwz r3,0x0(r31)             
10029bb0  7fc4f378    or r4,r30,r30               
10029bb4  480079e5    bl 0x10031598                  ; -> 10031598
10029bb8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10029bbc  3c60444d    lis r3,0x444d               
10029bc0  38634b59    addi r3,r3,0x4b59           
10029bc4  480088d5    bl 0x10032498                  ; -> 10032498
10029bc8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10029bcc  7c7d1b78    or r29,r3,r3                
10029bd0  3c80444d    lis r4,0x444d               
10029bd4  807f0000    lwz r3,0x0(r31)             
10029bd8  38844b59    addi r4,r4,0x4b59           
10029bdc  7fa5eb78    or r5,r29,r29               
10029be0  38c00000    li r6,0x0                   
10029be4  48007b4d    bl 0x10031730                  ; -> 10031730
10029be8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
10029bec  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10029bf0  38210050    addi r1,r1,0x50             
10029bf4  7c0803a6    mtspr LR,r0                 
10029bf8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10029bfc  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10029c00  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10029c04  4e800020    blr                         
