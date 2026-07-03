; MoveHHi @ 0x100317a8
100317a8  8182f6f0    lwz r12,-0x910(r2)             ; -> 10033860
100317ac  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100317b0  800c0000    lwz r0,0x0(r12)             
100317b4  804c0004    lwz r2,0x4(r12)             
100317b8  7c0903a6    mtspr CTR,r0                
100317bc  4e800420    bctr                        
