; DisposeHandle @ 0x10031058
10031058  8182f9f8    lwz r12,-0x608(r2)             ; -> 10033b68
1003105c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031060  800c0000    lwz r0,0x0(r12)             
10031064  804c0004    lwz r2,0x4(r12)             
10031068  7c0903a6    mtspr CTR,r0                
1003106c  4e800420    bctr                        
