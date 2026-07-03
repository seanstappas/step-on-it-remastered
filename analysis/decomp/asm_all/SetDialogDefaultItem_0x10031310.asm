; SetDialogDefaultItem @ 0x10031310
10031310  8182f9b4    lwz r12,-0x64c(r2)             ; -> 10033b24
10031314  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031318  800c0000    lwz r0,0x0(r12)             
1003131c  804c0004    lwz r2,0x4(r12)             
10031320  7c0903a6    mtspr CTR,r0                
10031324  4e800420    bctr                        
