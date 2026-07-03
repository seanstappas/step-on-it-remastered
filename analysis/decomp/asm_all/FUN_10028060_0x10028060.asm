; FUN_10028060 @ 0x10028060
10028060  7c0802a6    mfspr r0,LR                 
10028064  bf21ffe4    stmw r25,-0x1c(r1)             ; -> Stack[-0x1c]
10028068  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1002806c  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10028070  3b2261fc    addi r25,r2,0x61fc          
10028074  3bc262a0    addi r30,r2,0x62a0          
10028078  3b4261fe    addi r26,r2,0x61fe          
1002807c  abf90000    lha r31,0x0(r25)            
10028080  3b60ffff    li r27,-0x1                 
10028084  480002fc    b 0x10028380                   ; -> 10028380
10028088  7fe30734    extsh r3,r31                
1002808c  1c630018    mulli r3,r3,0x18            
10028090  7fe50734    extsh r5,r31                
10028094  1ca50018    mulli r5,r5,0x18            
10028098  38630014    addi r3,r3,0x14             
1002809c  7c9e1aae    lhax r4,r30,r3              
100280a0  38a50012    addi r5,r5,0x12             
100280a4  38840001    addi r4,r4,0x1              
100280a8  7c9e1b2e    sthx r4,r30,r3              
100280ac  7cbe28ae    lbzx r5,r30,r5              
100280b0  28050000    cmplwi r5,0x0               
100280b4  41820080    beq 0x10028134                 ; -> 10028134
100280b8  7fea0734    extsh r10,r31               
100280bc  1d4a0018    mulli r10,r10,0x18          
100280c0  7fe90734    extsh r9,r31                
100280c4  1d290018    mulli r9,r9,0x18            
100280c8  394a0014    addi r10,r10,0x14           
100280cc  7fe70734    extsh r7,r31                
100280d0  7fe80734    extsh r8,r31                
100280d4  7d5e52ae    lhax r10,r30,r10            
100280d8  7fe60734    extsh r6,r31                
100280dc  1ce70018    mulli r7,r7,0x18            
100280e0  1d080018    mulli r8,r8,0x18            
100280e4  1cc60018    mulli r6,r6,0x18            
100280e8  39290014    addi r9,r9,0x14             
100280ec  38e70010    addi r7,r7,0x10             
100280f0  39080014    addi r8,r8,0x14             
100280f4  38c6000c    addi r6,r6,0xc              
100280f8  7cde32ae    lhax r6,r30,r6              
100280fc  1d4a0005    mulli r10,r10,0x5           
10028100  7d3e4aae    lhax r9,r30,r9              
10028104  7cfe3aae    lhax r7,r30,r7              
10028108  7d1e42ae    lhax r8,r30,r8              
1002810c  7d2a49d6    mullw r9,r10,r9             
10028110  7d290e70    srawi r9,r9,0x1             
10028114  7ce839d6    mullw r7,r8,r7              
10028118  1cc6000a    mulli r6,r6,0xa             
1002811c  7d290194    addze r9,r9                 
10028120  7ce74a14    add r7,r7,r9                
10028124  7cc63a14    add r6,r6,r7                
10028128  3960000a    li r11,0xa                  
1002812c  7fa65bd6    divw r29,r6,r11             
10028130  48000048    b 0x10028178                   ; -> 10028178
10028134  7fec0734    extsh r12,r31               
10028138  7fe30734    extsh r3,r31                
1002813c  7fe40734    extsh r4,r31                
10028140  1d8c0018    mulli r12,r12,0x18          
10028144  1c630018    mulli r3,r3,0x18            
10028148  1c840018    mulli r4,r4,0x18            
1002814c  398c000c    addi r12,r12,0xc            
10028150  38630010    addi r3,r3,0x10             
10028154  38840014    addi r4,r4,0x14             
10028158  7d9e62ae    lhax r12,r30,r12            
1002815c  7c7e1aae    lhax r3,r30,r3              
10028160  7c9e22ae    lhax r4,r30,r4              
10028164  1d8c000a    mulli r12,r12,0xa           
10028168  7c6419d6    mullw r3,r4,r3              
1002816c  7d8c1a14    add r12,r12,r3              
10028170  38a0000a    li r5,0xa                   
10028174  7fac2bd6    divw r29,r12,r5             
10028178  7fe60734    extsh r6,r31                
1002817c  7fe70734    extsh r7,r31                
10028180  7fe80734    extsh r8,r31                
10028184  1cc60018    mulli r6,r6,0x18            
10028188  1ce70018    mulli r7,r7,0x18            
1002818c  1d080018    mulli r8,r8,0x18            
10028190  38c6000a    addi r6,r6,0xa              
10028194  38e7000e    addi r7,r7,0xe              
10028198  39080014    addi r8,r8,0x14             
1002819c  7cde32ae    lhax r6,r30,r6              
100281a0  7faa0734    extsh r10,r29               
100281a4  7cfe3aae    lhax r7,r30,r7              
100281a8  7d1e42ae    lhax r8,r30,r8              
100281ac  1cc6000a    mulli r6,r6,0xa             
100281b0  7ce839d6    mullw r7,r8,r7              
100281b4  7cc63a14    add r6,r6,r7                
100281b8  3920000a    li r9,0xa                   
100281bc  7f864bd6    divw r28,r6,r9              
100281c0  2c0a0028    cmpwi r10,0x28              
100281c4  40800020    bge 0x100281e4                 ; -> 100281e4
100281c8  7feb0734    extsh r11,r31               
100281cc  1d6b0018    mulli r11,r11,0x18          
100281d0  396b0012    addi r11,r11,0x12           
100281d4  7d7e58ae    lbzx r11,r30,r11            
100281d8  280b0000    cmplwi r11,0x0              
100281dc  41820008    beq 0x100281e4                 ; -> 100281e4
100281e0  3ba00028    li r29,0x28                 
100281e4  7f8c0734    extsh r12,r28               
100281e8  2c0c025d    cmpwi r12,0x25d             
100281ec  41810028    bgt 0x10028214                 ; -> 10028214
100281f0  7f830734    extsh r3,r28                
100281f4  2c030005    cmpwi r3,0x5                
100281f8  4180001c    blt 0x10028214                 ; -> 10028214
100281fc  7fa40734    extsh r4,r29                
10028200  2c0401bd    cmpwi r4,0x1bd              
10028204  41810010    bgt 0x10028214                 ; -> 10028214
10028208  7fa50734    extsh r5,r29                
1002820c  2c050028    cmpwi r5,0x28               
10028210  408000d4    bge 0x100282e4                 ; -> 100282e4
10028214  7fe60734    extsh r6,r31                
10028218  1cc60018    mulli r6,r6,0x18            
1002821c  7fe70734    extsh r7,r31                
10028220  7fe80734    extsh r8,r31                
10028224  7fe90734    extsh r9,r31                
10028228  1ce70018    mulli r7,r7,0x18            
1002822c  1d080018    mulli r8,r8,0x18            
10028230  1d290018    mulli r9,r9,0x18            
10028234  38e70004    addi r7,r7,0x4              
10028238  39080006    addi r8,r8,0x6              
1002823c  7c7e302e    lwzx r3,r30,r6              
10028240  39290008    addi r9,r9,0x8              
10028244  7c9e3aae    lhax r4,r30,r7              
10028248  7cbe42ae    lhax r5,r30,r8              
1002824c  7cde4aae    lhax r6,r30,r9              
10028250  4bfdca61    bl 0x10004cb0                  ; -> 10004cb0
10028254  60000000    ori r0,r0,0x0               
10028258  7f6a0734    extsh r10,r27               
1002825c  2c0affff    cmpwi r10,-0x1              
10028260  40820038    bne 0x10028298                 ; -> 10028298
10028264  7feb0734    extsh r11,r31               
10028268  1d6b0018    mulli r11,r11,0x18          
1002826c  7fe30734    extsh r3,r31                
10028270  396b0016    addi r11,r11,0x16           
10028274  1c630018    mulli r3,r3,0x18            
10028278  7d7e5aae    lhax r11,r30,r11            
1002827c  38630016    addi r3,r3,0x16             
10028280  b1790000    sth r11,0x0(r25)            
10028284  a99a0000    lha r12,0x0(r26)            
10028288  7d9e1b2e    sthx r12,r30,r3             
1002828c  b3fa0000    sth r31,0x0(r26)            
10028290  abf90000    lha r31,0x0(r25)            
10028294  480000ec    b 0x10028380                   ; -> 10028380
10028298  7fe40734    extsh r4,r31                
1002829c  1c840018    mulli r4,r4,0x18            
100282a0  7f650734    extsh r5,r27                
100282a4  1ca50018    mulli r5,r5,0x18            
100282a8  7fe70734    extsh r7,r31                
100282ac  38840016    addi r4,r4,0x16             
100282b0  1ce70018    mulli r7,r7,0x18            
100282b4  7f680734    extsh r8,r27                
100282b8  1d080018    mulli r8,r8,0x18            
100282bc  7c9e22ae    lhax r4,r30,r4              
100282c0  38a50016    addi r5,r5,0x16             
100282c4  7c9e2b2e    sthx r4,r30,r5              
100282c8  a8da0000    lha r6,0x0(r26)             
100282cc  38e70016    addi r7,r7,0x16             
100282d0  7cde3b2e    sthx r6,r30,r7              
100282d4  b3fa0000    sth r31,0x0(r26)            
100282d8  39080016    addi r8,r8,0x16             
100282dc  7ffe42ae    lhax r31,r30,r8             
100282e0  480000a0    b 0x10028380                   ; -> 10028380
100282e4  7fe90734    extsh r9,r31                
100282e8  1d290018    mulli r9,r9,0x18            
100282ec  7c7e482e    lwzx r3,r30,r9              
100282f0  7fe80734    extsh r8,r31                
100282f4  7fea0734    extsh r10,r31               
100282f8  1d080018    mulli r8,r8,0x18            
100282fc  7fe90734    extsh r9,r31                
10028300  1d4a0018    mulli r10,r10,0x18          
10028304  7feb0734    extsh r11,r31               
10028308  7fec0734    extsh r12,r31               
1002830c  1d290018    mulli r9,r9,0x18            
10028310  1d6b0018    mulli r11,r11,0x18          
10028314  1d8c0018    mulli r12,r12,0x18          
10028318  394a0004    addi r10,r10,0x4            
1002831c  7c9e52ae    lhax r4,r30,r10             
10028320  396b0006    addi r11,r11,0x6            
10028324  398c0008    addi r12,r12,0x8            
10028328  7cfe402e    lwzx r7,r30,r8              
1002832c  39290004    addi r9,r9,0x4              
10028330  7d1e4aae    lhax r8,r30,r9              
10028334  7cbe5aae    lhax r5,r30,r11             
10028338  7cde62ae    lhax r6,r30,r12             
1002833c  7f89e378    or r9,r28,r28               
10028340  7faaeb78    or r10,r29,r29              
10028344  4bfdc05d    bl 0x100043a0                  ; -> 100043a0
10028348  60000000    ori r0,r0,0x0               
1002834c  7fea0734    extsh r10,r31               
10028350  1d4a0018    mulli r10,r10,0x18          
10028354  7feb0734    extsh r11,r31               
10028358  1d6b0018    mulli r11,r11,0x18          
1002835c  7fec0734    extsh r12,r31               
10028360  1d8c0018    mulli r12,r12,0x18          
10028364  394a0006    addi r10,r10,0x6            
10028368  7f9e532e    sthx r28,r30,r10            
1002836c  396b0008    addi r11,r11,0x8            
10028370  7fbe5b2e    sthx r29,r30,r11            
10028374  7ffbfb78    or r27,r31,r31              
10028378  398c0016    addi r12,r12,0x16           
1002837c  7ffe62ae    lhax r31,r30,r12            
10028380  7fe30734    extsh r3,r31                
10028384  2c03ffff    cmpwi r3,-0x1               
10028388  4082fd00    bne 0x10028088                 ; -> 10028088
1002838c  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10028390  38210060    addi r1,r1,0x60             
10028394  7c0803a6    mtspr LR,r0                 
10028398  bb21ffe4    lmw r25,-0x1c(r1)              ; -> Stack[-0x1c]
1002839c  4e800020    blr                         
