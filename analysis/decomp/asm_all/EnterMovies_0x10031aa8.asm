; EnterMovies @ 0x10031aa8
10031aa8  8182fa64    lwz r12,-0x59c(r2)             ; -> 10033bd4
10031aac  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031ab0  800c0000    lwz r0,0x0(r12)             
10031ab4  804c0004    lwz r2,0x4(r12)             
10031ab8  7c0903a6    mtspr CTR,r0                
10031abc  4e800420    bctr                        
