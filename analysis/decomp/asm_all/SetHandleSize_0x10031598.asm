; SetHandleSize @ 0x10031598
10031598  8182f7d8    lwz r12,-0x828(r2)             ; -> 10033948
1003159c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100315a0  800c0000    lwz r0,0x0(r12)             
100315a4  804c0004    lwz r2,0x4(r12)             
100315a8  7c0903a6    mtspr CTR,r0                
100315ac  4e800420    bctr                        
