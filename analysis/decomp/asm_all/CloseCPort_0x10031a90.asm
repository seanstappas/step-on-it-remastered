; CloseCPort @ 0x10031a90
10031a90  8182f944    lwz r12,-0x6bc(r2)             ; -> 10033ab4
10031a94  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031a98  800c0000    lwz r0,0x0(r12)             
10031a9c  804c0004    lwz r2,0x4(r12)             
10031aa0  7c0903a6    mtspr CTR,r0                
10031aa4  4e800420    bctr                        
