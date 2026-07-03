; GetMovieBox @ 0x10032300
10032300  8182fa54    lwz r12,-0x5ac(r2)             ; -> 10033bc4
10032304  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032308  800c0000    lwz r0,0x0(r12)             
1003230c  804c0004    lwz r2,0x4(r12)             
10032310  7c0903a6    mtspr CTR,r0                
10032314  4e800420    bctr                        
