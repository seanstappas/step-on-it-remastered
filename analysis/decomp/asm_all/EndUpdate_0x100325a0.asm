; EndUpdate @ 0x100325a0
100325a0  8182f9c4    lwz r12,-0x63c(r2)             ; -> 10033b34
100325a4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100325a8  800c0000    lwz r0,0x0(r12)             
100325ac  804c0004    lwz r2,0x4(r12)             
100325b0  7c0903a6    mtspr CTR,r0                
100325b4  4e800420    bctr                        
