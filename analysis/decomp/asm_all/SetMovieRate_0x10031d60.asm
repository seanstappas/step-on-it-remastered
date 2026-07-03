; SetMovieRate @ 0x10031d60
10031d60  8182fa7c    lwz r12,-0x584(r2)             ; -> 10033bec
10031d64  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031d68  800c0000    lwz r0,0x0(r12)             
10031d6c  804c0004    lwz r2,0x4(r12)             
10031d70  7c0903a6    mtspr CTR,r0                
10031d74  4e800420    bctr                        
