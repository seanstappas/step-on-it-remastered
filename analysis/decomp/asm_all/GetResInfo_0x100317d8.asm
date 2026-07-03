; GetResInfo @ 0x100317d8
100317d8  8182f89c    lwz r12,-0x764(r2)             ; -> 10033a0c
100317dc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100317e0  800c0000    lwz r0,0x0(r12)             
100317e4  804c0004    lwz r2,0x4(r12)             
100317e8  7c0903a6    mtspr CTR,r0                
100317ec  4e800420    bctr                        
