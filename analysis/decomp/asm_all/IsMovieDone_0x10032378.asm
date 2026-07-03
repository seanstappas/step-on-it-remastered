; IsMovieDone @ 0x10032378
10032378  8182fa20    lwz r12,-0x5e0(r2)             ; -> 10033b90
1003237c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032380  800c0000    lwz r0,0x0(r12)             
10032384  804c0004    lwz r2,0x4(r12)             
10032388  7c0903a6    mtspr CTR,r0                
1003238c  4e800420    bctr                        
