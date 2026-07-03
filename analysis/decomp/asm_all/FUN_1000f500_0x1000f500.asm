; FUN_1000f500 @ 0x1000f500
1000f500  7c0802a6    mfspr r0,LR                 
1000f504  be81ffd0    stmw r20,-0x30(r1)             ; -> Stack[-0x30]
1000f508  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000f50c  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
1000f510  3aa24d40    addi r21,r2,0x4d40          
1000f514  3b226a34    addi r25,r2,0x6a34          
1000f518  a8750000    lha r3,0x0(r21)             
1000f51c  3b626a70    addi r27,r2,0x6a70          
1000f520  2c030003    cmpwi r3,0x3                
1000f524  3b426a2a    addi r26,r2,0x6a2a          
1000f528  3b826a66    addi r28,r2,0x6a66          
1000f52c  3a826a00    addi r20,r2,0x6a00          
1000f530  3ac25332    addi r22,r2,0x5332          
1000f534  3ba26bb8    addi r29,r2,0x6bb8          
1000f538  3ae26840    addi r23,r2,0x6840          
1000f53c  3bc000f4    li r30,0xf4                 
1000f540  3b000008    li r24,0x8                  
1000f544  4081000c    ble 0x1000f550                 ; -> 1000f550
1000f548  38800003    li r4,0x3                   
1000f54c  b0950000    sth r4,0x0(r21)             
1000f550  a8b50000    lha r5,0x0(r21)             
1000f554  38a5ffff    subi r5,r5,0x1              
1000f558  b0b50000    sth r5,0x0(r21)             
1000f55c  7ca50734    extsh r5,r5                 
1000f560  2c050000    cmpwi r5,0x0                
1000f564  418105a0    bgt 0x1000fb04                 ; -> 1000fb04
1000f568  38c00003    li r6,0x3                   
1000f56c  38e269fe    addi r7,r2,0x69fe           
1000f570  b0d50000    sth r6,0x0(r21)             
1000f574  88e70000    lbz r7,0x0(r7)              
1000f578  28070000    cmplwi r7,0x0               
1000f57c  41820348    beq 0x1000f8c4                 ; -> 1000f8c4
1000f580  39022f74    addi r8,r2,0x2f74           
1000f584  89080000    lbz r8,0x0(r8)              
1000f588  28080000    cmplwi r8,0x0               
1000f58c  41820338    beq 0x1000f8c4                 ; -> 1000f8c4
1000f590  a93700b0    lha r9,0xb0(r23)            
1000f594  2c0903e8    cmpwi r9,0x3e8              
1000f598  40820018    bne 0x1000f5b0                 ; -> 1000f5b0
1000f59c  895700aa    lbz r10,0xaa(r23)           
1000f5a0  280a0000    cmplwi r10,0x0              
1000f5a4  4082000c    bne 0x1000f5b0                 ; -> 1000f5b0
1000f5a8  4800957d    bl 0x10018b24                  ; -> 10018b24
1000f5ac  60000000    ori r0,r0,0x0               
1000f5b0  a9770120    lha r11,0x120(r23)          
1000f5b4  2c0b03e8    cmpwi r11,0x3e8             
1000f5b8  40820018    bne 0x1000f5d0                 ; -> 1000f5d0
1000f5bc  8997011a    lbz r12,0x11a(r23)          
1000f5c0  280c0000    cmplwi r12,0x0              
1000f5c4  4082000c    bne 0x1000f5d0                 ; -> 1000f5d0
1000f5c8  4800955d    bl 0x10018b24                  ; -> 10018b24
1000f5cc  60000000    ori r0,r0,0x0               
1000f5d0  887700aa    lbz r3,0xaa(r23)            
1000f5d4  28030000    cmplwi r3,0x0               
1000f5d8  40820010    bne 0x1000f5e8                 ; -> 1000f5e8
1000f5dc  a89700b0    lha r4,0xb0(r23)            
1000f5e0  3884ffff    subi r4,r4,0x1              
1000f5e4  b09700b0    sth r4,0xb0(r23)            
1000f5e8  a8b700b0    lha r5,0xb0(r23)            
1000f5ec  2c050000    cmpwi r5,0x0                
1000f5f0  40800030    bge 0x1000f620                 ; -> 1000f620
1000f5f4  38c00000    li r6,0x0                   
1000f5f8  b0d700b0    sth r6,0xb0(r23)            
1000f5fc  88f70098    lbz r7,0x98(r23)            
1000f600  28070000    cmplwi r7,0x0               
1000f604  40820010    bne 0x1000f614                 ; -> 1000f614
1000f608  38600001    li r3,0x1                   
1000f60c  3880ffff    li r4,-0x1                  
1000f610  4bfff3b9    bl 0x1000e9c8                  ; -> 1000e9c8
1000f614  38600001    li r3,0x1                   
1000f618  48002c11    bl 0x10012228                  ; -> 10012228
1000f61c  60000000    ori r0,r0,0x0               
1000f620  8917011a    lbz r8,0x11a(r23)           
1000f624  28080000    cmplwi r8,0x0               
1000f628  40820010    bne 0x1000f638                 ; -> 1000f638
1000f62c  a9370120    lha r9,0x120(r23)           
1000f630  3929ffff    subi r9,r9,0x1              
1000f634  b1370120    sth r9,0x120(r23)           
1000f638  a9570120    lha r10,0x120(r23)          
1000f63c  2c0a0000    cmpwi r10,0x0               
1000f640  40800030    bge 0x1000f670                 ; -> 1000f670
1000f644  39600000    li r11,0x0                  
1000f648  b1770120    sth r11,0x120(r23)          
1000f64c  89970108    lbz r12,0x108(r23)          
1000f650  280c0000    cmplwi r12,0x0              
1000f654  40820010    bne 0x1000f664                 ; -> 1000f664
1000f658  38600002    li r3,0x2                   
1000f65c  3880ffff    li r4,-0x1                  
1000f660  4bfff369    bl 0x1000e9c8                  ; -> 1000e9c8
1000f664  38600002    li r3,0x2                   
1000f668  48002bc1    bl 0x10012228                  ; -> 10012228
1000f66c  60000000    ori r0,r0,0x0               
1000f670  88740000    lbz r3,0x0(r20)             
1000f674  28030000    cmplwi r3,0x0               
1000f678  41820128    beq 0x1000f7a0                 ; -> 1000f7a0
1000f67c  a87700b0    lha r3,0xb0(r23)            
1000f680  7f84e378    or r4,r28,r28               
1000f684  4801c2cd    bl 0x1002b950                  ; -> 1002b950
1000f688  60000000    ori r0,r0,0x0               
1000f68c  a8770120    lha r3,0x120(r23)           
1000f690  7f44d378    or r4,r26,r26               
1000f694  4801c2bd    bl 0x1002b950                  ; -> 1002b950
1000f698  60000000    ori r0,r0,0x0               
1000f69c  3be00000    li r31,0x0                  
1000f6a0  480000f0    b 0x1000f790                   ; -> 1000f790
1000f6a4  7fe40734    extsh r4,r31                
1000f6a8  5484083c    rlwinm r4,r4,0x1,0x0,0x1e   
1000f6ac  7fe50734    extsh r5,r31                
1000f6b0  7c9c22ae    lhax r4,r28,r4              
1000f6b4  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1000f6b8  7cbb2aae    lhax r5,r27,r5              
1000f6bc  7c840734    extsh r4,r4                 
1000f6c0  7c042800    cmpw r4,r5                  
1000f6c4  41820054    beq 0x1000f718                 ; -> 1000f718
1000f6c8  20ff0004    subfic r7,r31,0x4           
1000f6cc  7fe90734    extsh r9,r31                
1000f6d0  7fe60734    extsh r6,r31                
1000f6d4  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1000f6d8  54c6083c    rlwinm r6,r6,0x1,0x0,0x1e   
1000f6dc  7d3c4aae    lhax r9,r28,r9              
1000f6e0  7cdb32ae    lhax r6,r27,r6              
1000f6e4  54e71838    rlwinm r7,r7,0x3,0x0,0x1c   
1000f6e8  215f0004    subfic r10,r31,0x4          
1000f6ec  7cbe3a14    add r5,r30,r7               
1000f6f0  38860005    addi r4,r6,0x5              
1000f6f4  39090005    addi r8,r9,0x5              
1000f6f8  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
1000f6fc  7d3e5214    add r9,r30,r10              
1000f700  807d0000    lwz r3,0x0(r29)             
1000f704  80fd0000    lwz r7,0x0(r29)             
1000f708  38c00000    li r6,0x0                   
1000f70c  39400000    li r10,0x0                  
1000f710  4bff4c91    bl 0x100043a0                  ; -> 100043a0
1000f714  60000000    ori r0,r0,0x0               
1000f718  7feb0734    extsh r11,r31               
1000f71c  556b083c    rlwinm r11,r11,0x1,0x0,0x1e 
1000f720  7fec0734    extsh r12,r31               
1000f724  7d7a5aae    lhax r11,r26,r11            
1000f728  558c083c    rlwinm r12,r12,0x1,0x0,0x1e 
1000f72c  7d9962ae    lhax r12,r25,r12            
1000f730  7d6b0734    extsh r11,r11               
1000f734  7c0b6000    cmpw r11,r12                
1000f738  41820054    beq 0x1000f78c                 ; -> 1000f78c
1000f73c  20df0004    subfic r6,r31,0x4           
1000f740  7fe50734    extsh r5,r31                
1000f744  7fe90734    extsh r9,r31                
1000f748  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1000f74c  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1000f750  7cb92aae    lhax r5,r25,r5              
1000f754  7d3a4aae    lhax r9,r26,r9              
1000f758  215f0004    subfic r10,r31,0x4          
1000f75c  38850005    addi r4,r5,0x5              
1000f760  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
1000f764  7cbe3214    add r5,r30,r6               
1000f768  39090005    addi r8,r9,0x5              
1000f76c  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
1000f770  7d3e5214    add r9,r30,r10              
1000f774  807d0000    lwz r3,0x0(r29)             
1000f778  80fd0000    lwz r7,0x0(r29)             
1000f77c  38c00010    li r6,0x10                  
1000f780  39400010    li r10,0x10                 
1000f784  4bff4c1d    bl 0x100043a0                  ; -> 100043a0
1000f788  60000000    ori r0,r0,0x0               
1000f78c  3bff0001    addi r31,r31,0x1            
1000f790  7feb0734    extsh r11,r31               
1000f794  2c0b0004    cmpwi r11,0x4               
1000f798  4081ff0c    ble 0x1000f6a4                 ; -> 1000f6a4
1000f79c  48000350    b 0x1000faec                   ; -> 1000faec
1000f7a0  a87700b0    lha r3,0xb0(r23)            
1000f7a4  7f64db78    or r4,r27,r27               
1000f7a8  4801c1a9    bl 0x1002b950                  ; -> 1002b950
1000f7ac  60000000    ori r0,r0,0x0               
1000f7b0  a8770120    lha r3,0x120(r23)           
1000f7b4  7f24cb78    or r4,r25,r25               
1000f7b8  4801c199    bl 0x1002b950                  ; -> 1002b950
1000f7bc  60000000    ori r0,r0,0x0               
1000f7c0  3be00000    li r31,0x0                  
1000f7c4  480000f0    b 0x1000f8b4                   ; -> 1000f8b4
1000f7c8  7fec0734    extsh r12,r31               
1000f7cc  558c083c    rlwinm r12,r12,0x1,0x0,0x1e 
1000f7d0  7fe30734    extsh r3,r31                
1000f7d4  7d9c62ae    lhax r12,r28,r12            
1000f7d8  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
1000f7dc  7c7b1aae    lhax r3,r27,r3              
1000f7e0  7d8c0734    extsh r12,r12               
1000f7e4  7c0c1800    cmpw r12,r3                 
1000f7e8  41820054    beq 0x1000f83c                 ; -> 1000f83c
1000f7ec  20df0004    subfic r6,r31,0x4           
1000f7f0  7fe50734    extsh r5,r31                
1000f7f4  7fe90734    extsh r9,r31                
1000f7f8  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1000f7fc  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1000f800  7cbc2aae    lhax r5,r28,r5              
1000f804  7d3b4aae    lhax r9,r27,r9              
1000f808  215f0004    subfic r10,r31,0x4          
1000f80c  38850005    addi r4,r5,0x5              
1000f810  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
1000f814  7cbe3214    add r5,r30,r6               
1000f818  39090005    addi r8,r9,0x5              
1000f81c  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
1000f820  7d3e5214    add r9,r30,r10              
1000f824  807d0000    lwz r3,0x0(r29)             
1000f828  80fd0000    lwz r7,0x0(r29)             
1000f82c  38c00000    li r6,0x0                   
1000f830  39400000    li r10,0x0                  
1000f834  4bff4b6d    bl 0x100043a0                  ; -> 100043a0
1000f838  60000000    ori r0,r0,0x0               
1000f83c  7feb0734    extsh r11,r31               
1000f840  556b083c    rlwinm r11,r11,0x1,0x0,0x1e 
1000f844  7fec0734    extsh r12,r31               
1000f848  7d7a5aae    lhax r11,r26,r11            
1000f84c  558c083c    rlwinm r12,r12,0x1,0x0,0x1e 
1000f850  7d9962ae    lhax r12,r25,r12            
1000f854  7d6b0734    extsh r11,r11               
1000f858  7c0b6000    cmpw r11,r12                
1000f85c  41820054    beq 0x1000f8b0                 ; -> 1000f8b0
1000f860  20df0004    subfic r6,r31,0x4           
1000f864  7fe50734    extsh r5,r31                
1000f868  7fe90734    extsh r9,r31                
1000f86c  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1000f870  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1000f874  7cba2aae    lhax r5,r26,r5              
1000f878  7d394aae    lhax r9,r25,r9              
1000f87c  215f0004    subfic r10,r31,0x4          
1000f880  38850005    addi r4,r5,0x5              
1000f884  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
1000f888  7cbe3214    add r5,r30,r6               
1000f88c  39090005    addi r8,r9,0x5              
1000f890  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
1000f894  7d3e5214    add r9,r30,r10              
1000f898  807d0000    lwz r3,0x0(r29)             
1000f89c  80fd0000    lwz r7,0x0(r29)             
1000f8a0  38c00010    li r6,0x10                  
1000f8a4  39400010    li r10,0x10                 
1000f8a8  4bff4af9    bl 0x100043a0                  ; -> 100043a0
1000f8ac  60000000    ori r0,r0,0x0               
1000f8b0  3bff0001    addi r31,r31,0x1            
1000f8b4  7feb0734    extsh r11,r31               
1000f8b8  2c0b0004    cmpwi r11,0x4               
1000f8bc  4081ff0c    ble 0x1000f7c8                 ; -> 1000f7c8
1000f8c0  4800022c    b 0x1000faec                   ; -> 1000faec
1000f8c4  a9960000    lha r12,0x0(r22)            
1000f8c8  1d8c0070    mulli r12,r12,0x70          
1000f8cc  398c0040    addi r12,r12,0x40           
1000f8d0  7c7762ae    lhax r3,r23,r12             
1000f8d4  3863ffff    subi r3,r3,0x1              
1000f8d8  7c77632e    sthx r3,r23,r12             
1000f8dc  a8960000    lha r4,0x0(r22)             
1000f8e0  1c840070    mulli r4,r4,0x70            
1000f8e4  38840040    addi r4,r4,0x40             
1000f8e8  7c9722ae    lhax r4,r23,r4              
1000f8ec  2c0403e8    cmpwi r4,0x3e8              
1000f8f0  4082000c    bne 0x1000f8fc                 ; -> 1000f8fc
1000f8f4  48009231    bl 0x10018b24                  ; -> 10018b24
1000f8f8  60000000    ori r0,r0,0x0               
1000f8fc  a8b60000    lha r5,0x0(r22)             
1000f900  1ca50070    mulli r5,r5,0x70            
1000f904  38a50040    addi r5,r5,0x40             
1000f908  7cb72aae    lhax r5,r23,r5              
1000f90c  2c050000    cmpwi r5,0x0                
1000f910  4080007c    bge 0x1000f98c                 ; -> 1000f98c
1000f914  a8f60000    lha r7,0x0(r22)             
1000f918  38c00000    li r6,0x0                   
1000f91c  1ce70070    mulli r7,r7,0x70            
1000f920  38e70040    addi r7,r7,0x40             
1000f924  7cd73b2e    sthx r6,r23,r7              
1000f928  a9160000    lha r8,0x0(r22)             
1000f92c  1d080070    mulli r8,r8,0x70            
1000f930  39080028    addi r8,r8,0x28             
1000f934  7d1740ae    lbzx r8,r23,r8              
1000f938  28080000    cmplwi r8,0x0               
1000f93c  40820010    bne 0x1000f94c                 ; -> 1000f94c
1000f940  a8760000    lha r3,0x0(r22)             
1000f944  3880ffff    li r4,-0x1                  
1000f948  4bfff081    bl 0x1000e9c8                  ; -> 1000e9c8
1000f94c  a8760000    lha r3,0x0(r22)             
1000f950  480028d9    bl 0x10012228                  ; -> 10012228
1000f954  60000000    ori r0,r0,0x0               
1000f958  392269fe    addi r9,r2,0x69fe           
1000f95c  89290000    lbz r9,0x0(r9)              
1000f960  28090000    cmplwi r9,0x0               
1000f964  41820028    beq 0x1000f98c                 ; -> 1000f98c
1000f968  89570108    lbz r10,0x108(r23)          
1000f96c  280a0000    cmplwi r10,0x0              
1000f970  40820010    bne 0x1000f980                 ; -> 1000f980
1000f974  38600002    li r3,0x2                   
1000f978  3880ffff    li r4,-0x1                  
1000f97c  4bfff04d    bl 0x1000e9c8                  ; -> 1000e9c8
1000f980  38600002    li r3,0x2                   
1000f984  480028a5    bl 0x10012228                  ; -> 10012228
1000f988  60000000    ori r0,r0,0x0               
1000f98c  89740000    lbz r11,0x0(r20)            
1000f990  280b0000    cmplwi r11,0x0              
1000f994  418200b0    beq 0x1000fa44                 ; -> 1000fa44
1000f998  a9960000    lha r12,0x0(r22)            
1000f99c  7f84e378    or r4,r28,r28               
1000f9a0  1d8c0070    mulli r12,r12,0x70          
1000f9a4  398c0040    addi r12,r12,0x40           
1000f9a8  7c7762ae    lhax r3,r23,r12             
1000f9ac  4801bfa5    bl 0x1002b950                  ; -> 1002b950
1000f9b0  60000000    ori r0,r0,0x0               
1000f9b4  3be00000    li r31,0x0                  
1000f9b8  4800007c    b 0x1000fa34                   ; -> 1000fa34
1000f9bc  7fe30734    extsh r3,r31                
1000f9c0  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
1000f9c4  7fe40734    extsh r4,r31                
1000f9c8  7c7c1aae    lhax r3,r28,r3              
1000f9cc  5484083c    rlwinm r4,r4,0x1,0x0,0x1e   
1000f9d0  7c9b22ae    lhax r4,r27,r4              
1000f9d4  7c630734    extsh r3,r3                 
1000f9d8  7c032000    cmpw r3,r4                  
1000f9dc  41820054    beq 0x1000fa30                 ; -> 1000fa30
1000f9e0  20df0004    subfic r6,r31,0x4           
1000f9e4  7fe50734    extsh r5,r31                
1000f9e8  7fe90734    extsh r9,r31                
1000f9ec  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1000f9f0  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1000f9f4  7cbb2aae    lhax r5,r27,r5              
1000f9f8  7d3c4aae    lhax r9,r28,r9              
1000f9fc  215f0004    subfic r10,r31,0x4          
1000fa00  38850005    addi r4,r5,0x5              
1000fa04  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
1000fa08  7cbe3214    add r5,r30,r6               
1000fa0c  39090005    addi r8,r9,0x5              
1000fa10  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
1000fa14  7d3e5214    add r9,r30,r10              
1000fa18  807d0000    lwz r3,0x0(r29)             
1000fa1c  80fd0000    lwz r7,0x0(r29)             
1000fa20  7f06c378    or r6,r24,r24               
1000fa24  7f0ac378    or r10,r24,r24              
1000fa28  4bff4979    bl 0x100043a0                  ; -> 100043a0
1000fa2c  60000000    ori r0,r0,0x0               
1000fa30  3bff0001    addi r31,r31,0x1            
1000fa34  7feb0734    extsh r11,r31               
1000fa38  2c0b0004    cmpwi r11,0x4               
1000fa3c  4081ff80    ble 0x1000f9bc                 ; -> 1000f9bc
1000fa40  480000ac    b 0x1000faec                   ; -> 1000faec
1000fa44  a9960000    lha r12,0x0(r22)            
1000fa48  7f64db78    or r4,r27,r27               
1000fa4c  1d8c0070    mulli r12,r12,0x70          
1000fa50  398c0040    addi r12,r12,0x40           
1000fa54  7c7762ae    lhax r3,r23,r12             
1000fa58  4801bef9    bl 0x1002b950                  ; -> 1002b950
1000fa5c  60000000    ori r0,r0,0x0               
1000fa60  3be00000    li r31,0x0                  
1000fa64  4800007c    b 0x1000fae0                   ; -> 1000fae0
1000fa68  7fe30734    extsh r3,r31                
1000fa6c  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
1000fa70  7fe40734    extsh r4,r31                
1000fa74  7c7c1aae    lhax r3,r28,r3              
1000fa78  5484083c    rlwinm r4,r4,0x1,0x0,0x1e   
1000fa7c  7c9b22ae    lhax r4,r27,r4              
1000fa80  7c630734    extsh r3,r3                 
1000fa84  7c032000    cmpw r3,r4                  
1000fa88  41820054    beq 0x1000fadc                 ; -> 1000fadc
1000fa8c  20df0004    subfic r6,r31,0x4           
1000fa90  7fe50734    extsh r5,r31                
1000fa94  7fe90734    extsh r9,r31                
1000fa98  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
1000fa9c  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
1000faa0  7cbc2aae    lhax r5,r28,r5              
1000faa4  7d3b4aae    lhax r9,r27,r9              
1000faa8  215f0004    subfic r10,r31,0x4          
1000faac  38850005    addi r4,r5,0x5              
1000fab0  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
1000fab4  7cbe3214    add r5,r30,r6               
1000fab8  39090005    addi r8,r9,0x5              
1000fabc  554a1838    rlwinm r10,r10,0x3,0x0,0x1c 
1000fac0  7d3e5214    add r9,r30,r10              
1000fac4  807d0000    lwz r3,0x0(r29)             
1000fac8  80fd0000    lwz r7,0x0(r29)             
1000facc  7f06c378    or r6,r24,r24               
1000fad0  7f0ac378    or r10,r24,r24              
1000fad4  4bff48cd    bl 0x100043a0                  ; -> 100043a0
1000fad8  60000000    ori r0,r0,0x0               
1000fadc  3bff0001    addi r31,r31,0x1            
1000fae0  7feb0734    extsh r11,r31               
1000fae4  2c0b0004    cmpwi r11,0x4               
1000fae8  4081ff80    ble 0x1000fa68                 ; -> 1000fa68
1000faec  88740000    lbz r3,0x0(r20)             
1000faf0  39800000    li r12,0x0                  
1000faf4  28030000    cmplwi r3,0x0               
1000faf8  40820008    bne 0x1000fb00                 ; -> 1000fb00
1000fafc  39800001    li r12,0x1                  
1000fb00  99940000    stb r12,0x0(r20)            
1000fb04  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
1000fb08  38210070    addi r1,r1,0x70             
1000fb0c  7c0803a6    mtspr LR,r0                 
1000fb10  ba81ffd0    lmw r20,-0x30(r1)              ; -> Stack[-0x30]
1000fb14  4e800020    blr                         
