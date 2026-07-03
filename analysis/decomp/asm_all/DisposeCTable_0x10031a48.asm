; DisposeCTable @ 0x10031a48
10031a48  8182f86c    lwz r12,-0x794(r2)             ; -> 100339dc
10031a4c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031a50  800c0000    lwz r0,0x0(r12)             
10031a54  804c0004    lwz r2,0x4(r12)             
10031a58  7c0903a6    mtspr CTR,r0                
10031a5c  4e800420    bctr                        
