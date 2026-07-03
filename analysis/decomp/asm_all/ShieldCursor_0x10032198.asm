; ShieldCursor @ 0x10032198
10032198  8182f800    lwz r12,-0x800(r2)             ; -> 10033970
1003219c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100321a0  800c0000    lwz r0,0x0(r12)             
100321a4  804c0004    lwz r2,0x4(r12)             
100321a8  7c0903a6    mtspr CTR,r0                
100321ac  4e800420    bctr                        
