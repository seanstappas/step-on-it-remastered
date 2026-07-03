; SysEnvirons @ 0x10030f98
10030f98  8182f6fc    lwz r12,-0x904(r2)             ; -> 1003386c
10030f9c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030fa0  800c0000    lwz r0,0x0(r12)             
10030fa4  804c0004    lwz r2,0x4(r12)             
10030fa8  7c0903a6    mtspr CTR,r0                
10030fac  4e800420    bctr                        
