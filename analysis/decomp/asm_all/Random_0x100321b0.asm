; Random @ 0x100321b0
100321b0  8182f6a4    lwz r12,-0x95c(r2)             ; -> 10033814
100321b4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100321b8  800c0000    lwz r0,0x0(r12)             
100321bc  804c0004    lwz r2,0x4(r12)             
100321c0  7c0903a6    mtspr CTR,r0                
100321c4  4e800420    bctr                        
