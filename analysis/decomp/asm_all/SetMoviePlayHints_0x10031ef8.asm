; SetMoviePlayHints @ 0x10031ef8
10031ef8  8182fa4c    lwz r12,-0x5b4(r2)             ; -> 10033bbc
10031efc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031f00  800c0000    lwz r0,0x0(r12)             
10031f04  804c0004    lwz r2,0x4(r12)             
10031f08  7c0903a6    mtspr CTR,r0                
10031f0c  4e800420    bctr                        
