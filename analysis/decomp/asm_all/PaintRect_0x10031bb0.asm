; PaintRect @ 0x10031bb0
10031bb0  8182f870    lwz r12,-0x790(r2)             ; -> 100339e0
10031bb4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031bb8  800c0000    lwz r0,0x0(r12)             
10031bbc  804c0004    lwz r2,0x4(r12)             
10031bc0  7c0903a6    mtspr CTR,r0                
10031bc4  4e800420    bctr                        
