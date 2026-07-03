; HandToHand @ 0x10030fe0
10030fe0  8182f99c    lwz r12,-0x664(r2)             ; -> 10033b0c
10030fe4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030fe8  800c0000    lwz r0,0x0(r12)             
10030fec  804c0004    lwz r2,0x4(r12)             
10030ff0  7c0903a6    mtspr CTR,r0                
10030ff4  4e800420    bctr                        
