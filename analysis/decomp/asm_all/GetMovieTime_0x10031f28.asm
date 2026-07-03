; GetMovieTime @ 0x10031f28
10031f28  8182fa28    lwz r12,-0x5d8(r2)             ; -> 10033b98
10031f2c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031f30  800c0000    lwz r0,0x0(r12)             
10031f34  804c0004    lwz r2,0x4(r12)             
10031f38  7c0903a6    mtspr CTR,r0                
10031f3c  4e800420    bctr                        
