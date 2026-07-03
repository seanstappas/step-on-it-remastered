; InitMenus @ 0x10030f08
10030f08  8182f830    lwz r12,-0x7d0(r2)             ; -> 100339a0
10030f0c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030f10  800c0000    lwz r0,0x0(r12)             
10030f14  804c0004    lwz r2,0x4(r12)             
10030f18  7c0903a6    mtspr CTR,r0                
10030f1c  4e800420    bctr                        
