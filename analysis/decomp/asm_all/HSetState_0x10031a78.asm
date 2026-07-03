; HSetState @ 0x10031a78
10031a78  8182f928    lwz r12,-0x6d8(r2)             ; -> 10033a98
10031a7c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031a80  800c0000    lwz r0,0x0(r12)             
10031a84  804c0004    lwz r2,0x4(r12)             
10031a88  7c0903a6    mtspr CTR,r0                
10031a8c  4e800420    bctr                        
