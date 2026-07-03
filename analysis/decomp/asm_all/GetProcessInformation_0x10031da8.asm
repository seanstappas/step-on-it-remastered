; GetProcessInformation @ 0x10031da8
10031da8  8182f924    lwz r12,-0x6dc(r2)             ; -> 10033a94
10031dac  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031db0  800c0000    lwz r0,0x0(r12)             
10031db4  804c0004    lwz r2,0x4(r12)             
10031db8  7c0903a6    mtspr CTR,r0                
10031dbc  4e800420    bctr                        
