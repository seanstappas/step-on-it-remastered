; FindNextComponent @ 0x10031430
10031430  8182f864    lwz r12,-0x79c(r2)             ; -> 100339d4
10031434  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031438  800c0000    lwz r0,0x0(r12)             
1003143c  804c0004    lwz r2,0x4(r12)             
10031440  7c0903a6    mtspr CTR,r0                
10031444  4e800420    bctr                        
