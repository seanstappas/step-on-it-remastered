; InitWindows @ 0x10030ef0
10030ef0  8182f948    lwz r12,-0x6b8(r2)             ; -> 10033ab8
10030ef4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030ef8  800c0000    lwz r0,0x0(r12)             
10030efc  804c0004    lwz r2,0x4(r12)             
10030f00  7c0903a6    mtspr CTR,r0                
10030f04  4e800420    bctr                        
