; SelectWindow @ 0x10031d30
10031d30  8182f6ec    lwz r12,-0x914(r2)             ; -> 1003385c
10031d34  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031d38  800c0000    lwz r0,0x0(r12)             
10031d3c  804c0004    lwz r2,0x4(r12)             
10031d40  7c0903a6    mtspr CTR,r0                
10031d44  4e800420    bctr                        
