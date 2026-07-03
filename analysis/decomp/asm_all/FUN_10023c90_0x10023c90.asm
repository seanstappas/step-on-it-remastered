; FUN_10023c90 @ 0x10023c90
10023c90  38a22f84    addi r5,r2,0x2f84           
10023c94  7c640734    extsh r4,r3                 
10023c98  80a50000    lwz r5,0x0(r5)              
10023c9c  7c042800    cmpw r4,r5                  
10023ca0  4082000c    bne 0x10023cac                 ; -> 10023cac
10023ca4  38600000    li r3,0x0                   
10023ca8  48000040    b 0x10023ce8                   ; -> 10023ce8
10023cac  38e22f88    addi r7,r2,0x2f88           
10023cb0  7c660734    extsh r6,r3                 
10023cb4  80e70000    lwz r7,0x0(r7)              
10023cb8  7c063800    cmpw r6,r7                  
10023cbc  4082000c    bne 0x10023cc8                 ; -> 10023cc8
10023cc0  38600000    li r3,0x0                   
10023cc4  48000024    b 0x10023ce8                   ; -> 10023ce8
10023cc8  39222f8c    addi r9,r2,0x2f8c           
10023ccc  7c680734    extsh r8,r3                 
10023cd0  81290000    lwz r9,0x0(r9)              
10023cd4  7c084800    cmpw r8,r9                  
10023cd8  4082000c    bne 0x10023ce4                 ; -> 10023ce4
10023cdc  38600000    li r3,0x0                   
10023ce0  48000008    b 0x10023ce8                   ; -> 10023ce8
10023ce4  38600001    li r3,0x1                   
10023ce8  4e800020    blr                         
