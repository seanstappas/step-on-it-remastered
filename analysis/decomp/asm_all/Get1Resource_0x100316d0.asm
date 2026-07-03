; Get1Resource @ 0x100316d0
100316d0  8182f7b4    lwz r12,-0x84c(r2)             ; -> 10033924
100316d4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100316d8  800c0000    lwz r0,0x0(r12)             
100316dc  804c0004    lwz r2,0x4(r12)             
100316e0  7c0903a6    mtspr CTR,r0                
100316e4  4e800420    bctr                        
