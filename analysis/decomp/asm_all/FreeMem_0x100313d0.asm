; FreeMem @ 0x100313d0
100313d0  8182f710    lwz r12,-0x8f0(r2)             ; -> 10033880
100313d4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100313d8  800c0000    lwz r0,0x0(r12)             
100313dc  804c0004    lwz r2,0x4(r12)             
100313e0  7c0903a6    mtspr CTR,r0                
100313e4  4e800420    bctr                        
