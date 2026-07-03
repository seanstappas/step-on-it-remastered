; GetMoviesError @ 0x10031df0
10031df0  8182fa74    lwz r12,-0x58c(r2)             ; -> 10033be4
10031df4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031df8  800c0000    lwz r0,0x0(r12)             
10031dfc  804c0004    lwz r2,0x4(r12)             
10031e00  7c0903a6    mtspr CTR,r0                
10031e04  4e800420    bctr                        
