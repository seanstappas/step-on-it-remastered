; TextSize @ 0x10031c10
10031c10  8182f8c0    lwz r12,-0x740(r2)             ; -> 10033a30
10031c14  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031c18  800c0000    lwz r0,0x0(r12)             
10031c1c  804c0004    lwz r2,0x4(r12)             
10031c20  7c0903a6    mtspr CTR,r0                
10031c24  4e800420    bctr                        
