; GetOSEvent @ 0x100322b8
100322b8  8182f93c    lwz r12,-0x6c4(r2)             ; -> 10033aac
100322bc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100322c0  800c0000    lwz r0,0x0(r12)             
100322c4  804c0004    lwz r2,0x4(r12)             
100322c8  7c0903a6    mtspr CTR,r0                
100322cc  4e800420    bctr                        
