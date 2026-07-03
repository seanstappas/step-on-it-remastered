; FUN_10006f6c @ 0x10006f6c
10006f6c  7c0802a6    mfspr r0,LR                 
10006f70  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10006f74  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10006f78  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10006f7c  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10006f80  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10006f84  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
10006f88  b061006a    sth r3,0x6a(r1)                ; -> Stack[0x1a]
10006f8c  a861006a    lha r3,0x6a(r1)                ; -> Stack[0x1a]
10006f90  3bc23cd8    addi r30,r2,0x3cd8          
10006f94  1c630046    mulli r3,r3,0x46            
10006f98  7ffe1a14    add r31,r30,r3              
10006f9c  889f001f    lbz r4,0x1f(r31)            
10006fa0  28040000    cmplwi r4,0x0               
10006fa4  41820048    beq 0x10006fec                 ; -> 10006fec
10006fa8  38a00000    li r5,0x0                   
10006fac  98bf001f    stb r5,0x1f(r31)            
10006fb0  38c00000    li r6,0x0                   
10006fb4  38e261a4    addi r7,r2,0x61a4           
10006fb8  98df001e    stb r6,0x1e(r31)            
10006fbc  80e7001c    lwz r7,0x1c(r7)             
10006fc0  39000000    li r8,0x0                   
10006fc4  90ff000a    stw r7,0xa(r31)             
10006fc8  911f0014    stw r8,0x14(r31)            
10006fcc  39200001    li r9,0x1                   
10006fd0  b13f0024    sth r9,0x24(r31)            
10006fd4  39400001    li r10,0x1                  
10006fd8  b15f0026    sth r10,0x26(r31)           
10006fdc  38600012    li r3,0x12                  
10006fe0  38800004    li r4,0x4                   
10006fe4  4802403d    bl 0x1002b020                  ; -> 1002b020
10006fe8  60000000    ori r0,r0,0x0               
10006fec  a97f0024    lha r11,0x24(r31)           
10006ff0  7d6c5b78    or r12,r11,r11              
10006ff4  7d8c0734    extsh r12,r12               
10006ff8  396bffff    subi r11,r11,0x1            
10006ffc  2c0c0000    cmpwi r12,0x0               
10007000  b17f0024    sth r11,0x24(r31)           
10007004  4082017c    bne 0x10007180                 ; -> 10007180
10007008  38600001    li r3,0x1                   
1000700c  b07f0024    sth r3,0x24(r31)            
10007010  38800001    li r4,0x1                   
10007014  989f001e    stb r4,0x1e(r31)            
10007018  a8bf0004    lha r5,0x4(r31)             
1000701c  2c050009    cmpwi r5,0x9                
10007020  4082009c    bne 0x100070bc                 ; -> 100070bc
10007024  a8df0026    lha r6,0x26(r31)            
10007028  a8ff000e    lha r7,0xe(r31)             
1000702c  7ce73214    add r7,r7,r6                
10007030  b0ff000e    sth r7,0xe(r31)             
10007034  a91f000e    lha r8,0xe(r31)             
10007038  2c080020    cmpwi r8,0x20               
1000703c  4081004c    ble 0x10007088                 ; -> 10007088
10007040  3920001f    li r9,0x1f                  
10007044  b13f000e    sth r9,0xe(r31)             
10007048  3940ffff    li r10,-0x1                 
1000704c  b15f0026    sth r10,0x26(r31)           
10007050  a97f0012    lha r11,0x12(r31)           
10007054  386b001e    addi r3,r11,0x1e            
10007058  480276a1    bl 0x1002e6f8                  ; -> 1002e6f8
1000705c  60000000    ori r0,r0,0x0               
10007060  a99f0010    lha r12,0x10(r31)           
10007064  7c7d1b78    or r29,r3,r3                
10007068  386c0010    addi r3,r12,0x10            
1000706c  48027661    bl 0x1002e6cc                  ; -> 1002e6cc
10007070  60000000    ori r0,r0,0x0               
10007074  7c7c1b78    or r28,r3,r3                
10007078  7f83e378    or r3,r28,r28               
1000707c  7fa4eb78    or r4,r29,r29               
10007080  48020945    bl 0x100279c4                  ; -> 100279c4
10007084  60000000    ori r0,r0,0x0               
10007088  ab9f000e    lha r28,0xe(r31)            
1000708c  2c1c0011    cmpwi r28,0x11              
10007090  408000c0    bge 0x10007150                 ; -> 10007150
10007094  3ba00011    li r29,0x11                 
10007098  b3bf000e    sth r29,0xe(r31)            
1000709c  38600001    li r3,0x1                   
100070a0  987f0020    stb r3,0x20(r31)            
100070a4  a8bf0030    lha r5,0x30(r31)            
100070a8  38800000    li r4,0x0                   
100070ac  1ca50046    mulli r5,r5,0x46            
100070b0  38a50032    addi r5,r5,0x32             
100070b4  7c9e2b2e    sthx r4,r30,r5              
100070b8  48000098    b 0x10007150                   ; -> 10007150
100070bc  a8df0026    lha r6,0x26(r31)            
100070c0  a8ff000e    lha r7,0xe(r31)             
100070c4  7ce73214    add r7,r7,r6                
100070c8  b0ff000e    sth r7,0xe(r31)             
100070cc  a91f000e    lha r8,0xe(r31)             
100070d0  2c080040    cmpwi r8,0x40               
100070d4  4081004c    ble 0x10007120                 ; -> 10007120
100070d8  3920003f    li r9,0x3f                  
100070dc  b13f000e    sth r9,0xe(r31)             
100070e0  3940ffff    li r10,-0x1                 
100070e4  b15f0026    sth r10,0x26(r31)           
100070e8  a97f0012    lha r11,0x12(r31)           
100070ec  386bfffa    subi r3,r11,0x6             
100070f0  48027609    bl 0x1002e6f8                  ; -> 1002e6f8
100070f4  60000000    ori r0,r0,0x0               
100070f8  a99f0010    lha r12,0x10(r31)           
100070fc  7c7d1b78    or r29,r3,r3                
10007100  386c0010    addi r3,r12,0x10            
10007104  480275c9    bl 0x1002e6cc                  ; -> 1002e6cc
10007108  60000000    ori r0,r0,0x0               
1000710c  7c7c1b78    or r28,r3,r3                
10007110  7f83e378    or r3,r28,r28               
10007114  7fa4eb78    or r4,r29,r29               
10007118  480208ad    bl 0x100279c4                  ; -> 100279c4
1000711c  60000000    ori r0,r0,0x0               
10007120  ab9f000e    lha r28,0xe(r31)            
10007124  2c1c0031    cmpwi r28,0x31              
10007128  40800028    bge 0x10007150                 ; -> 10007150
1000712c  3ba00031    li r29,0x31                 
10007130  b3bf000e    sth r29,0xe(r31)            
10007134  38600001    li r3,0x1                   
10007138  987f0020    stb r3,0x20(r31)            
1000713c  a8bf0030    lha r5,0x30(r31)            
10007140  38800000    li r4,0x0                   
10007144  1ca50046    mulli r5,r5,0x46            
10007148  38a50032    addi r5,r5,0x32             
1000714c  7c9e2b2e    sthx r4,r30,r5              
10007150  a8df0010    lha r6,0x10(r31)            
10007154  38c6000a    addi r6,r6,0xa              
10007158  b0df003a    sth r6,0x3a(r31)            
1000715c  a8ff0010    lha r7,0x10(r31)            
10007160  38e7000f    addi r7,r7,0xf              
10007164  b0ff003c    sth r7,0x3c(r31)            
10007168  a91f0012    lha r8,0x12(r31)            
1000716c  39080005    addi r8,r8,0x5              
10007170  b11f0038    sth r8,0x38(r31)            
10007174  a93f0012    lha r9,0x12(r31)            
10007178  3929001c    addi r9,r9,0x1c             
1000717c  b13f0036    sth r9,0x36(r31)            
10007180  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
10007184  38210050    addi r1,r1,0x50             
10007188  7c0803a6    mtspr LR,r0                 
1000718c  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
10007190  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
10007194  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
10007198  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1000719c  4e800020    blr                         
