; GetKeys @ 0x100321c8
100321c8  8182f82c    lwz r12,-0x7d4(r2)             ; -> 1003399c
100321cc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100321d0  800c0000    lwz r0,0x0(r12)             
100321d4  804c0004    lwz r2,0x4(r12)             
100321d8  7c0903a6    mtspr CTR,r0                
100321dc  4e800420    bctr                        
