; GetGDevice @ 0x10030fb0
10030fb0  8182f7f0    lwz r12,-0x810(r2)             ; -> 10033960
10030fb4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030fb8  800c0000    lwz r0,0x0(r12)             
10030fbc  804c0004    lwz r2,0x4(r12)             
10030fc0  7c0903a6    mtspr CTR,r0                
10030fc4  4e800420    bctr                        
