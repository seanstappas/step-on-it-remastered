; PBGetFCBInfoSync @ 0x100316b8
100316b8  8182f87c    lwz r12,-0x784(r2)             ; -> 100339ec
100316bc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100316c0  800c0000    lwz r0,0x0(r12)             
100316c4  804c0004    lwz r2,0x4(r12)             
100316c8  7c0903a6    mtspr CTR,r0                
100316cc  4e800420    bctr                        
