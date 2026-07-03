; PBCatSearchSync @ 0x100314d8
100314d8  8182f744    lwz r12,-0x8bc(r2)             ; -> 100338b4
100314dc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100314e0  800c0000    lwz r0,0x0(r12)             
100314e4  804c0004    lwz r2,0x4(r12)             
100314e8  7c0903a6    mtspr CTR,r0                
100314ec  4e800420    bctr                        
