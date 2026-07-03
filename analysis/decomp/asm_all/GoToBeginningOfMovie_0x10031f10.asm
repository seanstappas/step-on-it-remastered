; GoToBeginningOfMovie @ 0x10031f10
10031f10  8182fa1c    lwz r12,-0x5e4(r2)             ; -> 10033b8c
10031f14  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031f18  800c0000    lwz r0,0x0(r12)             
10031f1c  804c0004    lwz r2,0x4(r12)             
10031f20  7c0903a6    mtspr CTR,r0                
10031f24  4e800420    bctr                        
