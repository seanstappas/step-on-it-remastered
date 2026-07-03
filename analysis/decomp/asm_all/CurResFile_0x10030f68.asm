; CurResFile @ 0x10030f68
10030f68  8182f9d8    lwz r12,-0x628(r2)             ; -> 10033b48
10030f6c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030f70  800c0000    lwz r0,0x0(r12)             
10030f74  804c0004    lwz r2,0x4(r12)             
10030f78  7c0903a6    mtspr CTR,r0                
10030f7c  4e800420    bctr                        
