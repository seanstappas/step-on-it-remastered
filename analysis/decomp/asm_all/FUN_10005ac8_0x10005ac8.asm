; FUN_10005ac8 @ 0x10005ac8
10005ac8  7c0802a6    mfspr r0,LR                 
10005acc  bf61ffec    stmw r27,-0x14(r1)             ; -> Stack[-0x14]
10005ad0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10005ad4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10005ad8  7c7c1b78    or r28,r3,r3                
10005adc  3ba261f8    addi r29,r2,0x61f8          
10005ae0  3be23cd8    addi r31,r2,0x3cd8          
10005ae4  a87d0000    lha r3,0x0(r29)             
10005ae8  3b6261fa    addi r27,r2,0x61fa          
10005aec  2c030000    cmpwi r3,0x0                
10005af0  3bc00000    li r30,0x0                  
10005af4  40820014    bne 0x10005b08                 ; -> 10005b08
10005af8  38600008    li r3,0x8                   
10005afc  480137fd    bl 0x100192f8                  ; -> 100192f8
10005b00  60000000    ori r0,r0,0x0               
10005b04  480000a8    b 0x10005bac                   ; -> 10005bac
10005b08  a89d0000    lha r4,0x0(r29)             
10005b0c  abdd0000    lha r30,0x0(r29)            
10005b10  1c840046    mulli r4,r4,0x46            
10005b14  3884003e    addi r4,r4,0x3e             
10005b18  7c9f22ae    lhax r4,r31,r4              
10005b1c  38a00000    li r5,0x0                   
10005b20  b09d0000    sth r4,0x0(r29)             
10005b24  a8dd0000    lha r6,0x0(r29)             
10005b28  1cc60046    mulli r6,r6,0x46            
10005b2c  7cbf332e    sthx r5,r31,r6              
10005b30  a8fb0000    lha r7,0x0(r27)             
10005b34  2c070000    cmpwi r7,0x0                
10005b38  40820020    bne 0x10005b58                 ; -> 10005b58
10005b3c  b3db0000    sth r30,0x0(r27)            
10005b40  a93b0000    lha r9,0x0(r27)             
10005b44  39000000    li r8,0x0                   
10005b48  1d290046    mulli r9,r9,0x46            
10005b4c  3929003e    addi r9,r9,0x3e             
10005b50  7d1f4b2e    sthx r8,r31,r9              
10005b54  48000058    b 0x10005bac                   ; -> 10005bac
10005b58  7f8a0734    extsh r10,r28               
10005b5c  1d4a0046    mulli r10,r10,0x46          
10005b60  7fcb0734    extsh r11,r30               
10005b64  1d6b0046    mulli r11,r11,0x46          
10005b68  7f8c0734    extsh r12,r28               
10005b6c  1d8c0046    mulli r12,r12,0x46          
10005b70  394a003e    addi r10,r10,0x3e           
10005b74  7f830734    extsh r3,r28                
10005b78  1c630046    mulli r3,r3,0x46            
10005b7c  7fc40734    extsh r4,r30                
10005b80  7d5f52ae    lhax r10,r31,r10            
10005b84  396b003e    addi r11,r11,0x3e           
10005b88  7d5f5b2e    sthx r10,r31,r11            
10005b8c  398c003e    addi r12,r12,0x3e           
10005b90  7d9f62ae    lhax r12,r31,r12            
10005b94  1c840046    mulli r4,r4,0x46            
10005b98  1d8c0046    mulli r12,r12,0x46          
10005b9c  7fdf632e    sthx r30,r31,r12            
10005ba0  3863003e    addi r3,r3,0x3e             
10005ba4  7fdf1b2e    sthx r30,r31,r3             
10005ba8  7f9f232e    sthx r28,r31,r4             
10005bac  7fc60734    extsh r6,r30                
10005bb0  1cc60046    mulli r6,r6,0x46            
10005bb4  7fc80734    extsh r8,r30                
10005bb8  1d080046    mulli r8,r8,0x46            
10005bbc  7fca0734    extsh r10,r30               
10005bc0  1d4a0046    mulli r10,r10,0x46          
10005bc4  7fcc0734    extsh r12,r30               
10005bc8  1d8c0046    mulli r12,r12,0x46          
10005bcc  7fc40734    extsh r4,r30                
10005bd0  1c840046    mulli r4,r4,0x46            
10005bd4  38a00001    li r5,0x1                   
10005bd8  38c6001f    addi r6,r6,0x1f             
10005bdc  7cbf31ae    stbx r5,r31,r6              
10005be0  7fc60734    extsh r6,r30                
10005be4  1cc60046    mulli r6,r6,0x46            
10005be8  38e00000    li r7,0x0                   
10005bec  39080020    addi r8,r8,0x20             
10005bf0  7cff41ae    stbx r7,r31,r8              
10005bf4  7fc80734    extsh r8,r30                
10005bf8  1d080046    mulli r8,r8,0x46            
10005bfc  39200000    li r9,0x0                   
10005c00  394a0040    addi r10,r10,0x40           
10005c04  7d3f532e    sthx r9,r31,r10             
10005c08  7fca0734    extsh r10,r30               
10005c0c  1d4a0046    mulli r10,r10,0x46          
10005c10  39600000    li r11,0x0                  
10005c14  398c003a    addi r12,r12,0x3a           
10005c18  7d7f632e    sthx r11,r31,r12            
10005c1c  38600000    li r3,0x0                   
10005c20  38840038    addi r4,r4,0x38             
10005c24  7c7f232e    sthx r3,r31,r4              
10005c28  38a00000    li r5,0x0                   
10005c2c  38c6003c    addi r6,r6,0x3c             
10005c30  7cbf332e    sthx r5,r31,r6              
10005c34  38e00000    li r7,0x0                   
10005c38  39080036    addi r8,r8,0x36             
10005c3c  7cff432e    sthx r7,r31,r8              
10005c40  39200000    li r9,0x0                   
10005c44  394a0035    addi r10,r10,0x35           
10005c48  7d3f51ae    stbx r9,r31,r10             
10005c4c  7fc3f378    or r3,r30,r30               
10005c50  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10005c54  38210050    addi r1,r1,0x50             
10005c58  7c0803a6    mtspr LR,r0                 
10005c5c  bb61ffec    lmw r27,-0x14(r1)              ; -> Stack[-0x14]
10005c60  4e800020    blr                         
