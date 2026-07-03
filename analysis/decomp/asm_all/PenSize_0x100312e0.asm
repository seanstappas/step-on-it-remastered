; PenSize @ 0x100312e0
100312e0  8182f9e0    lwz r12,-0x620(r2)             ; -> 10033b50
100312e4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100312e8  800c0000    lwz r0,0x0(r12)             
100312ec  804c0004    lwz r2,0x4(r12)             
100312f0  7c0903a6    mtspr CTR,r0                
100312f4  4e800420    bctr                        
