; GetMouse @ 0x100311f0
100311f0  8182f898    lwz r12,-0x768(r2)             ; -> 10033a08
100311f4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100311f8  800c0000    lwz r0,0x0(r12)             
100311fc  804c0004    lwz r2,0x4(r12)             
10031200  7c0903a6    mtspr CTR,r0                
10031204  4e800420    bctr                        
