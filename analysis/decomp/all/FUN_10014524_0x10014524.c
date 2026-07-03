
void FUN_10014524(short param_1)

{
  undefined4 uVar1;
  undefined4 uVar2;
  short sVar3;
  
  *(undefined4 *)(param_1 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + param_1 * 4);
  sVar3 = *(short *)(param_1 * 0x70 + 0x1003a9e2) + 1;
  *(short *)(param_1 * 0x70 + 0x1003a9e2) = sVar3;
  if (sVar3 < 10) {
    if (*(short *)(param_1 * 0x70 + 0x1003a9e4) == 1) {
      *(undefined2 *)(param_1 * 0x70 + 0x1003a9be) =
           *(undefined2 *)(&DAT_10034724 + *(short *)(param_1 * 0x70 + 0x1003a9e2) * 2);
      if (*(short *)(param_1 * 0x70 + 0x1003a9e2) == 5) {
        uVar1 = FUN_1002e6f8(*(short *)(param_1 * 0x70 + 0x1003a9b4) + -4);
        uVar2 = FUN_1002e6cc(*(short *)(&DAT_1003a9b0 + param_1 * 0x70) + 0x12);
        FUN_1002ca5c(uVar2,uVar1);
      }
    }
    else {
      *(undefined2 *)(param_1 * 0x70 + 0x1003a9be) =
           *(undefined2 *)(&DAT_10034738 + *(short *)(param_1 * 0x70 + 0x1003a9e2) * 2);
      if (*(short *)(param_1 * 0x70 + 0x1003a9e2) == 5) {
        uVar1 = FUN_1002e6f8(*(short *)(param_1 * 0x70 + 0x1003a9b4) + -4);
        uVar2 = FUN_1002e6cc(*(short *)(&DAT_1003a9b0 + param_1 * 0x70) + 0xc);
        FUN_1002ca5c(uVar2,uVar1);
      }
    }
  }
  else {
    *(undefined2 *)(param_1 * 0x70 + 0x1003a9cc) = 0;
  }
  return;
}

