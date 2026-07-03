; AEInstallEventHandler @ 0x10032060
10032060  8182f6b8    lwz r12,-0x948(r2)             ; -> 10033828
10032064  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032068  800c0000    lwz r0,0x0(r12)             
1003206c  804c0004    lwz r2,0x4(r12)             
10032070  7c0903a6    mtspr CTR,r0                
10032074  4e800420    bctr                        
