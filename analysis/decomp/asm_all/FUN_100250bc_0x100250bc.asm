; FUN_100250bc @ 0x100250bc
100250bc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100250c0  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100250c4  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
100250c8  3ba26140    addi r29,r2,0x6140          
100250cc  3bc00000    li r30,0x0                  
100250d0  3be00001    li r31,0x1                  
100250d4  480000e4    b 0x100251b8                   ; -> 100251b8
100250d8  7fe50734    extsh r5,r31                
100250dc  1ca5001c    mulli r5,r5,0x1c            
100250e0  7cbd282e    lwzx r5,r29,r5              
100250e4  7c640734    extsh r4,r3                 
100250e8  7c042800    cmpw r4,r5                  
100250ec  40820008    bne 0x100250f4                 ; -> 100250f4
100250f0  3bde0001    addi r30,r30,0x1            
100250f4  7fe70734    extsh r7,r31                
100250f8  1ce7001c    mulli r7,r7,0x1c            
100250fc  38e70004    addi r7,r7,0x4              
10025100  7cfd382e    lwzx r7,r29,r7              
10025104  7c660734    extsh r6,r3                 
10025108  7c063800    cmpw r6,r7                  
1002510c  40820008    bne 0x10025114                 ; -> 10025114
10025110  3bde0001    addi r30,r30,0x1            
10025114  7fe90734    extsh r9,r31                
10025118  1d29001c    mulli r9,r9,0x1c            
1002511c  39290008    addi r9,r9,0x8              
10025120  7d3d482e    lwzx r9,r29,r9              
10025124  7c680734    extsh r8,r3                 
10025128  7c084800    cmpw r8,r9                  
1002512c  40820008    bne 0x10025134                 ; -> 10025134
10025130  3bde0001    addi r30,r30,0x1            
10025134  7feb0734    extsh r11,r31               
10025138  1d6b001c    mulli r11,r11,0x1c          
1002513c  396b000c    addi r11,r11,0xc            
10025140  7d7d582e    lwzx r11,r29,r11            
10025144  7c6a0734    extsh r10,r3                
10025148  7c0a5800    cmpw r10,r11                
1002514c  40820008    bne 0x10025154                 ; -> 10025154
10025150  3bde0001    addi r30,r30,0x1            
10025154  7fe40734    extsh r4,r31                
10025158  1c84001c    mulli r4,r4,0x1c            
1002515c  38840010    addi r4,r4,0x10             
10025160  7c9d202e    lwzx r4,r29,r4              
10025164  7c6c0734    extsh r12,r3                
10025168  7c0c2000    cmpw r12,r4                 
1002516c  40820008    bne 0x10025174                 ; -> 10025174
10025170  3bde0001    addi r30,r30,0x1            
10025174  7fe60734    extsh r6,r31                
10025178  1cc6001c    mulli r6,r6,0x1c            
1002517c  38c60014    addi r6,r6,0x14             
10025180  7cdd302e    lwzx r6,r29,r6              
10025184  7c650734    extsh r5,r3                 
10025188  7c053000    cmpw r5,r6                  
1002518c  40820008    bne 0x10025194                 ; -> 10025194
10025190  3bde0001    addi r30,r30,0x1            
10025194  7fe80734    extsh r8,r31                
10025198  1d08001c    mulli r8,r8,0x1c            
1002519c  39080018    addi r8,r8,0x18             
100251a0  7d1d402e    lwzx r8,r29,r8              
100251a4  7c670734    extsh r7,r3                 
100251a8  7c074000    cmpw r7,r8                  
100251ac  40820008    bne 0x100251b4                 ; -> 100251b4
100251b0  3bde0001    addi r30,r30,0x1            
100251b4  3bff0001    addi r31,r31,0x1            
100251b8  7fe90734    extsh r9,r31                
100251bc  2c090002    cmpwi r9,0x2                
100251c0  4081ff18    ble 0x100250d8                 ; -> 100250d8
100251c4  7fc3f378    or r3,r30,r30               
100251c8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100251cc  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100251d0  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100251d4  4e800020    blr                         
