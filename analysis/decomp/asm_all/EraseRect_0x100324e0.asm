; EraseRect @ 0x100324e0
100324e0  8182f92c    lwz r12,-0x6d4(r2)             ; -> 10033a9c
100324e4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100324e8  800c0000    lwz r0,0x0(r12)             
100324ec  804c0004    lwz r2,0x4(r12)             
100324f0  7c0903a6    mtspr CTR,r0                
100324f4  4e800420    bctr                        
