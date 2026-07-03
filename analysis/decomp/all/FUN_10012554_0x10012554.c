
void FUN_10012554(short param_1)

{
  short sVar1;
  short sVar2;
  int iVar3;
  int iVar4;
  
  iVar4 = (int)*(short *)(&DAT_1003a9b0 + param_1 * 0x70);
  iVar3 = (int)*(short *)(param_1 * 0x70 + 0x1003a9b4);
  sVar1 = FUN_1002e6f8(iVar3 + 7);
  sVar2 = FUN_1002e6cc(iVar4 + 10);
  if ((*(uint *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar1 * 4) & 0x200) == 0) {
    sVar1 = FUN_1002e6f8(iVar3 + 0x1e);
    sVar2 = FUN_1002e6cc(iVar4 + 10);
    if ((*(uint *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar1 * 4) & 0x200) == 0) goto LAB_10012620;
  }
  *(short *)(&DAT_1003a9b0 + param_1 * 0x70) = *(short *)(&DAT_1003a9b0 + param_1 * 0x70) + 2;
LAB_10012620:
  sVar1 = FUN_1002e6f8(iVar3 + 7);
  sVar2 = FUN_1002e6cc(iVar4 + 0x14);
  if ((*(uint *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar1 * 4) & 0x200) == 0) {
    sVar1 = FUN_1002e6f8(iVar3 + 0x1e);
    sVar2 = FUN_1002e6cc(iVar4 + 0x14);
    if ((*(uint *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar1 * 4) & 0x200) == 0) {
      return;
    }
  }
  *(short *)(&DAT_1003a9b0 + param_1 * 0x70) = *(short *)(&DAT_1003a9b0 + param_1 * 0x70) + -2;
  return;
}

