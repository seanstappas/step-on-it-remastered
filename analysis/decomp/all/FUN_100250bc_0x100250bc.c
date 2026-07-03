
int FUN_100250bc(short param_1)

{
  int iVar1;
  short sVar2;
  
  iVar1 = 0;
  for (sVar2 = 1; sVar2 < 3; sVar2 = sVar2 + 1) {
    if ((int)param_1 == *(int *)(&DAT_1003a2b0 + sVar2 * 0x1c)) {
      iVar1 = iVar1 + 1;
    }
    if ((int)param_1 == *(int *)(sVar2 * 0x1c + 0x1003a2b4)) {
      iVar1 = iVar1 + 1;
    }
    if ((int)param_1 == *(int *)(sVar2 * 0x1c + 0x1003a2b8)) {
      iVar1 = iVar1 + 1;
    }
    if ((int)param_1 == *(int *)(sVar2 * 0x1c + 0x1003a2bc)) {
      iVar1 = iVar1 + 1;
    }
    if ((int)param_1 == *(int *)(sVar2 * 0x1c + 0x1003a2c0)) {
      iVar1 = iVar1 + 1;
    }
    if ((int)param_1 == *(int *)(sVar2 * 0x1c + 0x1003a2c4)) {
      iVar1 = iVar1 + 1;
    }
    if ((int)param_1 == *(int *)(sVar2 * 0x1c + 0x1003a2c8)) {
      iVar1 = iVar1 + 1;
    }
  }
  return iVar1;
}

