; ResError @ 0x10031628
10031628  8182f94c    lwz r12,-0x6b4(r2)             ; -> 10033abc
1003162c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031630  800c0000    lwz r0,0x0(r12)             
10031634  804c0004    lwz r2,0x4(r12)             
10031638  7c0903a6    mtspr CTR,r0                
1003163c  4e800420    bctr                        
