; FUN_1001eef4 @ 0x1001eef4
1001eef4  7c640734    extsh r4,r3                 
1001eef8  54840528    rlwinm r4,r4,0x0,0x14,0x14  
1001eefc  2c040000    cmpwi r4,0x0                
1001ef00  4082000c    bne 0x1001ef0c                 ; -> 1001ef0c
1001ef04  38600000    li r3,0x0                   
1001ef08  48000008    b 0x1001ef10                   ; -> 1001ef10
1001ef0c  38600001    li r3,0x1                   
1001ef10  4e800020    blr                         
