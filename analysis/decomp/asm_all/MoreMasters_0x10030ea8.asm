; MoreMasters @ 0x10030ea8
10030ea8  8182f964    lwz r12,-0x69c(r2)             ; -> 10033ad4
10030eac  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030eb0  800c0000    lwz r0,0x0(r12)             
10030eb4  804c0004    lwz r2,0x4(r12)             
10030eb8  7c0903a6    mtspr CTR,r0                
10030ebc  4e800420    bctr                        
