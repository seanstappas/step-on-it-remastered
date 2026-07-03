; AECountItems @ 0x10031fb8
10031fb8  8182f798    lwz r12,-0x868(r2)             ; -> 10033908
10031fbc  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031fc0  800c0000    lwz r0,0x0(r12)             
10031fc4  804c0004    lwz r2,0x4(r12)             
10031fc8  7c0903a6    mtspr CTR,r0                
10031fcc  4e800420    bctr                        
