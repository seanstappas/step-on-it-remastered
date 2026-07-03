; CloseMovieFile @ 0x10031e20
10031e20  8182fa68    lwz r12,-0x598(r2)             ; -> 10033bd8
10031e24  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031e28  800c0000    lwz r0,0x0(r12)             
10031e2c  804c0004    lwz r2,0x4(r12)             
10031e30  7c0903a6    mtspr CTR,r0                
10031e34  4e800420    bctr                        
