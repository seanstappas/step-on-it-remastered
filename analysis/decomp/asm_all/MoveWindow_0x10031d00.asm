; MoveWindow @ 0x10031d00
10031d00  8182f908    lwz r12,-0x6f8(r2)             ; -> 10033a78
10031d04  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031d08  800c0000    lwz r0,0x0(r12)             
10031d0c  804c0004    lwz r2,0x4(r12)             
10031d10  7c0903a6    mtspr CTR,r0                
10031d14  4e800420    bctr                        
