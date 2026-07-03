; NewCWindow @ 0x10031b20
10031b20  8182f91c    lwz r12,-0x6e4(r2)             ; -> 10033a8c
10031b24  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031b28  800c0000    lwz r0,0x0(r12)             
10031b2c  804c0004    lwz r2,0x4(r12)             
10031b30  7c0903a6    mtspr CTR,r0                
10031b34  4e800420    bctr                        
