; FUN_1000f3f0 @ 0x1000f3f0
1000f3f0  7c0802a6    mfspr r0,LR                 
1000f3f4  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1000f3f8  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000f3fc  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1000f400  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000f404  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000f408  7c7e1b78    or r30,r3,r3                
1000f40c  b081006e    sth r4,0x6e(r1)                ; -> Stack[0x1e]
1000f410  7fc30734    extsh r3,r30                
1000f414  1c630070    mulli r3,r3,0x70            
1000f418  3be26840    addi r31,r2,0x6840          
1000f41c  38630040    addi r3,r3,0x40             
1000f420  7c7f1aae    lhax r3,r31,r3              
1000f424  2c0303e8    cmpwi r3,0x3e8              
1000f428  41810088    bgt 0x1000f4b0                 ; -> 1000f4b0
1000f42c  388269fe    addi r4,r2,0x69fe           
1000f430  88840000    lbz r4,0x0(r4)              
1000f434  28040000    cmplwi r4,0x0               
1000f438  41820070    beq 0x1000f4a8                 ; -> 1000f4a8
1000f43c  38a22f74    addi r5,r2,0x2f74           
1000f440  88a50000    lbz r5,0x0(r5)              
1000f444  28050000    cmplwi r5,0x0               
1000f448  41820060    beq 0x1000f4a8                 ; -> 1000f4a8
1000f44c  7fc60734    extsh r6,r30                
1000f450  2c060001    cmpwi r6,0x1                
1000f454  40820024    bne 0x1000f478                 ; -> 1000f478
1000f458  a8ff0120    lha r7,0x120(r31)           
1000f45c  2c0703e8    cmpwi r7,0x3e8              
1000f460  41810010    bgt 0x1000f470                 ; -> 1000f470
1000f464  891f011a    lbz r8,0x11a(r31)           
1000f468  28080000    cmplwi r8,0x0               
1000f46c  4182000c    beq 0x1000f478                 ; -> 1000f478
1000f470  48009655    bl 0x10018ac4                  ; -> 10018ac4
1000f474  60000000    ori r0,r0,0x0               
1000f478  7fc90734    extsh r9,r30                
1000f47c  2c090002    cmpwi r9,0x2                
1000f480  40820030    bne 0x1000f4b0                 ; -> 1000f4b0
1000f484  a95f00b0    lha r10,0xb0(r31)           
1000f488  2c0a03e8    cmpwi r10,0x3e8             
1000f48c  41810010    bgt 0x1000f49c                 ; -> 1000f49c
1000f490  897f00aa    lbz r11,0xaa(r31)           
1000f494  280b0000    cmplwi r11,0x0              
1000f498  41820018    beq 0x1000f4b0                 ; -> 1000f4b0
1000f49c  48009629    bl 0x10018ac4                  ; -> 10018ac4
1000f4a0  60000000    ori r0,r0,0x0               
1000f4a4  4800000c    b 0x1000f4b0                   ; -> 1000f4b0
1000f4a8  4800961d    bl 0x10018ac4                  ; -> 10018ac4
1000f4ac  60000000    ori r0,r0,0x0               
1000f4b0  7fc30734    extsh r3,r30                
1000f4b4  1c630070    mulli r3,r3,0x70            
1000f4b8  38630040    addi r3,r3,0x40             
1000f4bc  a981006e    lha r12,0x6e(r1)               ; -> Stack[0x1e]
1000f4c0  7c7f1aae    lhax r3,r31,r3              
1000f4c4  7fac1a14    add r29,r12,r3              
1000f4c8  2c1d7530    cmpwi r29,0x7530            
1000f4cc  40810008    ble 0x1000f4d4                 ; -> 1000f4d4
1000f4d0  3ba07530    li r29,0x7530               
1000f4d4  7fc40734    extsh r4,r30                
1000f4d8  1c840070    mulli r4,r4,0x70            
1000f4dc  38840040    addi r4,r4,0x40             
1000f4e0  7fbf232e    sthx r29,r31,r4             
1000f4e4  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1000f4e8  38210050    addi r1,r1,0x50             
1000f4ec  7c0803a6    mtspr LR,r0                 
1000f4f0  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1000f4f4  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1000f4f8  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1000f4fc  4e800020    blr                         
