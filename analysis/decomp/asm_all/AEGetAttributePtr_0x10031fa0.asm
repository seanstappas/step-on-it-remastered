; AEGetAttributePtr @ 0x10031fa0
10031fa0  8182f8fc    lwz r12,-0x704(r2)             ; -> 10033a6c
10031fa4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031fa8  800c0000    lwz r0,0x0(r12)             
10031fac  804c0004    lwz r2,0x4(r12)             
10031fb0  7c0903a6    mtspr CTR,r0                
10031fb4  4e800420    bctr                        
