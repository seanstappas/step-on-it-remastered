; SetTrackEnabled @ 0x10031e98
10031e98  8182fa34    lwz r12,-0x5cc(r2)             ; -> 10033ba4
10031e9c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031ea0  800c0000    lwz r0,0x0(r12)             
10031ea4  804c0004    lwz r2,0x4(r12)             
10031ea8  7c0903a6    mtspr CTR,r0                
10031eac  4e800420    bctr                        
