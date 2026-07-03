; SetMovieVolume @ 0x10031ad8
10031ad8  8182fa40    lwz r12,-0x5c0(r2)             ; -> 10033bb0
10031adc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031ae0  800c0000    lwz r0,0x0(r12)             
10031ae4  804c0004    lwz r2,0x4(r12)             
10031ae8  7c0903a6    mtspr CTR,r0                
10031aec  4e800420    bctr                        
