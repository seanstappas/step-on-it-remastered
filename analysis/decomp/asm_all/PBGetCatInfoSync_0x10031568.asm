; PBGetCatInfoSync @ 0x10031568
10031568  8182f9d4    lwz r12,-0x62c(r2)             ; -> 10033b44
1003156c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031570  800c0000    lwz r0,0x0(r12)             
10031574  804c0004    lwz r2,0x4(r12)             
10031578  7c0903a6    mtspr CTR,r0                
1003157c  4e800420    bctr                        
