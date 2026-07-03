; FSpGetFInfo @ 0x10031fe8
10031fe8  8182f8a0    lwz r12,-0x760(r2)             ; -> 10033a10
10031fec  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031ff0  800c0000    lwz r0,0x0(r12)             
10031ff4  804c0004    lwz r2,0x4(r12)             
10031ff8  7c0903a6    mtspr CTR,r0                
10031ffc  4e800420    bctr                        
