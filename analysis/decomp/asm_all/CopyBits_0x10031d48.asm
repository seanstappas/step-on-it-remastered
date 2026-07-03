; CopyBits @ 0x10031d48
10031d48  8182f988    lwz r12,-0x678(r2)             ; -> 10033af8
10031d4c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031d50  800c0000    lwz r0,0x0(r12)             
10031d54  804c0004    lwz r2,0x4(r12)             
10031d58  7c0903a6    mtspr CTR,r0                
10031d5c  4e800420    bctr                        
