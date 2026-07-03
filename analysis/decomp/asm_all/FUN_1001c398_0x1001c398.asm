; FUN_1001c398 @ 0x1001c398
1001c398  7c0802a6    mfspr r0,LR                 
1001c39c  bde1ffbc    stmw r15,-0x44(r1)             ; -> Stack[-0x44]
1001c3a0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001c3a4  9421fe70    stwu r1,-0x190(r1)             ; -> Stack[-0x190]
1001c3a8  906101a8    stw r3,0x1a8(r1)               ; -> Stack[0x18]
1001c3ac  908101ac    stw r4,0x1ac(r1)               ; -> Stack[0x1c]
1001c3b0  806101a8    lwz r3,0x1a8(r1)               ; -> Stack[0x18]
1001c3b4  808101a8    lwz r4,0x1a8(r1)               ; -> Stack[0x18]
1001c3b8  5463843e    rlwinm r3,r3,0x10,0x10,0x1f 
1001c3bc  b0610138    sth r3,0x138(r1)               ; -> Stack[-0x58]
1001c3c0  a8a10138    lha r5,0x138(r1)               ; -> Stack[-0x58]
1001c3c4  3aa25240    addi r21,r2,0x5240          
1001c3c8  38a5ff9c    subi r5,r5,0x64             
1001c3cc  28050021    cmplwi r5,0x21              
1001c3d0  3a625260    addi r19,r2,0x5260          
1001c3d4  3a02523d    addi r16,r2,0x523d          
1001c3d8  3a22342e    addi r17,r2,0x342e          
1001c3dc  3ac25250    addi r22,r2,0x5250          
1001c3e0  3a424fe4    addi r18,r2,0x4fe4          
1001c3e4  3ae25248    addi r23,r2,0x5248          
1001c3e8  3ba25242    addi r29,r2,0x5242          
1001c3ec  3b425258    addi r26,r2,0x5258          
1001c3f0  3a827100    addi r20,r2,0x7100          
1001c3f4  3b025254    addi r24,r2,0x5254          
1001c3f8  3b22524c    addi r25,r2,0x524c          
1001c3fc  3bc25244    addi r30,r2,0x5244          
1001c400  3b62525c    addi r27,r2,0x525c          
1001c404  3b824fe5    addi r28,r2,0x4fe5          
1001c408  549f043e    rlwinm r31,r4,0x0,0x10,0x1f 
1001c40c  418108f4    bgt 0x1001cd00                 ; -> 1001cd00
1001c410  38c20bdc    addi r6,r2,0xbdc            
1001c414  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
1001c418  7cc6282e    lwzx r6,r6,r5               
1001c41c  7cc903a6    mtspr CTR,r6                
1001c420  4e800420    bctr                        
1001cd00  38600000    li r3,0x0                   
1001cd04  4801574d    bl 0x10032450                  ; -> 10032450
1001cd08  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x17c]
1001cd0c  80010198    lwz r0,0x198(r1)               ; -> Stack[0x8]
1001cd10  38210190    addi r1,r1,0x190            
1001cd14  7c0803a6    mtspr LR,r0                 
1001cd18  b9e1ffbc    lmw r15,-0x44(r1)              ; -> Stack[-0x44]
1001cd1c  4e800020    blr                         
