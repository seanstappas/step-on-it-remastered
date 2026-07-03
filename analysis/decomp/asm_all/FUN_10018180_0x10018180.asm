; FUN_10018180 @ 0x10018180
10018180  7c0802a6    mfspr r0,LR                 
10018184  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10018188  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001818c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10018190  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10018194  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10018198  3ba261a4    addi r29,r2,0x61a4          
1001819c  3bc24e88    addi r30,r2,0x4e88          
100181a0  3be00001    li r31,0x1                  
100181a4  48000048    b 0x100181ec                   ; -> 100181ec
100181a8  7fe30734    extsh r3,r31                
100181ac  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100181b0  38630001    addi r3,r3,0x1              
100181b4  7c7e18ae    lbzx r3,r30,r3              
100181b8  28030000    cmplwi r3,0x0               
100181bc  4182002c    beq 0x100181e8                 ; -> 100181e8
100181c0  7fe40734    extsh r4,r31                
100181c4  5484103a    rlwinm r4,r4,0x2,0x0,0x1d   
100181c8  7c7d202e    lwzx r3,r29,r4              
100181cc  48018e8d    bl 0x10031058                  ; -> 10031058
100181d0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
100181d4  7fe60734    extsh r6,r31                
100181d8  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
100181dc  38a00000    li r5,0x0                   
100181e0  38c60001    addi r6,r6,0x1              
100181e4  7cbe31ae    stbx r5,r30,r6              
100181e8  3bff0001    addi r31,r31,0x1            
100181ec  7fe70734    extsh r7,r31                
100181f0  2c070013    cmpwi r7,0x13               
100181f4  4081ffb4    ble 0x100181a8                 ; -> 100181a8
100181f8  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
100181fc  38210050    addi r1,r1,0x50             
10018200  7c0803a6    mtspr LR,r0                 
10018204  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10018208  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001820c  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10018210  4e800020    blr                         
