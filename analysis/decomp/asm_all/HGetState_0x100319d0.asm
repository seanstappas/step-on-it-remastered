; HGetState @ 0x100319d0
100319d0  8182f910    lwz r12,-0x6f0(r2)             ; -> 10033a80
100319d4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100319d8  800c0000    lwz r0,0x0(r12)             
100319dc  804c0004    lwz r2,0x4(r12)             
100319e0  7c0903a6    mtspr CTR,r0                
100319e4  4e800420    bctr                        
