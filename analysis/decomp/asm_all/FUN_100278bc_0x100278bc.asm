; FUN_100278bc @ 0x100278bc
100278bc  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
100278c0  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
100278c4  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
100278c8  3ba261fe    addi r29,r2,0x61fe          
100278cc  3bc262a0    addi r30,r2,0x62a0          
100278d0  a95d0000    lha r10,0x0(r29)            
100278d4  2c0affff    cmpwi r10,-0x1              
100278d8  418200dc    beq 0x100279b4                 ; -> 100279b4
100278dc  a97d0000    lha r11,0x0(r29)            
100278e0  abfd0000    lha r31,0x0(r29)            
100278e4  1d6b0018    mulli r11,r11,0x18          
100278e8  7fea0734    extsh r10,r31               
100278ec  396b0016    addi r11,r11,0x16           
100278f0  1d4a0018    mulli r10,r10,0x18          
100278f4  7d7e5aae    lhax r11,r30,r11            
100278f8  398261fc    addi r12,r2,0x61fc          
100278fc  b17d0000    sth r11,0x0(r29)            
10027900  a98c0000    lha r12,0x0(r12)            
10027904  394a0016    addi r10,r10,0x16           
10027908  7d9e532e    sthx r12,r30,r10            
1002790c  7fec0734    extsh r12,r31               
10027910  7fea0734    extsh r10,r31               
10027914  1d4a0018    mulli r10,r10,0x18          
10027918  396261fc    addi r11,r2,0x61fc          
1002791c  1d8c0018    mulli r12,r12,0x18          
10027920  b3eb0000    sth r31,0x0(r11)            
10027924  7c7e612e    stwx r3,r30,r12             
10027928  394a0004    addi r10,r10,0x4            
1002792c  7feb0734    extsh r11,r31               
10027930  7c9e532e    sthx r4,r30,r10             
10027934  1d6b0018    mulli r11,r11,0x18          
10027938  7fec0734    extsh r12,r31               
1002793c  1d8c0018    mulli r12,r12,0x18          
10027940  7fea0734    extsh r10,r31               
10027944  1d4a0018    mulli r10,r10,0x18          
10027948  396b0006    addi r11,r11,0x6            
1002794c  7cbe5b2e    sthx r5,r30,r11             
10027950  398c0008    addi r12,r12,0x8            
10027954  7cde632e    sthx r6,r30,r12             
10027958  394a000a    addi r10,r10,0xa            
1002795c  7feb0734    extsh r11,r31               
10027960  7cbe532e    sthx r5,r30,r10             
10027964  1d6b0018    mulli r11,r11,0x18          
10027968  7fec0734    extsh r12,r31               
1002796c  1d8c0018    mulli r12,r12,0x18          
10027970  7fea0734    extsh r10,r31               
10027974  1d4a0018    mulli r10,r10,0x18          
10027978  396b000c    addi r11,r11,0xc            
1002797c  7cde5b2e    sthx r6,r30,r11             
10027980  398c000e    addi r12,r12,0xe            
10027984  7cfe632e    sthx r7,r30,r12             
10027988  394a0010    addi r10,r10,0x10           
1002798c  7d1e532e    sthx r8,r30,r10             
10027990  7feb0734    extsh r11,r31               
10027994  1d6b0018    mulli r11,r11,0x18          
10027998  7fea0734    extsh r10,r31               
1002799c  1d4a0018    mulli r10,r10,0x18          
100279a0  396b0012    addi r11,r11,0x12           
100279a4  7d3e59ae    stbx r9,r30,r11             
100279a8  39800000    li r12,0x0                  
100279ac  394a0014    addi r10,r10,0x14           
100279b0  7d9e532e    sthx r12,r30,r10            
100279b4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100279b8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100279bc  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100279c0  4e800020    blr                         
