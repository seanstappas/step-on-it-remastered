; RmvTime @ 0x100310b8
100310b8  8182f9b8    lwz r12,-0x648(r2)             ; -> 10033b28
100310bc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100310c0  800c0000    lwz r0,0x0(r12)             
100310c4  804c0004    lwz r2,0x4(r12)             
100310c8  7c0903a6    mtspr CTR,r0                
100310cc  4e800420    bctr                        
