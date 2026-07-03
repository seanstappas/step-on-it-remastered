; UnionRgn @ 0x10031b68
10031b68  8182f814    lwz r12,-0x7ec(r2)             ; -> 10033984
10031b6c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031b70  800c0000    lwz r0,0x0(r12)             
10031b74  804c0004    lwz r2,0x4(r12)             
10031b78  7c0903a6    mtspr CTR,r0                
10031b7c  4e800420    bctr                        
