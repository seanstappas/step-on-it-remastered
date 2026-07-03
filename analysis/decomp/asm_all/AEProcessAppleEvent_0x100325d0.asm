; AEProcessAppleEvent @ 0x100325d0
100325d0  8182f81c    lwz r12,-0x7e4(r2)             ; -> 1003398c
100325d4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100325d8  800c0000    lwz r0,0x0(r12)             
100325dc  804c0004    lwz r2,0x4(r12)             
100325e0  7c0903a6    mtspr CTR,r0                
100325e4  4e800420    bctr                        
