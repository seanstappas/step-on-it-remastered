; FUN_100251d8 @ 0x100251d8
100251d8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100251dc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100251e0  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
100251e4  3882523f    addi r4,r2,0x523f           
100251e8  38600001    li r3,0x1                   
100251ec  3ba26996    addi r29,r2,0x6996          
100251f0  3bc26140    addi r30,r2,0x6140          
100251f4  98640000    stb r3,0x0(r4)              
100251f8  3be00001    li r31,0x1                  
100251fc  480000e0    b 0x100252dc                   ; -> 100252dc
10025200  7fe50734    extsh r5,r31                
10025204  1ca5001c    mulli r5,r5,0x1c            
10025208  7fe60734    extsh r6,r31                
1002520c  7fe70734    extsh r7,r31                
10025210  1ce7001c    mulli r7,r7,0x1c            
10025214  7fe80734    extsh r8,r31                
10025218  1d08001c    mulli r8,r8,0x1c            
1002521c  7fe90734    extsh r9,r31                
10025220  1d29001c    mulli r9,r9,0x1c            
10025224  7fea0734    extsh r10,r31               
10025228  1d4a001c    mulli r10,r10,0x1c          
1002522c  7feb0734    extsh r11,r31               
10025230  1d6b001c    mulli r11,r11,0x1c          
10025234  7fec0734    extsh r12,r31               
10025238  1d8c001c    mulli r12,r12,0x1c          
1002523c  7fe30734    extsh r3,r31                
10025240  1c63001c    mulli r3,r3,0x1c            
10025244  7fe40734    extsh r4,r31                
10025248  1c84001c    mulli r4,r4,0x1c            
1002524c  1cc6001c    mulli r6,r6,0x1c            
10025250  7cbe282e    lwzx r5,r30,r5              
10025254  38e70004    addi r7,r7,0x4              
10025258  7cbd312e    stwx r5,r29,r6              
1002525c  7fe50734    extsh r5,r31                
10025260  1ca5001c    mulli r5,r5,0x1c            
10025264  7fe60734    extsh r6,r31                
10025268  1cc6001c    mulli r6,r6,0x1c            
1002526c  7cfe382e    lwzx r7,r30,r7              
10025270  39080004    addi r8,r8,0x4              
10025274  7cfd412e    stwx r7,r29,r8              
10025278  39290008    addi r9,r9,0x8              
1002527c  7fe70734    extsh r7,r31                
10025280  7fe80734    extsh r8,r31                
10025284  1ce7001c    mulli r7,r7,0x1c            
10025288  1d08001c    mulli r8,r8,0x1c            
1002528c  7d3e482e    lwzx r9,r30,r9              
10025290  394a0008    addi r10,r10,0x8            
10025294  7d3d512e    stwx r9,r29,r10             
10025298  396b000c    addi r11,r11,0xc            
1002529c  7d7e582e    lwzx r11,r30,r11            
100252a0  398c000c    addi r12,r12,0xc            
100252a4  7d7d612e    stwx r11,r29,r12            
100252a8  38630010    addi r3,r3,0x10             
100252ac  7c7e182e    lwzx r3,r30,r3              
100252b0  38840010    addi r4,r4,0x10             
100252b4  7c7d212e    stwx r3,r29,r4              
100252b8  38a50014    addi r5,r5,0x14             
100252bc  7cbe282e    lwzx r5,r30,r5              
100252c0  38c60014    addi r6,r6,0x14             
100252c4  7cbd312e    stwx r5,r29,r6              
100252c8  38e70018    addi r7,r7,0x18             
100252cc  7cfe382e    lwzx r7,r30,r7              
100252d0  39080018    addi r8,r8,0x18             
100252d4  7cfd412e    stwx r7,r29,r8              
100252d8  3bff0001    addi r31,r31,0x1            
100252dc  7fe90734    extsh r9,r31                
100252e0  2c090003    cmpwi r9,0x3                
100252e4  4180ff1c    blt 0x10025200                 ; -> 10025200
100252e8  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100252ec  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100252f0  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100252f4  4e800020    blr                         
