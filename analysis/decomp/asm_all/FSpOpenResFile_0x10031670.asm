; FSpOpenResFile @ 0x10031670
10031670  8182f9c0    lwz r12,-0x640(r2)             ; -> 10033b30
10031674  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031678  800c0000    lwz r0,0x0(r12)             
1003167c  804c0004    lwz r2,0x4(r12)             
10031680  7c0903a6    mtspr CTR,r0                
10031684  4e800420    bctr                        
