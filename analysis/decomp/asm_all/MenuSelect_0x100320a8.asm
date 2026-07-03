; MenuSelect @ 0x100320a8
100320a8  8182f9c8    lwz r12,-0x638(r2)             ; -> 10033b38
100320ac  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100320b0  800c0000    lwz r0,0x0(r12)             
100320b4  804c0004    lwz r2,0x4(r12)             
100320b8  7c0903a6    mtspr CTR,r0                
100320bc  4e800420    bctr                        
