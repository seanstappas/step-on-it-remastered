; Button @ 0x10031af0
10031af0  8182f9a0    lwz r12,-0x660(r2)             ; -> 10033b10
10031af4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031af8  800c0000    lwz r0,0x0(r12)             
10031afc  804c0004    lwz r2,0x4(r12)             
10031b00  7c0903a6    mtspr CTR,r0                
10031b04  4e800420    bctr                        
