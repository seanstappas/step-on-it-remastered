; GetPort @ 0x100311a8
100311a8  8182f8c4    lwz r12,-0x73c(r2)             ; -> 10033a34
100311ac  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100311b0  800c0000    lwz r0,0x0(r12)             
100311b4  804c0004    lwz r2,0x4(r12)             
100311b8  7c0903a6    mtspr CTR,r0                
100311bc  4e800420    bctr                        
