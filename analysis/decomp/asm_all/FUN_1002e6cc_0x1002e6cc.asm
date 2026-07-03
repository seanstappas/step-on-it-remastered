; FUN_1002e6cc @ 0x1002e6cc
1002e6cc  7c640734    extsh r4,r3                 
1002e6d0  2c040010    cmpwi r4,0x10               
1002e6d4  4080000c    bge 0x1002e6e0                 ; -> 1002e6e0
1002e6d8  38600000    li r3,0x0                   
1002e6dc  48000018    b 0x1002e6f4                   ; -> 1002e6f4
1002e6e0  7c650734    extsh r5,r3                 
1002e6e4  38a5fff0    subi r5,r5,0x10             
1002e6e8  7ca52e70    srawi r5,r5,0x5             
1002e6ec  7ca50194    addze r5,r5                 
1002e6f0  38650001    addi r3,r5,0x1              
1002e6f4  4e800020    blr                         
