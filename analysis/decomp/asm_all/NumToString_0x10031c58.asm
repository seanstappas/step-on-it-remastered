; NumToString @ 0x10031c58
10031c58  8182f9dc    lwz r12,-0x624(r2)             ; -> 10033b4c
10031c5c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031c60  800c0000    lwz r0,0x0(r12)             
10031c64  804c0004    lwz r2,0x4(r12)             
10031c68  7c0903a6    mtspr CTR,r0                
10031c6c  4e800420    bctr                        
