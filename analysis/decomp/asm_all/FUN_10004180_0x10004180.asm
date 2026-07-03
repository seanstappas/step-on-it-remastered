; FUN_10004180 @ 0x10004180
10004180  7c0802a6    mfspr r0,LR                 
10004184  bec1ffd8    stmw r22,-0x28(r1)             ; -> Stack[-0x28]
10004188  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1000418c  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10004190  3bc23432    addi r30,r2,0x3432          
10004194  3b823430    addi r28,r2,0x3430          
10004198  3ac270e4    addi r22,r2,0x70e4          
1000419c  3ae270e8    addi r23,r2,0x70e8          
100041a0  3b026bd8    addi r24,r2,0x6bd8          
100041a4  3b226bdc    addi r25,r2,0x6bdc          
100041a8  3ba2342e    addi r29,r2,0x342e          
100041ac  3b426bd0    addi r26,r2,0x6bd0          
100041b0  3b626bd4    addi r27,r2,0x6bd4          
100041b4  3be00001    li r31,0x1                  
100041b8  480001bc    b 0x10004374                   ; -> 10004374
100041bc  7fe30734    extsh r3,r31                
100041c0  1c63000c    mulli r3,r3,0xc             
100041c4  7c7e1aae    lhax r3,r30,r3              
100041c8  2c030001    cmpwi r3,0x1                
100041cc  40820104    bne 0x100042d0                 ; -> 100042d0
100041d0  7fe40734    extsh r4,r31                
100041d4  1c84000c    mulli r4,r4,0xc             
100041d8  7fe50734    extsh r5,r31                
100041dc  1ca5000c    mulli r5,r5,0xc             
100041e0  7fe60734    extsh r6,r31                
100041e4  1cc6000c    mulli r6,r6,0xc             
100041e8  38840002    addi r4,r4,0x2              
100041ec  7fe70734    extsh r7,r31                
100041f0  1ce7000c    mulli r7,r7,0xc             
100041f4  7c7e202e    lwzx r3,r30,r4              
100041f8  38a50006    addi r5,r5,0x6              
100041fc  7c9e2aae    lhax r4,r30,r5              
10004200  38c60008    addi r6,r6,0x8              
10004204  7cbe32ae    lhax r5,r30,r6              
10004208  38e7000a    addi r7,r7,0xa              
1000420c  7cde3aae    lhax r6,r30,r7              
10004210  a91a0000    lha r8,0x0(r26)             
10004214  80fb0000    lwz r7,0x0(r27)             
10004218  4bffd745    bl 0x1000195c                  ; -> 1000195c
1000421c  60000000    ori r0,r0,0x0               
10004220  7fe80734    extsh r8,r31                
10004224  1d08000c    mulli r8,r8,0xc             
10004228  7fe90734    extsh r9,r31                
1000422c  7fea0734    extsh r10,r31               
10004230  7feb0734    extsh r11,r31               
10004234  1d29000c    mulli r9,r9,0xc             
10004238  1d4a000c    mulli r10,r10,0xc           
1000423c  1d6b000c    mulli r11,r11,0xc           
10004240  39080002    addi r8,r8,0x2              
10004244  7c7e402e    lwzx r3,r30,r8              
10004248  39290006    addi r9,r9,0x6              
1000424c  394a0008    addi r10,r10,0x8            
10004250  396b000a    addi r11,r11,0xa            
10004254  7c9e4aae    lhax r4,r30,r9              
10004258  7cbe52ae    lhax r5,r30,r10             
1000425c  7cde5aae    lhax r6,r30,r11             
10004260  80f70000    lwz r7,0x0(r23)             
10004264  81160000    lwz r8,0x0(r22)             
10004268  4bffd6f5    bl 0x1000195c                  ; -> 1000195c
1000426c  60000000    ori r0,r0,0x0               
10004270  899d0000    lbz r12,0x0(r29)            
10004274  280c0000    cmplwi r12,0x0              
10004278  418200f8    beq 0x10004370                 ; -> 10004370
1000427c  7fe40734    extsh r4,r31                
10004280  1c84000c    mulli r4,r4,0xc             
10004284  7fe50734    extsh r5,r31                
10004288  1ca5000c    mulli r5,r5,0xc             
1000428c  7fe60734    extsh r6,r31                
10004290  1cc6000c    mulli r6,r6,0xc             
10004294  38840002    addi r4,r4,0x2              
10004298  7fe70734    extsh r7,r31                
1000429c  1ce7000c    mulli r7,r7,0xc             
100042a0  7c7e202e    lwzx r3,r30,r4              
100042a4  38a50006    addi r5,r5,0x6              
100042a8  7c9e2aae    lhax r4,r30,r5              
100042ac  38c60008    addi r6,r6,0x8              
100042b0  7cbe32ae    lhax r5,r30,r6              
100042b4  38e7000a    addi r7,r7,0xa              
100042b8  7cde3aae    lhax r6,r30,r7              
100042bc  81180000    lwz r8,0x0(r24)             
100042c0  80f90000    lwz r7,0x0(r25)             
100042c4  4bffd699    bl 0x1000195c                  ; -> 1000195c
100042c8  60000000    ori r0,r0,0x0               
100042cc  480000a4    b 0x10004370                   ; -> 10004370
100042d0  891d0000    lbz r8,0x0(r29)             
100042d4  28080000    cmplwi r8,0x0               
100042d8  41820050    beq 0x10004328                 ; -> 10004328
100042dc  7fe90734    extsh r9,r31                
100042e0  7fea0734    extsh r10,r31               
100042e4  7feb0734    extsh r11,r31               
100042e8  7fec0734    extsh r12,r31               
100042ec  1d29000c    mulli r9,r9,0xc             
100042f0  1d4a000c    mulli r10,r10,0xc           
100042f4  1d6b000c    mulli r11,r11,0xc           
100042f8  1d8c000c    mulli r12,r12,0xc           
100042fc  39290002    addi r9,r9,0x2              
10004300  394a0006    addi r10,r10,0x6            
10004304  396b0008    addi r11,r11,0x8            
10004308  398c000a    addi r12,r12,0xa            
1000430c  7c7e482e    lwzx r3,r30,r9              
10004310  7c9e52ae    lhax r4,r30,r10             
10004314  7cbe5aae    lhax r5,r30,r11             
10004318  7cde62ae    lhax r6,r30,r12             
1000431c  4bffd409    bl 0x10001724                  ; -> 10001724
10004320  60000000    ori r0,r0,0x0               
10004324  4800004c    b 0x10004370                   ; -> 10004370
10004328  7fe40734    extsh r4,r31                
1000432c  1c84000c    mulli r4,r4,0xc             
10004330  7fe50734    extsh r5,r31                
10004334  1ca5000c    mulli r5,r5,0xc             
10004338  7fe60734    extsh r6,r31                
1000433c  1cc6000c    mulli r6,r6,0xc             
10004340  38840002    addi r4,r4,0x2              
10004344  7fe70734    extsh r7,r31                
10004348  1ce7000c    mulli r7,r7,0xc             
1000434c  7c7e202e    lwzx r3,r30,r4              
10004350  38a50006    addi r5,r5,0x6              
10004354  7c9e2aae    lhax r4,r30,r5              
10004358  38c60008    addi r6,r6,0x8              
1000435c  7cbe32ae    lhax r5,r30,r6              
10004360  38e7000a    addi r7,r7,0xa              
10004364  7cde3aae    lhax r6,r30,r7              
10004368  4bffd259    bl 0x100015c0                  ; -> 100015c0
1000436c  60000000    ori r0,r0,0x0               
10004370  3bff0001    addi r31,r31,0x1            
10004374  a93c0000    lha r9,0x0(r28)             
10004378  7fe80734    extsh r8,r31                
1000437c  7c084800    cmpw r8,r9                  
10004380  4081fe3c    ble 0x100041bc                 ; -> 100041bc
10004384  39400000    li r10,0x0                  
10004388  b15c0000    sth r10,0x0(r28)            
1000438c  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10004390  38210060    addi r1,r1,0x60             
10004394  7c0803a6    mtspr LR,r0                 
10004398  bac1ffd8    lmw r22,-0x28(r1)              ; -> Stack[-0x28]
1000439c  4e800020    blr                         
