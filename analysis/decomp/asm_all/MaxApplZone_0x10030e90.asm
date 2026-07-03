; MaxApplZone @ 0x10030e90
10030e90  8182f700    lwz r12,-0x900(r2)             ; -> 10033870
10030e94  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030e98  800c0000    lwz r0,0x0(r12)             
10030e9c  804c0004    lwz r2,0x4(r12)             
10030ea0  7c0903a6    mtspr CTR,r0                
10030ea4  4e800420    bctr                        
