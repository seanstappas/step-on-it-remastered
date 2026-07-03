; GetTrackMedia @ 0x10031e68
10031e68  8182fa24    lwz r12,-0x5dc(r2)             ; -> 10033b94
10031e6c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031e70  800c0000    lwz r0,0x0(r12)             
10031e74  804c0004    lwz r2,0x4(r12)             
10031e78  7c0903a6    mtspr CTR,r0                
10031e7c  4e800420    bctr                        
