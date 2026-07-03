; FUN_1001ed88 @ 0x1001ed88
1001ed88  28030000    cmplwi r3,0x0               
1001ed8c  4082000c    bne 0x1001ed98                 ; -> 1001ed98
1001ed90  38600000    li r3,0x0                   
1001ed94  48000014    b 0x1001eda8                   ; -> 1001eda8
1001ed98  a883006c    lha r4,0x6c(r3)             
1001ed9c  2c040002    cmpwi r4,0x2                
1001eda0  7ca00026    mfcr r5                     
1001eda4  54a31ffe    rlwinm r3,r5,0x3,0x1f,0x1f  
1001eda8  4e800020    blr                         
