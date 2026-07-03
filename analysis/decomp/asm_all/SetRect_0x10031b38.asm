; SetRect @ 0x10031b38
10031b38  8182f880    lwz r12,-0x780(r2)             ; -> 100339f0
10031b3c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031b40  800c0000    lwz r0,0x0(r12)             
10031b44  804c0004    lwz r2,0x4(r12)             
10031b48  7c0903a6    mtspr CTR,r0                
10031b4c  4e800420    bctr                        
