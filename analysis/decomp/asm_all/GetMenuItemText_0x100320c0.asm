; GetMenuItemText @ 0x100320c0
100320c0  8182f774    lwz r12,-0x88c(r2)             ; -> 100338e4
100320c4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100320c8  800c0000    lwz r0,0x0(r12)             
100320cc  804c0004    lwz r2,0x4(r12)             
100320d0  7c0903a6    mtspr CTR,r0                
100320d4  4e800420    bctr                        
