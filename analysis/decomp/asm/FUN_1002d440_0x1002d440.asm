; FUN_1002d440 @ 0x1002d440  (336 instructions)
1002d440  7c0802a6    mfspr r0,LR                 
1002d444  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
1002d448  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002d44c  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
1002d450  3862523d    addi r3,r2,0x523d           
1002d454  3bc269ea    addi r30,r2,0x69ea          
1002d458  88630000    lbz r3,0x0(r3)              
1002d45c  3b826996    addi r28,r2,0x6996          
1002d460  28030000    cmplwi r3,0x0               
1002d464  3ba26840    addi r29,r2,0x6840          
1002d468  3b600000    li r27,0x0                  
1002d46c  41820024    beq 0x1002d490                 ; -> 1002d490
1002d470  3c600001    lis r3,0x1                  
1002d474  3863ffff    subi r3,r3,0x1              
1002d478  38810038    addi r4,r1,0x38             
1002d47c  38a00001    li r5,0x1                   
1002d480  7f66db78    or r6,r27,r27               
1002d484  48004bf5    bl 0x10032078                  ; -> 10032078
1002d488  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
1002d48c  98610048    stb r3,0x48(r1)                ; -> Stack[-0x28]
1002d490  3862758c    addi r3,r2,0x758c           
1002d494  48004d35    bl 0x100321c8                  ; -> 100321c8
1002d498  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x5c]
1002d49c  38a26992    addi r5,r2,0x6992           
1002d4a0  38800000    li r4,0x0                   
1002d4a4  98850000    stb r4,0x0(r5)              
1002d4a8  38c26993    addi r6,r2,0x6993           
1002d4ac  38e00000    li r7,0x0                   
1002d4b0  98860000    stb r4,0x0(r6)              
1002d4b4  98fd0090    stb r7,0x90(r29)            
1002d4b8  39000000    li r8,0x0                   
1002d4bc  991d0091    stb r8,0x91(r29)            
1002d4c0  39200000    li r9,0x0                   
1002d4c4  993d0092    stb r9,0x92(r29)            
1002d4c8  39400000    li r10,0x0                  
1002d4cc  995d0094    stb r10,0x94(r29)           
1002d4d0  39600000    li r11,0x0                  
1002d4d4  997d0093    stb r11,0x93(r29)           
1002d4d8  39800000    li r12,0x0                  
1002d4dc  999d008e    stb r12,0x8e(r29)           
1002d4e0  38600000    li r3,0x0                   
1002d4e4  987d008f    stb r3,0x8f(r29)            
1002d4e8  38800000    li r4,0x0                   
1002d4ec  989d0100    stb r4,0x100(r29)           
1002d4f0  38a00000    li r5,0x0                   
1002d4f4  98bd0101    stb r5,0x101(r29)           
1002d4f8  38c00000    li r6,0x0                   
1002d4fc  98dd0102    stb r6,0x102(r29)           
1002d500  38e00000    li r7,0x0                   
1002d504  98fd0104    stb r7,0x104(r29)           
1002d508  39000000    li r8,0x0                   
1002d50c  991d0103    stb r8,0x103(r29)           
1002d510  39200000    li r9,0x0                   
1002d514  993d00fe    stb r9,0xfe(r29)            
1002d518  39400000    li r10,0x0                  
1002d51c  995d00ff    stb r10,0xff(r29)           
1002d520  38603700    li r3,0x3700                
1002d524  4bfffe65    bl 0x1002d388                  ; -> 1002d388
1002d528  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d52c  28030000    cmplwi r3,0x0               
1002d530  418200f4    beq 0x1002d624                 ; -> 1002d624
1002d534  38600c00    li r3,0xc00                 
1002d538  4bfffe51    bl 0x1002d388                  ; -> 1002d388
1002d53c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d540  28030000    cmplwi r3,0x0               
1002d544  41820020    beq 0x1002d564                 ; -> 1002d564
1002d548  39826990    addi r12,r2,0x6990          
1002d54c  39600001    li r11,0x1                  
1002d550  38825263    addi r4,r2,0x5263           
1002d554  996c0000    stb r11,0x0(r12)            
1002d558  38600001    li r3,0x1                   
1002d55c  98640000    stb r3,0x0(r4)              
1002d560  4bfffebd    bl 0x1002d41c                  ; -> 1002d41c
1002d564  38a22f7c    addi r5,r2,0x2f7c           
1002d568  80650000    lwz r3,0x0(r5)              
1002d56c  4bfffe1d    bl 0x1002d388                  ; -> 1002d388
1002d570  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d574  28030000    cmplwi r3,0x0               
1002d578  41820014    beq 0x1002d58c                 ; -> 1002d58c
1002d57c  38e26993    addi r7,r2,0x6993           
1002d580  38c00001    li r6,0x1                   
1002d584  98c70000    stb r6,0x0(r7)              
1002d588  4bfffe95    bl 0x1002d41c                  ; -> 1002d41c
1002d58c  39022f80    addi r8,r2,0x2f80           
1002d590  80680000    lwz r3,0x0(r8)              
1002d594  4bfffdf5    bl 0x1002d388                  ; -> 1002d388
1002d598  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d59c  28030000    cmplwi r3,0x0               
1002d5a0  41820014    beq 0x1002d5b4                 ; -> 1002d5b4
1002d5a4  39426992    addi r10,r2,0x6992          
1002d5a8  39200001    li r9,0x1                   
1002d5ac  992a0000    stb r9,0x0(r10)             
1002d5b0  4bfffe6d    bl 0x1002d41c                  ; -> 1002d41c
1002d5b4  39622f78    addi r11,r2,0x2f78          
1002d5b8  806b0000    lwz r3,0x0(r11)             
1002d5bc  4bfffdcd    bl 0x1002d388                  ; -> 1002d388
1002d5c0  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d5c4  28030000    cmplwi r3,0x0               
1002d5c8  41820018    beq 0x1002d5e0                 ; -> 1002d5e0
1002d5cc  38626994    addi r3,r2,0x6994           
1002d5d0  39800001    li r12,0x1                  
1002d5d4  99830000    stb r12,0x0(r3)             
1002d5d8  4bfffe45    bl 0x1002d41c                  ; -> 1002d41c
1002d5dc  48000010    b 0x1002d5ec                   ; -> 1002d5ec
1002d5e0  38a26994    addi r5,r2,0x6994           
1002d5e4  38800000    li r4,0x0                   
1002d5e8  98850000    stb r4,0x0(r5)              
1002d5ec  38600100    li r3,0x100                 
1002d5f0  4bfffd99    bl 0x1002d388                  ; -> 1002d388
1002d5f4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d5f8  28030000    cmplwi r3,0x0               
1002d5fc  41820028    beq 0x1002d624                 ; -> 1002d624
1002d600  4bff3901    bl 0x10020f00                  ; -> 10020f00
1002d604  60000000    ori r0,r0,0x0               
1002d608  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d60c  28030000    cmplwi r3,0x0               
1002d610  41820010    beq 0x1002d620                 ; -> 1002d620
1002d614  3860002f    li r3,0x2f                  
1002d618  38800064    li r4,0x64                  
1002d61c  4bffda05    bl 0x1002b020                  ; -> 1002b020
1002d620  4bfffdfd    bl 0x1002d41c                  ; -> 1002d41c
1002d624  3be00001    li r31,0x1                  
1002d628  480002cc    b 0x1002d8f4                   ; -> 1002d8f4
1002d62c  7fe60734    extsh r6,r31                
1002d630  1cc6001c    mulli r6,r6,0x1c            
1002d634  7c7c302e    lwzx r3,r28,r6              
1002d638  4bfffd51    bl 0x1002d388                  ; -> 1002d388
1002d63c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d640  28030000    cmplwi r3,0x0               
1002d644  41820018    beq 0x1002d65c                 ; -> 1002d65c
1002d648  7fe80734    extsh r8,r31                
1002d64c  1d080070    mulli r8,r8,0x70            
1002d650  38e00001    li r7,0x1                   
1002d654  3908001f    addi r8,r8,0x1f             
1002d658  7cfd41ae    stbx r7,r29,r8              
1002d65c  7fe90734    extsh r9,r31                
1002d660  1d29001c    mulli r9,r9,0x1c            
1002d664  39290004    addi r9,r9,0x4              
1002d668  7c7c482e    lwzx r3,r28,r9              
1002d66c  4bfffd1d    bl 0x1002d388                  ; -> 1002d388
1002d670  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d674  28030000    cmplwi r3,0x0               
1002d678  41820018    beq 0x1002d690                 ; -> 1002d690
1002d67c  7feb0734    extsh r11,r31               
1002d680  1d6b0070    mulli r11,r11,0x70          
1002d684  39400001    li r10,0x1                  
1002d688  396b001e    addi r11,r11,0x1e           
1002d68c  7d5d59ae    stbx r10,r29,r11            
1002d690  7fec0734    extsh r12,r31               
1002d694  1d8c001c    mulli r12,r12,0x1c          
1002d698  398c0018    addi r12,r12,0x18           
1002d69c  7c7c602e    lwzx r3,r28,r12             
1002d6a0  4bfffce9    bl 0x1002d388                  ; -> 1002d388
1002d6a4  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d6a8  28030000    cmplwi r3,0x0               
1002d6ac  41820048    beq 0x1002d6f4                 ; -> 1002d6f4
1002d6b0  7fe30734    extsh r3,r31                
1002d6b4  1c630006    mulli r3,r3,0x6             
1002d6b8  38630004    addi r3,r3,0x4              
1002d6bc  7c7e18ae    lbzx r3,r30,r3              
1002d6c0  28030000    cmplwi r3,0x0               
1002d6c4  40820018    bne 0x1002d6dc                 ; -> 1002d6dc
1002d6c8  7fe50734    extsh r5,r31                
1002d6cc  1ca50070    mulli r5,r5,0x70            
1002d6d0  38800001    li r4,0x1                   
1002d6d4  38a50023    addi r5,r5,0x23             
1002d6d8  7c9d29ae    stbx r4,r29,r5              
1002d6dc  7fe70734    extsh r7,r31                
1002d6e0  1ce70006    mulli r7,r7,0x6             
1002d6e4  38c00001    li r6,0x1                   
1002d6e8  38e70004    addi r7,r7,0x4              
1002d6ec  7cde39ae    stbx r6,r30,r7              
1002d6f0  48000018    b 0x1002d708                   ; -> 1002d708
1002d6f4  7fe90734    extsh r9,r31                
1002d6f8  1d290006    mulli r9,r9,0x6             
1002d6fc  39000000    li r8,0x0                   
1002d700  39290004    addi r9,r9,0x4              
1002d704  7d1e49ae    stbx r8,r30,r9              
1002d708  7fea0734    extsh r10,r31               
1002d70c  1d4a001c    mulli r10,r10,0x1c          
1002d710  394a0014    addi r10,r10,0x14           
1002d714  7c7c502e    lwzx r3,r28,r10             
1002d718  4bfffc71    bl 0x1002d388                  ; -> 1002d388
1002d71c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d720  28030000    cmplwi r3,0x0               
1002d724  41820048    beq 0x1002d76c                 ; -> 1002d76c
1002d728  7feb0734    extsh r11,r31               
1002d72c  1d6b0006    mulli r11,r11,0x6           
1002d730  396b0003    addi r11,r11,0x3            
1002d734  7d7e58ae    lbzx r11,r30,r11            
1002d738  280b0000    cmplwi r11,0x0              
1002d73c  40820018    bne 0x1002d754                 ; -> 1002d754
1002d740  7fe30734    extsh r3,r31                
1002d744  1c630070    mulli r3,r3,0x70            
1002d748  39800001    li r12,0x1                  
1002d74c  38630024    addi r3,r3,0x24             
1002d750  7d9d19ae    stbx r12,r29,r3             
1002d754  7fe50734    extsh r5,r31                
1002d758  1ca50006    mulli r5,r5,0x6             
1002d75c  38800001    li r4,0x1                   
1002d760  38a50003    addi r5,r5,0x3              
1002d764  7c9e29ae    stbx r4,r30,r5              
1002d768  48000018    b 0x1002d780                   ; -> 1002d780
1002d76c  7fe70734    extsh r7,r31                
1002d770  1ce70006    mulli r7,r7,0x6             
1002d774  38c00000    li r6,0x0                   
1002d778  38e70003    addi r7,r7,0x3              
1002d77c  7cde39ae    stbx r6,r30,r7              
1002d780  7fe80734    extsh r8,r31                
1002d784  1d08001c    mulli r8,r8,0x1c            
1002d788  39080010    addi r8,r8,0x10             
1002d78c  7c7c402e    lwzx r3,r28,r8              
1002d790  4bfffbf9    bl 0x1002d388                  ; -> 1002d388
1002d794  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d798  28030000    cmplwi r3,0x0               
1002d79c  41820048    beq 0x1002d7e4                 ; -> 1002d7e4
1002d7a0  7fe90734    extsh r9,r31                
1002d7a4  1d290006    mulli r9,r9,0x6             
1002d7a8  39290002    addi r9,r9,0x2              
1002d7ac  7d3e48ae    lbzx r9,r30,r9              
1002d7b0  28090000    cmplwi r9,0x0               
1002d7b4  40820018    bne 0x1002d7cc                 ; -> 1002d7cc
1002d7b8  7feb0734    extsh r11,r31               
1002d7bc  1d6b0070    mulli r11,r11,0x70          
1002d7c0  39400001    li r10,0x1                  
1002d7c4  396b0022    addi r11,r11,0x22           
1002d7c8  7d5d59ae    stbx r10,r29,r11            
1002d7cc  7fe30734    extsh r3,r31                
1002d7d0  1c630006    mulli r3,r3,0x6             
1002d7d4  39800001    li r12,0x1                  
1002d7d8  38630002    addi r3,r3,0x2              
1002d7dc  7d9e19ae    stbx r12,r30,r3             
1002d7e0  48000018    b 0x1002d7f8                   ; -> 1002d7f8
1002d7e4  7fe50734    extsh r5,r31                
1002d7e8  1ca50006    mulli r5,r5,0x6             
1002d7ec  38800000    li r4,0x0                   
1002d7f0  38a50002    addi r5,r5,0x2              
1002d7f4  7c9e29ae    stbx r4,r30,r5              
1002d7f8  7fe60734    extsh r6,r31                
1002d7fc  1cc6001c    mulli r6,r6,0x1c            
1002d800  38c6000c    addi r6,r6,0xc              
1002d804  7c7c302e    lwzx r3,r28,r6              
1002d808  4bfffb81    bl 0x1002d388                  ; -> 1002d388
1002d80c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d810  28030000    cmplwi r3,0x0               
1002d814  41820048    beq 0x1002d85c                 ; -> 1002d85c
1002d818  7fe70734    extsh r7,r31                
1002d81c  1ce70006    mulli r7,r7,0x6             
1002d820  38e70001    addi r7,r7,0x1              
1002d824  7cfe38ae    lbzx r7,r30,r7              
1002d828  28070000    cmplwi r7,0x0               
1002d82c  40820018    bne 0x1002d844                 ; -> 1002d844
1002d830  7fe90734    extsh r9,r31                
1002d834  1d290070    mulli r9,r9,0x70            
1002d838  39000001    li r8,0x1                   
1002d83c  39290021    addi r9,r9,0x21             
1002d840  7d1d49ae    stbx r8,r29,r9              
1002d844  7feb0734    extsh r11,r31               
1002d848  1d6b0006    mulli r11,r11,0x6           
1002d84c  39400001    li r10,0x1                  
1002d850  396b0001    addi r11,r11,0x1            
1002d854  7d5e59ae    stbx r10,r30,r11            
1002d858  48000018    b 0x1002d870                   ; -> 1002d870
1002d85c  7fe30734    extsh r3,r31                
1002d860  1c630006    mulli r3,r3,0x6             
1002d864  39800000    li r12,0x0                  
1002d868  38630001    addi r3,r3,0x1              
1002d86c  7d9e19ae    stbx r12,r30,r3             
1002d870  7fe40734    extsh r4,r31                
1002d874  1c84001c    mulli r4,r4,0x1c            
1002d878  38840008    addi r4,r4,0x8              
1002d87c  7c7c202e    lwzx r3,r28,r4              
1002d880  4bfffb09    bl 0x1002d388                  ; -> 1002d388
1002d884  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d888  28030000    cmplwi r3,0x0               
1002d88c  41820054    beq 0x1002d8e0                 ; -> 1002d8e0
1002d890  7fe50734    extsh r5,r31                
1002d894  1ca50006    mulli r5,r5,0x6             
1002d898  7cbe28ae    lbzx r5,r30,r5              
1002d89c  28050000    cmplwi r5,0x0               
1002d8a0  40820018    bne 0x1002d8b8                 ; -> 1002d8b8
1002d8a4  7fe70734    extsh r7,r31                
1002d8a8  1ce70070    mulli r7,r7,0x70            
1002d8ac  38c00001    li r6,0x1                   
1002d8b0  38e70020    addi r7,r7,0x20             
1002d8b4  7cdd39ae    stbx r6,r29,r7              
1002d8b8  7fe90734    extsh r9,r31                
1002d8bc  1d290070    mulli r9,r9,0x70            
1002d8c0  7feb0734    extsh r11,r31               
1002d8c4  1d6b0006    mulli r11,r11,0x6           
1002d8c8  39000001    li r8,0x1                   
1002d8cc  39290020    addi r9,r9,0x20             
1002d8d0  7d1d49ae    stbx r8,r29,r9              
1002d8d4  39400001    li r10,0x1                  
1002d8d8  7d5e59ae    stbx r10,r30,r11            
1002d8dc  48000014    b 0x1002d8f0                   ; -> 1002d8f0
1002d8e0  7fe30734    extsh r3,r31                
1002d8e4  1c630006    mulli r3,r3,0x6             
1002d8e8  39800000    li r12,0x0                  
1002d8ec  7d9e19ae    stbx r12,r30,r3             
1002d8f0  3bff0001    addi r31,r31,0x1            
1002d8f4  7fe40734    extsh r4,r31                
1002d8f8  2c040003    cmpwi r4,0x3                
1002d8fc  4180fd30    blt 0x1002d62c                 ; -> 1002d62c
1002d900  38a22f88    addi r5,r2,0x2f88           
1002d904  80650000    lwz r3,0x0(r5)              
1002d908  4bfffa81    bl 0x1002d388                  ; -> 1002d388
1002d90c  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d910  28030000    cmplwi r3,0x0               
1002d914  41820010    beq 0x1002d924                 ; -> 1002d924
1002d918  38e26991    addi r7,r2,0x6991           
1002d91c  38c00001    li r6,0x1                   
1002d920  98c70000    stb r6,0x0(r7)              
1002d924  39022f8c    addi r8,r2,0x2f8c           
1002d928  80680000    lwz r3,0x0(r8)              
1002d92c  4bfffa5d    bl 0x1002d388                  ; -> 1002d388
1002d930  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d934  28030000    cmplwi r3,0x0               
1002d938  41820010    beq 0x1002d948                 ; -> 1002d948
1002d93c  39426990    addi r10,r2,0x6990          
1002d940  39200001    li r9,0x1                   
1002d944  992a0000    stb r9,0x0(r10)             
1002d948  39622f84    addi r11,r2,0x2f84          
1002d94c  806b0000    lwz r3,0x0(r11)             
1002d950  4bfffa39    bl 0x1002d388                  ; -> 1002d388
1002d954  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1002d958  28030000    cmplwi r3,0x0               
1002d95c  41820010    beq 0x1002d96c                 ; -> 1002d96c
1002d960  38625260    addi r3,r2,0x5260           
1002d964  39800001    li r12,0x1                  
1002d968  99830000    stb r12,0x0(r3)             
1002d96c  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
1002d970  38210070    addi r1,r1,0x70             
1002d974  7c0803a6    mtspr LR,r0                 
1002d978  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
1002d97c  4e800020    blr                         
