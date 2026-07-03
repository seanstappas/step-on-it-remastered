; GetIndString @ 0x10031118
10031118  8182f8a4    lwz r12,-0x75c(r2)             ; -> 10033a14
1003111c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031120  800c0000    lwz r0,0x0(r12)             
10031124  804c0004    lwz r2,0x4(r12)             
10031128  7c0903a6    mtspr CTR,r0                
1003112c  4e800420    bctr                        
