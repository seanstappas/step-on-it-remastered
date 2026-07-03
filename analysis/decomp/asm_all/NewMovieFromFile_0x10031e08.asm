; NewMovieFromFile @ 0x10031e08
10031e08  8182fa50    lwz r12,-0x5b0(r2)             ; -> 10033bc0
10031e0c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031e10  800c0000    lwz r0,0x0(r12)             
10031e14  804c0004    lwz r2,0x4(r12)             
10031e18  7c0903a6    mtspr CTR,r0                
10031e1c  4e800420    bctr                        
