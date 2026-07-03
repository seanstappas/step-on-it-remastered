; WriteResource @ 0x10031748
10031748  8182f9f0    lwz r12,-0x610(r2)             ; -> 10033b60
1003174c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031750  800c0000    lwz r0,0x0(r12)             
10031754  804c0004    lwz r2,0x4(r12)             
10031758  7c0903a6    mtspr CTR,r0                
1003175c  4e800420    bctr                        
