; GrowWindow @ 0x100324c8
100324c8  8182f90c    lwz r12,-0x6f4(r2)             ; -> 10033a7c
100324cc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100324d0  800c0000    lwz r0,0x0(r12)             
100324d4  804c0004    lwz r2,0x4(r12)             
100324d8  7c0903a6    mtspr CTR,r0                
100324dc  4e800420    bctr                        
