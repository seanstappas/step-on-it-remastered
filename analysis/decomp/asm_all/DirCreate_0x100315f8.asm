; DirCreate @ 0x100315f8
100315f8  8182f684    lwz r12,-0x97c(r2)             ; -> 100337f4
100315fc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031600  800c0000    lwz r0,0x0(r12)             
10031604  804c0004    lwz r2,0x4(r12)             
10031608  7c0903a6    mtspr CTR,r0                
1003160c  4e800420    bctr                        
