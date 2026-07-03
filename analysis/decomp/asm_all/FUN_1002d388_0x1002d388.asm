; FUN_1002d388 @ 0x1002d388
1002d388  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1002d38c  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1002d390  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
1002d394  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
1002d398  7c7e4670    srawi r30,r3,0x8            
1002d39c  7fde0194    addze r30,r30               
1002d3a0  7fc40734    extsh r4,r30                
1002d3a4  7c9d2e70    srawi r29,r4,0x5            
1002d3a8  7fbd0194    addze r29,r29               
1002d3ac  7fc50734    extsh r5,r30                
1002d3b0  7cbf2e70    srawi r31,r5,0x5            
1002d3b4  7fff0194    addze r31,r31               
1002d3b8  57ff2834    rlwinm r31,r31,0x5,0x0,0x1a 
1002d3bc  7fff2810    subfc r31,r31,r5            
1002d3c0  7fe80734    extsh r8,r31                
1002d3c4  7d081e70    srawi r8,r8,0x3             
1002d3c8  7d080194    addze r8,r8                 
1002d3cc  55082036    rlwinm r8,r8,0x4,0x0,0x1b   
1002d3d0  3922758c    addi r9,r2,0x758c           
1002d3d4  57aa103a    rlwinm r10,r29,0x2,0x0,0x1d 
1002d3d8  7fe70734    extsh r7,r31                
1002d3dc  39080007    addi r8,r8,0x7              
1002d3e0  3cc08000    lis r6,-0x8000              
1002d3e4  7ce74050    subf r7,r7,r8               
1002d3e8  7d29502e    lwzx r9,r9,r10              
1002d3ec  7cdc3c30    srw r28,r6,r7               
1002d3f0  7f894838    and r9,r28,r9               
1002d3f4  28090000    cmplwi r9,0x0               
1002d3f8  4182000c    beq 0x1002d404                 ; -> 1002d404
1002d3fc  38600001    li r3,0x1                   
1002d400  48000008    b 0x1002d408                   ; -> 1002d408
1002d404  38600000    li r3,0x0                   
1002d408  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1002d40c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1002d410  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
1002d414  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
1002d418  4e800020    blr                         
