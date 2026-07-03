; SetMovieBox @ 0x10032330
10032330  8182fa2c    lwz r12,-0x5d4(r2)             ; -> 10033b9c
10032334  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032338  800c0000    lwz r0,0x0(r12)             
1003233c  804c0004    lwz r2,0x4(r12)             
10032340  7c0903a6    mtspr CTR,r0                
10032344  4e800420    bctr                        
