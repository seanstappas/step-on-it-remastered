; FUN_1002b888 @ 0x1002b888
1002b888  7c0802a6    mfspr r0,LR                 
1002b88c  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1002b890  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002b894  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1002b898  7c7b1b78    or r27,r3,r3                
1002b89c  7c9c2378    or r28,r4,r4                
1002b8a0  7cbd2b78    or r29,r5,r5                
1002b8a4  3bc26bb8    addi r30,r2,0x6bb8          
1002b8a8  3be00004    li r31,0x4                  
1002b8ac  48000034    b 0x1002b8e0                   ; -> 1002b8e0
1002b8b0  7fe50734    extsh r5,r31                
1002b8b4  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1002b8b8  7cbb2aae    lhax r5,r27,r5              
1002b8bc  20df0004    subfic r6,r31,0x4           
1002b8c0  38850005    addi r4,r5,0x5              
1002b8c4  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
1002b8c8  7cbc3214    add r5,r28,r6               
1002b8cc  807e0000    lwz r3,0x0(r30)             
1002b8d0  7fa6eb78    or r6,r29,r29               
1002b8d4  4bfd92e1    bl 0x10004bb4                  ; -> 10004bb4
1002b8d8  60000000    ori r0,r0,0x0               
1002b8dc  3bffffff    subi r31,r31,0x1            
1002b8e0  7fe70734    extsh r7,r31                
1002b8e4  2c070000    cmpwi r7,0x0                
1002b8e8  4080ffc8    bge 0x1002b8b0                 ; -> 1002b8b0
1002b8ec  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1002b8f0  38210050    addi r1,r1,0x50             
1002b8f4  7c0803a6    mtspr LR,r0                 
1002b8f8  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1002b8fc  4e800020    blr                         
