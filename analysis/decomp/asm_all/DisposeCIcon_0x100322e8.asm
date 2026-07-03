; DisposeCIcon @ 0x100322e8
100322e8  8182f8cc    lwz r12,-0x734(r2)             ; -> 10033a3c
100322ec  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100322f0  800c0000    lwz r0,0x0(r12)             
100322f4  804c0004    lwz r2,0x4(r12)             
100322f8  7c0903a6    mtspr CTR,r0                
100322fc  4e800420    bctr                        
