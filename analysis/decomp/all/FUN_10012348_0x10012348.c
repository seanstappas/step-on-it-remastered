
undefined4 FUN_10012348(short param_1)

{
  short sVar1;
  short sVar2;
  short sVar3;
  int iVar4;
  
  iVar4 = *(short *)(param_1 * 0x70 + 0x1003a9b4) + 0x1f;
  sVar3 = *(short *)(&DAT_1003a9b0 + param_1 * 0x70);
  sVar1 = FUN_1002e6f8(iVar4);
  sVar2 = FUN_1002e6cc(sVar3 + 0x10);
  if ((*(uint *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar1 * 4) & 0x200) == 0) {
    sVar1 = FUN_1002e6f8(iVar4);
    sVar3 = FUN_1002e6cc(sVar3 + 0xe);
    if ((*(uint *)(&DAT_1003ad68 + sVar3 * 0x3c + sVar1 * 4) & 0x200) == 0) {
      return 0;
    }
  }
  return 1;
}

