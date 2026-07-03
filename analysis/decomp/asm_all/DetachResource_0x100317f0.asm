; DetachResource @ 0x100317f0
100317f0  8182f7c4    lwz r12,-0x83c(r2)             ; -> 10033934
100317f4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100317f8  800c0000    lwz r0,0x0(r12)             
100317fc  804c0004    lwz r2,0x4(r12)             
10031800  7c0903a6    mtspr CTR,r0                
10031804  4e800420    bctr                        
