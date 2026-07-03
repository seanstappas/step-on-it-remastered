; SizeWindow @ 0x10031ce8
10031ce8  8182f900    lwz r12,-0x700(r2)             ; -> 10033a70
10031cec  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031cf0  800c0000    lwz r0,0x0(r12)             
10031cf4  804c0004    lwz r2,0x4(r12)             
10031cf8  7c0903a6    mtspr CTR,r0                
10031cfc  4e800420    bctr                        
