; GetMovieDuration @ 0x10031f40
10031f40  8182fa70    lwz r12,-0x590(r2)             ; -> 10033be0
10031f44  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031f48  800c0000    lwz r0,0x0(r12)             
10031f4c  804c0004    lwz r2,0x4(r12)             
10031f50  7c0903a6    mtspr CTR,r0                
10031f54  4e800420    bctr                        
