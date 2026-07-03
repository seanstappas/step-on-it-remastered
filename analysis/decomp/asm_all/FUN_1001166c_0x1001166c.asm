; FUN_1001166c @ 0x1001166c
1001166c  7c0802a6    mfspr r0,LR                 
10011670  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
10011674  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10011678  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001167c  7c7f1b78    or r31,r3,r3                
10011680  3ba26bc4    addi r29,r2,0x6bc4          
10011684  3bc26840    addi r30,r2,0x6840          
10011688  7fe3fb78    or r3,r31,r31               
1001168c  4800312d    bl 0x100147b8                  ; -> 100147b8
10011690  60000000    ori r0,r0,0x0               
10011694  7fe40734    extsh r4,r31                
10011698  1c840070    mulli r4,r4,0x70            
1001169c  7fe50734    extsh r5,r31                
100116a0  1ca50070    mulli r5,r5,0x70            
100116a4  7fe30734    extsh r3,r31                
100116a8  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100116ac  7c7d182e    lwzx r3,r29,r3              
100116b0  38840006    addi r4,r4,0x6              
100116b4  7c7e212e    stwx r3,r30,r4              
100116b8  38a50028    addi r5,r5,0x28             
100116bc  7cbe28ae    lbzx r5,r30,r5              
100116c0  28050000    cmplwi r5,0x0               
100116c4  41820014    beq 0x100116d8                 ; -> 100116d8
100116c8  7fe3fb78    or r3,r31,r31               
100116cc  48000901    bl 0x10011fcc                  ; -> 10011fcc
100116d0  60000000    ori r0,r0,0x0               
100116d4  480008e4    b 0x10011fb8                   ; -> 10011fb8
100116d8  7fe60734    extsh r6,r31                
100116dc  1cc60070    mulli r6,r6,0x70            
100116e0  38c60025    addi r6,r6,0x25             
100116e4  7cde30ae    lbzx r6,r30,r6              
100116e8  28060000    cmplwi r6,0x0               
100116ec  408202a4    bne 0x10011990                 ; -> 10011990
100116f0  7fe70734    extsh r7,r31                
100116f4  1ce70070    mulli r7,r7,0x70            
100116f8  38e70021    addi r7,r7,0x21             
100116fc  7cfe38ae    lbzx r7,r30,r7              
10011700  28070000    cmplwi r7,0x0               
10011704  41820094    beq 0x10011798                 ; -> 10011798
10011708  7fe3fb78    or r3,r31,r31               
1001170c  48002ff5    bl 0x10014700                  ; -> 10014700
10011710  60000000    ori r0,r0,0x0               
10011714  7fe90734    extsh r9,r31                
10011718  1d290070    mulli r9,r9,0x70            
1001171c  7fea0734    extsh r10,r31               
10011720  1d4a0070    mulli r10,r10,0x70          
10011724  39000001    li r8,0x1                   
10011728  39290025    addi r9,r9,0x25             
1001172c  7d1e49ae    stbx r8,r30,r9              
10011730  394a0034    addi r10,r10,0x34           
10011734  7d5e52ae    lhax r10,r30,r10            
10011738  2c0a0001    cmpwi r10,0x1               
1001173c  4082001c    bne 0x10011758                 ; -> 10011758
10011740  7fec0734    extsh r12,r31               
10011744  1d8c0070    mulli r12,r12,0x70          
10011748  39600003    li r11,0x3                  
1001174c  398c0030    addi r12,r12,0x30           
10011750  7d7e632e    sthx r11,r30,r12            
10011754  48000018    b 0x1001176c                   ; -> 1001176c
10011758  7fe40734    extsh r4,r31                
1001175c  1c840070    mulli r4,r4,0x70            
10011760  38600001    li r3,0x1                   
10011764  38840030    addi r4,r4,0x30             
10011768  7c7e232e    sthx r3,r30,r4              
1001176c  7fe60734    extsh r6,r31                
10011770  1cc60070    mulli r6,r6,0x70            
10011774  7fe80734    extsh r8,r31                
10011778  1d080070    mulli r8,r8,0x70            
1001177c  38a00000    li r5,0x0                   
10011780  38c6002c    addi r6,r6,0x2c             
10011784  7cbe332e    sthx r5,r30,r6              
10011788  38e00001    li r7,0x1                   
1001178c  3908002e    addi r8,r8,0x2e             
10011790  7cfe432e    sthx r7,r30,r8              
10011794  48000734    b 0x10011ec8                   ; -> 10011ec8
10011798  7fe90734    extsh r9,r31                
1001179c  1d290070    mulli r9,r9,0x70            
100117a0  39290022    addi r9,r9,0x22             
100117a4  7d3e48ae    lbzx r9,r30,r9              
100117a8  28090000    cmplwi r9,0x0               
100117ac  41820094    beq 0x10011840                 ; -> 10011840
100117b0  7fe3fb78    or r3,r31,r31               
100117b4  48002f4d    bl 0x10014700                  ; -> 10014700
100117b8  60000000    ori r0,r0,0x0               
100117bc  7feb0734    extsh r11,r31               
100117c0  1d6b0070    mulli r11,r11,0x70          
100117c4  7fec0734    extsh r12,r31               
100117c8  1d8c0070    mulli r12,r12,0x70          
100117cc  39400001    li r10,0x1                  
100117d0  396b0025    addi r11,r11,0x25           
100117d4  7d5e59ae    stbx r10,r30,r11            
100117d8  398c0034    addi r12,r12,0x34           
100117dc  7d9e62ae    lhax r12,r30,r12            
100117e0  2c0c0001    cmpwi r12,0x1               
100117e4  4082001c    bne 0x10011800                 ; -> 10011800
100117e8  7fe40734    extsh r4,r31                
100117ec  1c840070    mulli r4,r4,0x70            
100117f0  38600004    li r3,0x4                   
100117f4  38840030    addi r4,r4,0x30             
100117f8  7c7e232e    sthx r3,r30,r4              
100117fc  48000018    b 0x10011814                   ; -> 10011814
10011800  7fe60734    extsh r6,r31                
10011804  1cc60070    mulli r6,r6,0x70            
10011808  38a00002    li r5,0x2                   
1001180c  38c60030    addi r6,r6,0x30             
10011810  7cbe332e    sthx r5,r30,r6              
10011814  7fe80734    extsh r8,r31                
10011818  1d080070    mulli r8,r8,0x70            
1001181c  7fea0734    extsh r10,r31               
10011820  1d4a0070    mulli r10,r10,0x70          
10011824  38e00000    li r7,0x0                   
10011828  3908002c    addi r8,r8,0x2c             
1001182c  7cfe432e    sthx r7,r30,r8              
10011830  39200001    li r9,0x1                   
10011834  394a002e    addi r10,r10,0x2e           
10011838  7d3e532e    sthx r9,r30,r10             
1001183c  4800068c    b 0x10011ec8                   ; -> 10011ec8
10011840  7feb0734    extsh r11,r31               
10011844  1d6b0070    mulli r11,r11,0x70          
10011848  396b0024    addi r11,r11,0x24           
1001184c  7d7e58ae    lbzx r11,r30,r11            
10011850  280b0000    cmplwi r11,0x0              
10011854  41820094    beq 0x100118e8                 ; -> 100118e8
10011858  7fe3fb78    or r3,r31,r31               
1001185c  48002ea5    bl 0x10014700                  ; -> 10014700
10011860  60000000    ori r0,r0,0x0               
10011864  7fe30734    extsh r3,r31                
10011868  1c630070    mulli r3,r3,0x70            
1001186c  7fe40734    extsh r4,r31                
10011870  1c840070    mulli r4,r4,0x70            
10011874  39800001    li r12,0x1                  
10011878  38630025    addi r3,r3,0x25             
1001187c  7d9e19ae    stbx r12,r30,r3             
10011880  38840034    addi r4,r4,0x34             
10011884  7c9e22ae    lhax r4,r30,r4              
10011888  2c040001    cmpwi r4,0x1                
1001188c  4082001c    bne 0x100118a8                 ; -> 100118a8
10011890  7fe60734    extsh r6,r31                
10011894  1cc60070    mulli r6,r6,0x70            
10011898  38a00003    li r5,0x3                   
1001189c  38c60030    addi r6,r6,0x30             
100118a0  7cbe332e    sthx r5,r30,r6              
100118a4  48000018    b 0x100118bc                   ; -> 100118bc
100118a8  7fe80734    extsh r8,r31                
100118ac  1d080070    mulli r8,r8,0x70            
100118b0  38e00001    li r7,0x1                   
100118b4  39080030    addi r8,r8,0x30             
100118b8  7cfe432e    sthx r7,r30,r8              
100118bc  7fea0734    extsh r10,r31               
100118c0  1d4a0070    mulli r10,r10,0x70          
100118c4  7fec0734    extsh r12,r31               
100118c8  1d8c0070    mulli r12,r12,0x70          
100118cc  39200000    li r9,0x0                   
100118d0  394a002c    addi r10,r10,0x2c           
100118d4  7d3e532e    sthx r9,r30,r10             
100118d8  39600003    li r11,0x3                  
100118dc  398c002e    addi r12,r12,0x2e           
100118e0  7d7e632e    sthx r11,r30,r12            
100118e4  480005e4    b 0x10011ec8                   ; -> 10011ec8
100118e8  7fe30734    extsh r3,r31                
100118ec  1c630070    mulli r3,r3,0x70            
100118f0  38630023    addi r3,r3,0x23             
100118f4  7c7e18ae    lbzx r3,r30,r3              
100118f8  28030000    cmplwi r3,0x0               
100118fc  418205cc    beq 0x10011ec8                 ; -> 10011ec8
10011900  7fe3fb78    or r3,r31,r31               
10011904  48002dfd    bl 0x10014700                  ; -> 10014700
10011908  60000000    ori r0,r0,0x0               
1001190c  7fe50734    extsh r5,r31                
10011910  1ca50070    mulli r5,r5,0x70            
10011914  7fe60734    extsh r6,r31                
10011918  1cc60070    mulli r6,r6,0x70            
1001191c  38800001    li r4,0x1                   
10011920  38a50025    addi r5,r5,0x25             
10011924  7c9e29ae    stbx r4,r30,r5              
10011928  38c60034    addi r6,r6,0x34             
1001192c  7cde32ae    lhax r6,r30,r6              
10011930  2c060001    cmpwi r6,0x1                
10011934  4082001c    bne 0x10011950                 ; -> 10011950
10011938  7fe80734    extsh r8,r31                
1001193c  1d080070    mulli r8,r8,0x70            
10011940  38e00003    li r7,0x3                   
10011944  39080030    addi r8,r8,0x30             
10011948  7cfe432e    sthx r7,r30,r8              
1001194c  48000018    b 0x10011964                   ; -> 10011964
10011950  7fea0734    extsh r10,r31               
10011954  1d4a0070    mulli r10,r10,0x70          
10011958  39200001    li r9,0x1                   
1001195c  394a0030    addi r10,r10,0x30           
10011960  7d3e532e    sthx r9,r30,r10             
10011964  7fec0734    extsh r12,r31               
10011968  1d8c0070    mulli r12,r12,0x70          
1001196c  7fe40734    extsh r4,r31                
10011970  1c840070    mulli r4,r4,0x70            
10011974  39600000    li r11,0x0                  
10011978  398c002c    addi r12,r12,0x2c           
1001197c  7d7e632e    sthx r11,r30,r12            
10011980  38600002    li r3,0x2                   
10011984  3884002e    addi r4,r4,0x2e             
10011988  7c7e232e    sthx r3,r30,r4              
1001198c  4800053c    b 0x10011ec8                   ; -> 10011ec8
10011990  7fe50734    extsh r5,r31                
10011994  1ca50070    mulli r5,r5,0x70            
10011998  7fe60734    extsh r6,r31                
1001199c  1cc60070    mulli r6,r6,0x70            
100119a0  7fe70734    extsh r7,r31                
100119a4  1ce70070    mulli r7,r7,0x70            
100119a8  7cbe2aae    lhax r5,r30,r5              
100119ac  38c60002    addi r6,r6,0x2              
100119b0  7cbe332e    sthx r5,r30,r6              
100119b4  38e70030    addi r7,r7,0x30             
100119b8  7cfe3aae    lhax r7,r30,r7              
100119bc  2c070003    cmpwi r7,0x3                
100119c0  4082015c    bne 0x10011b1c                 ; -> 10011b1c
100119c4  7fe80734    extsh r8,r31                
100119c8  1d080070    mulli r8,r8,0x70            
100119cc  3908002c    addi r8,r8,0x2c             
100119d0  7d3e42ae    lhax r9,r30,r8              
100119d4  39290001    addi r9,r9,0x1              
100119d8  7d3e432e    sthx r9,r30,r8              
100119dc  7d290734    extsh r9,r9                 
100119e0  2c090006    cmpwi r9,0x6                
100119e4  4081001c    ble 0x10011a00                 ; -> 10011a00
100119e8  7feb0734    extsh r11,r31               
100119ec  1d6b0070    mulli r11,r11,0x70          
100119f0  39400000    li r10,0x0                  
100119f4  396b0025    addi r11,r11,0x25           
100119f8  7d5e59ae    stbx r10,r30,r11            
100119fc  4800004c    b 0x10011a48                   ; -> 10011a48
10011a00  7fe30734    extsh r3,r31                
10011a04  1c630070    mulli r3,r3,0x70            
10011a08  7fe50734    extsh r5,r31                
10011a0c  1ca50070    mulli r5,r5,0x70            
10011a10  7fec0734    extsh r12,r31               
10011a14  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
10011a18  7fe60734    extsh r6,r31                
10011a1c  1cc60070    mulli r6,r6,0x70            
10011a20  7d9d602e    lwzx r12,r29,r12            
10011a24  38630006    addi r3,r3,0x6              
10011a28  7d9e192e    stwx r12,r30,r3             
10011a2c  38a5002c    addi r5,r5,0x2c             
10011a30  7cbe2aae    lhax r5,r30,r5              
10011a34  3882057c    addi r4,r2,0x57c            
10011a38  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
10011a3c  7c842aae    lhax r4,r4,r5               
10011a40  38c6000e    addi r6,r6,0xe              
10011a44  7c9e332e    sthx r4,r30,r6              
10011a48  7fe70734    extsh r7,r31                
10011a4c  1ce70070    mulli r7,r7,0x70            
10011a50  38e7002c    addi r7,r7,0x2c             
10011a54  7cfe3aae    lhax r7,r30,r7              
10011a58  2c070005    cmpwi r7,0x5                
10011a5c  4082046c    bne 0x10011ec8                 ; -> 10011ec8
10011a60  7fe80734    extsh r8,r31                
10011a64  1d080070    mulli r8,r8,0x70            
10011a68  3908002e    addi r8,r8,0x2e             
10011a6c  7d1e42ae    lhax r8,r30,r8              
10011a70  2c080001    cmpwi r8,0x1                
10011a74  40820058    bne 0x10011acc                 ; -> 10011acc
10011a78  7fe90734    extsh r9,r31                
10011a7c  1d290070    mulli r9,r9,0x70            
10011a80  39290004    addi r9,r9,0x4              
10011a84  7d3e4aae    lhax r9,r30,r9              
10011a88  38690010    addi r3,r9,0x10             
10011a8c  4801cc6d    bl 0x1002e6f8                  ; -> 1002e6f8
10011a90  60000000    ori r0,r0,0x0               
10011a94  7fea0734    extsh r10,r31               
10011a98  1d4a0070    mulli r10,r10,0x70          
10011a9c  7d5e52ae    lhax r10,r30,r10            
10011aa0  7c7c1b78    or r28,r3,r3                
10011aa4  386a0030    addi r3,r10,0x30            
10011aa8  4801cc25    bl 0x1002e6cc                  ; -> 1002e6cc
10011aac  60000000    ori r0,r0,0x0               
10011ab0  7c7b1b78    or r27,r3,r3                
10011ab4  7f63db78    or r3,r27,r27               
10011ab8  7f84e378    or r4,r28,r28               
10011abc  7fe5fb78    or r5,r31,r31               
10011ac0  4801b58d    bl 0x1002d04c                  ; -> 1002d04c
10011ac4  60000000    ori r0,r0,0x0               
10011ac8  48000400    b 0x10011ec8                   ; -> 10011ec8
10011acc  7feb0734    extsh r11,r31               
10011ad0  1d6b0070    mulli r11,r11,0x70          
10011ad4  396b002e    addi r11,r11,0x2e           
10011ad8  7d7e5aae    lhax r11,r30,r11            
10011adc  2c0b0003    cmpwi r11,0x3               
10011ae0  40820014    bne 0x10011af4                 ; -> 10011af4
10011ae4  7fe3fb78    or r3,r31,r31               
10011ae8  4bfff5cd    bl 0x100110b4                  ; -> 100110b4
10011aec  60000000    ori r0,r0,0x0               
10011af0  480003d8    b 0x10011ec8                   ; -> 10011ec8
10011af4  7fec0734    extsh r12,r31               
10011af8  1d8c0070    mulli r12,r12,0x70          
10011afc  398c002e    addi r12,r12,0x2e           
10011b00  7d9e62ae    lhax r12,r30,r12            
10011b04  2c0c0002    cmpwi r12,0x2               
10011b08  408203c0    bne 0x10011ec8                 ; -> 10011ec8
10011b0c  7fe3fb78    or r3,r31,r31               
10011b10  4bfff221    bl 0x10010d30                  ; -> 10010d30
10011b14  60000000    ori r0,r0,0x0               
10011b18  480003b0    b 0x10011ec8                   ; -> 10011ec8
10011b1c  7ffb0734    extsh r27,r31               
10011b20  1f7b0070    mulli r27,r27,0x70          
10011b24  3b7b0030    addi r27,r27,0x30           
10011b28  7f7edaae    lhax r27,r30,r27            
10011b2c  2c1b0001    cmpwi r27,0x1               
10011b30  4082015c    bne 0x10011c8c                 ; -> 10011c8c
10011b34  7ffc0734    extsh r28,r31               
10011b38  1f9c0070    mulli r28,r28,0x70          
10011b3c  3b9c002c    addi r28,r28,0x2c           
10011b40  7c7ee2ae    lhax r3,r30,r28             
10011b44  38630001    addi r3,r3,0x1              
10011b48  7c7ee32e    sthx r3,r30,r28             
10011b4c  7c630734    extsh r3,r3                 
10011b50  2c030006    cmpwi r3,0x6                
10011b54  4081001c    ble 0x10011b70                 ; -> 10011b70
10011b58  7fe50734    extsh r5,r31                
10011b5c  1ca50070    mulli r5,r5,0x70            
10011b60  38800000    li r4,0x0                   
10011b64  38a50025    addi r5,r5,0x25             
10011b68  7c9e29ae    stbx r4,r30,r5              
10011b6c  4800004c    b 0x10011bb8                   ; -> 10011bb8
10011b70  7fe70734    extsh r7,r31                
10011b74  1ce70070    mulli r7,r7,0x70            
10011b78  7fe90734    extsh r9,r31                
10011b7c  1d290070    mulli r9,r9,0x70            
10011b80  7fe60734    extsh r6,r31                
10011b84  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
10011b88  7fea0734    extsh r10,r31               
10011b8c  1d4a0070    mulli r10,r10,0x70          
10011b90  7cdd302e    lwzx r6,r29,r6              
10011b94  38e70006    addi r7,r7,0x6              
10011b98  7cde392e    stwx r6,r30,r7              
10011b9c  3929002c    addi r9,r9,0x2c             
10011ba0  7d3e4aae    lhax r9,r30,r9              
10011ba4  3902058a    addi r8,r2,0x58a            
10011ba8  5529083c    rlwinm r9,r9,0x1,0x0,0x1e   
10011bac  7d084aae    lhax r8,r8,r9               
10011bb0  394a000e    addi r10,r10,0xe            
10011bb4  7d1e532e    sthx r8,r30,r10             
10011bb8  7feb0734    extsh r11,r31               
10011bbc  1d6b0070    mulli r11,r11,0x70          
10011bc0  396b002c    addi r11,r11,0x2c           
10011bc4  7d7e5aae    lhax r11,r30,r11            
10011bc8  2c0b0005    cmpwi r11,0x5               
10011bcc  408202fc    bne 0x10011ec8                 ; -> 10011ec8
10011bd0  7fec0734    extsh r12,r31               
10011bd4  1d8c0070    mulli r12,r12,0x70          
10011bd8  398c002e    addi r12,r12,0x2e           
10011bdc  7d9e62ae    lhax r12,r30,r12            
10011be0  2c0c0001    cmpwi r12,0x1               
10011be4  40820058    bne 0x10011c3c                 ; -> 10011c3c
10011be8  7ffb0734    extsh r27,r31               
10011bec  1f7b0070    mulli r27,r27,0x70          
10011bf0  3b7b0004    addi r27,r27,0x4            
10011bf4  7f7edaae    lhax r27,r30,r27            
10011bf8  387b0010    addi r3,r27,0x10            
10011bfc  4801cafd    bl 0x1002e6f8                  ; -> 1002e6f8
10011c00  60000000    ori r0,r0,0x0               
10011c04  7fe40734    extsh r4,r31                
10011c08  1c840070    mulli r4,r4,0x70            
10011c0c  7c9e22ae    lhax r4,r30,r4              
10011c10  7c7c1b78    or r28,r3,r3                
10011c14  3864ffee    subi r3,r4,0x12             
10011c18  4801cab5    bl 0x1002e6cc                  ; -> 1002e6cc
10011c1c  60000000    ori r0,r0,0x0               
10011c20  7c7b1b78    or r27,r3,r3                
10011c24  7f63db78    or r3,r27,r27               
10011c28  7f84e378    or r4,r28,r28               
10011c2c  7fe5fb78    or r5,r31,r31               
10011c30  4801b2d9    bl 0x1002cf08                  ; -> 1002cf08
10011c34  60000000    ori r0,r0,0x0               
10011c38  48000290    b 0x10011ec8                   ; -> 10011ec8
10011c3c  7fe50734    extsh r5,r31                
10011c40  1ca50070    mulli r5,r5,0x70            
10011c44  38a5002e    addi r5,r5,0x2e             
10011c48  7cbe2aae    lhax r5,r30,r5              
10011c4c  2c050003    cmpwi r5,0x3                
10011c50  40820014    bne 0x10011c64                 ; -> 10011c64
10011c54  7fe3fb78    or r3,r31,r31               
10011c58  4bfff45d    bl 0x100110b4                  ; -> 100110b4
10011c5c  60000000    ori r0,r0,0x0               
10011c60  48000268    b 0x10011ec8                   ; -> 10011ec8
10011c64  7fe60734    extsh r6,r31                
10011c68  1cc60070    mulli r6,r6,0x70            
10011c6c  38c6002e    addi r6,r6,0x2e             
10011c70  7cde32ae    lhax r6,r30,r6              
10011c74  2c060002    cmpwi r6,0x2                
10011c78  40820250    bne 0x10011ec8                 ; -> 10011ec8
10011c7c  7fe3fb78    or r3,r31,r31               
10011c80  4bfff0b1    bl 0x10010d30                  ; -> 10010d30
10011c84  60000000    ori r0,r0,0x0               
10011c88  48000240    b 0x10011ec8                   ; -> 10011ec8
10011c8c  7fe70734    extsh r7,r31                
10011c90  1ce70070    mulli r7,r7,0x70            
10011c94  38e70030    addi r7,r7,0x30             
10011c98  7cfe3aae    lhax r7,r30,r7              
10011c9c  2c070004    cmpwi r7,0x4                
10011ca0  4082010c    bne 0x10011dac                 ; -> 10011dac
10011ca4  7fe80734    extsh r8,r31                
10011ca8  1d080070    mulli r8,r8,0x70            
10011cac  3908002c    addi r8,r8,0x2c             
10011cb0  7d3e42ae    lhax r9,r30,r8              
10011cb4  39290001    addi r9,r9,0x1              
10011cb8  7d3e432e    sthx r9,r30,r8              
10011cbc  7d290734    extsh r9,r9                 
10011cc0  2c090006    cmpwi r9,0x6                
10011cc4  4081001c    ble 0x10011ce0                 ; -> 10011ce0
10011cc8  7feb0734    extsh r11,r31               
10011ccc  1d6b0070    mulli r11,r11,0x70          
10011cd0  39400000    li r10,0x0                  
10011cd4  396b0025    addi r11,r11,0x25           
10011cd8  7d5e59ae    stbx r10,r30,r11            
10011cdc  4800004c    b 0x10011d28                   ; -> 10011d28
10011ce0  7ffb0734    extsh r27,r31               
10011ce4  1f7b0070    mulli r27,r27,0x70          
10011ce8  7fe30734    extsh r3,r31                
10011cec  1c630070    mulli r3,r3,0x70            
10011cf0  7fec0734    extsh r12,r31               
10011cf4  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
10011cf8  7fe40734    extsh r4,r31                
10011cfc  1c840070    mulli r4,r4,0x70            
10011d00  7d9d602e    lwzx r12,r29,r12            
10011d04  3b7b0006    addi r27,r27,0x6            
10011d08  7d9ed92e    stwx r12,r30,r27            
10011d0c  3863002c    addi r3,r3,0x2c             
10011d10  7c7e1aae    lhax r3,r30,r3              
10011d14  3b820598    addi r28,r2,0x598           
10011d18  5463083c    rlwinm r3,r3,0x1,0x0,0x1e   
10011d1c  7f9c1aae    lhax r28,r28,r3             
10011d20  3884000e    addi r4,r4,0xe              
10011d24  7f9e232e    sthx r28,r30,r4             
10011d28  7fe50734    extsh r5,r31                
10011d2c  1ca50070    mulli r5,r5,0x70            
10011d30  38a5002c    addi r5,r5,0x2c             
10011d34  7cbe2aae    lhax r5,r30,r5              
10011d38  2c050005    cmpwi r5,0x5                
10011d3c  4082018c    bne 0x10011ec8                 ; -> 10011ec8
10011d40  7fe60734    extsh r6,r31                
10011d44  1cc60070    mulli r6,r6,0x70            
10011d48  38c6002e    addi r6,r6,0x2e             
10011d4c  7cde32ae    lhax r6,r30,r6              
10011d50  2c060001    cmpwi r6,0x1                
10011d54  40820174    bne 0x10011ec8                 ; -> 10011ec8
10011d58  7fe70734    extsh r7,r31                
10011d5c  1ce70070    mulli r7,r7,0x70            
10011d60  38e70004    addi r7,r7,0x4              
10011d64  7cfe3aae    lhax r7,r30,r7              
10011d68  3867001f    addi r3,r7,0x1f             
10011d6c  4801c98d    bl 0x1002e6f8                  ; -> 1002e6f8
10011d70  60000000    ori r0,r0,0x0               
10011d74  7fe80734    extsh r8,r31                
10011d78  1d080070    mulli r8,r8,0x70            
10011d7c  7d1e42ae    lhax r8,r30,r8              
10011d80  7c7c1b78    or r28,r3,r3                
10011d84  38680030    addi r3,r8,0x30             
10011d88  4801c945    bl 0x1002e6cc                  ; -> 1002e6cc
10011d8c  60000000    ori r0,r0,0x0               
10011d90  7c7b1b78    or r27,r3,r3                
10011d94  7f63db78    or r3,r27,r27               
10011d98  7f84e378    or r4,r28,r28               
10011d9c  7fe5fb78    or r5,r31,r31               
10011da0  4801b3f1    bl 0x1002d190                  ; -> 1002d190
10011da4  60000000    ori r0,r0,0x0               
10011da8  48000120    b 0x10011ec8                   ; -> 10011ec8
10011dac  7fe90734    extsh r9,r31                
10011db0  1d290070    mulli r9,r9,0x70            
10011db4  39290030    addi r9,r9,0x30             
10011db8  7d3e4aae    lhax r9,r30,r9              
10011dbc  2c090002    cmpwi r9,0x2                
10011dc0  40820108    bne 0x10011ec8                 ; -> 10011ec8
10011dc4  7fea0734    extsh r10,r31               
10011dc8  1d4a0070    mulli r10,r10,0x70          
10011dcc  394a002c    addi r10,r10,0x2c           
10011dd0  7d7e52ae    lhax r11,r30,r10            
10011dd4  396b0001    addi r11,r11,0x1            
10011dd8  7d7e532e    sthx r11,r30,r10            
10011ddc  7d6b0734    extsh r11,r11               
10011de0  2c0b0006    cmpwi r11,0x6               
10011de4  4081001c    ble 0x10011e00                 ; -> 10011e00
10011de8  7ffb0734    extsh r27,r31               
10011dec  1f7b0070    mulli r27,r27,0x70          
10011df0  39800000    li r12,0x0                  
10011df4  3b7b0025    addi r27,r27,0x25           
10011df8  7d9ed9ae    stbx r12,r30,r27            
10011dfc  4800004c    b 0x10011e48                   ; -> 10011e48
10011e00  7fe30734    extsh r3,r31                
10011e04  1c630070    mulli r3,r3,0x70            
10011e08  7fe50734    extsh r5,r31                
10011e0c  1ca50070    mulli r5,r5,0x70            
10011e10  7ffc0734    extsh r28,r31               
10011e14  579c103a    rlwinm r28,r28,0x2,0x0,0x1d 
10011e18  7fe60734    extsh r6,r31                
10011e1c  1cc60070    mulli r6,r6,0x70            
10011e20  7f9de02e    lwzx r28,r29,r28            
10011e24  38630006    addi r3,r3,0x6              
10011e28  7f9e192e    stwx r28,r30,r3             
10011e2c  38a5002c    addi r5,r5,0x2c             
10011e30  7cbe2aae    lhax r5,r30,r5              
10011e34  388205a6    addi r4,r2,0x5a6            
10011e38  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
10011e3c  7c842aae    lhax r4,r4,r5               
10011e40  38c6000e    addi r6,r6,0xe              
10011e44  7c9e332e    sthx r4,r30,r6              
10011e48  7fe70734    extsh r7,r31                
10011e4c  1ce70070    mulli r7,r7,0x70            
10011e50  38e7002c    addi r7,r7,0x2c             
10011e54  7cfe3aae    lhax r7,r30,r7              
10011e58  2c070005    cmpwi r7,0x5                
10011e5c  4082006c    bne 0x10011ec8                 ; -> 10011ec8
10011e60  7fe80734    extsh r8,r31                
10011e64  1d080070    mulli r8,r8,0x70            
10011e68  3908002e    addi r8,r8,0x2e             
10011e6c  7d1e42ae    lhax r8,r30,r8              
10011e70  2c080001    cmpwi r8,0x1                
10011e74  40820054    bne 0x10011ec8                 ; -> 10011ec8
10011e78  7fe90734    extsh r9,r31                
10011e7c  1d290070    mulli r9,r9,0x70            
10011e80  39290004    addi r9,r9,0x4              
10011e84  7d3e4aae    lhax r9,r30,r9              
10011e88  3869001f    addi r3,r9,0x1f             
10011e8c  4801c86d    bl 0x1002e6f8                  ; -> 1002e6f8
10011e90  60000000    ori r0,r0,0x0               
10011e94  7fea0734    extsh r10,r31               
10011e98  1d4a0070    mulli r10,r10,0x70          
10011e9c  7d5e52ae    lhax r10,r30,r10            
10011ea0  7c7c1b78    or r28,r3,r3                
10011ea4  386affee    subi r3,r10,0x12            
10011ea8  4801c825    bl 0x1002e6cc                  ; -> 1002e6cc
10011eac  60000000    ori r0,r0,0x0               
10011eb0  7c7b1b78    or r27,r3,r3                
10011eb4  7f63db78    or r3,r27,r27               
10011eb8  7f84e378    or r4,r28,r28               
10011ebc  7fe5fb78    or r5,r31,r31               
10011ec0  4801b2d1    bl 0x1002d190                  ; -> 1002d190
10011ec4  60000000    ori r0,r0,0x0               
10011ec8  7feb0734    extsh r11,r31               
10011ecc  1d6b0070    mulli r11,r11,0x70          
10011ed0  396b0025    addi r11,r11,0x25           
10011ed4  7d7e58ae    lbzx r11,r30,r11            
10011ed8  280b0000    cmplwi r11,0x0              
10011edc  408200dc    bne 0x10011fb8                 ; -> 10011fb8
10011ee0  7fec0734    extsh r12,r31               
10011ee4  1d8c0070    mulli r12,r12,0x70          
10011ee8  398c001c    addi r12,r12,0x1c           
10011eec  7d9e62ae    lhax r12,r30,r12            
10011ef0  280c000d    cmplwi r12,0xd              
10011ef4  418100c4    bgt 0x10011fb8                 ; -> 10011fb8
10011ef8  3b620734    addi r27,r2,0x734           
10011efc  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
10011f00  7f7b602e    lwzx r27,r27,r12            
10011f04  7f6903a6    mtspr CTR,r27               
10011f08  4e800420    bctr                        
10011fb8  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10011fbc  38210050    addi r1,r1,0x50             
10011fc0  7c0803a6    mtspr LR,r0                 
10011fc4  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10011fc8  4e800020    blr                         
