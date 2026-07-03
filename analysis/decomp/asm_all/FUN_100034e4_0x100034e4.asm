; FUN_100034e4 @ 0x100034e4
100034e4  7c0802a6    mfspr r0,LR                 
100034e8  bee1ffdc    stmw r23,-0x24(r1)             ; -> Stack[-0x24]
100034ec  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
100034f0  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
100034f4  3b822fb4    addi r28,r2,0x2fb4          
100034f8  48025461    bl 0x10028958                  ; -> 10028958
100034fc  60000000    ori r0,r0,0x0               
10003500  38826bd0    addi r4,r2,0x6bd0           
10003504  38626bd4    addi r3,r2,0x6bd4           
10003508  a8840000    lha r4,0x0(r4)              
1000350c  83230000    lwz r25,0x0(r3)             
10003510  7c971670    srawi r23,r4,0x2            
10003514  7f3bcb78    or r27,r25,r25              
10003518  7ef70194    addze r23,r23               
1000351c  3b000000    li r24,0x0                  
10003520  4800009c    b 0x100035bc                   ; -> 100035bc
10003524  3b400000    li r26,0x0                  
10003528  48000078    b 0x100035a0                   ; -> 100035a0
1000352c  83db0000    lwz r30,0x0(r27)            
10003530  3b5a0001    addi r26,r26,0x1            
10003534  57dd063e    rlwinm r29,r30,0x0,0x18,0x1f
10003538  7fa50734    extsh r5,r29                
1000353c  57dec23e    rlwinm r30,r30,0x18,0x8,0x1f
10003540  57dd063e    rlwinm r29,r30,0x0,0x18,0x1f
10003544  54a5103a    rlwinm r5,r5,0x2,0x0,0x1d   
10003548  7fa60734    extsh r6,r29                
1000354c  57dec23e    rlwinm r30,r30,0x18,0x8,0x1f
10003550  57dd063e    rlwinm r29,r30,0x0,0x18,0x1f
10003554  7ffc282e    lwzx r31,r28,r5             
10003558  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1000355c  7fa70734    extsh r7,r29                
10003560  57dec23e    rlwinm r30,r30,0x18,0x8,0x1f
10003564  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
10003568  57dd063e    rlwinm r29,r30,0x0,0x18,0x1f
1000356c  7fa80734    extsh r8,r29                
10003570  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
10003574  7cdc302e    lwzx r6,r28,r6              
10003578  57ffc23e    rlwinm r31,r31,0x18,0x8,0x1f
1000357c  7fff3214    add r31,r31,r6              
10003580  7cfc382e    lwzx r7,r28,r7              
10003584  57ffc23e    rlwinm r31,r31,0x18,0x8,0x1f
10003588  7fff3a14    add r31,r31,r7              
1000358c  7d1c402e    lwzx r8,r28,r8              
10003590  57ffc23e    rlwinm r31,r31,0x18,0x8,0x1f
10003594  7fff4214    add r31,r31,r8              
10003598  93fb0000    stw r31,0x0(r27)            
1000359c  3b7b0004    addi r27,r27,0x4            
100035a0  7f490734    extsh r9,r26                
100035a4  2c0900a0    cmpwi r9,0xa0               
100035a8  4180ff84    blt 0x1000352c                 ; -> 1000352c
100035ac  56ea103a    rlwinm r10,r23,0x2,0x0,0x1d 
100035b0  7f395214    add r25,r25,r10             
100035b4  7f3bcb78    or r27,r25,r25              
100035b8  3b180001    addi r24,r24,0x1            
100035bc  7f0b0734    extsh r11,r24               
100035c0  2c0b01e0    cmpwi r11,0x1e0             
100035c4  4180ff60    blt 0x10003524                 ; -> 10003524
100035c8  480253f9    bl 0x100289c0                  ; -> 100289c0
100035cc  60000000    ori r0,r0,0x0               
100035d0  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
100035d4  38210060    addi r1,r1,0x60             
100035d8  7c0803a6    mtspr LR,r0                 
100035dc  bae1ffdc    lmw r23,-0x24(r1)              ; -> Stack[-0x24]
100035e0  4e800020    blr                         
