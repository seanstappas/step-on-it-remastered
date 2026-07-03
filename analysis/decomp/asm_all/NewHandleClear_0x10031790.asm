; NewHandleClear @ 0x10031790
10031790  8182f7a0    lwz r12,-0x860(r2)             ; -> 10033910
10031794  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031798  800c0000    lwz r0,0x0(r12)             
1003179c  804c0004    lwz r2,0x4(r12)             
100317a0  7c0903a6    mtspr CTR,r0                
100317a4  4e800420    bctr                        
