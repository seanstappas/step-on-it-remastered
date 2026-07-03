; SetMovieGWorld @ 0x10031eb0
10031eb0  8182fa18    lwz r12,-0x5e8(r2)             ; -> 10033b88
10031eb4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031eb8  800c0000    lwz r0,0x0(r12)             
10031ebc  804c0004    lwz r2,0x4(r12)             
10031ec0  7c0903a6    mtspr CTR,r0                
10031ec4  4e800420    bctr                        
