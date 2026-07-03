; FindWindow @ 0x10032090
10032090  8182fa08    lwz r12,-0x5f8(r2)             ; -> 10033b78
10032094  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032098  800c0000    lwz r0,0x0(r12)             
1003209c  804c0004    lwz r2,0x4(r12)             
100320a0  7c0903a6    mtspr CTR,r0                
100320a4  4e800420    bctr                        
