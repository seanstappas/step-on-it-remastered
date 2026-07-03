; LMSetMBarHeight @ 0x10031088
10031088  8182f8f0    lwz r12,-0x710(r2)             ; -> 10033a60
1003108c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031090  800c0000    lwz r0,0x0(r12)             
10031094  804c0004    lwz r2,0x4(r12)             
10031098  7c0903a6    mtspr CTR,r0                
1003109c  4e800420    bctr                        
