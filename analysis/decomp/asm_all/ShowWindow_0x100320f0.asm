; ShowWindow @ 0x100320f0
100320f0  8182f8b8    lwz r12,-0x748(r2)             ; -> 10033a28
100320f4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100320f8  800c0000    lwz r0,0x0(r12)             
100320fc  804c0004    lwz r2,0x4(r12)             
10032100  7c0903a6    mtspr CTR,r0                
10032104  4e800420    bctr                        
