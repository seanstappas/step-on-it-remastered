; GetMenuHandle @ 0x10031898
10031898  8182f748    lwz r12,-0x8b8(r2)             ; -> 100338b8
1003189c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100318a0  800c0000    lwz r0,0x0(r12)             
100318a4  804c0004    lwz r2,0x4(r12)             
100318a8  7c0903a6    mtspr CTR,r0                
100318ac  4e800420    bctr                        
