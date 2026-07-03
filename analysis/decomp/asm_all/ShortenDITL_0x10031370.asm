; ShortenDITL @ 0x10031370
10031370  8182f84c    lwz r12,-0x7b4(r2)             ; -> 100339bc
10031374  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031378  800c0000    lwz r0,0x0(r12)             
1003137c  804c0004    lwz r2,0x4(r12)             
10031380  7c0903a6    mtspr CTR,r0                
10031384  4e800420    bctr                        
