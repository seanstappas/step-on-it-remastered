; HCreateResFile @ 0x10031610
10031610  8182f6dc    lwz r12,-0x924(r2)             ; -> 1003384c
10031614  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031618  800c0000    lwz r0,0x0(r12)             
1003161c  804c0004    lwz r2,0x4(r12)             
10031620  7c0903a6    mtspr CTR,r0                
10031624  4e800420    bctr                        
