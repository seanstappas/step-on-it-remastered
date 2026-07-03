; SndDisposeChannel @ 0x100310d0
100310d0  8182f6cc    lwz r12,-0x934(r2)             ; -> 1003383c
100310d4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100310d8  800c0000    lwz r0,0x0(r12)             
100310dc  804c0004    lwz r2,0x4(r12)             
100310e0  7c0903a6    mtspr CTR,r0                
100310e4  4e800420    bctr                        
