; PrerollMovie @ 0x10031f70
10031f70  8182fa78    lwz r12,-0x588(r2)             ; -> 10033be8
10031f74  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031f78  800c0000    lwz r0,0x0(r12)             
10031f7c  804c0004    lwz r2,0x4(r12)             
10031f80  7c0903a6    mtspr CTR,r0                
10031f84  4e800420    bctr                        
