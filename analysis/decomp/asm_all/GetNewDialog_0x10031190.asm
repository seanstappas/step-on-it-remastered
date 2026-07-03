; GetNewDialog @ 0x10031190
10031190  8182f838    lwz r12,-0x7c8(r2)             ; -> 100339a8
10031194  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031198  800c0000    lwz r0,0x0(r12)             
1003119c  804c0004    lwz r2,0x4(r12)             
100311a0  7c0903a6    mtspr CTR,r0                
100311a4  4e800420    bctr                        
