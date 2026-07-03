; GetMovieTimeBase @ 0x10031ec8
10031ec8  8182fa44    lwz r12,-0x5bc(r2)             ; -> 10033bb4
10031ecc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031ed0  800c0000    lwz r0,0x0(r12)             
10031ed4  804c0004    lwz r2,0x4(r12)             
10031ed8  7c0903a6    mtspr CTR,r0                
10031edc  4e800420    bctr                        
