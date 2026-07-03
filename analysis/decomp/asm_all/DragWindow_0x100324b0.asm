; DragWindow @ 0x100324b0
100324b0  8182f914    lwz r12,-0x6ec(r2)             ; -> 10033a84
100324b4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100324b8  800c0000    lwz r0,0x0(r12)             
100324bc  804c0004    lwz r2,0x4(r12)             
100324c0  7c0903a6    mtspr CTR,r0                
100324c4  4e800420    bctr                        
