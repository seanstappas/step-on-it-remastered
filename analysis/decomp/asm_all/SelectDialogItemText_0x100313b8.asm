; SelectDialogItemText @ 0x100313b8
100313b8  8182f8f8    lwz r12,-0x708(r2)             ; -> 10033a68
100313bc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100313c0  800c0000    lwz r0,0x0(r12)             
100313c4  804c0004    lwz r2,0x4(r12)             
100313c8  7c0903a6    mtspr CTR,r0                
100313cc  4e800420    bctr                        
