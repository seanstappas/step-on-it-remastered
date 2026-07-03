; OpenDeskAcc @ 0x100320d8
100320d8  8182fa10    lwz r12,-0x5f0(r2)             ; -> 10033b80
100320dc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100320e0  800c0000    lwz r0,0x0(r12)             
100320e4  804c0004    lwz r2,0x4(r12)             
100320e8  7c0903a6    mtspr CTR,r0                
100320ec  4e800420    bctr                        
