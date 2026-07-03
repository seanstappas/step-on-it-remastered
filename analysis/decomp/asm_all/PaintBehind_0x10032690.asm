; PaintBehind @ 0x10032690
10032690  8182f85c    lwz r12,-0x7a4(r2)             ; -> 100339cc
10032694  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032698  800c0000    lwz r0,0x0(r12)             
1003269c  804c0004    lwz r2,0x4(r12)             
100326a0  7c0903a6    mtspr CTR,r0                
100326a4  4e800420    bctr                        
