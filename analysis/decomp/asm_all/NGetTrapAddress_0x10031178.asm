; NGetTrapAddress @ 0x10031178
10031178  8182f96c    lwz r12,-0x694(r2)             ; -> 10033adc
1003117c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031180  800c0000    lwz r0,0x0(r12)             
10031184  804c0004    lwz r2,0x4(r12)             
10031188  7c0903a6    mtspr CTR,r0                
1003118c  4e800420    bctr                        
