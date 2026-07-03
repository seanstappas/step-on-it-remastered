; SlotVRemove @ 0x100310a0
100310a0  8182f6b0    lwz r12,-0x950(r2)             ; -> 10033820
100310a4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100310a8  800c0000    lwz r0,0x0(r12)             
100310ac  804c0004    lwz r2,0x4(r12)             
100310b0  7c0903a6    mtspr CTR,r0                
100310b4  4e800420    bctr                        
