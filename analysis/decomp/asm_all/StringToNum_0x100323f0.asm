; StringToNum @ 0x100323f0
100323f0  8182f8bc    lwz r12,-0x744(r2)             ; -> 10033a2c
100323f4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100323f8  800c0000    lwz r0,0x0(r12)             
100323fc  804c0004    lwz r2,0x4(r12)             
10032400  7c0903a6    mtspr CTR,r0                
10032404  4e800420    bctr                        
