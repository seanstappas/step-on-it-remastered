; TEInit @ 0x10030f20
10030f20  8182f88c    lwz r12,-0x774(r2)             ; -> 100339fc
10030f24  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030f28  800c0000    lwz r0,0x0(r12)             
10030f2c  804c0004    lwz r2,0x4(r12)             
10030f30  7c0903a6    mtspr CTR,r0                
10030f34  4e800420    bctr                        
