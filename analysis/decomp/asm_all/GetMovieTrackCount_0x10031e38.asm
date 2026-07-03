; GetMovieTrackCount @ 0x10031e38
10031e38  8182fa30    lwz r12,-0x5d0(r2)             ; -> 10033ba0
10031e3c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031e40  800c0000    lwz r0,0x0(r12)             
10031e44  804c0004    lwz r2,0x4(r12)             
10031e48  7c0903a6    mtspr CTR,r0                
10031e4c  4e800420    bctr                        
