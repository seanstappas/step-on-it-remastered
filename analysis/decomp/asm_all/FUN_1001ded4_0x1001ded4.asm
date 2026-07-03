; FUN_1001ded4 @ 0x1001ded4
1001ded4  7c0802a6    mfspr r0,LR                 
1001ded8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
1001dedc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
1001dee0  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
1001dee4  9421ffb0    stwu r1,-0x50(r1)              ; -> Stack[-0x50]
1001dee8  386251e6    addi r3,r2,0x51e6           
1001deec  3be25230    addi r31,r2,0x5230          
1001def0  88630000    lbz r3,0x0(r3)              
1001def4  28030000    cmplwi r3,0x0               
1001def8  40820154    bne 0x1001e04c                 ; -> 1001e04c
1001defc  480073fd    bl 0x100252f8                  ; -> 100252f8
1001df00  60000000    ori r0,r0,0x0               
1001df04  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
1001df08  28030000    cmplwi r3,0x0               
1001df0c  41820140    beq 0x1001e04c                 ; -> 1001e04c
1001df10  38600001    li r3,0x1                   
1001df14  48013355    bl 0x10031268                  ; -> 10031268
1001df18  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001df1c  807f0000    lwz r3,0x0(r31)             
1001df20  480141d1    bl 0x100320f0                  ; -> 100320f0
1001df24  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001df28  807f0000    lwz r3,0x0(r31)             
1001df2c  480141dd    bl 0x10032108                  ; -> 10032108
1001df30  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001df34  807f0000    lwz r3,0x0(r31)             
1001df38  48013df9    bl 0x10031d30                  ; -> 10031d30
1001df3c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001df40  3bc00000    li r30,0x0                  
1001df44  4800009c    b 0x1001dfe0                   ; -> 1001dfe0
1001df48  38600000    li r3,0x0                   
1001df4c  38810046    addi r4,r1,0x46             
1001df50  480141d1    bl 0x10032120                  ; -> 10032120
1001df54  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001df58  a8810046    lha r4,0x46(r1)                ; -> Stack[-0xa]
1001df5c  2c040002    cmpwi r4,0x2                
1001df60  41820028    beq 0x1001df88                 ; -> 1001df88
1001df64  4080007c    bge 0x1001dfe0                 ; -> 1001dfe0
1001df68  2c040001    cmpwi r4,0x1                
1001df6c  40800008    bge 0x1001df74                 ; -> 1001df74
1001df70  48000070    b 0x1001dfe0                   ; -> 1001dfe0
1001df74  807f0000    lwz r3,0x0(r31)             
1001df78  480141c1    bl 0x10032138                  ; -> 10032138
1001df7c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001df80  3bc00001    li r30,0x1                  
1001df84  4800005c    b 0x1001dfe0                   ; -> 1001dfe0
1001df88  807f0000    lwz r3,0x0(r31)             
1001df8c  a8810046    lha r4,0x46(r1)                ; -> Stack[-0xa]
1001df90  38a10044    addi r5,r1,0x44             
1001df94  38c10040    addi r6,r1,0x40             
1001df98  38e10038    addi r7,r1,0x38             
1001df9c  4801323d    bl 0x100311d8                  ; -> 100311d8
1001dfa0  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dfa4  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x10]
1001dfa8  48014491    bl 0x10032438                  ; -> 10032438
1001dfac  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dfb0  7c630734    extsh r3,r3                 
1001dfb4  2c030001    cmpwi r3,0x1                
1001dfb8  40820018    bne 0x1001dfd0                 ; -> 1001dfd0
1001dfbc  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x10]
1001dfc0  38800000    li r4,0x0                   
1001dfc4  48014445    bl 0x10032408                  ; -> 10032408
1001dfc8  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dfcc  48000014    b 0x1001dfe0                   ; -> 1001dfe0
1001dfd0  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x10]
1001dfd4  38800001    li r4,0x1                   
1001dfd8  48014431    bl 0x10032408                  ; -> 10032408
1001dfdc  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001dfe0  57c5063e    rlwinm r5,r30,0x0,0x18,0x1f 
1001dfe4  28050000    cmplwi r5,0x0               
1001dfe8  4182ff60    beq 0x1001df48                 ; -> 1001df48
1001dfec  807f0000    lwz r3,0x0(r31)             
1001dff0  38800002    li r4,0x2                   
1001dff4  38a10044    addi r5,r1,0x44             
1001dff8  38c10040    addi r6,r1,0x40             
1001dffc  38e10038    addi r7,r1,0x38             
1001e000  480131d9    bl 0x100311d8                  ; -> 100311d8
1001e004  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001e008  80610040    lwz r3,0x40(r1)                ; -> Stack[-0x10]
1001e00c  4801442d    bl 0x10032438                  ; -> 10032438
1001e010  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001e014  7c630734    extsh r3,r3                 
1001e018  2c030001    cmpwi r3,0x1                
1001e01c  4082001c    bne 0x1001e038                 ; -> 1001e038
1001e020  38e251e6    addi r7,r2,0x51e6           
1001e024  38c00001    li r6,0x1                   
1001e028  39225240    addi r9,r2,0x5240           
1001e02c  98c70000    stb r6,0x0(r7)              
1001e030  39000001    li r8,0x1                   
1001e034  99090000    stb r8,0x0(r9)              
1001e038  48012f19    bl 0x10030f50                  ; -> 10030f50
1001e03c  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001e040  807f0000    lwz r3,0x0(r31)             
1001e044  480140f5    bl 0x10032138                  ; -> 10032138
1001e048  80410014    lwz r2,0x14(r1)                ; -> Stack[-0x3c]
1001e04c  80010058    lwz r0,0x58(r1)                ; -> Stack[0x8]
1001e050  38210050    addi r1,r1,0x50             
1001e054  7c0803a6    mtspr LR,r0                 
1001e058  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
1001e05c  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
1001e060  4e800020    blr                         
