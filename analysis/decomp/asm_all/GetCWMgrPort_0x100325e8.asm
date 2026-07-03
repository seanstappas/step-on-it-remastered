; GetCWMgrPort @ 0x100325e8
100325e8  8182f8dc    lwz r12,-0x724(r2)             ; -> 10033a4c
100325ec  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100325f0  800c0000    lwz r0,0x0(r12)             
100325f4  804c0004    lwz r2,0x4(r12)             
100325f8  7c0903a6    mtspr CTR,r0                
100325fc  4e800420    bctr                        
