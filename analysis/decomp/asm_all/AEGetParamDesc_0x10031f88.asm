; AEGetParamDesc @ 0x10031f88
10031f88  8182f858    lwz r12,-0x7a8(r2)             ; -> 100339c8
10031f8c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031f90  800c0000    lwz r0,0x0(r12)             
10031f94  804c0004    lwz r2,0x4(r12)             
10031f98  7c0903a6    mtspr CTR,r0                
10031f9c  4e800420    bctr                        
