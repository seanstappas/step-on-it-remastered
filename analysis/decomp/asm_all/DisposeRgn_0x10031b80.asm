; DisposeRgn @ 0x10031b80
10031b80  8182f7ac    lwz r12,-0x854(r2)             ; -> 1003391c
10031b84  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031b88  800c0000    lwz r0,0x0(r12)             
10031b8c  804c0004    lwz r2,0x4(r12)             
10031b90  7c0903a6    mtspr CTR,r0                
10031b94  4e800420    bctr                        
