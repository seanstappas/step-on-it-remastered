; SetMenuBar @ 0x10031838
10031838  8182f9ec    lwz r12,-0x614(r2)             ; -> 10033b5c
1003183c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031840  800c0000    lwz r0,0x0(r12)             
10031844  804c0004    lwz r2,0x4(r12)             
10031848  7c0903a6    mtspr CTR,r0                
1003184c  4e800420    bctr                        
