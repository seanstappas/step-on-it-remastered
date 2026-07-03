; FUN_10019f70 @ 0x10019f70
10019f70  be01ffc0    stmw r16,-0x40(r1)             ; -> Stack[-0x40]
10019f74  7c880734    extsh r8,r4                 
10019f78  2c080000    cmpwi r8,0x0                
10019f7c  40820040    bne 0x10019fbc                 ; -> 10019fbc
10019f80  3ee08081    lis r23,-0x7f7f             
10019f84  3af78080    subi r23,r23,0x7f80         
10019f88  7cd53378    or r21,r6,r6                
10019f8c  3ac00000    li r22,0x0                  
10019f90  48000018    b 0x10019fa8                   ; -> 10019fa8
10019f94  92f50000    stw r23,0x0(r21)            
10019f98  3ab50004    addi r21,r21,0x4            
10019f9c  92f50000    stw r23,0x0(r21)            
10019fa0  3ab50004    addi r21,r21,0x4            
10019fa4  3ad60001    addi r22,r22,0x1            
10019fa8  7ec90734    extsh r9,r22                
10019fac  7c6a0734    extsh r10,r3                
10019fb0  7c095000    cmpw r9,r10                 
10019fb4  4180ffe0    blt 0x10019f94                 ; -> 10019f94
10019fb8  48000308    b 0x1001a2c0                   ; -> 1001a2c0
10019fbc  7c8b0734    extsh r11,r4                
10019fc0  2c0b0001    cmpwi r11,0x1               
10019fc4  4082007c    bne 0x1001a040                 ; -> 1001a040
10019fc8  81050000    lwz r8,0x0(r5)              
10019fcc  7c690734    extsh r9,r3                 
10019fd0  39800180    li r12,0x180                
10019fd4  5529103a    rlwinm r9,r9,0x2,0x0,0x1d   
10019fd8  b181ffb0    sth r12,-0x50(r1)              ; -> Stack[-0x50]
10019fdc  9101ffa6    stw r8,-0x5a(r1)               ; -> Stack[-0x5a]
10019fe0  90e1ffaa    stw r7,-0x56(r1)               ; -> Stack[-0x56]
10019fe4  7cd33378    or r19,r6,r6                
10019fe8  b121ffae    sth r9,-0x52(r1)               ; -> Stack[-0x52]
10019fec  3a800000    li r20,0x0                  
10019ff0  4800003c    b 0x1001a02c                   ; -> 1001a02c
10019ff4  8141ffa6    lwz r10,-0x5a(r1)              ; -> Stack[-0x5a]
10019ff8  ab81ffb0    lha r28,-0x50(r1)              ; -> Stack[-0x50]
10019ffc  7d4b5378    or r11,r10,r10              
1001a000  896b0000    lbz r11,0x0(r11)            
1001a004  394a0001    addi r10,r10,0x1            
1001a008  7f9c5a14    add r28,r28,r11             
1001a00c  7f8c0734    extsh r12,r28               
1001a010  7f6760ae    lbzx r27,r7,r12             
1001a014  9141ffa6    stw r10,-0x5a(r1)              ; -> Stack[-0x5a]
1001a018  9b730000    stb r27,0x0(r19)            
1001a01c  3a730001    addi r19,r19,0x1            
1001a020  9b730000    stb r27,0x0(r19)            
1001a024  3a730001    addi r19,r19,0x1            
1001a028  3a940001    addi r20,r20,0x1            
1001a02c  a921ffae    lha r9,-0x52(r1)               ; -> Stack[-0x52]
1001a030  7e880734    extsh r8,r20                
1001a034  7c084800    cmpw r8,r9                  
1001a038  4180ffbc    blt 0x10019ff4                 ; -> 10019ff4
1001a03c  48000284    b 0x1001a2c0                   ; -> 1001a2c0
1001a040  7c8a0734    extsh r10,r4                
1001a044  2c0a0002    cmpwi r10,0x2               
1001a048  4082009c    bne 0x1001a0e4                 ; -> 1001a0e4
1001a04c  81850000    lwz r12,0x0(r5)             
1001a050  81050004    lwz r8,0x4(r5)              
1001a054  7c690734    extsh r9,r3                 
1001a058  39600100    li r11,0x100                
1001a05c  5529103a    rlwinm r9,r9,0x2,0x0,0x1d   
1001a060  b161ffa4    sth r11,-0x5c(r1)              ; -> Stack[-0x5c]
1001a064  9181ff9a    stw r12,-0x66(r1)              ; -> Stack[-0x66]
1001a068  9101ff96    stw r8,-0x6a(r1)               ; -> Stack[-0x6a]
1001a06c  90e1ff9e    stw r7,-0x62(r1)               ; -> Stack[-0x62]
1001a070  7cd13378    or r17,r6,r6                
1001a074  b121ffa2    sth r9,-0x5e(r1)               ; -> Stack[-0x5e]
1001a078  3a400000    li r18,0x0                  
1001a07c  48000054    b 0x1001a0d0                   ; -> 1001a0d0
1001a080  8141ff9a    lwz r10,-0x66(r1)              ; -> Stack[-0x66]
1001a084  8181ff96    lwz r12,-0x6a(r1)              ; -> Stack[-0x6a]
1001a088  7d4b5378    or r11,r10,r10              
1001a08c  7d886378    or r8,r12,r12               
1001a090  394a0001    addi r10,r10,0x1            
1001a094  398c0001    addi r12,r12,0x1            
1001a098  aba1ffa4    lha r29,-0x5c(r1)              ; -> Stack[-0x5c]
1001a09c  896b0000    lbz r11,0x0(r11)            
1001a0a0  89080000    lbz r8,0x0(r8)              
1001a0a4  7fbd5a14    add r29,r29,r11             
1001a0a8  7fbd4214    add r29,r29,r8              
1001a0ac  7fa90734    extsh r9,r29                
1001a0b0  7f4748ae    lbzx r26,r7,r9              
1001a0b4  9141ff9a    stw r10,-0x66(r1)              ; -> Stack[-0x66]
1001a0b8  9b510000    stb r26,0x0(r17)            
1001a0bc  3a310001    addi r17,r17,0x1            
1001a0c0  9b510000    stb r26,0x0(r17)            
1001a0c4  9181ff96    stw r12,-0x6a(r1)              ; -> Stack[-0x6a]
1001a0c8  3a310001    addi r17,r17,0x1            
1001a0cc  3a520001    addi r18,r18,0x1            
1001a0d0  a961ffa2    lha r11,-0x5e(r1)              ; -> Stack[-0x5e]
1001a0d4  7e4a0734    extsh r10,r18               
1001a0d8  7c0a5800    cmpw r10,r11                
1001a0dc  4180ffa4    blt 0x1001a080                 ; -> 1001a080
1001a0e0  480001e0    b 0x1001a2c0                   ; -> 1001a2c0
1001a0e4  7c8c0734    extsh r12,r4                
1001a0e8  2c0c0003    cmpwi r12,0x3               
1001a0ec  408200d4    bne 0x1001a1c0                 ; -> 1001a1c0
1001a0f0  81250000    lwz r9,0x0(r5)              
1001a0f4  81450004    lwz r10,0x4(r5)             
1001a0f8  81650008    lwz r11,0x8(r5)             
1001a0fc  7c6c0734    extsh r12,r3                
1001a100  39000080    li r8,0x80                  
1001a104  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
1001a108  b101ff94    sth r8,-0x6c(r1)               ; -> Stack[-0x6c]
1001a10c  9121ff8a    stw r9,-0x76(r1)               ; -> Stack[-0x76]
1001a110  9141ff86    stw r10,-0x7a(r1)              ; -> Stack[-0x7a]
1001a114  9161ff82    stw r11,-0x7e(r1)              ; -> Stack[-0x7e]
1001a118  90e1ff8e    stw r7,-0x72(r1)               ; -> Stack[-0x72]
1001a11c  90c1ff7e    stw r6,-0x82(r1)               ; -> Stack[-0x82]
1001a120  b181ff92    sth r12,-0x6e(r1)              ; -> Stack[-0x6e]
1001a124  3a000000    li r16,0x0                  
1001a128  48000084    b 0x1001a1ac                   ; -> 1001a1ac
1001a12c  8101ff8a    lwz r8,-0x76(r1)               ; -> Stack[-0x76]
1001a130  8141ff86    lwz r10,-0x7a(r1)              ; -> Stack[-0x7a]
1001a134  7d094378    or r9,r8,r8                 
1001a138  7d4b5378    or r11,r10,r10              
1001a13c  394a0001    addi r10,r10,0x1            
1001a140  39080001    addi r8,r8,0x1              
1001a144  9141ff86    stw r10,-0x7a(r1)              ; -> Stack[-0x7a]
1001a148  abe1ff94    lha r31,-0x6c(r1)              ; -> Stack[-0x6c]
1001a14c  89290000    lbz r9,0x0(r9)              
1001a150  896b0000    lbz r11,0x0(r11)            
1001a154  7fff4a14    add r31,r31,r9              
1001a158  8181ff82    lwz r12,-0x7e(r1)              ; -> Stack[-0x7e]
1001a15c  9101ff8a    stw r8,-0x76(r1)               ; -> Stack[-0x76]
1001a160  7d886378    or r8,r12,r12               
1001a164  398c0001    addi r12,r12,0x1            
1001a168  8141ff7e    lwz r10,-0x82(r1)              ; -> Stack[-0x82]
1001a16c  7fff5a14    add r31,r31,r11             
1001a170  89080000    lbz r8,0x0(r8)              
1001a174  7d4b5378    or r11,r10,r10              
1001a178  394a0001    addi r10,r10,0x1            
1001a17c  7fff4214    add r31,r31,r8              
1001a180  7fe90734    extsh r9,r31                
1001a184  7f2748ae    lbzx r25,r7,r9              
1001a188  9181ff82    stw r12,-0x7e(r1)              ; -> Stack[-0x7e]
1001a18c  9141ff7e    stw r10,-0x82(r1)              ; -> Stack[-0x82]
1001a190  8181ff7e    lwz r12,-0x82(r1)              ; -> Stack[-0x82]
1001a194  9b2b0000    stb r25,0x0(r11)            
1001a198  7d886378    or r8,r12,r12               
1001a19c  398c0001    addi r12,r12,0x1            
1001a1a0  9181ff7e    stw r12,-0x82(r1)              ; -> Stack[-0x82]
1001a1a4  9b280000    stb r25,0x0(r8)             
1001a1a8  3a100001    addi r16,r16,0x1            
1001a1ac  a941ff92    lha r10,-0x6e(r1)              ; -> Stack[-0x6e]
1001a1b0  7e090734    extsh r9,r16                
1001a1b4  7c095000    cmpw r9,r10                 
1001a1b8  4180ff74    blt 0x1001a12c                 ; -> 1001a12c
1001a1bc  48000104    b 0x1001a2c0                   ; -> 1001a2c0
1001a1c0  7c8b0734    extsh r11,r4                
1001a1c4  2c0b0004    cmpwi r11,0x4               
1001a1c8  408200f8    bne 0x1001a2c0                 ; -> 1001a2c0
1001a1cc  39800000    li r12,0x0                  
1001a1d0  81050000    lwz r8,0x0(r5)              
1001a1d4  b181ff7c    sth r12,-0x84(r1)              ; -> Stack[-0x84]
1001a1d8  9101ff70    stw r8,-0x90(r1)               ; -> Stack[-0x90]
1001a1dc  81250004    lwz r9,0x4(r5)              
1001a1e0  81450008    lwz r10,0x8(r5)             
1001a1e4  8165000c    lwz r11,0xc(r5)             
1001a1e8  7c6c0734    extsh r12,r3                
1001a1ec  558c103a    rlwinm r12,r12,0x2,0x0,0x1d 
1001a1f0  39000000    li r8,0x0                   
1001a1f4  9121ff6c    stw r9,-0x94(r1)               ; -> Stack[-0x94]
1001a1f8  9141ff68    stw r10,-0x98(r1)              ; -> Stack[-0x98]
1001a1fc  9161ff64    stw r11,-0x9c(r1)              ; -> Stack[-0x9c]
1001a200  90e1ff74    stw r7,-0x8c(r1)               ; -> Stack[-0x8c]
1001a204  90c1ff60    stw r6,-0xa0(r1)               ; -> Stack[-0xa0]
1001a208  b181ff78    sth r12,-0x88(r1)              ; -> Stack[-0x88]
1001a20c  b101ff7a    sth r8,-0x86(r1)               ; -> Stack[-0x86]
1001a210  4800009c    b 0x1001a2ac                   ; -> 1001a2ac
1001a214  8121ff70    lwz r9,-0x90(r1)               ; -> Stack[-0x90]
1001a218  8161ff6c    lwz r11,-0x94(r1)              ; -> Stack[-0x94]
1001a21c  7d2a4b78    or r10,r9,r9                
1001a220  7d6c5b78    or r12,r11,r11              
1001a224  39290001    addi r9,r9,0x1              
1001a228  8bca0000    lbz r30,0x0(r10)            
1001a22c  396b0001    addi r11,r11,0x1            
1001a230  898c0000    lbz r12,0x0(r12)            
1001a234  8101ff68    lwz r8,-0x98(r1)               ; -> Stack[-0x98]
1001a238  9121ff70    stw r9,-0x90(r1)               ; -> Stack[-0x90]
1001a23c  7d094378    or r9,r8,r8                 
1001a240  39080001    addi r8,r8,0x1              
1001a244  9101ff68    stw r8,-0x98(r1)               ; -> Stack[-0x98]
1001a248  8141ff64    lwz r10,-0x9c(r1)              ; -> Stack[-0x9c]
1001a24c  9161ff6c    stw r11,-0x94(r1)              ; -> Stack[-0x94]
1001a250  7d4b5378    or r11,r10,r10              
1001a254  394a0001    addi r10,r10,0x1            
1001a258  89290000    lbz r9,0x0(r9)              
1001a25c  7fde6214    add r30,r30,r12             
1001a260  896b0000    lbz r11,0x0(r11)            
1001a264  7fde4a14    add r30,r30,r9              
1001a268  8101ff60    lwz r8,-0xa0(r1)               ; -> Stack[-0xa0]
1001a26c  7fde5a14    add r30,r30,r11             
1001a270  7d094378    or r9,r8,r8                 
1001a274  7fcc0734    extsh r12,r30               
1001a278  7f0760ae    lbzx r24,r7,r12             
1001a27c  39080001    addi r8,r8,0x1              
1001a280  a981ff7a    lha r12,-0x86(r1)              ; -> Stack[-0x86]
1001a284  9141ff64    stw r10,-0x9c(r1)              ; -> Stack[-0x9c]
1001a288  9101ff60    stw r8,-0xa0(r1)               ; -> Stack[-0xa0]
1001a28c  8141ff60    lwz r10,-0xa0(r1)              ; -> Stack[-0xa0]
1001a290  398c0001    addi r12,r12,0x1            
1001a294  7d4b5378    or r11,r10,r10              
1001a298  9b090000    stb r24,0x0(r9)             
1001a29c  394a0001    addi r10,r10,0x1            
1001a2a0  9141ff60    stw r10,-0xa0(r1)              ; -> Stack[-0xa0]
1001a2a4  9b0b0000    stb r24,0x0(r11)            
1001a2a8  b181ff7a    sth r12,-0x86(r1)              ; -> Stack[-0x86]
1001a2ac  a901ff7a    lha r8,-0x86(r1)               ; -> Stack[-0x86]
1001a2b0  a921ff78    lha r9,-0x88(r1)               ; -> Stack[-0x88]
1001a2b4  7d080734    extsh r8,r8                 
1001a2b8  7c084800    cmpw r8,r9                  
1001a2bc  4180ff58    blt 0x1001a214                 ; -> 1001a214
1001a2c0  ba01ffc0    lmw r16,-0x40(r1)              ; -> Stack[-0x40]
1001a2c4  4e800020    blr                         
