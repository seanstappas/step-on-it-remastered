; FUN_1000fd5c @ 0x1000fd5c
1000fd5c  7c0802a6    mfspr r0,LR                 
1000fd60  be61ffcc    stmw r19,-0x34(r1)             ; -> Stack[-0x34]
1000fd64  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000fd68  9421ff90    stwu r1,-0x70(r1)              ; -> Stack[-0x70]
1000fd6c  7c7f1b78    or r31,r3,r3                
1000fd70  7c942378    or r20,r4,r4                
1000fd74  a87f004e    lha r3,0x4e(r31)            
1000fd78  3ba26bb0    addi r29,r2,0x6bb0          
1000fd7c  2c030000    cmpwi r3,0x0                
1000fd80  3bc26bf8    addi r30,r2,0x6bf8          
1000fd84  3b623cd8    addi r27,r2,0x3cd8          
1000fd88  3aa22f74    addi r21,r2,0x2f74          
1000fd8c  41820f90    beq 0x10010d1c                 ; -> 10010d1c
1000fd90  a89f0054    lha r4,0x54(r31)            
1000fd94  2c040001    cmpwi r4,0x1                
1000fd98  408201ec    bne 0x1000ff84                 ; -> 1000ff84
1000fd9c  a8bf0050    lha r5,0x50(r31)            
1000fda0  a8df004e    lha r6,0x4e(r31)            
1000fda4  38850001    addi r4,r5,0x1              
1000fda8  a8ff0050    lha r7,0x50(r31)            
1000fdac  38a6000f    addi r5,r6,0xf              
1000fdb0  a87f004e    lha r3,0x4e(r31)            
1000fdb4  38c70005    addi r6,r7,0x5              
1000fdb8  4bff32f5    bl 0x100030ac                  ; -> 100030ac
1000fdbc  60000000    ori r0,r0,0x0               
1000fdc0  7c7c1b78    or r28,r3,r3                
1000fdc4  7f880734    extsh r8,r28                
1000fdc8  2c080000    cmpwi r8,0x0                
1000fdcc  41820040    beq 0x1000fe0c                 ; -> 1000fe0c
1000fdd0  39200001    li r9,0x1                   
1000fdd4  993f0058    stb r9,0x58(r31)            
1000fdd8  89550000    lbz r10,0x0(r21)            
1000fddc  280a0000    cmplwi r10,0x0              
1000fde0  41820018    beq 0x1000fdf8                 ; -> 1000fdf8
1000fde4  7f8b0734    extsh r11,r28               
1000fde8  1d6b0046    mulli r11,r11,0x46          
1000fdec  396b0040    addi r11,r11,0x40           
1000fdf0  7e9b5b2e    sthx r20,r27,r11            
1000fdf4  48000018    b 0x1000fe0c                   ; -> 1000fe0c
1000fdf8  7f830734    extsh r3,r28                
1000fdfc  1c630046    mulli r3,r3,0x46            
1000fe00  39800001    li r12,0x1                  
1000fe04  38630040    addi r3,r3,0x40             
1000fe08  7d9b1b2e    sthx r12,r27,r3             
1000fe0c  a89f0052    lha r4,0x52(r31)            
1000fe10  2c040001    cmpwi r4,0x1                
1000fe14  408200bc    bne 0x1000fed0                 ; -> 1000fed0
1000fe18  a8bf004e    lha r5,0x4e(r31)            
1000fe1c  38650018    addi r3,r5,0x18             
1000fe20  4801e8ad    bl 0x1002e6cc                  ; -> 1002e6cc
1000fe24  60000000    ori r0,r0,0x0               
1000fe28  a8df0050    lha r6,0x50(r31)            
1000fe2c  7c771b78    or r23,r3,r3                
1000fe30  38660003    addi r3,r6,0x3              
1000fe34  4801e8c5    bl 0x1002e6f8                  ; -> 1002e6f8
1000fe38  60000000    ori r0,r0,0x0               
1000fe3c  7ee70734    extsh r7,r23                
1000fe40  7c761b78    or r22,r3,r3                
1000fe44  7ec80734    extsh r8,r22                
1000fe48  1ce7003c    mulli r7,r7,0x3c            
1000fe4c  5508103a    rlwinm r8,r8,0x2,0x0,0x1d   
1000fe50  7ce74214    add r7,r7,r8                
1000fe54  7cfe382e    lwzx r7,r30,r7              
1000fe58  54e705ac    rlwinm r7,r7,0x0,0x16,0x16  
1000fe5c  2c070000    cmpwi r7,0x0                
1000fe60  4082004c    bne 0x1000feac                 ; -> 1000feac
1000fe64  893f0058    lbz r9,0x58(r31)            
1000fe68  28090000    cmplwi r9,0x0               
1000fe6c  40820040    bne 0x1000feac                 ; -> 1000feac
1000fe70  a95f004e    lha r10,0x4e(r31)           
1000fe74  807d0000    lwz r3,0x0(r29)             
1000fe78  392a0004    addi r9,r10,0x4             
1000fe7c  a8bf004e    lha r5,0x4e(r31)            
1000fe80  a8df0050    lha r6,0x50(r31)            
1000fe84  80fd0000    lwz r7,0x0(r29)             
1000fe88  a95f0050    lha r10,0x50(r31)           
1000fe8c  3880000a    li r4,0xa                   
1000fe90  3900000a    li r8,0xa                   
1000fe94  4bff450d    bl 0x100043a0                  ; -> 100043a0
1000fe98  60000000    ori r0,r0,0x0               
1000fe9c  a97f004e    lha r11,0x4e(r31)           
1000fea0  396b0004    addi r11,r11,0x4            
1000fea4  b17f004e    sth r11,0x4e(r31)           
1000fea8  480007a8    b 0x10010650                   ; -> 10010650
1000feac  807d0000    lwz r3,0x0(r29)             
1000feb0  a8bf004e    lha r5,0x4e(r31)            
1000feb4  a8df0050    lha r6,0x50(r31)            
1000feb8  3880000a    li r4,0xa                   
1000febc  4bff4df5    bl 0x10004cb0                  ; -> 10004cb0
1000fec0  60000000    ori r0,r0,0x0               
1000fec4  39800000    li r12,0x0                  
1000fec8  b19f004e    sth r12,0x4e(r31)           
1000fecc  48000784    b 0x10010650                   ; -> 10010650
1000fed0  a87f004e    lha r3,0x4e(r31)            
1000fed4  4801e7f9    bl 0x1002e6cc                  ; -> 1002e6cc
1000fed8  60000000    ori r0,r0,0x0               
1000fedc  a89f0050    lha r4,0x50(r31)            
1000fee0  7c771b78    or r23,r3,r3                
1000fee4  38640003    addi r3,r4,0x3              
1000fee8  4801e811    bl 0x1002e6f8                  ; -> 1002e6f8
1000feec  60000000    ori r0,r0,0x0               
1000fef0  7ee50734    extsh r5,r23                
1000fef4  7c761b78    or r22,r3,r3                
1000fef8  7ec60734    extsh r6,r22                
1000fefc  1ca5003c    mulli r5,r5,0x3c            
1000ff00  54c6103a    rlwinm r6,r6,0x2,0x0,0x1d   
1000ff04  7ca53214    add r5,r5,r6                
1000ff08  7cbe282e    lwzx r5,r30,r5              
1000ff0c  54a505ac    rlwinm r5,r5,0x0,0x16,0x16  
1000ff10  2c050000    cmpwi r5,0x0                
1000ff14  4082004c    bne 0x1000ff60                 ; -> 1000ff60
1000ff18  88ff0058    lbz r7,0x58(r31)            
1000ff1c  28070000    cmplwi r7,0x0               
1000ff20  40820040    bne 0x1000ff60                 ; -> 1000ff60
1000ff24  a95f004e    lha r10,0x4e(r31)           
1000ff28  807d0000    lwz r3,0x0(r29)             
1000ff2c  392afffc    subi r9,r10,0x4             
1000ff30  a8bf004e    lha r5,0x4e(r31)            
1000ff34  a8df0050    lha r6,0x50(r31)            
1000ff38  80fd0000    lwz r7,0x0(r29)             
1000ff3c  a95f0050    lha r10,0x50(r31)           
1000ff40  38800009    li r4,0x9                   
1000ff44  39000009    li r8,0x9                   
1000ff48  4bff4459    bl 0x100043a0                  ; -> 100043a0
1000ff4c  60000000    ori r0,r0,0x0               
1000ff50  a97f004e    lha r11,0x4e(r31)           
1000ff54  396bfffc    subi r11,r11,0x4            
1000ff58  b17f004e    sth r11,0x4e(r31)           
1000ff5c  480006f4    b 0x10010650                   ; -> 10010650
1000ff60  807d0000    lwz r3,0x0(r29)             
1000ff64  a8bf004e    lha r5,0x4e(r31)            
1000ff68  a8df0050    lha r6,0x50(r31)            
1000ff6c  38800009    li r4,0x9                   
1000ff70  4bff4d41    bl 0x10004cb0                  ; -> 10004cb0
1000ff74  60000000    ori r0,r0,0x0               
1000ff78  39800000    li r12,0x0                  
1000ff7c  b19f004e    sth r12,0x4e(r31)           
1000ff80  480006d0    b 0x10010650                   ; -> 10010650
1000ff84  a87f0054    lha r3,0x54(r31)            
1000ff88  2c030002    cmpwi r3,0x2                
1000ff8c  408206c4    bne 0x10010650                 ; -> 10010650
1000ff90  a89f005a    lha r4,0x5a(r31)            
1000ff94  ab5f004e    lha r26,0x4e(r31)           
1000ff98  ab3f0050    lha r25,0x50(r31)           
1000ff9c  ab1f005a    lha r24,0x5a(r31)           
1000ffa0  38840001    addi r4,r4,0x1              
1000ffa4  b09f005a    sth r4,0x5a(r31)            
1000ffa8  7c840734    extsh r4,r4                 
1000ffac  2c040008    cmpwi r4,0x8                
1000ffb0  4081000c    ble 0x1000ffbc                 ; -> 1000ffbc
1000ffb4  38a00001    li r5,0x1                   
1000ffb8  b0bf005a    sth r5,0x5a(r31)            
1000ffbc  a8df004e    lha r6,0x4e(r31)            
1000ffc0  a8ff0050    lha r7,0x50(r31)            
1000ffc4  a91f004e    lha r8,0x4e(r31)            
1000ffc8  a93f0050    lha r9,0x50(r31)            
1000ffcc  38660001    addi r3,r6,0x1              
1000ffd0  38870001    addi r4,r7,0x1              
1000ffd4  38a80017    addi r5,r8,0x17             
1000ffd8  38c90017    addi r6,r9,0x17             
1000ffdc  4bff30d1    bl 0x100030ac                  ; -> 100030ac
1000ffe0  60000000    ori r0,r0,0x0               
1000ffe4  7c7c1b78    or r28,r3,r3                
1000ffe8  7f8a0734    extsh r10,r28               
1000ffec  2c0a0000    cmpwi r10,0x0               
1000fff0  41820038    beq 0x10010028                 ; -> 10010028
1000fff4  89750000    lbz r11,0x0(r21)            
1000fff8  280b0000    cmplwi r11,0x0              
1000fffc  41820018    beq 0x10010014                 ; -> 10010014
10010000  7f8c0734    extsh r12,r28               
10010004  1d8c0046    mulli r12,r12,0x46          
10010008  398c0040    addi r12,r12,0x40           
1001000c  7e9b632e    sthx r20,r27,r12            
10010010  48000018    b 0x10010028                   ; -> 10010028
10010014  7f840734    extsh r4,r28                
10010018  1c840046    mulli r4,r4,0x46            
1001001c  38600001    li r3,0x1                   
10010020  38840040    addi r4,r4,0x40             
10010024  7c7b232e    sthx r3,r27,r4              
10010028  a8bf0052    lha r5,0x52(r31)            
1001002c  2c050001    cmpwi r5,0x1                
10010030  4082016c    bne 0x1001019c                 ; -> 1001019c
10010034  a8df0050    lha r6,0x50(r31)            
10010038  3866000c    addi r3,r6,0xc              
1001003c  4801e6bd    bl 0x1002e6f8                  ; -> 1002e6f8
10010040  60000000    ori r0,r0,0x0               
10010044  7c630734    extsh r3,r3                 
10010048  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1001004c  a8ff004e    lha r7,0x4e(r31)            
10010050  7c731b78    or r19,r3,r3                
10010054  3867fffe    subi r3,r7,0x2              
10010058  4801e675    bl 0x1002e6cc                  ; -> 1002e6cc
1001005c  60000000    ori r0,r0,0x0               
10010060  7c630734    extsh r3,r3                 
10010064  1c63003c    mulli r3,r3,0x3c            
10010068  7c639a14    add r3,r3,r19               
1001006c  7c7e182e    lwzx r3,r30,r3              
10010070  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010074  2c030000    cmpwi r3,0x0                
10010078  41820010    beq 0x10010088                 ; -> 10010088
1001007c  39000004    li r8,0x4                   
10010080  b11f0052    sth r8,0x52(r31)            
10010084  48000568    b 0x100105ec                   ; -> 100105ec
10010088  a93f0050    lha r9,0x50(r31)            
1001008c  3869fffe    subi r3,r9,0x2              
10010090  4801e669    bl 0x1002e6f8                  ; -> 1002e6f8
10010094  60000000    ori r0,r0,0x0               
10010098  7c630734    extsh r3,r3                 
1001009c  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100100a0  a95f004e    lha r10,0x4e(r31)           
100100a4  7c731b78    or r19,r3,r3                
100100a8  386a0017    addi r3,r10,0x17            
100100ac  4801e621    bl 0x1002e6cc                  ; -> 1002e6cc
100100b0  60000000    ori r0,r0,0x0               
100100b4  7c630734    extsh r3,r3                 
100100b8  1c63003c    mulli r3,r3,0x3c            
100100bc  7c639a14    add r3,r3,r19               
100100c0  7c7e182e    lwzx r3,r30,r3              
100100c4  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
100100c8  2c030000    cmpwi r3,0x0                
100100cc  41820014    beq 0x100100e0                 ; -> 100100e0
100100d0  a97f004e    lha r11,0x4e(r31)           
100100d4  396bfffe    subi r11,r11,0x2            
100100d8  b17f004e    sth r11,0x4e(r31)           
100100dc  48000510    b 0x100105ec                   ; -> 100105ec
100100e0  a99f0050    lha r12,0x50(r31)           
100100e4  386cfffe    subi r3,r12,0x2             
100100e8  4801e611    bl 0x1002e6f8                  ; -> 1002e6f8
100100ec  60000000    ori r0,r0,0x0               
100100f0  7c630734    extsh r3,r3                 
100100f4  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100100f8  a89f004e    lha r4,0x4e(r31)            
100100fc  7c731b78    or r19,r3,r3                
10010100  3864fffe    subi r3,r4,0x2              
10010104  4801e5c9    bl 0x1002e6cc                  ; -> 1002e6cc
10010108  60000000    ori r0,r0,0x0               
1001010c  7c630734    extsh r3,r3                 
10010110  1c63003c    mulli r3,r3,0x3c            
10010114  7c639a14    add r3,r3,r19               
10010118  7c7e182e    lwzx r3,r30,r3              
1001011c  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010120  2c030000    cmpwi r3,0x0                
10010124  41820014    beq 0x10010138                 ; -> 10010138
10010128  a8bf004e    lha r5,0x4e(r31)            
1001012c  38a5fffe    subi r5,r5,0x2              
10010130  b0bf004e    sth r5,0x4e(r31)            
10010134  480004b8    b 0x100105ec                   ; -> 100105ec
10010138  a8df0050    lha r6,0x50(r31)            
1001013c  3866fffe    subi r3,r6,0x2              
10010140  4801e5b9    bl 0x1002e6f8                  ; -> 1002e6f8
10010144  60000000    ori r0,r0,0x0               
10010148  7c630734    extsh r3,r3                 
1001014c  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010150  a8ff004e    lha r7,0x4e(r31)            
10010154  7c731b78    or r19,r3,r3                
10010158  38670019    addi r3,r7,0x19             
1001015c  4801e571    bl 0x1002e6cc                  ; -> 1002e6cc
10010160  60000000    ori r0,r0,0x0               
10010164  7c630734    extsh r3,r3                 
10010168  1c63003c    mulli r3,r3,0x3c            
1001016c  7c639a14    add r3,r3,r19               
10010170  7c7e182e    lwzx r3,r30,r3              
10010174  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010178  2c030000    cmpwi r3,0x0                
1001017c  40820014    bne 0x10010190                 ; -> 10010190
10010180  a91f004e    lha r8,0x4e(r31)            
10010184  3908fffe    subi r8,r8,0x2              
10010188  b11f004e    sth r8,0x4e(r31)            
1001018c  48000460    b 0x100105ec                   ; -> 100105ec
10010190  39200002    li r9,0x2                   
10010194  b13f0052    sth r9,0x52(r31)            
10010198  48000454    b 0x100105ec                   ; -> 100105ec
1001019c  a95f0052    lha r10,0x52(r31)           
100101a0  2c0a0002    cmpwi r10,0x2               
100101a4  4082016c    bne 0x10010310                 ; -> 10010310
100101a8  a97f0050    lha r11,0x50(r31)           
100101ac  386bfffe    subi r3,r11,0x2             
100101b0  4801e549    bl 0x1002e6f8                  ; -> 1002e6f8
100101b4  60000000    ori r0,r0,0x0               
100101b8  7c630734    extsh r3,r3                 
100101bc  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100101c0  a99f004e    lha r12,0x4e(r31)           
100101c4  7c731b78    or r19,r3,r3                
100101c8  386c000c    addi r3,r12,0xc             
100101cc  4801e501    bl 0x1002e6cc                  ; -> 1002e6cc
100101d0  60000000    ori r0,r0,0x0               
100101d4  7c630734    extsh r3,r3                 
100101d8  1c63003c    mulli r3,r3,0x3c            
100101dc  7c639a14    add r3,r3,r19               
100101e0  7c7e182e    lwzx r3,r30,r3              
100101e4  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
100101e8  2c030000    cmpwi r3,0x0                
100101ec  41820010    beq 0x100101fc                 ; -> 100101fc
100101f0  3a600001    li r19,0x1                  
100101f4  b27f0052    sth r19,0x52(r31)           
100101f8  480003f4    b 0x100105ec                   ; -> 100105ec
100101fc  a89f0050    lha r4,0x50(r31)            
10010200  38640017    addi r3,r4,0x17             
10010204  4801e4f5    bl 0x1002e6f8                  ; -> 1002e6f8
10010208  60000000    ori r0,r0,0x0               
1001020c  7c630734    extsh r3,r3                 
10010210  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010214  a8bf004e    lha r5,0x4e(r31)            
10010218  7c731b78    or r19,r3,r3                
1001021c  38650019    addi r3,r5,0x19             
10010220  4801e4ad    bl 0x1002e6cc                  ; -> 1002e6cc
10010224  60000000    ori r0,r0,0x0               
10010228  7c630734    extsh r3,r3                 
1001022c  1c63003c    mulli r3,r3,0x3c            
10010230  7c639a14    add r3,r3,r19               
10010234  7c7e182e    lwzx r3,r30,r3              
10010238  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
1001023c  2c030000    cmpwi r3,0x0                
10010240  41820014    beq 0x10010254                 ; -> 10010254
10010244  a8df0050    lha r6,0x50(r31)            
10010248  38c6fffe    subi r6,r6,0x2              
1001024c  b0df0050    sth r6,0x50(r31)            
10010250  4800039c    b 0x100105ec                   ; -> 100105ec
10010254  a8ff0050    lha r7,0x50(r31)            
10010258  3867fffe    subi r3,r7,0x2              
1001025c  4801e49d    bl 0x1002e6f8                  ; -> 1002e6f8
10010260  60000000    ori r0,r0,0x0               
10010264  7c630734    extsh r3,r3                 
10010268  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1001026c  a91f004e    lha r8,0x4e(r31)            
10010270  7c731b78    or r19,r3,r3                
10010274  38680005    addi r3,r8,0x5              
10010278  4801e455    bl 0x1002e6cc                  ; -> 1002e6cc
1001027c  60000000    ori r0,r0,0x0               
10010280  7c630734    extsh r3,r3                 
10010284  1c63003c    mulli r3,r3,0x3c            
10010288  7c639a14    add r3,r3,r19               
1001028c  7c7e182e    lwzx r3,r30,r3              
10010290  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010294  2c030000    cmpwi r3,0x0                
10010298  41820014    beq 0x100102ac                 ; -> 100102ac
1001029c  a93f0050    lha r9,0x50(r31)            
100102a0  3929fffe    subi r9,r9,0x2              
100102a4  b13f0050    sth r9,0x50(r31)            
100102a8  48000344    b 0x100105ec                   ; -> 100105ec
100102ac  a95f0050    lha r10,0x50(r31)           
100102b0  386a0019    addi r3,r10,0x19            
100102b4  4801e445    bl 0x1002e6f8                  ; -> 1002e6f8
100102b8  60000000    ori r0,r0,0x0               
100102bc  7c630734    extsh r3,r3                 
100102c0  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100102c4  a97f004e    lha r11,0x4e(r31)           
100102c8  7c731b78    or r19,r3,r3                
100102cc  386b0019    addi r3,r11,0x19            
100102d0  4801e3fd    bl 0x1002e6cc                  ; -> 1002e6cc
100102d4  60000000    ori r0,r0,0x0               
100102d8  7c630734    extsh r3,r3                 
100102dc  1c63003c    mulli r3,r3,0x3c            
100102e0  7c639a14    add r3,r3,r19               
100102e4  7c7e182e    lwzx r3,r30,r3              
100102e8  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
100102ec  2c030000    cmpwi r3,0x0                
100102f0  40820014    bne 0x10010304                 ; -> 10010304
100102f4  a99f0050    lha r12,0x50(r31)           
100102f8  398cfffe    subi r12,r12,0x2            
100102fc  b19f0050    sth r12,0x50(r31)           
10010300  480002ec    b 0x100105ec                   ; -> 100105ec
10010304  3a600003    li r19,0x3                  
10010308  b27f0052    sth r19,0x52(r31)           
1001030c  480002e0    b 0x100105ec                   ; -> 100105ec
10010310  a87f0052    lha r3,0x52(r31)            
10010314  2c030003    cmpwi r3,0x3                
10010318  40820168    bne 0x10010480                 ; -> 10010480
1001031c  a89f0050    lha r4,0x50(r31)            
10010320  3864000c    addi r3,r4,0xc              
10010324  4801e3d5    bl 0x1002e6f8                  ; -> 1002e6f8
10010328  60000000    ori r0,r0,0x0               
1001032c  7c630734    extsh r3,r3                 
10010330  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010334  a8bf004e    lha r5,0x4e(r31)            
10010338  7c731b78    or r19,r3,r3                
1001033c  38650019    addi r3,r5,0x19             
10010340  4801e38d    bl 0x1002e6cc                  ; -> 1002e6cc
10010344  60000000    ori r0,r0,0x0               
10010348  7c630734    extsh r3,r3                 
1001034c  1c63003c    mulli r3,r3,0x3c            
10010350  7c639a14    add r3,r3,r19               
10010354  7c7e182e    lwzx r3,r30,r3              
10010358  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
1001035c  2c030000    cmpwi r3,0x0                
10010360  41820010    beq 0x10010370                 ; -> 10010370
10010364  38c00002    li r6,0x2                   
10010368  b0df0052    sth r6,0x52(r31)            
1001036c  48000280    b 0x100105ec                   ; -> 100105ec
10010370  a8ff0050    lha r7,0x50(r31)            
10010374  38670019    addi r3,r7,0x19             
10010378  4801e381    bl 0x1002e6f8                  ; -> 1002e6f8
1001037c  60000000    ori r0,r0,0x0               
10010380  7c630734    extsh r3,r3                 
10010384  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010388  7c731b78    or r19,r3,r3                
1001038c  a87f004e    lha r3,0x4e(r31)            
10010390  4801e33d    bl 0x1002e6cc                  ; -> 1002e6cc
10010394  60000000    ori r0,r0,0x0               
10010398  7c630734    extsh r3,r3                 
1001039c  1c63003c    mulli r3,r3,0x3c            
100103a0  7c639a14    add r3,r3,r19               
100103a4  7c7e182e    lwzx r3,r30,r3              
100103a8  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
100103ac  2c030000    cmpwi r3,0x0                
100103b0  41820014    beq 0x100103c4                 ; -> 100103c4
100103b4  a91f004e    lha r8,0x4e(r31)            
100103b8  39080002    addi r8,r8,0x2              
100103bc  b11f004e    sth r8,0x4e(r31)            
100103c0  4800022c    b 0x100105ec                   ; -> 100105ec
100103c4  a93f0050    lha r9,0x50(r31)            
100103c8  38690019    addi r3,r9,0x19             
100103cc  4801e32d    bl 0x1002e6f8                  ; -> 1002e6f8
100103d0  60000000    ori r0,r0,0x0               
100103d4  7c630734    extsh r3,r3                 
100103d8  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100103dc  a95f004e    lha r10,0x4e(r31)           
100103e0  7c731b78    or r19,r3,r3                
100103e4  386a0019    addi r3,r10,0x19            
100103e8  4801e2e5    bl 0x1002e6cc                  ; -> 1002e6cc
100103ec  60000000    ori r0,r0,0x0               
100103f0  7c630734    extsh r3,r3                 
100103f4  1c63003c    mulli r3,r3,0x3c            
100103f8  7c639a14    add r3,r3,r19               
100103fc  7c7e182e    lwzx r3,r30,r3              
10010400  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010404  2c030000    cmpwi r3,0x0                
10010408  41820014    beq 0x1001041c                 ; -> 1001041c
1001040c  a97f004e    lha r11,0x4e(r31)           
10010410  396b0002    addi r11,r11,0x2            
10010414  b17f004e    sth r11,0x4e(r31)           
10010418  480001d4    b 0x100105ec                   ; -> 100105ec
1001041c  a99f0050    lha r12,0x50(r31)           
10010420  386c0019    addi r3,r12,0x19            
10010424  4801e2d5    bl 0x1002e6f8                  ; -> 1002e6f8
10010428  60000000    ori r0,r0,0x0               
1001042c  7c630734    extsh r3,r3                 
10010430  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010434  a89f004e    lha r4,0x4e(r31)            
10010438  7c731b78    or r19,r3,r3                
1001043c  3864fffe    subi r3,r4,0x2              
10010440  4801e28d    bl 0x1002e6cc                  ; -> 1002e6cc
10010444  60000000    ori r0,r0,0x0               
10010448  7c630734    extsh r3,r3                 
1001044c  1c63003c    mulli r3,r3,0x3c            
10010450  7c639a14    add r3,r3,r19               
10010454  7c7e182e    lwzx r3,r30,r3              
10010458  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
1001045c  2c030000    cmpwi r3,0x0                
10010460  40820014    bne 0x10010474                 ; -> 10010474
10010464  a8bf004e    lha r5,0x4e(r31)            
10010468  38a50002    addi r5,r5,0x2              
1001046c  b0bf004e    sth r5,0x4e(r31)            
10010470  4800017c    b 0x100105ec                   ; -> 100105ec
10010474  38c00004    li r6,0x4                   
10010478  b0df0052    sth r6,0x52(r31)            
1001047c  48000170    b 0x100105ec                   ; -> 100105ec
10010480  a8ff0052    lha r7,0x52(r31)            
10010484  2c070004    cmpwi r7,0x4                
10010488  40820164    bne 0x100105ec                 ; -> 100105ec
1001048c  a91f0050    lha r8,0x50(r31)            
10010490  38680019    addi r3,r8,0x19             
10010494  4801e265    bl 0x1002e6f8                  ; -> 1002e6f8
10010498  60000000    ori r0,r0,0x0               
1001049c  7c630734    extsh r3,r3                 
100104a0  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100104a4  a93f004e    lha r9,0x4e(r31)            
100104a8  7c731b78    or r19,r3,r3                
100104ac  3869000c    addi r3,r9,0xc              
100104b0  4801e21d    bl 0x1002e6cc                  ; -> 1002e6cc
100104b4  60000000    ori r0,r0,0x0               
100104b8  7c630734    extsh r3,r3                 
100104bc  1c63003c    mulli r3,r3,0x3c            
100104c0  7c639a14    add r3,r3,r19               
100104c4  7c7e182e    lwzx r3,r30,r3              
100104c8  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
100104cc  2c030000    cmpwi r3,0x0                
100104d0  41820010    beq 0x100104e0                 ; -> 100104e0
100104d4  39400003    li r10,0x3                  
100104d8  b15f0052    sth r10,0x52(r31)           
100104dc  48000110    b 0x100105ec                   ; -> 100105ec
100104e0  a87f0050    lha r3,0x50(r31)            
100104e4  4801e215    bl 0x1002e6f8                  ; -> 1002e6f8
100104e8  60000000    ori r0,r0,0x0               
100104ec  7c630734    extsh r3,r3                 
100104f0  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100104f4  a97f004e    lha r11,0x4e(r31)           
100104f8  7c731b78    or r19,r3,r3                
100104fc  386bfffe    subi r3,r11,0x2             
10010500  4801e1cd    bl 0x1002e6cc                  ; -> 1002e6cc
10010504  60000000    ori r0,r0,0x0               
10010508  7c630734    extsh r3,r3                 
1001050c  1c63003c    mulli r3,r3,0x3c            
10010510  7c639a14    add r3,r3,r19               
10010514  7c7e182e    lwzx r3,r30,r3              
10010518  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
1001051c  2c030000    cmpwi r3,0x0                
10010520  41820014    beq 0x10010534                 ; -> 10010534
10010524  a99f0050    lha r12,0x50(r31)           
10010528  398c0002    addi r12,r12,0x2            
1001052c  b19f0050    sth r12,0x50(r31)           
10010530  480000bc    b 0x100105ec                   ; -> 100105ec
10010534  aa7f0050    lha r19,0x50(r31)           
10010538  38730019    addi r3,r19,0x19            
1001053c  4801e1bd    bl 0x1002e6f8                  ; -> 1002e6f8
10010540  60000000    ori r0,r0,0x0               
10010544  7c630734    extsh r3,r3                 
10010548  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1001054c  a89f004e    lha r4,0x4e(r31)            
10010550  7c731b78    or r19,r3,r3                
10010554  3864fffe    subi r3,r4,0x2              
10010558  4801e175    bl 0x1002e6cc                  ; -> 1002e6cc
1001055c  60000000    ori r0,r0,0x0               
10010560  7c630734    extsh r3,r3                 
10010564  1c63003c    mulli r3,r3,0x3c            
10010568  7c639a14    add r3,r3,r19               
1001056c  7c7e182e    lwzx r3,r30,r3              
10010570  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010574  2c030000    cmpwi r3,0x0                
10010578  41820014    beq 0x1001058c                 ; -> 1001058c
1001057c  a8bf0050    lha r5,0x50(r31)            
10010580  38a50002    addi r5,r5,0x2              
10010584  b0bf0050    sth r5,0x50(r31)            
10010588  48000064    b 0x100105ec                   ; -> 100105ec
1001058c  a8df0050    lha r6,0x50(r31)            
10010590  3866fffe    subi r3,r6,0x2              
10010594  4801e165    bl 0x1002e6f8                  ; -> 1002e6f8
10010598  60000000    ori r0,r0,0x0               
1001059c  7c630734    extsh r3,r3                 
100105a0  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100105a4  a8ff004e    lha r7,0x4e(r31)            
100105a8  7c731b78    or r19,r3,r3                
100105ac  3867fffe    subi r3,r7,0x2              
100105b0  4801e11d    bl 0x1002e6cc                  ; -> 1002e6cc
100105b4  60000000    ori r0,r0,0x0               
100105b8  7c630734    extsh r3,r3                 
100105bc  1c63003c    mulli r3,r3,0x3c            
100105c0  7c639a14    add r3,r3,r19               
100105c4  7c7e182e    lwzx r3,r30,r3              
100105c8  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
100105cc  2c030000    cmpwi r3,0x0                
100105d0  40820014    bne 0x100105e4                 ; -> 100105e4
100105d4  a91f0050    lha r8,0x50(r31)            
100105d8  39080002    addi r8,r8,0x2              
100105dc  b11f0050    sth r8,0x50(r31)            
100105e0  4800000c    b 0x100105ec                   ; -> 100105ec
100105e4  39200001    li r9,0x1                   
100105e8  b13f0052    sth r9,0x52(r31)            
100105ec  a95f0056    lha r10,0x56(r31)           
100105f0  394a0001    addi r10,r10,0x1            
100105f4  b15f0056    sth r10,0x56(r31)           
100105f8  7d4a0734    extsh r10,r10               
100105fc  2c0a01f4    cmpwi r10,0x1f4             
10010600  40800030    bge 0x10010630                 ; -> 10010630
10010604  807d0000    lwz r3,0x0(r29)             
10010608  80fd0000    lwz r7,0x0(r29)             
1001060c  a91f005a    lha r8,0x5a(r31)            
10010610  a93f004e    lha r9,0x4e(r31)            
10010614  a95f0050    lha r10,0x50(r31)           
10010618  7f04c378    or r4,r24,r24               
1001061c  7f45d378    or r5,r26,r26               
10010620  7f26cb78    or r6,r25,r25               
10010624  4bff3d7d    bl 0x100043a0                  ; -> 100043a0
10010628  60000000    ori r0,r0,0x0               
1001062c  48000024    b 0x10010650                   ; -> 10010650
10010630  807d0000    lwz r3,0x0(r29)             
10010634  7f04c378    or r4,r24,r24               
10010638  7f45d378    or r5,r26,r26               
1001063c  7f26cb78    or r6,r25,r25               
10010640  4bff4671    bl 0x10004cb0                  ; -> 10004cb0
10010644  60000000    ori r0,r0,0x0               
10010648  39600000    li r11,0x0                  
1001064c  b17f004e    sth r11,0x4e(r31)           
10010650  a99f0054    lha r12,0x54(r31)           
10010654  2c0c0003    cmpwi r12,0x3               
10010658  408206c4    bne 0x10010d1c                 ; -> 10010d1c
1001065c  aa7f005a    lha r19,0x5a(r31)           
10010660  ab5f004e    lha r26,0x4e(r31)           
10010664  ab3f0050    lha r25,0x50(r31)           
10010668  ab1f005a    lha r24,0x5a(r31)           
1001066c  3a73ffff    subi r19,r19,0x1            
10010670  b27f005a    sth r19,0x5a(r31)           
10010674  7e730734    extsh r19,r19               
10010678  2c130001    cmpwi r19,0x1               
1001067c  4080000c    bge 0x10010688                 ; -> 10010688
10010680  38600008    li r3,0x8                   
10010684  b07f005a    sth r3,0x5a(r31)            
10010688  a89f004e    lha r4,0x4e(r31)            
1001068c  a8bf0050    lha r5,0x50(r31)            
10010690  38640001    addi r3,r4,0x1              
10010694  a8df004e    lha r6,0x4e(r31)            
10010698  38850001    addi r4,r5,0x1              
1001069c  a8ff0050    lha r7,0x50(r31)            
100106a0  38a60017    addi r5,r6,0x17             
100106a4  38c70017    addi r6,r7,0x17             
100106a8  4bff2a05    bl 0x100030ac                  ; -> 100030ac
100106ac  60000000    ori r0,r0,0x0               
100106b0  7c7c1b78    or r28,r3,r3                
100106b4  7f880734    extsh r8,r28                
100106b8  2c080000    cmpwi r8,0x0                
100106bc  41820038    beq 0x100106f4                 ; -> 100106f4
100106c0  89350000    lbz r9,0x0(r21)             
100106c4  28090000    cmplwi r9,0x0               
100106c8  41820018    beq 0x100106e0                 ; -> 100106e0
100106cc  7f8a0734    extsh r10,r28               
100106d0  1d4a0046    mulli r10,r10,0x46          
100106d4  394a0040    addi r10,r10,0x40           
100106d8  7e9b532e    sthx r20,r27,r10            
100106dc  48000018    b 0x100106f4                   ; -> 100106f4
100106e0  7f8c0734    extsh r12,r28               
100106e4  1d8c0046    mulli r12,r12,0x46          
100106e8  39600001    li r11,0x1                  
100106ec  398c0040    addi r12,r12,0x40           
100106f0  7d7b632e    sthx r11,r27,r12            
100106f4  aa7f0052    lha r19,0x52(r31)           
100106f8  2c130001    cmpwi r19,0x1               
100106fc  4082016c    bne 0x10010868                 ; -> 10010868
10010700  a89f0050    lha r4,0x50(r31)            
10010704  3864000c    addi r3,r4,0xc              
10010708  4801dff1    bl 0x1002e6f8                  ; -> 1002e6f8
1001070c  60000000    ori r0,r0,0x0               
10010710  7c630734    extsh r3,r3                 
10010714  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010718  a8bf004e    lha r5,0x4e(r31)            
1001071c  7c731b78    or r19,r3,r3                
10010720  3865fffe    subi r3,r5,0x2              
10010724  4801dfa9    bl 0x1002e6cc                  ; -> 1002e6cc
10010728  60000000    ori r0,r0,0x0               
1001072c  7c630734    extsh r3,r3                 
10010730  1c63003c    mulli r3,r3,0x3c            
10010734  7c639a14    add r3,r3,r19               
10010738  7c7e182e    lwzx r3,r30,r3              
1001073c  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010740  2c030000    cmpwi r3,0x0                
10010744  41820010    beq 0x10010754                 ; -> 10010754
10010748  38c00002    li r6,0x2                   
1001074c  b0df0052    sth r6,0x52(r31)            
10010750  48000568    b 0x10010cb8                   ; -> 10010cb8
10010754  a8ff0050    lha r7,0x50(r31)            
10010758  38670019    addi r3,r7,0x19             
1001075c  4801df9d    bl 0x1002e6f8                  ; -> 1002e6f8
10010760  60000000    ori r0,r0,0x0               
10010764  7c630734    extsh r3,r3                 
10010768  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1001076c  a91f004e    lha r8,0x4e(r31)            
10010770  7c731b78    or r19,r3,r3                
10010774  38680017    addi r3,r8,0x17             
10010778  4801df55    bl 0x1002e6cc                  ; -> 1002e6cc
1001077c  60000000    ori r0,r0,0x0               
10010780  7c630734    extsh r3,r3                 
10010784  1c63003c    mulli r3,r3,0x3c            
10010788  7c639a14    add r3,r3,r19               
1001078c  7c7e182e    lwzx r3,r30,r3              
10010790  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010794  2c030000    cmpwi r3,0x0                
10010798  41820014    beq 0x100107ac                 ; -> 100107ac
1001079c  a93f004e    lha r9,0x4e(r31)            
100107a0  3929fffe    subi r9,r9,0x2              
100107a4  b13f004e    sth r9,0x4e(r31)            
100107a8  48000510    b 0x10010cb8                   ; -> 10010cb8
100107ac  a95f0050    lha r10,0x50(r31)           
100107b0  386a0019    addi r3,r10,0x19            
100107b4  4801df45    bl 0x1002e6f8                  ; -> 1002e6f8
100107b8  60000000    ori r0,r0,0x0               
100107bc  7c630734    extsh r3,r3                 
100107c0  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100107c4  a97f004e    lha r11,0x4e(r31)           
100107c8  7c731b78    or r19,r3,r3                
100107cc  386bfffe    subi r3,r11,0x2             
100107d0  4801defd    bl 0x1002e6cc                  ; -> 1002e6cc
100107d4  60000000    ori r0,r0,0x0               
100107d8  7c630734    extsh r3,r3                 
100107dc  1c63003c    mulli r3,r3,0x3c            
100107e0  7c639a14    add r3,r3,r19               
100107e4  7c7e182e    lwzx r3,r30,r3              
100107e8  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
100107ec  2c030000    cmpwi r3,0x0                
100107f0  41820014    beq 0x10010804                 ; -> 10010804
100107f4  a99f004e    lha r12,0x4e(r31)           
100107f8  398cfffe    subi r12,r12,0x2            
100107fc  b19f004e    sth r12,0x4e(r31)           
10010800  480004b8    b 0x10010cb8                   ; -> 10010cb8
10010804  aa7f0050    lha r19,0x50(r31)           
10010808  38730019    addi r3,r19,0x19            
1001080c  4801deed    bl 0x1002e6f8                  ; -> 1002e6f8
10010810  60000000    ori r0,r0,0x0               
10010814  7c630734    extsh r3,r3                 
10010818  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1001081c  a89f004e    lha r4,0x4e(r31)            
10010820  7c731b78    or r19,r3,r3                
10010824  38640019    addi r3,r4,0x19             
10010828  4801dea5    bl 0x1002e6cc                  ; -> 1002e6cc
1001082c  60000000    ori r0,r0,0x0               
10010830  7c630734    extsh r3,r3                 
10010834  1c63003c    mulli r3,r3,0x3c            
10010838  7c639a14    add r3,r3,r19               
1001083c  7c7e182e    lwzx r3,r30,r3              
10010840  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010844  2c030000    cmpwi r3,0x0                
10010848  40820014    bne 0x1001085c                 ; -> 1001085c
1001084c  a8bf004e    lha r5,0x4e(r31)            
10010850  38a5fffe    subi r5,r5,0x2              
10010854  b0bf004e    sth r5,0x4e(r31)            
10010858  48000460    b 0x10010cb8                   ; -> 10010cb8
1001085c  38c00004    li r6,0x4                   
10010860  b0df0052    sth r6,0x52(r31)            
10010864  48000454    b 0x10010cb8                   ; -> 10010cb8
10010868  a8ff0052    lha r7,0x52(r31)            
1001086c  2c070002    cmpwi r7,0x2                
10010870  4082016c    bne 0x100109dc                 ; -> 100109dc
10010874  a91f0050    lha r8,0x50(r31)            
10010878  3868fffe    subi r3,r8,0x2              
1001087c  4801de7d    bl 0x1002e6f8                  ; -> 1002e6f8
10010880  60000000    ori r0,r0,0x0               
10010884  7c630734    extsh r3,r3                 
10010888  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
1001088c  a93f004e    lha r9,0x4e(r31)            
10010890  7c731b78    or r19,r3,r3                
10010894  3869000c    addi r3,r9,0xc              
10010898  4801de35    bl 0x1002e6cc                  ; -> 1002e6cc
1001089c  60000000    ori r0,r0,0x0               
100108a0  7c630734    extsh r3,r3                 
100108a4  1c63003c    mulli r3,r3,0x3c            
100108a8  7c639a14    add r3,r3,r19               
100108ac  7c7e182e    lwzx r3,r30,r3              
100108b0  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
100108b4  2c030000    cmpwi r3,0x0                
100108b8  41820010    beq 0x100108c8                 ; -> 100108c8
100108bc  39400003    li r10,0x3                  
100108c0  b15f0052    sth r10,0x52(r31)           
100108c4  480003f4    b 0x10010cb8                   ; -> 10010cb8
100108c8  a97f0050    lha r11,0x50(r31)           
100108cc  386b0017    addi r3,r11,0x17            
100108d0  4801de29    bl 0x1002e6f8                  ; -> 1002e6f8
100108d4  60000000    ori r0,r0,0x0               
100108d8  7c630734    extsh r3,r3                 
100108dc  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
100108e0  a99f004e    lha r12,0x4e(r31)           
100108e4  7c731b78    or r19,r3,r3                
100108e8  386cfffe    subi r3,r12,0x2             
100108ec  4801dde1    bl 0x1002e6cc                  ; -> 1002e6cc
100108f0  60000000    ori r0,r0,0x0               
100108f4  7c630734    extsh r3,r3                 
100108f8  1c63003c    mulli r3,r3,0x3c            
100108fc  7c639a14    add r3,r3,r19               
10010900  7c7e182e    lwzx r3,r30,r3              
10010904  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010908  2c030000    cmpwi r3,0x0                
1001090c  41820014    beq 0x10010920                 ; -> 10010920
10010910  aa7f0050    lha r19,0x50(r31)           
10010914  3a73fffe    subi r19,r19,0x2            
10010918  b27f0050    sth r19,0x50(r31)           
1001091c  4800039c    b 0x10010cb8                   ; -> 10010cb8
10010920  a89f0050    lha r4,0x50(r31)            
10010924  3864fffe    subi r3,r4,0x2              
10010928  4801ddd1    bl 0x1002e6f8                  ; -> 1002e6f8
1001092c  60000000    ori r0,r0,0x0               
10010930  7c630734    extsh r3,r3                 
10010934  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010938  a8bf004e    lha r5,0x4e(r31)            
1001093c  7c731b78    or r19,r3,r3                
10010940  3865fffe    subi r3,r5,0x2              
10010944  4801dd89    bl 0x1002e6cc                  ; -> 1002e6cc
10010948  60000000    ori r0,r0,0x0               
1001094c  7c630734    extsh r3,r3                 
10010950  1c63003c    mulli r3,r3,0x3c            
10010954  7c639a14    add r3,r3,r19               
10010958  7c7e182e    lwzx r3,r30,r3              
1001095c  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010960  2c030000    cmpwi r3,0x0                
10010964  41820014    beq 0x10010978                 ; -> 10010978
10010968  a8df0050    lha r6,0x50(r31)            
1001096c  38c6fffe    subi r6,r6,0x2              
10010970  b0df0050    sth r6,0x50(r31)            
10010974  48000344    b 0x10010cb8                   ; -> 10010cb8
10010978  a8ff0050    lha r7,0x50(r31)            
1001097c  38670019    addi r3,r7,0x19             
10010980  4801dd79    bl 0x1002e6f8                  ; -> 1002e6f8
10010984  60000000    ori r0,r0,0x0               
10010988  7c630734    extsh r3,r3                 
1001098c  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010990  a91f004e    lha r8,0x4e(r31)            
10010994  7c731b78    or r19,r3,r3                
10010998  3868fffe    subi r3,r8,0x2              
1001099c  4801dd31    bl 0x1002e6cc                  ; -> 1002e6cc
100109a0  60000000    ori r0,r0,0x0               
100109a4  7c630734    extsh r3,r3                 
100109a8  1c63003c    mulli r3,r3,0x3c            
100109ac  7c639a14    add r3,r3,r19               
100109b0  7c7e182e    lwzx r3,r30,r3              
100109b4  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
100109b8  2c030000    cmpwi r3,0x0                
100109bc  40820014    bne 0x100109d0                 ; -> 100109d0
100109c0  a93f0050    lha r9,0x50(r31)            
100109c4  3929fffe    subi r9,r9,0x2              
100109c8  b13f0050    sth r9,0x50(r31)            
100109cc  480002ec    b 0x10010cb8                   ; -> 10010cb8
100109d0  39400001    li r10,0x1                  
100109d4  b15f0052    sth r10,0x52(r31)           
100109d8  480002e0    b 0x10010cb8                   ; -> 10010cb8
100109dc  a97f0052    lha r11,0x52(r31)           
100109e0  2c0b0003    cmpwi r11,0x3               
100109e4  40820168    bne 0x10010b4c                 ; -> 10010b4c
100109e8  a99f0050    lha r12,0x50(r31)           
100109ec  386c000c    addi r3,r12,0xc             
100109f0  4801dd09    bl 0x1002e6f8                  ; -> 1002e6f8
100109f4  60000000    ori r0,r0,0x0               
100109f8  7c630734    extsh r3,r3                 
100109fc  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010a00  a89f004e    lha r4,0x4e(r31)            
10010a04  7c731b78    or r19,r3,r3                
10010a08  38640019    addi r3,r4,0x19             
10010a0c  4801dcc1    bl 0x1002e6cc                  ; -> 1002e6cc
10010a10  60000000    ori r0,r0,0x0               
10010a14  7c630734    extsh r3,r3                 
10010a18  1c63003c    mulli r3,r3,0x3c            
10010a1c  7c639a14    add r3,r3,r19               
10010a20  7c7e182e    lwzx r3,r30,r3              
10010a24  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010a28  2c030000    cmpwi r3,0x0                
10010a2c  41820010    beq 0x10010a3c                 ; -> 10010a3c
10010a30  38a00004    li r5,0x4                   
10010a34  b0bf0052    sth r5,0x52(r31)            
10010a38  48000280    b 0x10010cb8                   ; -> 10010cb8
10010a3c  a8df0050    lha r6,0x50(r31)            
10010a40  3866fffe    subi r3,r6,0x2              
10010a44  4801dcb5    bl 0x1002e6f8                  ; -> 1002e6f8
10010a48  60000000    ori r0,r0,0x0               
10010a4c  7c630734    extsh r3,r3                 
10010a50  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010a54  7c731b78    or r19,r3,r3                
10010a58  a87f004e    lha r3,0x4e(r31)            
10010a5c  4801dc71    bl 0x1002e6cc                  ; -> 1002e6cc
10010a60  60000000    ori r0,r0,0x0               
10010a64  7c630734    extsh r3,r3                 
10010a68  1c63003c    mulli r3,r3,0x3c            
10010a6c  7c639a14    add r3,r3,r19               
10010a70  7c7e182e    lwzx r3,r30,r3              
10010a74  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010a78  2c030000    cmpwi r3,0x0                
10010a7c  41820014    beq 0x10010a90                 ; -> 10010a90
10010a80  a8ff004e    lha r7,0x4e(r31)            
10010a84  38e70002    addi r7,r7,0x2              
10010a88  b0ff004e    sth r7,0x4e(r31)            
10010a8c  4800022c    b 0x10010cb8                   ; -> 10010cb8
10010a90  a91f0050    lha r8,0x50(r31)            
10010a94  3868fffe    subi r3,r8,0x2              
10010a98  4801dc61    bl 0x1002e6f8                  ; -> 1002e6f8
10010a9c  60000000    ori r0,r0,0x0               
10010aa0  7c630734    extsh r3,r3                 
10010aa4  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010aa8  a93f004e    lha r9,0x4e(r31)            
10010aac  7c731b78    or r19,r3,r3                
10010ab0  38690019    addi r3,r9,0x19             
10010ab4  4801dc19    bl 0x1002e6cc                  ; -> 1002e6cc
10010ab8  60000000    ori r0,r0,0x0               
10010abc  7c630734    extsh r3,r3                 
10010ac0  1c63003c    mulli r3,r3,0x3c            
10010ac4  7c639a14    add r3,r3,r19               
10010ac8  7c7e182e    lwzx r3,r30,r3              
10010acc  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010ad0  2c030000    cmpwi r3,0x0                
10010ad4  41820014    beq 0x10010ae8                 ; -> 10010ae8
10010ad8  a95f004e    lha r10,0x4e(r31)           
10010adc  394a0002    addi r10,r10,0x2            
10010ae0  b15f004e    sth r10,0x4e(r31)           
10010ae4  480001d4    b 0x10010cb8                   ; -> 10010cb8
10010ae8  a97f0050    lha r11,0x50(r31)           
10010aec  386bfffe    subi r3,r11,0x2             
10010af0  4801dc09    bl 0x1002e6f8                  ; -> 1002e6f8
10010af4  60000000    ori r0,r0,0x0               
10010af8  7c630734    extsh r3,r3                 
10010afc  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010b00  a99f004e    lha r12,0x4e(r31)           
10010b04  7c731b78    or r19,r3,r3                
10010b08  386cfffe    subi r3,r12,0x2             
10010b0c  4801dbc1    bl 0x1002e6cc                  ; -> 1002e6cc
10010b10  60000000    ori r0,r0,0x0               
10010b14  7c630734    extsh r3,r3                 
10010b18  1c63003c    mulli r3,r3,0x3c            
10010b1c  7c639a14    add r3,r3,r19               
10010b20  7c7e182e    lwzx r3,r30,r3              
10010b24  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010b28  2c030000    cmpwi r3,0x0                
10010b2c  40820014    bne 0x10010b40                 ; -> 10010b40
10010b30  aa7f004e    lha r19,0x4e(r31)           
10010b34  3a730002    addi r19,r19,0x2            
10010b38  b27f004e    sth r19,0x4e(r31)           
10010b3c  4800017c    b 0x10010cb8                   ; -> 10010cb8
10010b40  38600002    li r3,0x2                   
10010b44  b07f0052    sth r3,0x52(r31)            
10010b48  48000170    b 0x10010cb8                   ; -> 10010cb8
10010b4c  a89f0052    lha r4,0x52(r31)            
10010b50  2c040004    cmpwi r4,0x4                
10010b54  40820164    bne 0x10010cb8                 ; -> 10010cb8
10010b58  a8bf0050    lha r5,0x50(r31)            
10010b5c  38650018    addi r3,r5,0x18             
10010b60  4801db99    bl 0x1002e6f8                  ; -> 1002e6f8
10010b64  60000000    ori r0,r0,0x0               
10010b68  7c630734    extsh r3,r3                 
10010b6c  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010b70  a8df004e    lha r6,0x4e(r31)            
10010b74  7c731b78    or r19,r3,r3                
10010b78  3866000c    addi r3,r6,0xc              
10010b7c  4801db51    bl 0x1002e6cc                  ; -> 1002e6cc
10010b80  60000000    ori r0,r0,0x0               
10010b84  7c630734    extsh r3,r3                 
10010b88  1c63003c    mulli r3,r3,0x3c            
10010b8c  7c639a14    add r3,r3,r19               
10010b90  7c7e182e    lwzx r3,r30,r3              
10010b94  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010b98  2c030000    cmpwi r3,0x0                
10010b9c  41820010    beq 0x10010bac                 ; -> 10010bac
10010ba0  38e00001    li r7,0x1                   
10010ba4  b0ff0052    sth r7,0x52(r31)            
10010ba8  48000110    b 0x10010cb8                   ; -> 10010cb8
10010bac  a87f0050    lha r3,0x50(r31)            
10010bb0  4801db49    bl 0x1002e6f8                  ; -> 1002e6f8
10010bb4  60000000    ori r0,r0,0x0               
10010bb8  7c630734    extsh r3,r3                 
10010bbc  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010bc0  a91f004e    lha r8,0x4e(r31)            
10010bc4  7c731b78    or r19,r3,r3                
10010bc8  38680019    addi r3,r8,0x19             
10010bcc  4801db01    bl 0x1002e6cc                  ; -> 1002e6cc
10010bd0  60000000    ori r0,r0,0x0               
10010bd4  7c630734    extsh r3,r3                 
10010bd8  1c63003c    mulli r3,r3,0x3c            
10010bdc  7c639a14    add r3,r3,r19               
10010be0  7c7e182e    lwzx r3,r30,r3              
10010be4  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010be8  2c030000    cmpwi r3,0x0                
10010bec  41820014    beq 0x10010c00                 ; -> 10010c00
10010bf0  a93f0050    lha r9,0x50(r31)            
10010bf4  39290002    addi r9,r9,0x2              
10010bf8  b13f0050    sth r9,0x50(r31)            
10010bfc  480000bc    b 0x10010cb8                   ; -> 10010cb8
10010c00  a95f0050    lha r10,0x50(r31)           
10010c04  386a0018    addi r3,r10,0x18            
10010c08  4801daf1    bl 0x1002e6f8                  ; -> 1002e6f8
10010c0c  60000000    ori r0,r0,0x0               
10010c10  7c630734    extsh r3,r3                 
10010c14  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010c18  a97f004e    lha r11,0x4e(r31)           
10010c1c  7c731b78    or r19,r3,r3                
10010c20  386b0019    addi r3,r11,0x19            
10010c24  4801daa9    bl 0x1002e6cc                  ; -> 1002e6cc
10010c28  60000000    ori r0,r0,0x0               
10010c2c  7c630734    extsh r3,r3                 
10010c30  1c63003c    mulli r3,r3,0x3c            
10010c34  7c639a14    add r3,r3,r19               
10010c38  7c7e182e    lwzx r3,r30,r3              
10010c3c  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010c40  2c030000    cmpwi r3,0x0                
10010c44  41820014    beq 0x10010c58                 ; -> 10010c58
10010c48  a99f0050    lha r12,0x50(r31)           
10010c4c  398c0002    addi r12,r12,0x2            
10010c50  b19f0050    sth r12,0x50(r31)           
10010c54  48000064    b 0x10010cb8                   ; -> 10010cb8
10010c58  aa7f0050    lha r19,0x50(r31)           
10010c5c  3873fffe    subi r3,r19,0x2             
10010c60  4801da99    bl 0x1002e6f8                  ; -> 1002e6f8
10010c64  60000000    ori r0,r0,0x0               
10010c68  7c630734    extsh r3,r3                 
10010c6c  5463103a    rlwinm r3,r3,0x2,0x0,0x1d   
10010c70  a89f004e    lha r4,0x4e(r31)            
10010c74  7c731b78    or r19,r3,r3                
10010c78  38640019    addi r3,r4,0x19             
10010c7c  4801da51    bl 0x1002e6cc                  ; -> 1002e6cc
10010c80  60000000    ori r0,r0,0x0               
10010c84  7c630734    extsh r3,r3                 
10010c88  1c63003c    mulli r3,r3,0x3c            
10010c8c  7c639a14    add r3,r3,r19               
10010c90  7c7e182e    lwzx r3,r30,r3              
10010c94  546305ac    rlwinm r3,r3,0x0,0x16,0x16  
10010c98  2c030000    cmpwi r3,0x0                
10010c9c  40820014    bne 0x10010cb0                 ; -> 10010cb0
10010ca0  a8bf0050    lha r5,0x50(r31)            
10010ca4  38a50002    addi r5,r5,0x2              
10010ca8  b0bf0050    sth r5,0x50(r31)            
10010cac  4800000c    b 0x10010cb8                   ; -> 10010cb8
10010cb0  38c00003    li r6,0x3                   
10010cb4  b0df0052    sth r6,0x52(r31)            
10010cb8  a8ff0056    lha r7,0x56(r31)            
10010cbc  38e70001    addi r7,r7,0x1              
10010cc0  b0ff0056    sth r7,0x56(r31)            
10010cc4  7ce70734    extsh r7,r7                 
10010cc8  2c0701f4    cmpwi r7,0x1f4              
10010ccc  40800030    bge 0x10010cfc                 ; -> 10010cfc
10010cd0  807d0000    lwz r3,0x0(r29)             
10010cd4  80fd0000    lwz r7,0x0(r29)             
10010cd8  a91f005a    lha r8,0x5a(r31)            
10010cdc  a93f004e    lha r9,0x4e(r31)            
10010ce0  a95f0050    lha r10,0x50(r31)           
10010ce4  7f04c378    or r4,r24,r24               
10010ce8  7f45d378    or r5,r26,r26               
10010cec  7f26cb78    or r6,r25,r25               
10010cf0  4bff36b1    bl 0x100043a0                  ; -> 100043a0
10010cf4  60000000    ori r0,r0,0x0               
10010cf8  48000024    b 0x10010d1c                   ; -> 10010d1c
10010cfc  807d0000    lwz r3,0x0(r29)             
10010d00  7f04c378    or r4,r24,r24               
10010d04  7f45d378    or r5,r26,r26               
10010d08  7f26cb78    or r6,r25,r25               
10010d0c  4bff3fa5    bl 0x10004cb0                  ; -> 10004cb0
10010d10  60000000    ori r0,r0,0x0               
10010d14  39000000    li r8,0x0                   
10010d18  b11f004e    sth r8,0x4e(r31)            
10010d1c  80010078    lwz r0,0x78(r1)                ; -> Stack[0x8]
10010d20  38210070    addi r1,r1,0x70             
10010d24  7c0803a6    mtspr LR,r0                 
10010d28  ba61ffcc    lmw r19,-0x34(r1)              ; -> Stack[-0x34]
10010d2c  4e800020    blr                         
