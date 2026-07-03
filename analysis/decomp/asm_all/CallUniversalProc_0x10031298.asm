; CallUniversalProc @ 0x10031298
10031298  8182f768    lwz r12,-0x898(r2)             ; -> 100338d8
1003129c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100312a0  800c0000    lwz r0,0x0(r12)             
100312a4  804c0004    lwz r2,0x4(r12)             
100312a8  7c0903a6    mtspr CTR,r0                
100312ac  4e800420    bctr                        
