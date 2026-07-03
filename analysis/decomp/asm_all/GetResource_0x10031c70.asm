; GetResource @ 0x10031c70
10031c70  8182f884    lwz r12,-0x77c(r2)             ; -> 100339f4
10031c74  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031c78  800c0000    lwz r0,0x0(r12)             
10031c7c  804c0004    lwz r2,0x4(r12)             
10031c80  7c0903a6    mtspr CTR,r0                
10031c84  4e800420    bctr                        
