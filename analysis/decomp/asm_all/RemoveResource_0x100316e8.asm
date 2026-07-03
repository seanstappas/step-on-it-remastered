; RemoveResource @ 0x100316e8
100316e8  8182f834    lwz r12,-0x7cc(r2)             ; -> 100339a4
100316ec  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100316f0  800c0000    lwz r0,0x0(r12)             
100316f4  804c0004    lwz r2,0x4(r12)             
100316f8  7c0903a6    mtspr CTR,r0                
100316fc  4e800420    bctr                        
