; GetMovieIndTrack @ 0x10031e50
10031e50  8182fa58    lwz r12,-0x5a8(r2)             ; -> 10033bc8
10031e54  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031e58  800c0000    lwz r0,0x0(r12)             
10031e5c  804c0004    lwz r2,0x4(r12)             
10031e60  7c0903a6    mtspr CTR,r0                
10031e64  4e800420    bctr                        
