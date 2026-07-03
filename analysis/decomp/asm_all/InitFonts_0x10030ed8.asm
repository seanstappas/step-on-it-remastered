; InitFonts @ 0x10030ed8
10030ed8  8182f8d8    lwz r12,-0x728(r2)             ; -> 10033a48
10030edc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030ee0  800c0000    lwz r0,0x0(r12)             
10030ee4  804c0004    lwz r2,0x4(r12)             
10030ee8  7c0903a6    mtspr CTR,r0                
10030eec  4e800420    bctr                        
