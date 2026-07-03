; FSMakeFSSpec @ 0x10031dc0
10031dc0  8182f7cc    lwz r12,-0x834(r2)             ; -> 1003393c
10031dc4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031dc8  800c0000    lwz r0,0x0(r12)             
10031dcc  804c0004    lwz r2,0x4(r12)             
10031dd0  7c0903a6    mtspr CTR,r0                
10031dd4  4e800420    bctr                        
