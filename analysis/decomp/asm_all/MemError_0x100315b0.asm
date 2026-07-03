; MemError @ 0x100315b0
100315b0  8182f9e4    lwz r12,-0x61c(r2)             ; -> 10033b54
100315b4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100315b8  800c0000    lwz r0,0x0(r12)             
100315bc  804c0004    lwz r2,0x4(r12)             
100315c0  7c0903a6    mtspr CTR,r0                
100315c4  4e800420    bctr                        
