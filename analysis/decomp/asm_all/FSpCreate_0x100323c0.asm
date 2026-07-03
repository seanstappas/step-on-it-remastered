; FSpCreate @ 0x100323c0
100323c0  8182f904    lwz r12,-0x6fc(r2)             ; -> 10033a74
100323c4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100323c8  800c0000    lwz r0,0x0(r12)             
100323cc  804c0004    lwz r2,0x4(r12)             
100323d0  7c0903a6    mtspr CTR,r0                
100323d4  4e800420    bctr                        
