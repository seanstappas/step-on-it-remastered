; DisposeWindow @ 0x10032630
10032630  8182f8e4    lwz r12,-0x71c(r2)             ; -> 10033a54
10032634  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032638  800c0000    lwz r0,0x0(r12)             
1003263c  804c0004    lwz r2,0x4(r12)             
10032640  7c0903a6    mtspr CTR,r0                
10032644  4e800420    bctr                        
