; SetDeviceAttribute @ 0x10031a60
10031a60  8182f71c    lwz r12,-0x8e4(r2)             ; -> 1003388c
10031a64  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031a68  800c0000    lwz r0,0x0(r12)             
10031a6c  804c0004    lwz r2,0x4(r12)             
10031a70  7c0903a6    mtspr CTR,r0                
10031a74  4e800420    bctr                        
