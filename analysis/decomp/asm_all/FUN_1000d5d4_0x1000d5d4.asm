; FUN_1000d5d4 @ 0x1000d5d4
1000d5d4  7c0802a6    mfspr r0,LR                 
1000d5d8  bf41ffe8    stmw r26,-0x18(r1)             ; -> Stack[-0x18]
1000d5dc  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000d5e0  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000d5e4  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
1000d5e8  a861006a    lha r3,0x6a(r1)                ; -> Stack[0x1a]
1000d5ec  3bc23cd8    addi r30,r2,0x3cd8          
1000d5f0  1c630046    mulli r3,r3,0x46            
1000d5f4  7ffe1a14    add r31,r30,r3              
1000d5f8  889f001f    lbz r4,0x1f(r31)            
1000d5fc  3b8261a4    addi r28,r2,0x61a4          
1000d600  28040000    cmplwi r4,0x0               
1000d604  41820094    beq 0x1000d698                 ; -> 1000d698
1000d608  38a00000    li r5,0x0                   
1000d60c  98bf001f    stb r5,0x1f(r31)            
1000d610  38c00001    li r6,0x1                   
1000d614  98df0035    stb r6,0x35(r31)            
1000d618  a8ff0006    lha r7,0x6(r31)             
1000d61c  38800032    li r4,0x32                  
1000d620  1ce70006    mulli r7,r7,0x6             
1000d624  b0ff0024    sth r7,0x24(r31)            
1000d628  807c0028    lwz r3,0x28(r28)            
1000d62c  a8bf0010    lha r5,0x10(r31)            
1000d630  a8df0012    lha r6,0x12(r31)            
1000d634  4bff6ad5    bl 0x10004108                  ; -> 10004108
1000d638  60000000    ori r0,r0,0x0               
1000d63c  a93f0012    lha r9,0x12(r31)            
1000d640  39000100    li r8,0x100                 
1000d644  7d1b4378    or r27,r8,r8                
1000d648  3869000a    addi r3,r9,0xa              
1000d64c  480210ad    bl 0x1002e6f8                  ; -> 1002e6f8
1000d650  60000000    ori r0,r0,0x0               
1000d654  7c630734    extsh r3,r3                 
1000d658  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1000d65c  a95f0010    lha r10,0x10(r31)           
1000d660  7c7a1b78    or r26,r3,r3                
1000d664  386a000a    addi r3,r10,0xa             
1000d668  48021065    bl 0x1002e6cc                  ; -> 1002e6cc
1000d66c  60000000    ori r0,r0,0x0               
1000d670  7c630734    extsh r3,r3                 
1000d674  1c63003c    mulli r3,r3,0x3c            
1000d678  7c63d214    add r3,r3,r26               
1000d67c  39626bf8    addi r11,r2,0x6bf8          
1000d680  398003e8    li r12,0x3e8                
1000d684  7f6b192e    stwx r27,r11,r3             
1000d688  b19f0038    sth r12,0x38(r31)           
1000d68c  3b400000    li r26,0x0                  
1000d690  9b5f001e    stb r26,0x1e(r31)           
1000d694  4800002c    b 0x1000d6c0                   ; -> 1000d6c0
1000d698  3b623bde    addi r27,r2,0x3bde          
1000d69c  8b7b0000    lbz r27,0x0(r27)            
1000d6a0  281b0000    cmplwi r27,0x0              
1000d6a4  4182001c    beq 0x1000d6c0                 ; -> 1000d6c0
1000d6a8  807c0028    lwz r3,0x28(r28)            
1000d6ac  a8bf0010    lha r5,0x10(r31)            
1000d6b0  a8df0012    lha r6,0x12(r31)            
1000d6b4  38800032    li r4,0x32                  
1000d6b8  4bff6a51    bl 0x10004108                  ; -> 10004108
1000d6bc  60000000    ori r0,r0,0x0               
1000d6c0  a87f0024    lha r3,0x24(r31)            
1000d6c4  7c641b78    or r4,r3,r3                 
1000d6c8  7c840734    extsh r4,r4                 
1000d6cc  3863ffff    subi r3,r3,0x1              
1000d6d0  2c040000    cmpwi r4,0x0                
1000d6d4  b07f0024    sth r3,0x24(r31)            
1000d6d8  408201d8    bne 0x1000d8b0                 ; -> 1000d8b0
1000d6dc  4bff826d    bl 0x10005948                  ; -> 10005948
1000d6e0  60000000    ori r0,r0,0x0               
1000d6e4  a8bf0004    lha r5,0x4(r31)             
1000d6e8  7c7d1b78    or r29,r3,r3                
1000d6ec  2c050004    cmpwi r5,0x4                
1000d6f0  40820024    bne 0x1000d714                 ; -> 1000d714
1000d6f4  a87f0010    lha r3,0x10(r31)            
1000d6f8  4bff7dad    bl 0x100054a4                  ; -> 100054a4
1000d6fc  60000000    ori r0,r0,0x0               
1000d700  7fa60734    extsh r6,r29                
1000d704  1cc60046    mulli r6,r6,0x46            
1000d708  38c60004    addi r6,r6,0x4              
1000d70c  7c7e332e    sthx r3,r30,r6              
1000d710  480000a0    b 0x1000d7b0                   ; -> 1000d7b0
1000d714  a8ff0004    lha r7,0x4(r31)             
1000d718  2c070003    cmpwi r7,0x3                
1000d71c  40820050    bne 0x1000d76c                 ; -> 1000d76c
1000d720  891f0034    lbz r8,0x34(r31)            
1000d724  28080000    cmplwi r8,0x0               
1000d728  41820024    beq 0x1000d74c                 ; -> 1000d74c
1000d72c  7faa0734    extsh r10,r29               
1000d730  1d4a0046    mulli r10,r10,0x46          
1000d734  39200001    li r9,0x1                   
1000d738  394a0004    addi r10,r10,0x4            
1000d73c  7d3e532e    sthx r9,r30,r10             
1000d740  39600000    li r11,0x0                  
1000d744  997f0034    stb r11,0x34(r31)           
1000d748  48000068    b 0x1000d7b0                   ; -> 1000d7b0
1000d74c  7fba0734    extsh r26,r29               
1000d750  1f5a0046    mulli r26,r26,0x46          
1000d754  39800002    li r12,0x2                  
1000d758  3b5a0004    addi r26,r26,0x4            
1000d75c  7d9ed32e    sthx r12,r30,r26            
1000d760  3b600001    li r27,0x1                  
1000d764  9b7f0034    stb r27,0x34(r31)           
1000d768  48000048    b 0x1000d7b0                   ; -> 1000d7b0
1000d76c  a87f0004    lha r3,0x4(r31)             
1000d770  2c030002    cmpwi r3,0x2                
1000d774  4082001c    bne 0x1000d790                 ; -> 1000d790
1000d778  7fa50734    extsh r5,r29                
1000d77c  1ca50046    mulli r5,r5,0x46            
1000d780  38800002    li r4,0x2                   
1000d784  38a50004    addi r5,r5,0x4              
1000d788  7c9e2b2e    sthx r4,r30,r5              
1000d78c  48000024    b 0x1000d7b0                   ; -> 1000d7b0
1000d790  a8df0004    lha r6,0x4(r31)             
1000d794  2c060001    cmpwi r6,0x1                
1000d798  40820018    bne 0x1000d7b0                 ; -> 1000d7b0
1000d79c  7fa80734    extsh r8,r29                
1000d7a0  1d080046    mulli r8,r8,0x46            
1000d7a4  38e00001    li r7,0x1                   
1000d7a8  39080004    addi r8,r8,0x4              
1000d7ac  7cfe432e    sthx r7,r30,r8              
1000d7b0  7fa90734    extsh r9,r29                
1000d7b4  1d290046    mulli r9,r9,0x46            
1000d7b8  39290004    addi r9,r9,0x4              
1000d7bc  7d3e4aae    lhax r9,r30,r9              
1000d7c0  2c090002    cmpwi r9,0x2                
1000d7c4  40820034    bne 0x1000d7f8                 ; -> 1000d7f8
1000d7c8  7fab0734    extsh r11,r29               
1000d7cc  1d6b0046    mulli r11,r11,0x46          
1000d7d0  7fba0734    extsh r26,r29               
1000d7d4  1f5a0046    mulli r26,r26,0x46          
1000d7d8  a95f0010    lha r10,0x10(r31)           
1000d7dc  396b0010    addi r11,r11,0x10           
1000d7e0  7d5e5b2e    sthx r10,r30,r11            
1000d7e4  a99f0012    lha r12,0x12(r31)           
1000d7e8  3b5a0012    addi r26,r26,0x12           
1000d7ec  398c0004    addi r12,r12,0x4            
1000d7f0  7d9ed32e    sthx r12,r30,r26            
1000d7f4  48000048    b 0x1000d83c                   ; -> 1000d83c
1000d7f8  7fbb0734    extsh r27,r29               
1000d7fc  1f7b0046    mulli r27,r27,0x46          
1000d800  3b7b0004    addi r27,r27,0x4            
1000d804  7f7edaae    lhax r27,r30,r27            
1000d808  2c1b0001    cmpwi r27,0x1               
1000d80c  40820030    bne 0x1000d83c                 ; -> 1000d83c
1000d810  7fa40734    extsh r4,r29                
1000d814  1c840046    mulli r4,r4,0x46            
1000d818  7fa60734    extsh r6,r29                
1000d81c  1cc60046    mulli r6,r6,0x46            
1000d820  a87f0010    lha r3,0x10(r31)            
1000d824  38840010    addi r4,r4,0x10             
1000d828  7c7e232e    sthx r3,r30,r4              
1000d82c  a8bf0012    lha r5,0x12(r31)            
1000d830  38c60012    addi r6,r6,0x12             
1000d834  38a50004    addi r5,r5,0x4              
1000d838  7cbe332e    sthx r5,r30,r6              
1000d83c  7fa80734    extsh r8,r29                
1000d840  1d080046    mulli r8,r8,0x46            
1000d844  7faa0734    extsh r10,r29               
1000d848  1d4a0046    mulli r10,r10,0x46          
1000d84c  7fac0734    extsh r12,r29               
1000d850  1d8c0046    mulli r12,r12,0x46          
1000d854  7fbb0734    extsh r27,r29               
1000d858  1f7b0046    mulli r27,r27,0x46          
1000d85c  7fa40734    extsh r4,r29                
1000d860  1c840046    mulli r4,r4,0x46            
1000d864  38e0006e    li r7,0x6e                  
1000d868  39080002    addi r8,r8,0x2              
1000d86c  7cfe432e    sthx r7,r30,r8              
1000d870  813c0028    lwz r9,0x28(r28)            
1000d874  394a000a    addi r10,r10,0xa            
1000d878  7d3e512e    stwx r9,r30,r10             
1000d87c  39600000    li r11,0x0                  
1000d880  398c0014    addi r12,r12,0x14           
1000d884  7d7e612e    stwx r11,r30,r12            
1000d888  3b400000    li r26,0x0                  
1000d88c  3b7b001e    addi r27,r27,0x1e           
1000d890  7f5ed9ae    stbx r26,r30,r27            
1000d894  a87f0008    lha r3,0x8(r31)             
1000d898  3884002c    addi r4,r4,0x2c             
1000d89c  54631838    rlwinm r3,r3,0x3,0x0,0x1c   
1000d8a0  7c7e232e    sthx r3,r30,r4              
1000d8a4  a8bf0008    lha r5,0x8(r31)             
1000d8a8  1ca50006    mulli r5,r5,0x6             
1000d8ac  b0bf0024    sth r5,0x24(r31)            
1000d8b0  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000d8b4  38210050    addi r1,r1,0x50             
1000d8b8  7c0803a6    mtspr LR,r0                 
1000d8bc  bb41ffe8    lmw r26,-0x18(r1)              ; -> Stack[-0x18]
1000d8c0  4e800020    blr                         
