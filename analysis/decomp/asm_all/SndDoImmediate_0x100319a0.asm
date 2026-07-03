; SndDoImmediate @ 0x100319a0
100319a0  8182f750    lwz r12,-0x8b0(r2)             ; -> 100338c0
100319a4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100319a8  800c0000    lwz r0,0x0(r12)             
100319ac  804c0004    lwz r2,0x4(r12)             
100319b0  7c0903a6    mtspr CTR,r0                
100319b4  4e800420    bctr                        
