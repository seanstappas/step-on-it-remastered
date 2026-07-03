; MoveTo @ 0x10031bf8
10031bf8  8182f954    lwz r12,-0x6ac(r2)             ; -> 10033ac4
10031bfc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031c00  800c0000    lwz r0,0x0(r12)             
10031c04  804c0004    lwz r2,0x4(r12)             
10031c08  7c0903a6    mtspr CTR,r0                
10031c0c  4e800420    bctr                        
