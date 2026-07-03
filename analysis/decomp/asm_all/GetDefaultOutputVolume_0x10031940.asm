; GetDefaultOutputVolume @ 0x10031940
10031940  8182f968    lwz r12,-0x698(r2)             ; -> 10033ad8
10031944  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031948  800c0000    lwz r0,0x0(r12)             
1003194c  804c0004    lwz r2,0x4(r12)             
10031950  7c0903a6    mtspr CTR,r0                
10031954  4e800420    bctr                        
