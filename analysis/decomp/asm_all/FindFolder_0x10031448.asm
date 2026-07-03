; FindFolder @ 0x10031448
10031448  8182f95c    lwz r12,-0x6a4(r2)             ; -> 10033acc
1003144c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031450  800c0000    lwz r0,0x0(r12)             
10031454  804c0004    lwz r2,0x4(r12)             
10031458  7c0903a6    mtspr CTR,r0                
1003145c  4e800420    bctr                        
