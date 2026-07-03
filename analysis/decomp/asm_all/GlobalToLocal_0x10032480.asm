; GlobalToLocal @ 0x10032480
10032480  8182f76c    lwz r12,-0x894(r2)             ; -> 100338dc
10032484  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032488  800c0000    lwz r0,0x0(r12)             
1003248c  804c0004    lwz r2,0x4(r12)             
10032490  7c0903a6    mtspr CTR,r0                
10032494  4e800420    bctr                        
