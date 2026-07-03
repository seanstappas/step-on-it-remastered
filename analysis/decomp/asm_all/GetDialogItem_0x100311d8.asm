; GetDialogItem @ 0x100311d8
100311d8  8182f7e0    lwz r12,-0x820(r2)             ; -> 10033950
100311dc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100311e0  800c0000    lwz r0,0x0(r12)             
100311e4  804c0004    lwz r2,0x4(r12)             
100311e8  7c0903a6    mtspr CTR,r0                
100311ec  4e800420    bctr                        
