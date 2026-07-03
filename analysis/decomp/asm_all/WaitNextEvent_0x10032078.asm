; WaitNextEvent @ 0x10032078
10032078  8182f874    lwz r12,-0x78c(r2)             ; -> 100339e4
1003207c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032080  800c0000    lwz r0,0x0(r12)             
10032084  804c0004    lwz r2,0x4(r12)             
10032088  7c0903a6    mtspr CTR,r0                
1003208c  4e800420    bctr                        
