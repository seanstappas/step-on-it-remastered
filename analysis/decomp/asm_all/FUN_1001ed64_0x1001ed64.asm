; FUN_1001ed64 @ 0x1001ed64
1001ed64  28030000    cmplwi r3,0x0               
1001ed68  4082000c    bne 0x1001ed74                 ; -> 1001ed74
1001ed6c  38600000    li r3,0x0                   
1001ed70  48000014    b 0x1001ed84                   ; -> 1001ed84
1001ed74  a883006c    lha r4,0x6c(r3)             
1001ed78  2c040000    cmpwi r4,0x0                
1001ed7c  7ca00026    mfcr r5                     
1001ed80  54a30ffe    rlwinm r3,r5,0x1,0x1f,0x1f  
1001ed84  4e800020    blr                         
