; InitGraf @ 0x10030ec0
10030ec0  8182f694    lwz r12,-0x96c(r2)             ; -> 10033804
10030ec4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10030ec8  800c0000    lwz r0,0x0(r12)             
10030ecc  804c0004    lwz r2,0x4(r12)             
10030ed0  7c0903a6    mtspr CTR,r0                
10030ed4  4e800420    bctr                        
