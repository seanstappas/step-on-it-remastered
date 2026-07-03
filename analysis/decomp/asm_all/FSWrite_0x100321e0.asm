; FSWrite @ 0x100321e0
100321e0  8182f720    lwz r12,-0x8e0(r2)             ; -> 10033890
100321e4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100321e8  800c0000    lwz r0,0x0(r12)             
100321ec  804c0004    lwz r2,0x4(r12)             
100321f0  7c0903a6    mtspr CTR,r0                
100321f4  4e800420    bctr                        
