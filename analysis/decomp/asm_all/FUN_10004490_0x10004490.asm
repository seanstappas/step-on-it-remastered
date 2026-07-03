; FUN_10004490 @ 0x10004490
10004490  7c0802a6    mfspr r0,LR                 
10004494  bec1ffd8    stmw r22,-0x28(r1)             ; -> Stack[-0x28]
10004498  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000449c  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
100044a0  7c7d1b78    or r29,r3,r3                
100044a4  7c962378    or r22,r4,r4                
100044a8  7cb72b78    or r23,r5,r5                
100044ac  7cd83378    or r24,r6,r6                
100044b0  7cf93b78    or r25,r7,r7                
100044b4  7d1a4378    or r26,r8,r8                
100044b8  7d3b4b78    or r27,r9,r9                
100044bc  7d5c5378    or r28,r10,r10              
100044c0  7c1dc840    cmplw r29,r25               
100044c4  3bc26bd0    addi r30,r2,0x6bd0          
100044c8  3be26bd4    addi r31,r2,0x6bd4          
100044cc  40820050    bne 0x1000451c                 ; -> 1000451c
100044d0  a87e0000    lha r3,0x0(r30)             
100044d4  38826bdc    addi r4,r2,0x6bdc           
100044d8  90610038    stw r3,0x38(r1)                ; -> Stack[-0x38]
100044dc  80840000    lwz r4,0x0(r4)              
100044e0  38a26bd8    addi r5,r2,0x6bd8           
100044e4  9081003c    stw r4,0x3c(r1)                ; -> Stack[-0x34]
100044e8  80a50000    lwz r5,0x0(r5)              
100044ec  7fa3eb78    or r3,r29,r29               
100044f0  90a10040    stw r5,0x40(r1)                ; -> Stack[-0x30]
100044f4  815f0000    lwz r10,0x0(r31)            
100044f8  7ec4b378    or r4,r22,r22               
100044fc  7ee5bb78    or r5,r23,r23               
10004500  7f06c378    or r6,r24,r24               
10004504  7f47d378    or r7,r26,r26               
10004508  7f68db78    or r8,r27,r27               
1000450c  7f89e378    or r9,r28,r28               
10004510  4bffd661    bl 0x10001b70                  ; -> 10001b70
10004514  60000000    ori r0,r0,0x0               
10004518  48000054    b 0x1000456c                   ; -> 1000456c
1000451c  39426bdc    addi r10,r2,0x6bdc          
10004520  39626bd8    addi r11,r2,0x6bd8          
10004524  812a0000    lwz r9,0x0(r10)             
10004528  80ff0000    lwz r7,0x0(r31)             
1000452c  a91e0000    lha r8,0x0(r30)             
10004530  814b0000    lwz r10,0x0(r11)            
10004534  7fa3eb78    or r3,r29,r29               
10004538  7ec4b378    or r4,r22,r22               
1000453c  7ee5bb78    or r5,r23,r23               
10004540  7f06c378    or r6,r24,r24               
10004544  4bffcf35    bl 0x10001478                  ; -> 10001478
10004548  60000000    ori r0,r0,0x0               
1000454c  80ff0000    lwz r7,0x0(r31)             
10004550  a91e0000    lha r8,0x0(r30)             
10004554  7f23cb78    or r3,r25,r25               
10004558  7f44d378    or r4,r26,r26               
1000455c  7f65db78    or r5,r27,r27               
10004560  7f86e378    or r6,r28,r28               
10004564  4bffd3f9    bl 0x1000195c                  ; -> 1000195c
10004568  60000000    ori r0,r0,0x0               
1000456c  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
10004570  38210070    addi r1,r1,0x70             
10004574  7c0803a6    mtspr LR,r0                 
10004578  bac1ffd8    lmw r22,-0x28(r1)              ; -> Stack[-0x28]
1000457c  4e800020    blr                         
