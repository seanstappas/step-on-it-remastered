; MaxBlock @ 0x100314a8
100314a8  8182f920    lwz r12,-0x6e0(r2)             ; -> 10033a90
100314ac  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100314b0  800c0000    lwz r0,0x0(r12)             
100314b4  804c0004    lwz r2,0x4(r12)             
100314b8  7c0903a6    mtspr CTR,r0                
100314bc  4e800420    bctr                        
