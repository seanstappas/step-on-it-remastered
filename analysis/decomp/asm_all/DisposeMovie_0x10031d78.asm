; DisposeMovie @ 0x10031d78
10031d78  8182fa5c    lwz r12,-0x5a4(r2)             ; -> 10033bcc
10031d7c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031d80  800c0000    lwz r0,0x0(r12)             
10031d84  804c0004    lwz r2,0x4(r12)             
10031d88  7c0903a6    mtspr CTR,r0                
10031d8c  4e800420    bctr                        
