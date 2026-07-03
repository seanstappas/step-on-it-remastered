; HiliteControl @ 0x10031238
10031238  8182f7ec    lwz r12,-0x814(r2)             ; -> 1003395c
1003123c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031240  800c0000    lwz r0,0x0(r12)             
10031244  804c0004    lwz r2,0x4(r12)             
10031248  7c0903a6    mtspr CTR,r0                
1003124c  4e800420    bctr                        
