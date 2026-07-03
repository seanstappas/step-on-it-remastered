; OpenResFile @ 0x10031928
10031928  8182f930    lwz r12,-0x6d0(r2)             ; -> 10033aa0
1003192c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031930  800c0000    lwz r0,0x0(r12)             
10031934  804c0004    lwz r2,0x4(r12)             
10031938  7c0903a6    mtspr CTR,r0                
1003193c  4e800420    bctr                        
