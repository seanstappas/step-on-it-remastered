; GetStdFilterProc @ 0x10031280
10031280  8182f868    lwz r12,-0x798(r2)             ; -> 100339d8
10031284  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031288  800c0000    lwz r0,0x0(r12)             
1003128c  804c0004    lwz r2,0x4(r12)             
10031290  7c0903a6    mtspr CTR,r0                
10031294  4e800420    bctr                        
