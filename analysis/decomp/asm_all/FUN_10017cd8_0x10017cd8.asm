; FUN_10017cd8 @ 0x10017cd8
10017cd8  93e1fffc    stw r31,-0x4(r1)               ; -> Stack[-0x4]
10017cdc  93c1fff8    stw r30,-0x8(r1)               ; -> Stack[-0x8]
10017ce0  93a1fff4    stw r29,-0xc(r1)               ; -> Stack[-0xc]
10017ce4  9381fff0    stw r28,-0x10(r1)              ; -> Stack[-0x10]
10017ce8  386261fa    addi r3,r2,0x61fa           
10017cec  3b826ba4    addi r28,r2,0x6ba4          
10017cf0  3ba261a4    addi r29,r2,0x61a4          
10017cf4  3bc23cd8    addi r30,r2,0x3cd8          
10017cf8  abe30000    lha r31,0x0(r3)             
10017cfc  480003bc    b 0x100180b8                   ; -> 100180b8
10017d00  7fe40734    extsh r4,r31                
10017d04  1c840046    mulli r4,r4,0x46            
10017d08  38840002    addi r4,r4,0x2              
10017d0c  7c9e22ae    lhax r4,r30,r4              
10017d10  2c040065    cmpwi r4,0x65               
10017d14  418200f0    beq 0x10017e04                 ; -> 10017e04
10017d18  40800080    bge 0x10017d98                 ; -> 10017d98
10017d1c  2c04000b    cmpwi r4,0xb                
10017d20  4182015c    beq 0x10017e7c                 ; -> 10017e7c
10017d24  40800040    bge 0x10017d64                 ; -> 10017d64
10017d28  2c040005    cmpwi r4,0x5                
10017d2c  41820178    beq 0x10017ea4                 ; -> 10017ea4
10017d30  4080001c    bge 0x10017d4c                 ; -> 10017d4c
10017d34  2c040001    cmpwi r4,0x1                
10017d38  418200cc    beq 0x10017e04                 ; -> 10017e04
10017d3c  4180036c    blt 0x100180a8                 ; -> 100180a8
10017d40  2c040004    cmpwi r4,0x4                
10017d44  40800250    bge 0x10017f94                 ; -> 10017f94
10017d48  48000274    b 0x10017fbc                   ; -> 10017fbc
10017d4c  2c040009    cmpwi r4,0x9                
10017d50  418201f4    beq 0x10017f44                 ; -> 10017f44
10017d54  408000d8    bge 0x10017e2c                 ; -> 10017e2c
10017d58  2c040007    cmpwi r4,0x7                
10017d5c  40800210    bge 0x10017f6c                 ; -> 10017f6c
10017d60  480001bc    b 0x10017f1c                   ; -> 10017f1c
10017d64  2c04000f    cmpwi r4,0xf                
10017d68  4182027c    beq 0x10017fe4                 ; -> 10017fe4
10017d6c  40800014    bge 0x10017d80                 ; -> 10017d80
10017d70  2c04000d    cmpwi r4,0xd                
10017d74  41820310    beq 0x10018084                 ; -> 10018084
10017d78  408002bc    bge 0x10018034                 ; -> 10018034
10017d7c  480000d8    b 0x10017e54                   ; -> 10017e54
10017d80  2c040013    cmpwi r4,0x13               
10017d84  41820170    beq 0x10017ef4                 ; -> 10017ef4
10017d88  40800320    bge 0x100180a8                 ; -> 100180a8
10017d8c  2c040012    cmpwi r4,0x12               
10017d90  4080013c    bge 0x10017ecc                 ; -> 10017ecc
10017d94  48000278    b 0x1001800c                   ; -> 1001800c
10017d98  2c040070    cmpwi r4,0x70               
10017d9c  418200b8    beq 0x10017e54                 ; -> 10017e54
10017da0  40800038    bge 0x10017dd8                 ; -> 10017dd8
10017da4  2c04006a    cmpwi r4,0x6a               
10017da8  41820174    beq 0x10017f1c                 ; -> 10017f1c
10017dac  40800014    bge 0x10017dc0                 ; -> 10017dc0
10017db0  2c040068    cmpwi r4,0x68               
10017db4  418201e0    beq 0x10017f94                 ; -> 10017f94
10017db8  408000ec    bge 0x10017ea4                 ; -> 10017ea4
10017dbc  480002ec    b 0x100180a8                   ; -> 100180a8
10017dc0  2c04006e    cmpwi r4,0x6e               
10017dc4  41820068    beq 0x10017e2c                 ; -> 10017e2c
10017dc8  408000b4    bge 0x10017e7c                 ; -> 10017e7c
10017dcc  2c04006d    cmpwi r4,0x6d               
10017dd0  408002d8    bge 0x100180a8                 ; -> 100180a8
10017dd4  48000198    b 0x10017f6c                   ; -> 10017f6c
10017dd8  2c040077    cmpwi r4,0x77               
10017ddc  41820118    beq 0x10017ef4                 ; -> 10017ef4
10017de0  40800018    bge 0x10017df8                 ; -> 10017df8
10017de4  2c040076    cmpwi r4,0x76               
10017de8  408000e4    bge 0x10017ecc                 ; -> 10017ecc
10017dec  2c040073    cmpwi r4,0x73               
10017df0  408002b8    bge 0x100180a8                 ; -> 100180a8
10017df4  48000268    b 0x1001805c                   ; -> 1001805c
10017df8  2c0400c8    cmpwi r4,0xc8               
10017dfc  41820260    beq 0x1001805c                 ; -> 1001805c
10017e00  480002a8    b 0x100180a8                   ; -> 100180a8
10017e04  7fe60734    extsh r6,r31                
10017e08  1cc60046    mulli r6,r6,0x46            
10017e0c  7fe70734    extsh r7,r31                
10017e10  1ce70046    mulli r7,r7,0x46            
10017e14  80bd0004    lwz r5,0x4(r29)             
10017e18  38c6000a    addi r6,r6,0xa              
10017e1c  7cbe312e    stwx r5,r30,r6              
10017e20  38e70014    addi r7,r7,0x14             
10017e24  7cbe392e    stwx r5,r30,r7              
10017e28  48000280    b 0x100180a8                   ; -> 100180a8
10017e2c  7fe90734    extsh r9,r31                
10017e30  1d290046    mulli r9,r9,0x46            
10017e34  7fea0734    extsh r10,r31               
10017e38  1d4a0046    mulli r10,r10,0x46          
10017e3c  811d0028    lwz r8,0x28(r29)            
10017e40  3929000a    addi r9,r9,0xa              
10017e44  7d1e492e    stwx r8,r30,r9              
10017e48  394a0014    addi r10,r10,0x14           
10017e4c  7d1e512e    stwx r8,r30,r10             
10017e50  48000258    b 0x100180a8                   ; -> 100180a8
10017e54  7fec0734    extsh r12,r31               
10017e58  1d8c0046    mulli r12,r12,0x46          
10017e5c  7fe30734    extsh r3,r31                
10017e60  1c630046    mulli r3,r3,0x46            
10017e64  817d0030    lwz r11,0x30(r29)           
10017e68  398c000a    addi r12,r12,0xa            
10017e6c  7d7e612e    stwx r11,r30,r12            
10017e70  38630014    addi r3,r3,0x14             
10017e74  7d7e192e    stwx r11,r30,r3             
10017e78  48000230    b 0x100180a8                   ; -> 100180a8
10017e7c  7fe50734    extsh r5,r31                
10017e80  1ca50046    mulli r5,r5,0x46            
10017e84  7fe60734    extsh r6,r31                
10017e88  1cc60046    mulli r6,r6,0x46            
10017e8c  809d002c    lwz r4,0x2c(r29)            
10017e90  38a5000a    addi r5,r5,0xa              
10017e94  7c9e292e    stwx r4,r30,r5              
10017e98  38c60014    addi r6,r6,0x14             
10017e9c  7c9e312e    stwx r4,r30,r6              
10017ea0  48000208    b 0x100180a8                   ; -> 100180a8
10017ea4  7fe80734    extsh r8,r31                
10017ea8  1d080046    mulli r8,r8,0x46            
10017eac  7fe90734    extsh r9,r31                
10017eb0  1d290046    mulli r9,r9,0x46            
10017eb4  80fd0014    lwz r7,0x14(r29)            
10017eb8  3908000a    addi r8,r8,0xa              
10017ebc  7cfe412e    stwx r7,r30,r8              
10017ec0  39290014    addi r9,r9,0x14             
10017ec4  7cfe492e    stwx r7,r30,r9              
10017ec8  480001e0    b 0x100180a8                   ; -> 100180a8
10017ecc  7feb0734    extsh r11,r31               
10017ed0  1d6b0046    mulli r11,r11,0x46          
10017ed4  7fec0734    extsh r12,r31               
10017ed8  1d8c0046    mulli r12,r12,0x46          
10017edc  815d0048    lwz r10,0x48(r29)           
10017ee0  396b000a    addi r11,r11,0xa            
10017ee4  7d5e592e    stwx r10,r30,r11            
10017ee8  398c0014    addi r12,r12,0x14           
10017eec  7d5e612e    stwx r10,r30,r12            
10017ef0  480001b8    b 0x100180a8                   ; -> 100180a8
10017ef4  7fe40734    extsh r4,r31                
10017ef8  1c840046    mulli r4,r4,0x46            
10017efc  7fe50734    extsh r5,r31                
10017f00  1ca50046    mulli r5,r5,0x46            
10017f04  807d004c    lwz r3,0x4c(r29)            
10017f08  3884000a    addi r4,r4,0xa              
10017f0c  7c7e212e    stwx r3,r30,r4              
10017f10  38a50014    addi r5,r5,0x14             
10017f14  7c7e292e    stwx r3,r30,r5              
10017f18  48000190    b 0x100180a8                   ; -> 100180a8
10017f1c  7fe70734    extsh r7,r31                
10017f20  1ce70046    mulli r7,r7,0x46            
10017f24  7fe80734    extsh r8,r31                
10017f28  1d080046    mulli r8,r8,0x46            
10017f2c  80dd0018    lwz r6,0x18(r29)            
10017f30  38e7000a    addi r7,r7,0xa              
10017f34  7cde392e    stwx r6,r30,r7              
10017f38  39080014    addi r8,r8,0x14             
10017f3c  7cde412e    stwx r6,r30,r8              
10017f40  48000168    b 0x100180a8                   ; -> 100180a8
10017f44  7fea0734    extsh r10,r31               
10017f48  1d4a0046    mulli r10,r10,0x46          
10017f4c  7feb0734    extsh r11,r31               
10017f50  1d6b0046    mulli r11,r11,0x46          
10017f54  813d0024    lwz r9,0x24(r29)            
10017f58  394a000a    addi r10,r10,0xa            
10017f5c  7d3e512e    stwx r9,r30,r10             
10017f60  396b0014    addi r11,r11,0x14           
10017f64  7d3e592e    stwx r9,r30,r11             
10017f68  48000140    b 0x100180a8                   ; -> 100180a8
10017f6c  7fe30734    extsh r3,r31                
10017f70  1c630046    mulli r3,r3,0x46            
10017f74  7fe40734    extsh r4,r31                
10017f78  1c840046    mulli r4,r4,0x46            
10017f7c  819d001c    lwz r12,0x1c(r29)           
10017f80  3863000a    addi r3,r3,0xa              
10017f84  7d9e192e    stwx r12,r30,r3             
10017f88  38840014    addi r4,r4,0x14             
10017f8c  7d9e212e    stwx r12,r30,r4             
10017f90  48000118    b 0x100180a8                   ; -> 100180a8
10017f94  7fe60734    extsh r6,r31                
10017f98  1cc60046    mulli r6,r6,0x46            
10017f9c  7fe70734    extsh r7,r31                
10017fa0  1ce70046    mulli r7,r7,0x46            
10017fa4  80bd0010    lwz r5,0x10(r29)            
10017fa8  38c6000a    addi r6,r6,0xa              
10017fac  7cbe312e    stwx r5,r30,r6              
10017fb0  38e70014    addi r7,r7,0x14             
10017fb4  7cbe392e    stwx r5,r30,r7              
10017fb8  480000f0    b 0x100180a8                   ; -> 100180a8
10017fbc  7fe90734    extsh r9,r31                
10017fc0  1d290046    mulli r9,r9,0x46            
10017fc4  7fea0734    extsh r10,r31               
10017fc8  1d4a0046    mulli r10,r10,0x46          
10017fcc  811d0008    lwz r8,0x8(r29)             
10017fd0  3929000a    addi r9,r9,0xa              
10017fd4  7d1e492e    stwx r8,r30,r9              
10017fd8  394a0014    addi r10,r10,0x14           
10017fdc  7d1e512e    stwx r8,r30,r10             
10017fe0  480000c8    b 0x100180a8                   ; -> 100180a8
10017fe4  7fec0734    extsh r12,r31               
10017fe8  1d8c0046    mulli r12,r12,0x46          
10017fec  7fe30734    extsh r3,r31                
10017ff0  1c630046    mulli r3,r3,0x46            
10017ff4  817d003c    lwz r11,0x3c(r29)           
10017ff8  398c000a    addi r12,r12,0xa            
10017ffc  7d7e612e    stwx r11,r30,r12            
10018000  38630014    addi r3,r3,0x14             
10018004  7d7e192e    stwx r11,r30,r3             
10018008  480000a0    b 0x100180a8                   ; -> 100180a8
1001800c  7fe50734    extsh r5,r31                
10018010  1ca50046    mulli r5,r5,0x46            
10018014  7fe60734    extsh r6,r31                
10018018  1cc60046    mulli r6,r6,0x46            
1001801c  809d0040    lwz r4,0x40(r29)            
10018020  38a5000a    addi r5,r5,0xa              
10018024  7c9e292e    stwx r4,r30,r5              
10018028  38c60014    addi r6,r6,0x14             
1001802c  7c9e312e    stwx r4,r30,r6              
10018030  48000078    b 0x100180a8                   ; -> 100180a8
10018034  7fe80734    extsh r8,r31                
10018038  1d080046    mulli r8,r8,0x46            
1001803c  7fe90734    extsh r9,r31                
10018040  1d290046    mulli r9,r9,0x46            
10018044  80fd0038    lwz r7,0x38(r29)            
10018048  3908000a    addi r8,r8,0xa              
1001804c  7cfe412e    stwx r7,r30,r8              
10018050  39290014    addi r9,r9,0x14             
10018054  7cfe492e    stwx r7,r30,r9              
10018058  48000050    b 0x100180a8                   ; -> 100180a8
1001805c  7feb0734    extsh r11,r31               
10018060  1d6b0046    mulli r11,r11,0x46          
10018064  7fec0734    extsh r12,r31               
10018068  1d8c0046    mulli r12,r12,0x46          
1001806c  815c0000    lwz r10,0x0(r28)            
10018070  396b000a    addi r11,r11,0xa            
10018074  7d5e592e    stwx r10,r30,r11            
10018078  398c0014    addi r12,r12,0x14           
1001807c  7d5e612e    stwx r10,r30,r12            
10018080  48000028    b 0x100180a8                   ; -> 100180a8
10018084  7fe40734    extsh r4,r31                
10018088  1c840046    mulli r4,r4,0x46            
1001808c  7fe50734    extsh r5,r31                
10018090  1ca50046    mulli r5,r5,0x46            
10018094  807d0034    lwz r3,0x34(r29)            
10018098  3884000a    addi r4,r4,0xa              
1001809c  7c7e212e    stwx r3,r30,r4              
100180a0  38a50014    addi r5,r5,0x14             
100180a4  7c7e292e    stwx r3,r30,r5              
100180a8  7fe60734    extsh r6,r31                
100180ac  1cc60046    mulli r6,r6,0x46            
100180b0  38c6003e    addi r6,r6,0x3e             
100180b4  7ffe32ae    lhax r31,r30,r6             
100180b8  7fe70734    extsh r7,r31                
100180bc  2c070000    cmpwi r7,0x0                
100180c0  4082fc40    bne 0x10017d00                 ; -> 10017d00
100180c4  83e1fffc    lwz r31,-0x4(r1)               ; -> Stack[-0x4]
100180c8  83c1fff8    lwz r30,-0x8(r1)               ; -> Stack[-0x8]
100180cc  83a1fff4    lwz r29,-0xc(r1)               ; -> Stack[-0xc]
100180d0  8381fff0    lwz r28,-0x10(r1)              ; -> Stack[-0x10]
100180d4  4e800020    blr                         
