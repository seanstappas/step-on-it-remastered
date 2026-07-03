; SetCursor @ 0x100310e8
100310e8  8182f714    lwz r12,-0x8ec(r2)             ; -> 10033884
100310ec  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100310f0  800c0000    lwz r0,0x0(r12)             
100310f4  804c0004    lwz r2,0x4(r12)             
100310f8  7c0903a6    mtspr CTR,r0                
100310fc  4e800420    bctr                        
