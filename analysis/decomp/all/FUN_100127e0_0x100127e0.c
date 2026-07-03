
undefined4 FUN_100127e0(short param_1)

{
  short sVar1;
  short sVar2;
  short sVar3;
  int iVar4;
  int iVar5;
  
  sVar3 = *(short *)(&DAT_1003a9b0 + param_1 * 0x70);
  iVar5 = (int)*(short *)(param_1 * 0x70 + 0x1003a9b4);
  iVar4 = 1;
  if ((*(short *)(param_1 * 0x70 + 0x1003a9e2) < 0x11) &&
     (*(short *)(param_1 * 0x70 + 0x1003a9cc) == 2)) {
    iVar4 = 7;
  }
  sVar1 = FUN_1002e6f8(iVar5 + iVar4);
  sVar2 = FUN_1002e6cc(sVar3 + 0x14);
  if ((*(uint *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar1 * 4) & 0x200) == 0) {
    sVar1 = FUN_1002e6f8(iVar5 + 0x1e);
    sVar3 = FUN_1002e6cc(sVar3 + 0x14);
    if ((*(uint *)(&DAT_1003ad68 + sVar3 * 0x3c + sVar1 * 4) & 0x200) == 0) {
      return 1;
    }
  }
  return 0;
}

