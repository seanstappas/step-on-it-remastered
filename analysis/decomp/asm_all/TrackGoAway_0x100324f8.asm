; TrackGoAway @ 0x100324f8
100324f8  8182f980    lwz r12,-0x680(r2)             ; -> 10033af0
100324fc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032500  800c0000    lwz r0,0x0(r12)             
10032504  804c0004    lwz r2,0x4(r12)             
10032508  7c0903a6    mtspr CTR,r0                
1003250c  4e800420    bctr                        
