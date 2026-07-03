; SetPort @ 0x100311c0
100311c0  8182f8ac    lwz r12,-0x754(r2)             ; -> 10033a1c
100311c4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100311c8  800c0000    lwz r0,0x0(r12)             
100311cc  804c0004    lwz r2,0x4(r12)             
100311d0  7c0903a6    mtspr CTR,r0                
100311d4  4e800420    bctr                        
