; GetCIcon @ 0x10031ca0
10031ca0  8182f728    lwz r12,-0x8d8(r2)             ; -> 10033898
10031ca4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031ca8  800c0000    lwz r0,0x0(r12)             
10031cac  804c0004    lwz r2,0x4(r12)             
10031cb0  7c0903a6    mtspr CTR,r0                
10031cb4  4e800420    bctr                        
