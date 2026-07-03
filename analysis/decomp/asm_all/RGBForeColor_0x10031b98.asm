; RGBForeColor @ 0x10031b98
10031b98  8182f8ec    lwz r12,-0x714(r2)             ; -> 10033a5c
10031b9c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031ba0  800c0000    lwz r0,0x0(r12)             
10031ba4  804c0004    lwz r2,0x4(r12)             
10031ba8  7c0903a6    mtspr CTR,r0                
10031bac  4e800420    bctr                        
