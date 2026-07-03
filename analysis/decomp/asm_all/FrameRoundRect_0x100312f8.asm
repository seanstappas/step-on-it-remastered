; FrameRoundRect @ 0x100312f8
100312f8  8182f6ac    lwz r12,-0x954(r2)             ; -> 1003381c
100312fc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031300  800c0000    lwz r0,0x0(r12)             
10031304  804c0004    lwz r2,0x4(r12)             
10031308  7c0903a6    mtspr CTR,r0                
1003130c  4e800420    bctr                        
