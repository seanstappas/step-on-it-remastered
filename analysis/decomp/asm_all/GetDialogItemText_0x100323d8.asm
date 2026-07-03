; GetDialogItemText @ 0x100323d8
100323d8  8182f80c    lwz r12,-0x7f4(r2)             ; -> 1003397c
100323dc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100323e0  800c0000    lwz r0,0x0(r12)             
100323e4  804c0004    lwz r2,0x4(r12)             
100323e8  7c0903a6    mtspr CTR,r0                
100323ec  4e800420    bctr                        
