; SndPlayDoubleBuffer @ 0x10031988
10031988  8182f9cc    lwz r12,-0x634(r2)             ; -> 10033b3c
1003198c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031990  800c0000    lwz r0,0x0(r12)             
10031994  804c0004    lwz r2,0x4(r12)             
10031998  7c0903a6    mtspr CTR,r0                
1003199c  4e800420    bctr                        
