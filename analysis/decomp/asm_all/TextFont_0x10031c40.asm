; TextFont @ 0x10031c40
10031c40  8182f6c8    lwz r12,-0x938(r2)             ; -> 10033838
10031c44  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031c48  800c0000    lwz r0,0x0(r12)             
10031c4c  804c0004    lwz r2,0x4(r12)             
10031c50  7c0903a6    mtspr CTR,r0                
10031c54  4e800420    bctr                        
