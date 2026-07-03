; PtrToHand @ 0x100316a0
100316a0  8182f9f4    lwz r12,-0x60c(r2)             ; -> 10033b64
100316a4  90410014    stw r2,0x14(r1)                ; -> Stack[0x14]
100316a8  800c0000    lwz r0,0x0(r12)             
100316ac  804c0004    lwz r2,0x4(r12)             
100316b0  7c0903a6    mtspr CTR,r0                
100316b4  4e800420    bctr                        
