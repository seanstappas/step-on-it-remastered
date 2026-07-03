; InsXTime @ 0x100319b8
100319b8  8182f7f8    lwz r12,-0x808(r2)             ; -> 10033968
100319bc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100319c0  800c0000    lwz r0,0x0(r12)             
100319c4  804c0004    lwz r2,0x4(r12)             
100319c8  7c0903a6    mtspr CTR,r0                
100319cc  4e800420    bctr                        
