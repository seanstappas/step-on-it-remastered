
void FUN_10019cb8(short param_1)

{
  int iVar1;
  bool bVar2;
  short sVar3;
  int local_3c;
  
  iVar1 = *(int *)(&DAT_1003abec + param_1 * 4);
  if (iVar1 != 0) {
    bVar2 = true;
    while (bVar2) {
      bVar2 = false;
      for (sVar3 = 0; sVar3 < 4; sVar3 = sVar3 + 1) {
        if (*(int *)(&DAT_100390c4 + sVar3 * 0x24) == iVar1) {
          if (*(int *)(sVar3 * 0x24 + 0x100390cc) < *(int *)(sVar3 * 0x24 + 0x100390c8)) {
            bVar2 = true;
          }
        }
      }
    }
    .glue::DisposeHandle(iVar1);
    *(undefined4 *)(local_3c + 0x6a7c + param_1 * 4) = 0;
  }
  return;
}

