; GetMBarHeight @ 0x10031b08
10031b08  8182f784    lwz r12,-0x87c(r2)             ; -> 100338f4
10031b0c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031b10  800c0000    lwz r0,0x0(r12)             
10031b14  804c0004    lwz r2,0x4(r12)             
10031b18  7c0903a6    mtspr CTR,r0                
10031b1c  4e800420    bctr                        
