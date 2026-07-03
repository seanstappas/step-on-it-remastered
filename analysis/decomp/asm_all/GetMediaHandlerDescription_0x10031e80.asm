; GetMediaHandlerDescription @ 0x10031e80
10031e80  8182fa3c    lwz r12,-0x5c4(r2)             ; -> 10033bac
10031e84  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031e88  800c0000    lwz r0,0x0(r12)             
10031e8c  804c0004    lwz r2,0x4(r12)             
10031e90  7c0903a6    mtspr CTR,r0                
10031e94  4e800420    bctr                        
