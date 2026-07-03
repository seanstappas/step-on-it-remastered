; PBHGetVInfoSync @ 0x10031478
10031478  8182f770    lwz r12,-0x890(r2)             ; -> 100338e0
1003147c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031480  800c0000    lwz r0,0x0(r12)             
10031484  804c0004    lwz r2,0x4(r12)             
10031488  7c0903a6    mtspr CTR,r0                
1003148c  4e800420    bctr                        
