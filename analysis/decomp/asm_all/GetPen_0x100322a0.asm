; GetPen @ 0x100322a0
100322a0  8182fa04    lwz r12,-0x5fc(r2)             ; -> 10033b74
100322a4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100322a8  800c0000    lwz r0,0x0(r12)             
100322ac  804c0004    lwz r2,0x4(r12)             
100322b0  7c0903a6    mtspr CTR,r0                
100322b4  4e800420    bctr                        
