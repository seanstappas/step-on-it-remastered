; SetGDevice @ 0x10031ac0
10031ac0  8182f754    lwz r12,-0x8ac(r2)             ; -> 100338c4
10031ac4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031ac8  800c0000    lwz r0,0x0(r12)             
10031acc  804c0004    lwz r2,0x4(r12)             
10031ad0  7c0903a6    mtspr CTR,r0                
10031ad4  4e800420    bctr                        
