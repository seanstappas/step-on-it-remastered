; GetControlValue @ 0x10032438
10032438  8182f788    lwz r12,-0x878(r2)             ; -> 100338f8
1003243c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032440  800c0000    lwz r0,0x0(r12)             
10032444  804c0004    lwz r2,0x4(r12)             
10032448  7c0903a6    mtspr CTR,r0                
1003244c  4e800420    bctr                        
