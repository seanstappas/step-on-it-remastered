; FUN_1002219c @ 0x1002219c
1002219c  38a2535c    addi r5,r2,0x535c           
100221a0  3882535e    addi r4,r2,0x535e           
100221a4  a8c50000    lha r6,0x0(r5)              
100221a8  7cc73378    or r7,r6,r6                 
100221ac  38c60001    addi r6,r6,0x1              
100221b0  7ce70734    extsh r7,r7                 
100221b4  b0c50000    sth r6,0x0(r5)              
100221b8  54e7083c    rlwinm r7,r7,0x1,0x0,0x1e   
100221bc  7c643b2e    sthx r3,r4,r7               
100221c0  4e800020    blr                         
