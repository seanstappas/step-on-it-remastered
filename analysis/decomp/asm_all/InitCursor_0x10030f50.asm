; InitCursor @ 0x10030f50
10030f50  8182f8e0    lwz r12,-0x720(r2)             ; -> 10033a50
10030f54  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030f58  800c0000    lwz r0,0x0(r12)             
10030f5c  804c0004    lwz r2,0x4(r12)             
10030f60  7c0903a6    mtspr CTR,r0                
10030f64  4e800420    bctr                        
