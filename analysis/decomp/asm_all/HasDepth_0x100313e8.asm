; HasDepth @ 0x100313e8
100313e8  8182f740    lwz r12,-0x8c0(r2)             ; -> 100338b0
100313ec  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100313f0  800c0000    lwz r0,0x0(r12)             
100313f4  804c0004    lwz r2,0x4(r12)             
100313f8  7c0903a6    mtspr CTR,r0                
100313fc  4e800420    bctr                        
