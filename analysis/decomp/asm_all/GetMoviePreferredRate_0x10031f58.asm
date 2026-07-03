; GetMoviePreferredRate @ 0x10031f58
10031f58  8182fa6c    lwz r12,-0x594(r2)             ; -> 10033bdc
10031f5c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031f60  800c0000    lwz r0,0x0(r12)             
10031f64  804c0004    lwz r2,0x4(r12)             
10031f68  7c0903a6    mtspr CTR,r0                
10031f6c  4e800420    bctr                        
