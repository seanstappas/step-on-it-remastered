; AEGetNthPtr @ 0x10031fd0
10031fd0  8182f820    lwz r12,-0x7e0(r2)             ; -> 10033990
10031fd4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031fd8  800c0000    lwz r0,0x0(r12)             
10031fdc  804c0004    lwz r2,0x4(r12)             
10031fe0  7c0903a6    mtspr CTR,r0                
10031fe4  4e800420    bctr                        
