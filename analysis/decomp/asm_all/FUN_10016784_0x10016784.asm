; FUN_10016784 @ 0x10016784
10016784  7c0802a6    mfspr r0,LR                 
10016788  bf01ffe0    stmw r24,-0x20(r1)             ; -> Stack[-0x20]
1001678c  90010008    stw r0,0x8(r1)                 ; -> Stack[0x8]
10016790  9421ffa0    stwu r1,-0x60(r1)              ; -> Stack[-0x60]
10016794  3b826bf8    addi r28,r2,0x6bf8          
10016798  3ba26ba8    addi r29,r2,0x6ba8          
1001679c  3bc24d58    addi r30,r2,0x4d58          
100167a0  3b624d56    addi r27,r2,0x4d56          
100167a4  3be00000    li r31,0x0                  
100167a8  4800035c    b 0x10016b04                   ; -> 10016b04
100167ac  7fe30734    extsh r3,r31                
100167b0  1c63000e    mulli r3,r3,0xe             
100167b4  38630004    addi r3,r3,0x4              
100167b8  7c7e1aae    lhax r3,r30,r3              
100167bc  2c030004    cmpwi r3,0x4                
100167c0  408201d4    bne 0x10016994                 ; -> 10016994
100167c4  7fe40734    extsh r4,r31                
100167c8  1c84000e    mulli r4,r4,0xe             
100167cc  38840006    addi r4,r4,0x6              
100167d0  7c9e22ae    lhax r4,r30,r4              
100167d4  2c040008    cmpwi r4,0x8                
100167d8  40820100    bne 0x100168d8                 ; -> 100168d8
100167dc  7fe60734    extsh r6,r31                
100167e0  7fe50734    extsh r5,r31                
100167e4  1cc6000e    mulli r6,r6,0xe             
100167e8  1ca5000e    mulli r5,r5,0xe             
100167ec  38c60002    addi r6,r6,0x2              
100167f0  7c7e2aae    lhax r3,r30,r5              
100167f4  7c9e32ae    lhax r4,r30,r6              
100167f8  4bfede59    bl 0x10004650                  ; -> 10004650
100167fc  60000000    ori r0,r0,0x0               
10016800  5463063e    rlwinm r3,r3,0x0,0x18,0x1f  
10016804  28030000    cmplwi r3,0x0               
10016808  418202f8    beq 0x10016b00                 ; -> 10016b00
1001680c  7fe70734    extsh r7,r31                
10016810  1ce7000e    mulli r7,r7,0xe             
10016814  7fea0734    extsh r10,r31               
10016818  38e70006    addi r7,r7,0x6              
1001681c  7d1e3aae    lhax r8,r30,r7              
10016820  7feb0734    extsh r11,r31               
10016824  3908ffff    subi r8,r8,0x1              
10016828  7fe90734    extsh r9,r31                
1001682c  1d6b000e    mulli r11,r11,0xe           
10016830  1d29000e    mulli r9,r9,0xe             
10016834  7fec0734    extsh r12,r31               
10016838  1d8c000e    mulli r12,r12,0xe           
1001683c  1d4a000e    mulli r10,r10,0xe           
10016840  7d1e3b2e    sthx r8,r30,r7              
10016844  7d5e52ae    lhax r10,r30,r10            
10016848  396b0002    addi r11,r11,0x2            
1001684c  3929000a    addi r9,r9,0xa              
10016850  7d7e5aae    lhax r11,r30,r11            
10016854  7d3e4aae    lhax r9,r30,r9              
10016858  1d4a003c    mulli r10,r10,0x3c          
1001685c  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
10016860  39290300    addi r9,r9,0x300            
10016864  7d4a5a14    add r10,r10,r11             
10016868  7d3c512e    stwx r9,r28,r10             
1001686c  398c0002    addi r12,r12,0x2            
10016870  7c7e62ae    lhax r3,r30,r12             
10016874  48017e49    bl 0x1002e6bc                  ; -> 1002e6bc
10016878  60000000    ori r0,r0,0x0               
1001687c  7fe40734    extsh r4,r31                
10016880  1c84000e    mulli r4,r4,0xe             
10016884  7c791b78    or r25,r3,r3                
10016888  7c7e22ae    lhax r3,r30,r4              
1001688c  48017e21    bl 0x1002e6ac                  ; -> 1002e6ac
10016890  60000000    ori r0,r0,0x0               
10016894  7fe60734    extsh r6,r31                
10016898  7fe50734    extsh r5,r31                
1001689c  1cc6000e    mulli r6,r6,0xe             
100168a0  1ca5000e    mulli r5,r5,0xe             
100168a4  38c60008    addi r6,r6,0x8              
100168a8  38a50006    addi r5,r5,0x6              
100168ac  7cde32ae    lhax r6,r30,r6              
100168b0  7c781b78    or r24,r3,r3                
100168b4  7cbe2aae    lhax r5,r30,r5              
100168b8  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
100168bc  7c853214    add r4,r5,r6                
100168c0  807d0000    lwz r3,0x0(r29)             
100168c4  7f05c378    or r5,r24,r24               
100168c8  7f26cb78    or r6,r25,r25               
100168cc  4bfed83d    bl 0x10004108                  ; -> 10004108
100168d0  60000000    ori r0,r0,0x0               
100168d4  4800022c    b 0x10016b00                   ; -> 10016b00
100168d8  7fe70734    extsh r7,r31                
100168dc  1ce7000e    mulli r7,r7,0xe             
100168e0  7fe90734    extsh r9,r31                
100168e4  1d29000e    mulli r9,r9,0xe             
100168e8  38e70006    addi r7,r7,0x6              
100168ec  7d1e3aae    lhax r8,r30,r7              
100168f0  39290006    addi r9,r9,0x6              
100168f4  3908ffff    subi r8,r8,0x1              
100168f8  7d1e3b2e    sthx r8,r30,r7              
100168fc  7d3e4aae    lhax r9,r30,r9              
10016900  2c090000    cmpwi r9,0x0                
10016904  4181001c    bgt 0x10016920                 ; -> 10016920
10016908  7feb0734    extsh r11,r31               
1001690c  1d6b000e    mulli r11,r11,0xe           
10016910  39400002    li r10,0x2                  
10016914  396b0004    addi r11,r11,0x4            
10016918  7d5e5b2e    sthx r10,r30,r11            
1001691c  480001e4    b 0x10016b00                   ; -> 10016b00
10016920  7fec0734    extsh r12,r31               
10016924  1d8c000e    mulli r12,r12,0xe           
10016928  398c0002    addi r12,r12,0x2            
1001692c  7c7e62ae    lhax r3,r30,r12             
10016930  48017d8d    bl 0x1002e6bc                  ; -> 1002e6bc
10016934  60000000    ori r0,r0,0x0               
10016938  7ff80734    extsh r24,r31               
1001693c  1f18000e    mulli r24,r24,0xe           
10016940  7c791b78    or r25,r3,r3                
10016944  7c7ec2ae    lhax r3,r30,r24             
10016948  48017d65    bl 0x1002e6ac                  ; -> 1002e6ac
1001694c  60000000    ori r0,r0,0x0               
10016950  7fe60734    extsh r6,r31                
10016954  7fe50734    extsh r5,r31                
10016958  1cc6000e    mulli r6,r6,0xe             
1001695c  1ca5000e    mulli r5,r5,0xe             
10016960  38c60008    addi r6,r6,0x8              
10016964  38a50006    addi r5,r5,0x6              
10016968  7cde32ae    lhax r6,r30,r6              
1001696c  7c781b78    or r24,r3,r3                
10016970  7cbe2aae    lhax r5,r30,r5              
10016974  54c61838    rlwinm r6,r6,0x3,0x0,0x1c   
10016978  7c853214    add r4,r5,r6                
1001697c  807d0000    lwz r3,0x0(r29)             
10016980  7f05c378    or r5,r24,r24               
10016984  7f26cb78    or r6,r25,r25               
10016988  4bfed781    bl 0x10004108                  ; -> 10004108
1001698c  60000000    ori r0,r0,0x0               
10016990  48000170    b 0x10016b00                   ; -> 10016b00
10016994  7fe70734    extsh r7,r31                
10016998  1ce7000e    mulli r7,r7,0xe             
1001699c  38e70004    addi r7,r7,0x4              
100169a0  7cfe3aae    lhax r7,r30,r7              
100169a4  2c070003    cmpwi r7,0x3                
100169a8  40820158    bne 0x10016b00                 ; -> 10016b00
100169ac  7fe80734    extsh r8,r31                
100169b0  1d08000e    mulli r8,r8,0xe             
100169b4  39080006    addi r8,r8,0x6              
100169b8  7d1e42ae    lhax r8,r30,r8              
100169bc  2c080000    cmpwi r8,0x0                
100169c0  40820044    bne 0x10016a04                 ; -> 10016a04
100169c4  7fea0734    extsh r10,r31               
100169c8  1d4a000e    mulli r10,r10,0xe           
100169cc  7feb0734    extsh r11,r31               
100169d0  7fe90734    extsh r9,r31                
100169d4  1d6b000e    mulli r11,r11,0xe           
100169d8  1d29000e    mulli r9,r9,0xe             
100169dc  7d5e52ae    lhax r10,r30,r10            
100169e0  396b0002    addi r11,r11,0x2            
100169e4  3929000c    addi r9,r9,0xc              
100169e8  7d7e5aae    lhax r11,r30,r11            
100169ec  7d3e4aae    lhax r9,r30,r9              
100169f0  1d4a003c    mulli r10,r10,0x3c          
100169f4  556b103a    rlwinm r11,r11,0x2,0x0,0x1d 
100169f8  39290300    addi r9,r9,0x300            
100169fc  7d4a5a14    add r10,r10,r11             
10016a00  7d3c512e    stwx r9,r28,r10             
10016a04  7fec0734    extsh r12,r31               
10016a08  1d8c000e    mulli r12,r12,0xe           
10016a0c  7ff90734    extsh r25,r31               
10016a10  1f39000e    mulli r25,r25,0xe           
10016a14  398c0006    addi r12,r12,0x6            
10016a18  7f1e62ae    lhax r24,r30,r12            
10016a1c  3b390006    addi r25,r25,0x6            
10016a20  3b180001    addi r24,r24,0x1            
10016a24  7f1e632e    sthx r24,r30,r12            
10016a28  7f3ecaae    lhax r25,r30,r25            
10016a2c  2c190008    cmpwi r25,0x8               
10016a30  40810060    ble 0x10016a90                 ; -> 10016a90
10016a34  7fe40734    extsh r4,r31                
10016a38  1c84000e    mulli r4,r4,0xe             
10016a3c  7fe60734    extsh r6,r31                
10016a40  7fe70734    extsh r7,r31                
10016a44  7fe50734    extsh r5,r31                
10016a48  1ce7000e    mulli r7,r7,0xe             
10016a4c  1ca5000e    mulli r5,r5,0xe             
10016a50  1cc6000e    mulli r6,r6,0xe             
10016a54  38600001    li r3,0x1                   
10016a58  38840004    addi r4,r4,0x4              
10016a5c  7c7e232e    sthx r3,r30,r4              
10016a60  7cde32ae    lhax r6,r30,r6              
10016a64  38e70002    addi r7,r7,0x2              
10016a68  38a5000c    addi r5,r5,0xc              
10016a6c  7cfe3aae    lhax r7,r30,r7              
10016a70  7cbe2aae    lhax r5,r30,r5              
10016a74  1cc6003c    mulli r6,r6,0x3c            
10016a78  54e7103a    rlwinm r7,r7,0x2,0x0,0x1d   
10016a7c  38a50100    addi r5,r5,0x100            
10016a80  7cc63a14    add r6,r6,r7                
10016a84  3b40fdff    li r26,-0x201               
10016a88  7cbc312e    stwx r5,r28,r6              
10016a8c  48000074    b 0x10016b00                   ; -> 10016b00
10016a90  7fe80734    extsh r8,r31                
10016a94  1d08000e    mulli r8,r8,0xe             
10016a98  39080002    addi r8,r8,0x2              
10016a9c  7c7e42ae    lhax r3,r30,r8              
10016aa0  48017c1d    bl 0x1002e6bc                  ; -> 1002e6bc
10016aa4  60000000    ori r0,r0,0x0               
10016aa8  7fe90734    extsh r9,r31                
10016aac  1d29000e    mulli r9,r9,0xe             
10016ab0  7c791b78    or r25,r3,r3                
10016ab4  7c7e4aae    lhax r3,r30,r9              
10016ab8  48017bf5    bl 0x1002e6ac                  ; -> 1002e6ac
10016abc  60000000    ori r0,r0,0x0               
10016ac0  7c781b78    or r24,r3,r3                
10016ac4  7feb0734    extsh r11,r31               
10016ac8  7fea0734    extsh r10,r31               
10016acc  1d6b000e    mulli r11,r11,0xe           
10016ad0  1d4a000e    mulli r10,r10,0xe           
10016ad4  396b0008    addi r11,r11,0x8            
10016ad8  394a0006    addi r10,r10,0x6            
10016adc  7d7e5aae    lhax r11,r30,r11            
10016ae0  7d5e52ae    lhax r10,r30,r10            
10016ae4  556b1838    rlwinm r11,r11,0x3,0x0,0x1c 
10016ae8  807d0000    lwz r3,0x0(r29)             
10016aec  7c8a5a14    add r4,r10,r11              
10016af0  7f05c378    or r5,r24,r24               
10016af4  7f26cb78    or r6,r25,r25               
10016af8  4bfed611    bl 0x10004108                  ; -> 10004108
10016afc  60000000    ori r0,r0,0x0               
10016b00  3bff0001    addi r31,r31,0x1            
10016b04  ab1b0000    lha r24,0x0(r27)            
10016b08  7fec0734    extsh r12,r31               
10016b0c  7c0cc000    cmpw r12,r24                
10016b10  4180fc9c    blt 0x100167ac                 ; -> 100167ac
10016b14  80010068    lwz r0,0x68(r1)                ; -> Stack[0x8]
10016b18  38210060    addi r1,r1,0x60             
10016b1c  7c0803a6    mtspr LR,r0                 
10016b20  bb01ffe0    lmw r24,-0x20(r1)              ; -> Stack[-0x20]
10016b24  4e800020    blr                         
