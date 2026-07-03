; FUN_1002e6f8 @ 0x1002e6f8
1002e6f8  7c640734    extsh r4,r3                 
1002e6fc  2c040030    cmpwi r4,0x30               
1002e700  4080000c    bge 0x1002e70c                 ; -> 1002e70c
1002e704  38600000    li r3,0x0                   
1002e708  48000018    b 0x1002e720                   ; -> 1002e720
1002e70c  7c650734    extsh r5,r3                 
1002e710  38a5ffd0    subi r5,r5,0x30             
1002e714  7ca52e70    srawi r5,r5,0x5             
1002e718  7ca50194    addze r5,r5                 
1002e71c  38650001    addi r3,r5,0x1              
1002e720  4e800020    blr                         
