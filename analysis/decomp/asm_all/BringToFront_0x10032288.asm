; BringToFront @ 0x10032288
10032288  8182f98c    lwz r12,-0x674(r2)             ; -> 10033afc
1003228c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10032290  800c0000    lwz r0,0x0(r12)             
10032294  804c0004    lwz r2,0x4(r12)             
10032298  7c0903a6    mtspr CTR,r0                
1003229c  4e800420    bctr                        
