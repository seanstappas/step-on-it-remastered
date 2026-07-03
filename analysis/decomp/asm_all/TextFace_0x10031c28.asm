; TextFace @ 0x10031c28
10031c28  8182f70c    lwz r12,-0x8f4(r2)             ; -> 1003387c
10031c2c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031c30  800c0000    lwz r0,0x0(r12)             
10031c34  804c0004    lwz r2,0x4(r12)             
10031c38  7c0903a6    mtspr CTR,r0                
10031c3c  4e800420    bctr                        
