; ClipRect @ 0x10031a30
10031a30  8182f6d8    lwz r12,-0x928(r2)             ; -> 10033848
10031a34  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031a38  800c0000    lwz r0,0x0(r12)             
10031a3c  804c0004    lwz r2,0x4(r12)             
10031a40  7c0903a6    mtspr CTR,r0                
10031a44  4e800420    bctr                        
