
undefined4 FUN_10017b68(void)

{
  int iVar1;
  int iVar2;
  short sVar3;
  
  FUN_10017a70();
  for (iVar2 = 1; sVar3 = (short)iVar2, sVar3 < 0x14; iVar2 = iVar2 + 1) {
    if (((&DAT_10038ff8)[sVar3 * 4] != '\0') && (*(char *)(sVar3 * 4 + 0x10038ff9) == '\0')) {
      iVar1 = FUN_10000004(iVar2 + 1000,(int)*(short *)(&DAT_10034a98 + sVar3 * 2));
      if (iVar1 == 0) {
        FUN_100192f8(5);
      }
      else if (iVar1 == -1) {
        FUN_100180d8();
        iVar1 = FUN_10000004(iVar2 + 1000,(int)*(short *)(&DAT_10034a98 + sVar3 * 2));
        if (iVar1 == 0) {
          FUN_100192f8(5);
        }
        else if (iVar1 == -1) {
          FUN_100192f8(6);
        }
        else {
          *(int *)(&DAT_1003a314 + sVar3 * 4) = iVar1;
          *(undefined1 *)(sVar3 * 4 + 0x10038ff9) = 1;
        }
      }
      else {
        *(int *)(&DAT_1003a314 + sVar3 * 4) = iVar1;
        *(undefined1 *)(sVar3 * 4 + 0x10038ff9) = 1;
      }
    }
  }
  FUN_10017cd8();
  return 1;
}

