; OpenMovieFile @ 0x10031dd8
10031dd8  8182fa80    lwz r12,-0x580(r2)             ; -> 10033bf0
10031ddc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031de0  800c0000    lwz r0,0x0(r12)             
10031de4  804c0004    lwz r2,0x4(r12)             
10031de8  7c0903a6    mtspr CTR,r0                
10031dec  4e800420    bctr                        
