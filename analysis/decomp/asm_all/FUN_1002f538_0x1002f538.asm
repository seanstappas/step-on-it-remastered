; FUN_1002f538 @ 0x1002f538
1002f538  7c0802a6    mfspr r0,LR                 
1002f53c  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1002f540  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002f544  9421fd40    stwu r1,-0x2c0(r1)             ; -> Stack[-0x2c0]
1002f548  7c7c1b78    or r28,r3,r3                
1002f54c  7c9b2378    or r27,r4,r4                
1002f550  7cbd2b78    or r29,r5,r5                
1002f554  7f830734    extsh r3,r28                
1002f558  2c030000    cmpwi r3,0x0                
1002f55c  3be00000    li r31,0x0                  
1002f560  3bc00000    li r30,0x0                  
1002f564  408000c4    bge 0x1002f628                 ; -> 1002f628
1002f568  7c1be800    cmpw r27,r29                
1002f56c  4082000c    bne 0x1002f578                 ; -> 1002f578
1002f570  3bc00001    li r30,0x1                  
1002f574  480000b4    b 0x1002f628                   ; -> 1002f628
1002f578  38800000    li r4,0x0                   
1002f57c  9361029c    stw r27,0x29c(r1)              ; -> Stack[-0x24]
1002f580  38a10138    addi r5,r1,0x138            
1002f584  98810038    stb r4,0x38(r1)                ; -> Stack[-0x288]
1002f588  90a1024a    stw r5,0x24a(r1)               ; -> Stack[-0x76]
1002f58c  b381024e    sth r28,0x24e(r1)              ; -> Stack[-0x72]
1002f590  38c0ffff    li r6,-0x1                  
1002f594  b0c10254    sth r6,0x254(r1)               ; -> Stack[-0x6c]
1002f598  80e1029c    lwz r7,0x29c(r1)               ; -> Stack[-0x24]
1002f59c  38610238    addi r3,r1,0x238            
1002f5a0  90e10268    stw r7,0x268(r1)               ; -> Stack[-0x58]
1002f5a4  48001fc5    bl 0x10031568                  ; -> 10031568
1002f5a8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x2ac]
1002f5ac  7c7f1b78    or r31,r3,r3                
1002f5b0  7fe80734    extsh r8,r31                
1002f5b4  2c080000    cmpwi r8,0x0                
1002f5b8  4082005c    bne 0x1002f614                 ; -> 1002f614
1002f5bc  8121029c    lwz r9,0x29c(r1)               ; -> Stack[-0x24]
1002f5c0  7c09e800    cmpw r9,r29                 
1002f5c4  4082000c    bne 0x1002f5d0                 ; -> 1002f5d0
1002f5c8  3bc00001    li r30,0x1                  
1002f5cc  4800005c    b 0x1002f628                   ; -> 1002f628
1002f5d0  38610138    addi r3,r1,0x138            
1002f5d4  3882ffeb    subi r4,r2,0x15             
1002f5d8  38a10138    addi r5,r1,0x138            
1002f5dc  480001d9    bl 0x1002f7b4                  ; -> 1002f7b4
1002f5e0  7c7f1b78    or r31,r3,r3                
1002f5e4  7fea0734    extsh r10,r31               
1002f5e8  2c0a0000    cmpwi r10,0x0               
1002f5ec  4082003c    bne 0x1002f628                 ; -> 1002f628
1002f5f0  38610138    addi r3,r1,0x138            
1002f5f4  38810038    addi r4,r1,0x38             
1002f5f8  38a10038    addi r5,r1,0x38             
1002f5fc  480001b9    bl 0x1002f7b4                  ; -> 1002f7b4
1002f600  7c7f1b78    or r31,r3,r3                
1002f604  7feb0734    extsh r11,r31               
1002f608  2c0b0000    cmpwi r11,0x0               
1002f60c  4082001c    bne 0x1002f628                 ; -> 1002f628
1002f610  48000008    b 0x1002f618                   ; -> 1002f618
1002f614  48000014    b 0x1002f628                   ; -> 1002f628
1002f618  81810268    lwz r12,0x268(r1)              ; -> Stack[-0x58]
1002f61c  2c0c0002    cmpwi r12,0x2               
1002f620  4082ff6c    bne 0x1002f58c                 ; -> 1002f58c
1002f624  48000004    b 0x1002f628                   ; -> 1002f628
1002f628  7fc3f378    or r3,r30,r30               
1002f62c  800102c8    lwz r0,0x2c8(r1)               ; -> Stack[0x8]
1002f630  382102c0    addi r1,r1,0x2c0            
1002f634  7c0803a6    mtspr LR,r0                 
1002f638  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1002f63c  4e800020    blr                         
