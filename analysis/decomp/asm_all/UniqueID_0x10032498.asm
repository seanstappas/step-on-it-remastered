; UniqueID @ 0x10032498
10032498  8182f9ac    lwz r12,-0x654(r2)             ; -> 10033b1c
1003249c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100324a0  800c0000    lwz r0,0x0(r12)             
100324a4  804c0004    lwz r2,0x4(r12)             
100324a8  7c0903a6    mtspr CTR,r0                
100324ac  4e800420    bctr                        
