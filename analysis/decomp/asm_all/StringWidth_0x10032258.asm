; StringWidth @ 0x10032258
10032258  8182f73c    lwz r12,-0x8c4(r2)             ; -> 100338ac
1003225c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032260  800c0000    lwz r0,0x0(r12)             
10032264  804c0004    lwz r2,0x4(r12)             
10032268  7c0903a6    mtspr CTR,r0                
1003226c  4e800420    bctr                        
