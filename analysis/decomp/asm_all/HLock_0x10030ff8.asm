; HLock @ 0x10030ff8
10030ff8  8182f9fc    lwz r12,-0x604(r2)             ; -> 10033b6c
10030ffc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031000  800c0000    lwz r0,0x0(r12)             
10031004  804c0004    lwz r2,0x4(r12)             
10031008  7c0903a6    mtspr CTR,r0                
1003100c  4e800420    bctr                        
