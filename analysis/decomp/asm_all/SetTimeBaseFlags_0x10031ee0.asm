; SetTimeBaseFlags @ 0x10031ee0
10031ee0  8182fa48    lwz r12,-0x5b8(r2)             ; -> 10033bb8
10031ee4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031ee8  800c0000    lwz r0,0x0(r12)             
10031eec  804c0004    lwz r2,0x4(r12)             
10031ef0  7c0903a6    mtspr CTR,r0                
10031ef4  4e800420    bctr                        
