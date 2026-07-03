; GetCurrentProcess @ 0x10031d90
10031d90  8182fa00    lwz r12,-0x600(r2)             ; -> 10033b70
10031d94  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031d98  800c0000    lwz r0,0x0(r12)             
10031d9c  804c0004    lwz r2,0x4(r12)             
10031da0  7c0903a6    mtspr CTR,r0                
10031da4  4e800420    bctr                        
