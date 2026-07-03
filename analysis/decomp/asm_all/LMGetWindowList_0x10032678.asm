; LMGetWindowList @ 0x10032678
10032678  8182f9a4    lwz r12,-0x65c(r2)             ; -> 10033b14
1003267c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032680  800c0000    lwz r0,0x0(r12)             
10032684  804c0004    lwz r2,0x4(r12)             
10032688  7c0903a6    mtspr CTR,r0                
1003268c  4e800420    bctr                        
