; FUN_10003774 @ 0x10003774
10003774  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10003778  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1000377c  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10003780  54642834    rlwinm r4,r3,0x5,0x0,0x1a   
10003784  7c9f0e70    srawi r31,r4,0x1            
10003788  3ba00000    li r29,0x0                  
1000378c  7fff0194    addze r31,r31               
10003790  48000034    b 0x100037c4                   ; -> 100037c4
10003794  5465502a    rlwinm r5,r3,0xa,0x0,0x15   
10003798  7fc5fb96    divwu r30,r5,r31            
1000379c  7c1ef840    cmplw r30,r31               
100037a0  4180000c    blt 0x100037ac                 ; -> 100037ac
100037a4  3ba00001    li r29,0x1                  
100037a8  4800001c    b 0x100037c4                   ; -> 100037c4
100037ac  7cdff214    add r6,r31,r30              
100037b0  54dff87e    rlwinm r31,r6,0x1f,0x1,0x1f 
100037b4  281f0010    cmplwi r31,0x10             
100037b8  4080000c    bge 0x100037c4                 ; -> 100037c4
100037bc  38600020    li r3,0x20                  
100037c0  48000014    b 0x100037d4                   ; -> 100037d4
100037c4  57a7063e    rlwinm r7,r29,0x0,0x18,0x1f 
100037c8  28070000    cmplwi r7,0x0               
100037cc  4182ffc8    beq 0x10003794                 ; -> 10003794
100037d0  7fe3fb78    or r3,r31,r31               
100037d4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100037d8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100037dc  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100037e0  4e800020    blr                         
