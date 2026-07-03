; BlockMoveData @ 0x10031460
10031460  8182f8d4    lwz r12,-0x72c(r2)             ; -> 10033a44
10031464  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031468  800c0000    lwz r0,0x0(r12)             
1003146c  804c0004    lwz r2,0x4(r12)             
10031470  7c0903a6    mtspr CTR,r0                
10031474  4e800420    bctr                        
