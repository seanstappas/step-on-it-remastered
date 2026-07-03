; CustomGetFile @ 0x10032390
10032390  8182f844    lwz r12,-0x7bc(r2)             ; -> 100339b4
10032394  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032398  800c0000    lwz r0,0x0(r12)             
1003239c  804c0004    lwz r2,0x4(r12)             
100323a0  7c0903a6    mtspr CTR,r0                
100323a4  4e800420    bctr                        
