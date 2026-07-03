; FUN_1001f4f8 @ 0x1001f4f8
1001f4f8  7c0802a6    mfspr r0,LR                 
1001f4fc  be61ffcc    stmw r19,-0x34(r1)             ; -> Stack[-0x34]
1001f500  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001f504  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
1001f508  3b225262    addi r25,r2,0x5262          
1001f50c  38600000    li r3,0x0                   
1001f510  3a825348    addi r20,r2,0x5348          
1001f514  3aa2534c    addi r21,r2,0x534c          
1001f518  3be26840    addi r31,r2,0x6840          
1001f51c  3bc25332    addi r30,r2,0x5332          
1001f520  3ac25334    addi r22,r2,0x5334          
1001f524  3a6251ec    addi r19,r2,0x51ec          
1001f528  3b027128    addi r24,r2,0x7128          
1001f52c  3b82712c    addi r28,r2,0x712c          
1001f530  3ae2712a    addi r23,r2,0x712a          
1001f534  3b622f74    addi r27,r2,0x2f74          
1001f538  3ba25260    addi r29,r2,0x5260          
1001f53c  3b425263    addi r26,r2,0x5263          
1001f540  98790000    stb r3,0x0(r25)             
1001f544  48012c0d    bl 0x10032150                  ; -> 10032150
1001f548  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
1001f54c  480057b1    bl 0x10024cfc                  ; -> 10024cfc
1001f550  60000000    ori r0,r0,0x0               
1001f554  4bff96a5    bl 0x10018bf8                  ; -> 10018bf8
1001f558  60000000    ori r0,r0,0x0               
1001f55c  3882759e    addi r4,r2,0x759e           
1001f560  a8840000    lha r4,0x0(r4)              
1001f564  2c040001    cmpwi r4,0x1                
1001f568  40820148    bne 0x1001f6b0                 ; -> 1001f6b0
1001f56c  88bd0000    lbz r5,0x0(r29)             
1001f570  28050000    cmplwi r5,0x0               
1001f574  41820020    beq 0x1001f594                 ; -> 1001f594
1001f578  88d30000    lbz r6,0x0(r19)             
1001f57c  28060000    cmplwi r6,0x0               
1001f580  40820014    bne 0x1001f594                 ; -> 1001f594
1001f584  38600001    li r3,0x1                   
1001f588  48009485    bl 0x10028a0c                  ; -> 10028a0c
1001f58c  60000000    ori r0,r0,0x0               
1001f590  48000088    b 0x1001f618                   ; -> 1001f618
1001f594  38e00000    li r7,0x0                   
1001f598  98fd0000    stb r7,0x0(r29)             
1001f59c  a9180000    lha r8,0x0(r24)             
1001f5a0  a93c0000    lha r9,0x0(r28)             
1001f5a4  7d080734    extsh r8,r8                 
1001f5a8  7c084800    cmpw r8,r9                  
1001f5ac  4081000c    ble 0x1001f5b8                 ; -> 1001f5b8
1001f5b0  39400001    li r10,0x1                  
1001f5b4  b1580000    sth r10,0x0(r24)            
1001f5b8  a8780000    lha r3,0x0(r24)             
1001f5bc  4800baa5    bl 0x1002b060                  ; -> 1002b060
1001f5c0  60000000    ori r0,r0,0x0               
1001f5c4  39600001    li r11,0x1                  
1001f5c8  b1760000    sth r11,0x0(r22)            
1001f5cc  39800001    li r12,0x1                  
1001f5d0  b19e0000    sth r12,0x0(r30)            
1001f5d4  48000044    b 0x1001f618                   ; -> 1001f618
1001f5d8  a87f00a8    lha r3,0xa8(r31)            
1001f5dc  38800001    li r4,0x1                   
1001f5e0  4800a4ed    bl 0x10029acc                  ; -> 10029acc
1001f5e4  60000000    ori r0,r0,0x0               
1001f5e8  38600001    li r3,0x1                   
1001f5ec  48009421    bl 0x10028a0c                  ; -> 10028a0c
1001f5f0  60000000    ori r0,r0,0x0               
1001f5f4  a87f00a8    lha r3,0xa8(r31)            
1001f5f8  a89c0000    lha r4,0x0(r28)             
1001f5fc  7c630734    extsh r3,r3                 
1001f600  7c032000    cmpw r3,r4                  
1001f604  40810014    ble 0x1001f618                 ; -> 1001f618
1001f608  4bff8085    bl 0x1001768c                  ; -> 1001768c
1001f60c  60000000    ori r0,r0,0x0               
1001f610  38a0ffff    li r5,-0x1                  
1001f614  b0bf00b6    sth r5,0xb6(r31)            
1001f618  a8df00b6    lha r6,0xb6(r31)            
1001f61c  2c060000    cmpwi r6,0x0                
1001f620  41800010    blt 0x1001f630                 ; -> 1001f630
1001f624  88fd0000    lbz r7,0x0(r29)             
1001f628  28070000    cmplwi r7,0x0               
1001f62c  4182ffac    beq 0x1001f5d8                 ; -> 1001f5d8
1001f630  891d0000    lbz r8,0x0(r29)             
1001f634  28080000    cmplwi r8,0x0               
1001f638  4082005c    bne 0x1001f694                 ; -> 1001f694
1001f63c  893a0000    lbz r9,0x0(r26)             
1001f640  28090000    cmplwi r9,0x0               
1001f644  40820024    bne 0x1001f668                 ; -> 1001f668
1001f648  a95f00a8    lha r10,0xa8(r31)           
1001f64c  a97c0000    lha r11,0x0(r28)            
1001f650  7d4a0734    extsh r10,r10               
1001f654  7c0a5800    cmpw r10,r11                
1001f658  40800010    bge 0x1001f668                 ; -> 1001f668
1001f65c  38600000    li r3,0x0                   
1001f660  480049bd    bl 0x1002401c                  ; -> 1002401c
1001f664  60000000    ori r0,r0,0x0               
1001f668  819f00ac    lwz r12,0xac(r31)           
1001f66c  91950000    stw r12,0x0(r21)            
1001f670  4800e5d5    bl 0x1002dc44                  ; -> 1002dc44
1001f674  60000000    ori r0,r0,0x0               
1001f678  88790000    lbz r3,0x0(r25)             
1001f67c  28030000    cmplwi r3,0x0               
1001f680  408204dc    bne 0x1001fb5c                 ; -> 1001fb5c
1001f684  38600001    li r3,0x1                   
1001f688  48003775    bl 0x10022dfc                  ; -> 10022dfc
1001f68c  60000000    ori r0,r0,0x0               
1001f690  480004cc    b 0x1001fb5c                   ; -> 1001fb5c
1001f694  38800001    li r4,0x1                   
1001f698  b0960000    sth r4,0x0(r22)             
1001f69c  80bf00ac    lwz r5,0xac(r31)            
1001f6a0  90b50000    stw r5,0x0(r21)             
1001f6a4  4800e5a1    bl 0x1002dc44                  ; -> 1002dc44
1001f6a8  60000000    ori r0,r0,0x0               
1001f6ac  480004b0    b 0x1001fb5c                   ; -> 1001fb5c
1001f6b0  38c269fe    addi r6,r2,0x69fe           
1001f6b4  88c60000    lbz r6,0x0(r6)              
1001f6b8  28060000    cmplwi r6,0x0               
1001f6bc  40820210    bne 0x1001f8cc                 ; -> 1001f8cc
1001f6c0  88fd0000    lbz r7,0x0(r29)             
1001f6c4  28070000    cmplwi r7,0x0               
1001f6c8  41820020    beq 0x1001f6e8                 ; -> 1001f6e8
1001f6cc  89130000    lbz r8,0x0(r19)             
1001f6d0  28080000    cmplwi r8,0x0               
1001f6d4  40820014    bne 0x1001f6e8                 ; -> 1001f6e8
1001f6d8  a87e0000    lha r3,0x0(r30)             
1001f6dc  48009331    bl 0x10028a0c                  ; -> 10028a0c
1001f6e0  60000000    ori r0,r0,0x0               
1001f6e4  4800014c    b 0x1001f830                   ; -> 1001f830
1001f6e8  39200000    li r9,0x0                   
1001f6ec  993d0000    stb r9,0x0(r29)             
1001f6f0  a9580000    lha r10,0x0(r24)            
1001f6f4  a97c0000    lha r11,0x0(r28)            
1001f6f8  7d4a0734    extsh r10,r10               
1001f6fc  7c0a5800    cmpw r10,r11                
1001f700  4081000c    ble 0x1001f70c                 ; -> 1001f70c
1001f704  39800001    li r12,0x1                  
1001f708  b1980000    sth r12,0x0(r24)            
1001f70c  a8780000    lha r3,0x0(r24)             
1001f710  4800b951    bl 0x1002b060                  ; -> 1002b060
1001f714  60000000    ori r0,r0,0x0               
1001f718  38600002    li r3,0x2                   
1001f71c  b0760000    sth r3,0x0(r22)             
1001f720  38800002    li r4,0x2                   
1001f724  b09e0000    sth r4,0x0(r30)             
1001f728  48000108    b 0x1001f830                   ; -> 1001f830
1001f72c  a8be0000    lha r5,0x0(r30)             
1001f730  38a50001    addi r5,r5,0x1              
1001f734  b0be0000    sth r5,0x0(r30)             
1001f738  7ca50734    extsh r5,r5                 
1001f73c  2c050002    cmpwi r5,0x2                
1001f740  4081000c    ble 0x1001f74c                 ; -> 1001f74c
1001f744  38c00001    li r6,0x1                   
1001f748  b0de0000    sth r6,0x0(r30)             
1001f74c  a8fe0000    lha r7,0x0(r30)             
1001f750  1ce70070    mulli r7,r7,0x70            
1001f754  38e70046    addi r7,r7,0x46             
1001f758  7cff3aae    lhax r7,r31,r7              
1001f75c  2c070000    cmpwi r7,0x0                
1001f760  418000d0    blt 0x1001f830                 ; -> 1001f830
1001f764  a91e0000    lha r8,0x0(r30)             
1001f768  a89e0000    lha r4,0x0(r30)             
1001f76c  1d080070    mulli r8,r8,0x70            
1001f770  39080038    addi r8,r8,0x38             
1001f774  7c7f42ae    lhax r3,r31,r8              
1001f778  4800a355    bl 0x10029acc                  ; -> 10029acc
1001f77c  60000000    ori r0,r0,0x0               
1001f780  a87e0000    lha r3,0x0(r30)             
1001f784  48009289    bl 0x10028a0c                  ; -> 10028a0c
1001f788  60000000    ori r0,r0,0x0               
1001f78c  a93e0000    lha r9,0x0(r30)             
1001f790  a95c0000    lha r10,0x0(r28)            
1001f794  1d290070    mulli r9,r9,0x70            
1001f798  39290038    addi r9,r9,0x38             
1001f79c  7d3f4aae    lhax r9,r31,r9              
1001f7a0  7d290734    extsh r9,r9                 
1001f7a4  7c095000    cmpw r9,r10                 
1001f7a8  40810020    ble 0x1001f7c8                 ; -> 1001f7c8
1001f7ac  4bff7ee1    bl 0x1001768c                  ; -> 1001768c
1001f7b0  60000000    ori r0,r0,0x0               
1001f7b4  a99e0000    lha r12,0x0(r30)            
1001f7b8  3960ffff    li r11,-0x1                 
1001f7bc  1d8c0070    mulli r12,r12,0x70          
1001f7c0  398c0046    addi r12,r12,0x46           
1001f7c4  7d7f632e    sthx r11,r31,r12            
1001f7c8  a87e0000    lha r3,0x0(r30)             
1001f7cc  1c630070    mulli r3,r3,0x70            
1001f7d0  38630046    addi r3,r3,0x46             
1001f7d4  7c7f1aae    lhax r3,r31,r3              
1001f7d8  2c030000    cmpwi r3,0x0                
1001f7dc  4080003c    bge 0x1001f818                 ; -> 1001f818
1001f7e0  889a0000    lbz r4,0x0(r26)             
1001f7e4  28040000    cmplwi r4,0x0               
1001f7e8  40820030    bne 0x1001f818                 ; -> 1001f818
1001f7ec  a8be0000    lha r5,0x0(r30)             
1001f7f0  a8dc0000    lha r6,0x0(r28)             
1001f7f4  1ca50070    mulli r5,r5,0x70            
1001f7f8  38a50038    addi r5,r5,0x38             
1001f7fc  7cbf2aae    lhax r5,r31,r5              
1001f800  7ca50734    extsh r5,r5                 
1001f804  7c053000    cmpw r5,r6                  
1001f808  40800010    bge 0x1001f818                 ; -> 1001f818
1001f80c  a87e0000    lha r3,0x0(r30)             
1001f810  4800480d    bl 0x1002401c                  ; -> 1002401c
1001f814  60000000    ori r0,r0,0x0               
1001f818  88fa0000    lbz r7,0x0(r26)             
1001f81c  28070000    cmplwi r7,0x0               
1001f820  41820010    beq 0x1001f830                 ; -> 1001f830
1001f824  3900ffff    li r8,-0x1                  
1001f828  b11f0126    sth r8,0x126(r31)           
1001f82c  b11f00b6    sth r8,0xb6(r31)            
1001f830  a93f00b6    lha r9,0xb6(r31)            
1001f834  2c090000    cmpwi r9,0x0                
1001f838  40800010    bge 0x1001f848                 ; -> 1001f848
1001f83c  a95f0126    lha r10,0x126(r31)          
1001f840  2c0a0000    cmpwi r10,0x0               
1001f844  41800010    blt 0x1001f854                 ; -> 1001f854
1001f848  897d0000    lbz r11,0x0(r29)            
1001f84c  280b0000    cmplwi r11,0x0              
1001f850  4182fedc    beq 0x1001f72c                 ; -> 1001f72c
1001f854  899d0000    lbz r12,0x0(r29)            
1001f858  280c0000    cmplwi r12,0x0              
1001f85c  4082004c    bne 0x1001f8a8                 ; -> 1001f8a8
1001f860  38600002    li r3,0x2                   
1001f864  b0760000    sth r3,0x0(r22)             
1001f868  809f00ac    lwz r4,0xac(r31)            
1001f86c  90950000    stw r4,0x0(r21)             
1001f870  80bf011c    lwz r5,0x11c(r31)           
1001f874  90b40000    stw r5,0x0(r20)             
1001f878  4800e3cd    bl 0x1002dc44                  ; -> 1002dc44
1001f87c  60000000    ori r0,r0,0x0               
1001f880  88d90000    lbz r6,0x0(r25)             
1001f884  28060000    cmplwi r6,0x0               
1001f888  408202d4    bne 0x1001fb5c                 ; -> 1001fb5c
1001f88c  38600001    li r3,0x1                   
1001f890  4800356d    bl 0x10022dfc                  ; -> 10022dfc
1001f894  60000000    ori r0,r0,0x0               
1001f898  38600002    li r3,0x2                   
1001f89c  48003561    bl 0x10022dfc                  ; -> 10022dfc
1001f8a0  60000000    ori r0,r0,0x0               
1001f8a4  480002b8    b 0x1001fb5c                   ; -> 1001fb5c
1001f8a8  38e00002    li r7,0x2                   
1001f8ac  b0f60000    sth r7,0x0(r22)             
1001f8b0  811f00ac    lwz r8,0xac(r31)            
1001f8b4  91150000    stw r8,0x0(r21)             
1001f8b8  813f011c    lwz r9,0x11c(r31)           
1001f8bc  91340000    stw r9,0x0(r20)             
1001f8c0  4800e385    bl 0x1002dc44                  ; -> 1002dc44
1001f8c4  60000000    ori r0,r0,0x0               
1001f8c8  48000294    b 0x1001fb5c                   ; -> 1001fb5c
1001f8cc  394269fe    addi r10,r2,0x69fe          
1001f8d0  894a0000    lbz r10,0x0(r10)            
1001f8d4  280a0001    cmplwi r10,0x1              
1001f8d8  40820284    bne 0x1001fb5c                 ; -> 1001fb5c
1001f8dc  897d0000    lbz r11,0x0(r29)            
1001f8e0  280b0000    cmplwi r11,0x0              
1001f8e4  4182006c    beq 0x1001f950                 ; -> 1001f950
1001f8e8  89930000    lbz r12,0x0(r19)            
1001f8ec  280c0000    cmplwi r12,0x0              
1001f8f0  40820060    bne 0x1001f950                 ; -> 1001f950
1001f8f4  4800aa15    bl 0x1002a308                  ; -> 1002a308
1001f8f8  60000000    ori r0,r0,0x0               
1001f8fc  887d0000    lbz r3,0x0(r29)             
1001f900  28030000    cmplwi r3,0x0               
1001f904  4082017c    bne 0x1001fa80                 ; -> 1001fa80
1001f908  889b0000    lbz r4,0x0(r27)             
1001f90c  28040000    cmplwi r4,0x0               
1001f910  41820170    beq 0x1001fa80                 ; -> 1001fa80
1001f914  88bf00b8    lbz r5,0xb8(r31)            
1001f918  28050000    cmplwi r5,0x0               
1001f91c  41820010    beq 0x1001f92c                 ; -> 1001f92c
1001f920  88df0128    lbz r6,0x128(r31)           
1001f924  28060000    cmplwi r6,0x0               
1001f928  40820158    bne 0x1001fa80                 ; -> 1001fa80
1001f92c  88f90000    lbz r7,0x0(r25)             
1001f930  28070000    cmplwi r7,0x0               
1001f934  4082000c    bne 0x1001f940                 ; -> 1001f940
1001f938  4bff5439    bl 0x10014d70                  ; -> 10014d70
1001f93c  60000000    ori r0,r0,0x0               
1001f940  39000000    li r8,0x0                   
1001f944  991f0128    stb r8,0x128(r31)           
1001f948  991f00b8    stb r8,0xb8(r31)            
1001f94c  48000134    b 0x1001fa80                   ; -> 1001fa80
1001f950  39200000    li r9,0x0                   
1001f954  993d0000    stb r9,0x0(r29)             
1001f958  895b0000    lbz r10,0x0(r27)            
1001f95c  280a0000    cmplwi r10,0x0              
1001f960  41820024    beq 0x1001f984                 ; -> 1001f984
1001f964  a9780000    lha r11,0x0(r24)            
1001f968  a9970000    lha r12,0x0(r23)            
1001f96c  7d6b0734    extsh r11,r11               
1001f970  7c0b6000    cmpw r11,r12                
1001f974  4081002c    ble 0x1001f9a0                 ; -> 1001f9a0
1001f978  38600001    li r3,0x1                   
1001f97c  b0780000    sth r3,0x0(r24)             
1001f980  48000020    b 0x1001f9a0                   ; -> 1001f9a0
1001f984  a8980000    lha r4,0x0(r24)             
1001f988  a8bc0000    lha r5,0x0(r28)             
1001f98c  7c840734    extsh r4,r4                 
1001f990  7c042800    cmpw r4,r5                  
1001f994  4081000c    ble 0x1001f9a0                 ; -> 1001f9a0
1001f998  38c00001    li r6,0x1                   
1001f99c  b0d80000    sth r6,0x0(r24)             
1001f9a0  a8780000    lha r3,0x0(r24)             
1001f9a4  4800b6bd    bl 0x1002b060                  ; -> 1002b060
1001f9a8  60000000    ori r0,r0,0x0               
1001f9ac  480000d4    b 0x1001fa80                   ; -> 1001fa80
1001f9b0  38e00001    li r7,0x1                   
1001f9b4  b0fe0000    sth r7,0x0(r30)             
1001f9b8  891b0000    lbz r8,0x0(r27)             
1001f9bc  28080000    cmplwi r8,0x0               
1001f9c0  41820028    beq 0x1001f9e8                 ; -> 1001f9e8
1001f9c4  a93f00a8    lha r9,0xa8(r31)            
1001f9c8  a9570000    lha r10,0x0(r23)            
1001f9cc  7d290734    extsh r9,r9                 
1001f9d0  7c095000    cmpw r9,r10                 
1001f9d4  40810014    ble 0x1001f9e8                 ; -> 1001f9e8
1001f9d8  39600001    li r11,0x1                  
1001f9dc  b17f00a8    sth r11,0xa8(r31)           
1001f9e0  39800001    li r12,0x1                  
1001f9e4  b19f0118    sth r12,0x118(r31)          
1001f9e8  a87f00a8    lha r3,0xa8(r31)            
1001f9ec  4800a12d    bl 0x10029b18                  ; -> 10029b18
1001f9f0  60000000    ori r0,r0,0x0               
1001f9f4  4800a915    bl 0x1002a308                  ; -> 1002a308
1001f9f8  60000000    ori r0,r0,0x0               
1001f9fc  887d0000    lbz r3,0x0(r29)             
1001fa00  28030000    cmplwi r3,0x0               
1001fa04  40820048    bne 0x1001fa4c                 ; -> 1001fa4c
1001fa08  889b0000    lbz r4,0x0(r27)             
1001fa0c  28040000    cmplwi r4,0x0               
1001fa10  4182003c    beq 0x1001fa4c                 ; -> 1001fa4c
1001fa14  88bf00b8    lbz r5,0xb8(r31)            
1001fa18  28050000    cmplwi r5,0x0               
1001fa1c  41820010    beq 0x1001fa2c                 ; -> 1001fa2c
1001fa20  88df0128    lbz r6,0x128(r31)           
1001fa24  28060000    cmplwi r6,0x0               
1001fa28  40820024    bne 0x1001fa4c                 ; -> 1001fa4c
1001fa2c  88f90000    lbz r7,0x0(r25)             
1001fa30  28070000    cmplwi r7,0x0               
1001fa34  4082000c    bne 0x1001fa40                 ; -> 1001fa40
1001fa38  4bff5339    bl 0x10014d70                  ; -> 10014d70
1001fa3c  60000000    ori r0,r0,0x0               
1001fa40  39000000    li r8,0x0                   
1001fa44  991f0128    stb r8,0x128(r31)           
1001fa48  991f00b8    stb r8,0xb8(r31)            
1001fa4c  893b0000    lbz r9,0x0(r27)             
1001fa50  28090000    cmplwi r9,0x0               
1001fa54  4082002c    bne 0x1001fa80                 ; -> 1001fa80
1001fa58  a95f00a8    lha r10,0xa8(r31)           
1001fa5c  a97c0000    lha r11,0x0(r28)            
1001fa60  7d4a0734    extsh r10,r10               
1001fa64  7c0a5800    cmpw r10,r11                
1001fa68  40810018    ble 0x1001fa80                 ; -> 1001fa80
1001fa6c  4bff7c21    bl 0x1001768c                  ; -> 1001768c
1001fa70  60000000    ori r0,r0,0x0               
1001fa74  39800000    li r12,0x0                  
1001fa78  999f0128    stb r12,0x128(r31)          
1001fa7c  999f00b8    stb r12,0xb8(r31)           
1001fa80  887f00b8    lbz r3,0xb8(r31)            
1001fa84  28030000    cmplwi r3,0x0               
1001fa88  40820010    bne 0x1001fa98                 ; -> 1001fa98
1001fa8c  889f0128    lbz r4,0x128(r31)           
1001fa90  28040000    cmplwi r4,0x0               
1001fa94  41820010    beq 0x1001faa4                 ; -> 1001faa4
1001fa98  88bd0000    lbz r5,0x0(r29)             
1001fa9c  28050000    cmplwi r5,0x0               
1001faa0  4182ff10    beq 0x1001f9b0                 ; -> 1001f9b0
1001faa4  88dd0000    lbz r6,0x0(r29)             
1001faa8  28060000    cmplwi r6,0x0               
1001faac  40820068    bne 0x1001fb14                 ; -> 1001fb14
1001fab0  88fb0000    lbz r7,0x0(r27)             
1001fab4  28070000    cmplwi r7,0x0               
1001fab8  41820028    beq 0x1001fae0                 ; -> 1001fae0
1001fabc  39000002    li r8,0x2                   
1001fac0  b1160000    sth r8,0x0(r22)             
1001fac4  813f00ac    lwz r9,0xac(r31)            
1001fac8  91350000    stw r9,0x0(r21)             
1001facc  815f011c    lwz r10,0x11c(r31)          
1001fad0  91540000    stw r10,0x0(r20)            
1001fad4  4800e171    bl 0x1002dc44                  ; -> 1002dc44
1001fad8  60000000    ori r0,r0,0x0               
1001fadc  48000080    b 0x1001fb5c                   ; -> 1001fb5c
1001fae0  39600001    li r11,0x1                  
1001fae4  b1760000    sth r11,0x0(r22)            
1001fae8  819f00ac    lwz r12,0xac(r31)           
1001faec  91950000    stw r12,0x0(r21)            
1001faf0  4800e155    bl 0x1002dc44                  ; -> 1002dc44
1001faf4  60000000    ori r0,r0,0x0               
1001faf8  88790000    lbz r3,0x0(r25)             
1001fafc  28030000    cmplwi r3,0x0               
1001fb00  4082005c    bne 0x1001fb5c                 ; -> 1001fb5c
1001fb04  38600001    li r3,0x1                   
1001fb08  480032f5    bl 0x10022dfc                  ; -> 10022dfc
1001fb0c  60000000    ori r0,r0,0x0               
1001fb10  4800004c    b 0x1001fb5c                   ; -> 1001fb5c
1001fb14  889b0000    lbz r4,0x0(r27)             
1001fb18  28040000    cmplwi r4,0x0               
1001fb1c  41820028    beq 0x1001fb44                 ; -> 1001fb44
1001fb20  38a00002    li r5,0x2                   
1001fb24  b0b60000    sth r5,0x0(r22)             
1001fb28  80df00ac    lwz r6,0xac(r31)            
1001fb2c  90d50000    stw r6,0x0(r21)             
1001fb30  80ff011c    lwz r7,0x11c(r31)           
1001fb34  90f40000    stw r7,0x0(r20)             
1001fb38  4800e10d    bl 0x1002dc44                  ; -> 1002dc44
1001fb3c  60000000    ori r0,r0,0x0               
1001fb40  4800001c    b 0x1001fb5c                   ; -> 1001fb5c
1001fb44  39000001    li r8,0x1                   
1001fb48  b1160000    sth r8,0x0(r22)             
1001fb4c  813f00ac    lwz r9,0xac(r31)            
1001fb50  91350000    stw r9,0x0(r21)             
1001fb54  4800e0f1    bl 0x1002dc44                  ; -> 1002dc44
1001fb58  60000000    ori r0,r0,0x0               
1001fb5c  39427534    addi r10,r2,0x7534          
1001fb60  806a0000    lwz r3,0x0(r10)             
1001fb64  4801165d    bl 0x100311c0                  ; -> 100311c0
1001fb68  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
1001fb6c  39627534    addi r11,r2,0x7534          
1001fb70  816b0000    lwz r11,0x0(r11)            
1001fb74  386b0010    addi r3,r11,0x10            
1001fb78  480121a1    bl 0x10031d18                  ; -> 10031d18
1001fb7c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
1001fb80  48011581    bl 0x10031100                  ; -> 10031100
1001fb84  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
1001fb88  4bff90a5    bl 0x10018c2c                  ; -> 10018c2c
1001fb8c  60000000    ori r0,r0,0x0               
1001fb90  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
1001fb94  38210070    addi r1,r1,0x70             
1001fb98  7c0803a6    mtspr LR,r0                 
1001fb9c  ba61ffcc    lmw r19,-0x34(r1)              ; -> Stack[-0x34]
1001fba0  4e800020    blr                         
