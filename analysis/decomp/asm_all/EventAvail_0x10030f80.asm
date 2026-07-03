; EventAvail @ 0x10030f80
10030f80  8182f974    lwz r12,-0x68c(r2)             ; -> 10033ae4
10030f84  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030f88  800c0000    lwz r0,0x0(r12)             
10030f8c  804c0004    lwz r2,0x4(r12)             
10030f90  7c0903a6    mtspr CTR,r0                
10030f94  4e800420    bctr                        
