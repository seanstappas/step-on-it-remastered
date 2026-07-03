; CustomPutFile @ 0x100323a8
100323a8  8182f958    lwz r12,-0x6a8(r2)             ; -> 10033ac8
100323ac  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100323b0  800c0000    lwz r0,0x0(r12)             
100323b4  804c0004    lwz r2,0x4(r12)             
100323b8  7c0903a6    mtspr CTR,r0                
100323bc  4e800420    bctr                        
