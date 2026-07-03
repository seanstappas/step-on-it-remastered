; GetPicture @ 0x10031bc8
10031bc8  8182f6e4    lwz r12,-0x91c(r2)             ; -> 10033854
10031bcc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031bd0  800c0000    lwz r0,0x0(r12)             
10031bd4  804c0004    lwz r2,0x4(r12)             
10031bd8  7c0903a6    mtspr CTR,r0                
10031bdc  4e800420    bctr                        
