; FUN_10006840 @ 0x10006840
10006840  7c0802a6    mfspr r0,LR                 
10006844  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10006848  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000684c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10006850  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10006854  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10006858  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1000685c  7c7d1b78    or r29,r3,r3                
10006860  7fa30734    extsh r3,r29                
10006864  1c630046    mulli r3,r3,0x46            
10006868  3bc23cd8    addi r30,r2,0x3cd8          
1000686c  3b8261a4    addi r28,r2,0x61a4          
10006870  7ffe1a14    add r31,r30,r3              
10006874  889f001f    lbz r4,0x1f(r31)            
10006878  28040000    cmplwi r4,0x0               
1000687c  41820074    beq 0x100068f0                 ; -> 100068f0
10006880  38a00000    li r5,0x0                   
10006884  98bf001f    stb r5,0x1f(r31)            
10006888  38c00000    li r6,0x0                   
1000688c  98df001e    stb r6,0x1e(r31)            
10006890  80fc001c    lwz r7,0x1c(r28)            
10006894  39000000    li r8,0x0                   
10006898  90ff000a    stw r7,0xa(r31)             
1000689c  911f0014    stw r8,0x14(r31)            
100068a0  39200001    li r9,0x1                   
100068a4  b13f0024    sth r9,0x24(r31)            
100068a8  a95f0010    lha r10,0x10(r31)           
100068ac  39800000    li r12,0x0                  
100068b0  394a0004    addi r10,r10,0x4            
100068b4  b15f0010    sth r10,0x10(r31)           
100068b8  a97f0012    lha r11,0x12(r31)           
100068bc  396b0002    addi r11,r11,0x2            
100068c0  b17f0012    sth r11,0x12(r31)           
100068c4  b19f0032    sth r12,0x32(r31)           
100068c8  a87f0004    lha r3,0x4(r31)             
100068cc  2c030002    cmpwi r3,0x2                
100068d0  40820010    bne 0x100068e0                 ; -> 100068e0
100068d4  38800009    li r4,0x9                   
100068d8  b09f0004    sth r4,0x4(r31)             
100068dc  4800000c    b 0x100068e8                   ; -> 100068e8
100068e0  38a00008    li r5,0x8                   
100068e4  b0bf0004    sth r5,0x4(r31)             
100068e8  38c002ee    li r6,0x2ee                 
100068ec  b0df0042    sth r6,0x42(r31)            
100068f0  a8ff0024    lha r7,0x24(r31)            
100068f4  7ce83b78    or r8,r7,r7                 
100068f8  7d080734    extsh r8,r8                 
100068fc  38e7ffff    subi r7,r7,0x1              
10006900  2c080000    cmpwi r8,0x0                
10006904  b0ff0024    sth r7,0x24(r31)            
10006908  4082041c    bne 0x10006d24                 ; -> 10006d24
1000690c  39200001    li r9,0x1                   
10006910  b13f0024    sth r9,0x24(r31)            
10006914  39400001    li r10,0x1                  
10006918  995f001e    stb r10,0x1e(r31)           
1000691c  a97f0040    lha r11,0x40(r31)           
10006920  2c0b0000    cmpwi r11,0x0               
10006924  40810058    ble 0x1000697c                 ; -> 1000697c
10006928  38600007    li r3,0x7                   
1000692c  38800005    li r4,0x5                   
10006930  480246f1    bl 0x1002b020                  ; -> 1002b020
10006934  60000000    ori r0,r0,0x0               
10006938  39800001    li r12,0x1                  
1000693c  999f0020    stb r12,0x20(r31)           
10006940  807f000a    lwz r3,0xa(r31)             
10006944  a89f000e    lha r4,0xe(r31)             
10006948  a8bf0010    lha r5,0x10(r31)            
1000694c  a8df0012    lha r6,0x12(r31)            
10006950  38e00001    li r7,0x1                   
10006954  480216c1    bl 0x10028014                  ; -> 10028014
10006958  60000000    ori r0,r0,0x0               
1000695c  a8bf0040    lha r5,0x40(r31)            
10006960  38826840    addi r4,r2,0x6840           
10006964  1ca50070    mulli r5,r5,0x70            
10006968  3884003c    addi r4,r4,0x3c             
1000696c  a87f0042    lha r3,0x42(r31)            
10006970  7cc4282e    lwzx r6,r4,r5               
10006974  7cc61a14    add r6,r6,r3                
10006978  7cc4292e    stwx r6,r4,r5               
1000697c  a8ff0004    lha r7,0x4(r31)             
10006980  2c070009    cmpwi r7,0x9                
10006984  40820174    bne 0x10006af8                 ; -> 10006af8
10006988  a91f0032    lha r8,0x32(r31)            
1000698c  2c080000    cmpwi r8,0x0                
10006990  40820364    bne 0x10006cf4                 ; -> 10006cf4
10006994  a93f0012    lha r9,0x12(r31)            
10006998  a87f0010    lha r3,0x10(r31)            
1000699c  3889001e    addi r4,r9,0x1e             
100069a0  4bffebad    bl 0x1000554c                  ; -> 1000554c
100069a4  60000000    ori r0,r0,0x0               
100069a8  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
100069ac  28030000    cmplwi r3,0x0               
100069b0  41820104    beq 0x10006ab4                 ; -> 10006ab4
100069b4  a95f0012    lha r10,0x12(r31)           
100069b8  a87f0010    lha r3,0x10(r31)            
100069bc  388a001e    addi r4,r10,0x1e            
100069c0  4bffed15    bl 0x100056d4                  ; -> 100056d4
100069c4  60000000    ori r0,r0,0x0               
100069c8  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
100069cc  28030000    cmplwi r3,0x0               
100069d0  41820018    beq 0x100069e8                 ; -> 100069e8
100069d4  3960000a    li r11,0xa                  
100069d8  b17f0004    sth r11,0x4(r31)            
100069dc  39800000    li r12,0x0                  
100069e0  b19f0026    sth r12,0x26(r31)           
100069e4  48000310    b 0x10006cf4                   ; -> 10006cf4
100069e8  7fa3eb78    or r3,r29,r29               
100069ec  4bfff0dd    bl 0x10005ac8                  ; -> 10005ac8
100069f0  60000000    ori r0,r0,0x0               
100069f4  b07f0032    sth r3,0x32(r31)            
100069f8  a87f0032    lha r3,0x32(r31)            
100069fc  39000009    li r8,0x9                   
10006a00  1c630046    mulli r3,r3,0x46            
10006a04  38630030    addi r3,r3,0x30             
10006a08  7fbe1b2e    sthx r29,r30,r3             
10006a0c  a8bf0032    lha r5,0x32(r31)            
10006a10  a89f0010    lha r4,0x10(r31)            
10006a14  1ca50046    mulli r5,r5,0x46            
10006a18  3884fffc    subi r4,r4,0x4              
10006a1c  38a50010    addi r5,r5,0x10             
10006a20  7c9e2b2e    sthx r4,r30,r5              
10006a24  a8ff0032    lha r7,0x32(r31)            
10006a28  a8df0012    lha r6,0x12(r31)            
10006a2c  1ce70046    mulli r7,r7,0x46            
10006a30  38c60012    addi r6,r6,0x12             
10006a34  38e70012    addi r7,r7,0x12             
10006a38  7cde3b2e    sthx r6,r30,r7              
10006a3c  a93f0032    lha r9,0x32(r31)            
10006a40  39400010    li r10,0x10                 
10006a44  1d290046    mulli r9,r9,0x46            
10006a48  39290004    addi r9,r9,0x4              
10006a4c  7d1e4b2e    sthx r8,r30,r9              
10006a50  a97f0032    lha r11,0x32(r31)           
10006a54  3980006c    li r12,0x6c                 
10006a58  1d6b0046    mulli r11,r11,0x46          
10006a5c  396b000e    addi r11,r11,0xe            
10006a60  7d5e5b2e    sthx r10,r30,r11            
10006a64  a87f0032    lha r3,0x32(r31)            
10006a68  38c00000    li r6,0x0                   
10006a6c  1c630046    mulli r3,r3,0x46            
10006a70  38630002    addi r3,r3,0x2              
10006a74  7d9e1b2e    sthx r12,r30,r3             
10006a78  a8bf0032    lha r5,0x32(r31)            
10006a7c  809c001c    lwz r4,0x1c(r28)            
10006a80  1ca50046    mulli r5,r5,0x46            
10006a84  38a5000a    addi r5,r5,0xa              
10006a88  7c9e292e    stwx r4,r30,r5              
10006a8c  a8ff0032    lha r7,0x32(r31)            
10006a90  39000000    li r8,0x0                   
10006a94  1ce70046    mulli r7,r7,0x46            
10006a98  38e70014    addi r7,r7,0x14             
10006a9c  7cde392e    stwx r6,r30,r7              
10006aa0  a93f0032    lha r9,0x32(r31)            
10006aa4  1d290046    mulli r9,r9,0x46            
10006aa8  3929001e    addi r9,r9,0x1e             
10006aac  7d1e49ae    stbx r8,r30,r9              
10006ab0  48000244    b 0x10006cf4                   ; -> 10006cf4
10006ab4  a95f0012    lha r10,0x12(r31)           
10006ab8  394a0002    addi r10,r10,0x2            
10006abc  b15f0012    sth r10,0x12(r31)           
10006ac0  a97f000e    lha r11,0xe(r31)            
10006ac4  2c0b0051    cmpwi r11,0x51              
10006ac8  4080000c    bge 0x10006ad4                 ; -> 10006ad4
10006acc  39800051    li r12,0x51                 
10006ad0  b19f000e    sth r12,0xe(r31)            
10006ad4  a87f000e    lha r3,0xe(r31)             
10006ad8  38630001    addi r3,r3,0x1              
10006adc  b07f000e    sth r3,0xe(r31)             
10006ae0  7c630734    extsh r3,r3                 
10006ae4  2c030058    cmpwi r3,0x58               
10006ae8  4081020c    ble 0x10006cf4                 ; -> 10006cf4
10006aec  38800051    li r4,0x51                  
10006af0  b09f000e    sth r4,0xe(r31)             
10006af4  48000200    b 0x10006cf4                   ; -> 10006cf4
10006af8  a8bf0004    lha r5,0x4(r31)             
10006afc  2c050008    cmpwi r5,0x8                
10006b00  40820170    bne 0x10006c70                 ; -> 10006c70
10006b04  a8df0032    lha r6,0x32(r31)            
10006b08  2c060000    cmpwi r6,0x0                
10006b0c  408201e8    bne 0x10006cf4                 ; -> 10006cf4
10006b10  a8ff0012    lha r7,0x12(r31)            
10006b14  a87f0010    lha r3,0x10(r31)            
10006b18  3887ffff    subi r4,r7,0x1              
10006b1c  4bffea31    bl 0x1000554c                  ; -> 1000554c
10006b20  60000000    ori r0,r0,0x0               
10006b24  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10006b28  28030000    cmplwi r3,0x0               
10006b2c  41820100    beq 0x10006c2c                 ; -> 10006c2c
10006b30  a91f0012    lha r8,0x12(r31)            
10006b34  a87f0010    lha r3,0x10(r31)            
10006b38  3888ffff    subi r4,r8,0x1              
10006b3c  4bffeb99    bl 0x100056d4                  ; -> 100056d4
10006b40  60000000    ori r0,r0,0x0               
10006b44  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10006b48  28030000    cmplwi r3,0x0               
10006b4c  41820018    beq 0x10006b64                 ; -> 10006b64
10006b50  3920000b    li r9,0xb                   
10006b54  b13f0004    sth r9,0x4(r31)             
10006b58  3940000f    li r10,0xf                  
10006b5c  b15f0026    sth r10,0x26(r31)           
10006b60  48000194    b 0x10006cf4                   ; -> 10006cf4
10006b64  4bffede5    bl 0x10005948                  ; -> 10005948
10006b68  60000000    ori r0,r0,0x0               
10006b6c  b07f0032    sth r3,0x32(r31)            
10006b70  a97f0032    lha r11,0x32(r31)           
10006b74  38c00008    li r6,0x8                   
10006b78  1d6b0046    mulli r11,r11,0x46          
10006b7c  396b0030    addi r11,r11,0x30           
10006b80  7fbe5b2e    sthx r29,r30,r11            
10006b84  a87f0032    lha r3,0x32(r31)            
10006b88  a99f0010    lha r12,0x10(r31)           
10006b8c  1c630046    mulli r3,r3,0x46            
10006b90  398c0004    addi r12,r12,0x4            
10006b94  38630010    addi r3,r3,0x10             
10006b98  7d9e1b2e    sthx r12,r30,r3             
10006b9c  a8bf0032    lha r5,0x32(r31)            
10006ba0  a89f0012    lha r4,0x12(r31)            
10006ba4  1ca50046    mulli r5,r5,0x46            
10006ba8  3884fff8    subi r4,r4,0x8              
10006bac  38a50012    addi r5,r5,0x12             
10006bb0  7c9e2b2e    sthx r4,r30,r5              
10006bb4  a8ff0032    lha r7,0x32(r31)            
10006bb8  39000030    li r8,0x30                  
10006bbc  1ce70046    mulli r7,r7,0x46            
10006bc0  38e70004    addi r7,r7,0x4              
10006bc4  7cde3b2e    sthx r6,r30,r7              
10006bc8  a93f0032    lha r9,0x32(r31)            
10006bcc  3940006c    li r10,0x6c                 
10006bd0  1d290046    mulli r9,r9,0x46            
10006bd4  3929000e    addi r9,r9,0xe              
10006bd8  7d1e4b2e    sthx r8,r30,r9              
10006bdc  a97f0032    lha r11,0x32(r31)           
10006be0  38800000    li r4,0x0                   
10006be4  1d6b0046    mulli r11,r11,0x46          
10006be8  396b0002    addi r11,r11,0x2            
10006bec  7d5e5b2e    sthx r10,r30,r11            
10006bf0  a87f0032    lha r3,0x32(r31)            
10006bf4  819c001c    lwz r12,0x1c(r28)           
10006bf8  1c630046    mulli r3,r3,0x46            
10006bfc  3863000a    addi r3,r3,0xa              
10006c00  7d9e192e    stwx r12,r30,r3             
10006c04  a8bf0032    lha r5,0x32(r31)            
10006c08  38c00000    li r6,0x0                   
10006c0c  1ca50046    mulli r5,r5,0x46            
10006c10  38a50014    addi r5,r5,0x14             
10006c14  7c9e292e    stwx r4,r30,r5              
10006c18  a8ff0032    lha r7,0x32(r31)            
10006c1c  1ce70046    mulli r7,r7,0x46            
10006c20  38e7001e    addi r7,r7,0x1e             
10006c24  7cde39ae    stbx r6,r30,r7              
10006c28  480000cc    b 0x10006cf4                   ; -> 10006cf4
10006c2c  a91f0012    lha r8,0x12(r31)            
10006c30  3908fffe    subi r8,r8,0x2              
10006c34  b11f0012    sth r8,0x12(r31)            
10006c38  a93f000e    lha r9,0xe(r31)             
10006c3c  2c090071    cmpwi r9,0x71               
10006c40  4080000c    bge 0x10006c4c                 ; -> 10006c4c
10006c44  39400071    li r10,0x71                 
10006c48  b15f000e    sth r10,0xe(r31)            
10006c4c  a97f000e    lha r11,0xe(r31)            
10006c50  396b0001    addi r11,r11,0x1            
10006c54  b17f000e    sth r11,0xe(r31)            
10006c58  7d6b0734    extsh r11,r11               
10006c5c  2c0b0078    cmpwi r11,0x78              
10006c60  40810094    ble 0x10006cf4                 ; -> 10006cf4
10006c64  39800071    li r12,0x71                 
10006c68  b19f000e    sth r12,0xe(r31)            
10006c6c  48000088    b 0x10006cf4                   ; -> 10006cf4
10006c70  a87f0004    lha r3,0x4(r31)             
10006c74  2c03000b    cmpwi r3,0xb                
10006c78  4082003c    bne 0x10006cb4                 ; -> 10006cb4
10006c7c  a8bf0026    lha r5,0x26(r31)            
10006c80  388201a0    addi r4,r2,0x1a0            
10006c84  54a5083c    rlwinm r5,r5,0x1,0x0,0x1e   
10006c88  7c842aae    lhax r4,r4,r5               
10006c8c  b09f000e    sth r4,0xe(r31)             
10006c90  a8df0026    lha r6,0x26(r31)            
10006c94  38c6ffff    subi r6,r6,0x1              
10006c98  b0df0026    sth r6,0x26(r31)            
10006c9c  7cc60734    extsh r6,r6                 
10006ca0  2c060000    cmpwi r6,0x0                
10006ca4  40800050    bge 0x10006cf4                 ; -> 10006cf4
10006ca8  38e00009    li r7,0x9                   
10006cac  b0ff0004    sth r7,0x4(r31)             
10006cb0  48000044    b 0x10006cf4                   ; -> 10006cf4
10006cb4  a91f0004    lha r8,0x4(r31)             
10006cb8  2c08000a    cmpwi r8,0xa                
10006cbc  40820038    bne 0x10006cf4                 ; -> 10006cf4
10006cc0  a95f0026    lha r10,0x26(r31)           
10006cc4  392201a0    addi r9,r2,0x1a0            
10006cc8  554a083c    rlwinm r10,r10,0x1,0x0,0x1e 
10006ccc  7d2952ae    lhax r9,r9,r10              
10006cd0  b13f000e    sth r9,0xe(r31)             
10006cd4  a97f0026    lha r11,0x26(r31)           
10006cd8  396b0001    addi r11,r11,0x1            
10006cdc  b17f0026    sth r11,0x26(r31)           
10006ce0  7d6b0734    extsh r11,r11               
10006ce4  2c0b0010    cmpwi r11,0x10              
10006ce8  4082000c    bne 0x10006cf4                 ; -> 10006cf4
10006cec  39800008    li r12,0x8                  
10006cf0  b19f0004    sth r12,0x4(r31)            
10006cf4  a87f0010    lha r3,0x10(r31)            
10006cf8  38630002    addi r3,r3,0x2              
10006cfc  b07f003a    sth r3,0x3a(r31)            
10006d00  a89f0010    lha r4,0x10(r31)            
10006d04  38840016    addi r4,r4,0x16             
10006d08  b09f003c    sth r4,0x3c(r31)            
10006d0c  a8bf0012    lha r5,0x12(r31)            
10006d10  38a50002    addi r5,r5,0x2              
10006d14  b0bf0038    sth r5,0x38(r31)            
10006d18  a8df0012    lha r6,0x12(r31)            
10006d1c  38c6001c    addi r6,r6,0x1c             
10006d20  b0df0036    sth r6,0x36(r31)            
10006d24  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10006d28  38210050    addi r1,r1,0x50             
10006d2c  7c0803a6    mtspr LR,r0                 
10006d30  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10006d34  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10006d38  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10006d3c  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
10006d40  4e800020    blr                         
