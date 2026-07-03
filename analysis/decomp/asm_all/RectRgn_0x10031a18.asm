; RectRgn @ 0x10031a18
10031a18  8182f760    lwz r12,-0x8a0(r2)             ; -> 100338d0
10031a1c  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
10031a20  800c0000    lwz r0,0x0(r12)             
10031a24  804c0004    lwz r2,0x4(r12)             
10031a28  7c0903a6    mtspr CTR,r0                
10031a2c  4e800420    bctr                        
