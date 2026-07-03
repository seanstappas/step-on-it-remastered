; DisableItem @ 0x100318f8
100318f8  8182f850    lwz r12,-0x7b0(r2)             ; -> 100339c0
100318fc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031900  800c0000    lwz r0,0x0(r12)             
10031904  804c0004    lwz r2,0x4(r12)             
10031908  7c0903a6    mtspr CTR,r0                
1003190c  4e800420    bctr                        
