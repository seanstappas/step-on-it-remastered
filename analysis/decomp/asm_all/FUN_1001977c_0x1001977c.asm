; FUN_1001977c @ 0x1001977c
1001977c  7c0802a6    mfspr r0,LR                 
10019780  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
10019784  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10019788  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001978c  3ba00200    li r29,0x200                
10019790  3b624f08    addi r27,r2,0x4f08          
10019794  57a3083c    rlwinm r3,r29,0x1,0x0,0x1e  
10019798  48017cf9    bl 0x10031490                  ; -> 10031490
1001979c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
100197a0  907b0006    stw r3,0x6(r27)             
100197a4  807b0006    lwz r3,0x6(r27)             
100197a8  28030000    cmplwi r3,0x0               
100197ac  4082000c    bne 0x100197b8                 ; -> 100197b8
100197b0  38600000    li r3,0x0                   
100197b4  48000080    b 0x10019834                   ; -> 10019834
100197b8  3b800004    li r28,0x4                  
100197bc  7f9ce1d6    mullw r28,r28,r28           
100197c0  3f400020    lis r26,0x20                
100197c4  3bc00000    li r30,0x0                  
100197c8  48000028    b 0x100197f0                   ; -> 100197f0
100197cc  7c9ee850    subf r4,r30,r29             
100197d0  23e40200    subfic r31,r4,0x200         
100197d4  7ffff9d6    mullw r31,r31,r31           
100197d8  7fffe3d6    divw r31,r31,r28            
100197dc  7ffff9d6    mullw r31,r31,r31           
100197e0  7cbfd3d6    divw r5,r31,r26             
100197e4  80db0006    lwz r6,0x6(r27)             
100197e8  7ca6f1ae    stbx r5,r6,r30              
100197ec  3bde0001    addi r30,r30,0x1            
100197f0  7c1ee800    cmpw r30,r29                
100197f4  4180ffd8    blt 0x100197cc                 ; -> 100197cc
100197f8  3bc00000    li r30,0x0                  
100197fc  4800002c    b 0x10019828                   ; -> 10019828
10019800  23fe0200    subfic r31,r30,0x200        
10019804  7ffff9d6    mullw r31,r31,r31           
10019808  7fffe3d6    divw r31,r31,r28            
1001980c  7ffff9d6    mullw r31,r31,r31           
10019810  7cffd3d6    divw r7,r31,r26             
10019814  811b0006    lwz r8,0x6(r27)             
10019818  20e700ff    subfic r7,r7,0xff           
1001981c  7d08ea14    add r8,r8,r29               
10019820  7cfe41ae    stbx r7,r30,r8              
10019824  3bde0001    addi r30,r30,0x1            
10019828  7c1ee800    cmpw r30,r29                
1001982c  4180ffd4    blt 0x10019800                 ; -> 10019800
10019830  38600001    li r3,0x1                   
10019834  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10019838  38210050    addi r1,r1,0x50             
1001983c  7c0803a6    mtspr LR,r0                 
10019840  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
10019844  4e800020    blr                         
