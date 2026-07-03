; InvalRect @ 0x10031d18
10031d18  8182f950    lwz r12,-0x6b0(r2)             ; -> 10033ac0
10031d1c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031d20  800c0000    lwz r0,0x0(r12)             
10031d24  804c0004    lwz r2,0x4(r12)             
10031d28  7c0903a6    mtspr CTR,r0                
10031d2c  4e800420    bctr                        
