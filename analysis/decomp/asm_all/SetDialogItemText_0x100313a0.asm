; SetDialogItemText @ 0x100313a0
100313a0  8182f860    lwz r12,-0x7a0(r2)             ; -> 100339d0
100313a4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100313a8  800c0000    lwz r0,0x0(r12)             
100313ac  804c0004    lwz r2,0x4(r12)             
100313b0  7c0903a6    mtspr CTR,r0                
100313b4  4e800420    bctr                        
