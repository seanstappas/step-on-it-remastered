; DrawPicture @ 0x10031be0
10031be0  8182f998    lwz r12,-0x668(r2)             ; -> 10033b08
10031be4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031be8  800c0000    lwz r0,0x0(r12)             
10031bec  804c0004    lwz r2,0x4(r12)             
10031bf0  7c0903a6    mtspr CTR,r0                
10031bf4  4e800420    bctr                        
