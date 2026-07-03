; NewRoutineDescriptor @ 0x100312b0
100312b0  8182f894    lwz r12,-0x76c(r2)             ; -> 10033a04
100312b4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100312b8  800c0000    lwz r0,0x0(r12)             
100312bc  804c0004    lwz r2,0x4(r12)             
100312c0  7c0903a6    mtspr CTR,r0                
100312c4  4e800420    bctr                        
