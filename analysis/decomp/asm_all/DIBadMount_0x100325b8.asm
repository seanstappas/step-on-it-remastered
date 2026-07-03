; DIBadMount @ 0x100325b8
100325b8  8182f9bc    lwz r12,-0x644(r2)             ; -> 10033b2c
100325bc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100325c0  800c0000    lwz r0,0x0(r12)             
100325c4  804c0004    lwz r2,0x4(r12)             
100325c8  7c0903a6    mtspr CTR,r0                
100325cc  4e800420    bctr                        
