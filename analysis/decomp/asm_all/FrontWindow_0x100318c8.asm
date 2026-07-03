; FrontWindow @ 0x100318c8
100318c8  8182f8a8    lwz r12,-0x758(r2)             ; -> 10033a18
100318cc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100318d0  800c0000    lwz r0,0x0(r12)             
100318d4  804c0004    lwz r2,0x4(r12)             
100318d8  7c0903a6    mtspr CTR,r0                
100318dc  4e800420    bctr                        
