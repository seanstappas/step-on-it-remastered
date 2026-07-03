; Get1IndResource @ 0x100317c0
100317c0  8182f730    lwz r12,-0x8d0(r2)             ; -> 100338a0
100317c4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100317c8  800c0000    lwz r0,0x0(r12)             
100317cc  804c0004    lwz r2,0x4(r12)             
100317d0  7c0903a6    mtspr CTR,r0                
100317d4  4e800420    bctr                        
