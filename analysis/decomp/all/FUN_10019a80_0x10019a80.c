
void FUN_10019a80(undefined4 *param_1,int param_2)

{
  int iVar1;
  undefined4 *puVar2;
  short sVar3;
  short sVar4;
  
  if (param_1 != (undefined4 *)0x0) {
    puVar2 = (undefined4 *)*param_1;
    if (iRam10039088 != iRam10039084) {
      iRam10039088 = iRam10039084;
      for (sVar3 = 0; sVar3 < 0xc; sVar3 = sVar3 + 1) {
        *(undefined4 *)(sVar3 * 4 + 0x1003908c) = 0;
      }
    }
    for (sVar3 = 0; sVar3 < 0xc; sVar3 = sVar3 + 1) {
      if (*(undefined4 **)(sVar3 * 4 + 0x1003908c) == param_1) {
        return;
      }
    }
    for (sVar3 = 0; sVar3 < 4; sVar3 = sVar3 + 1) {
      if (*(int *)(sVar3 * 0x24 + 0x100390c8) < *(int *)(sVar3 * 0x24 + 0x100390cc)) {
        *(int *)(sVar3 * 0x24 + 0x100390d4) = param_2;
        *(undefined4 *)(sVar3 * 0x24 + 0x100390d0) = puVar2[1];
        *(undefined4 *)(sVar3 * 0x24 + 0x100390d8) = 0;
        *(undefined4 *)(sVar3 * 0x24 + 0x100390c8) = 0;
        *(undefined4 **)(&DAT_100390c4 + sVar3 * 0x24) = param_1;
        *(undefined4 *)(sVar3 * 0x24 + 0x100390cc) = 0;
        *(undefined4 *)(sVar3 * 0x24 + 0x100390c8) = *puVar2;
        return;
      }
    }
    sVar3 = 0;
    iVar1 = iRam100390d4;
    for (sVar4 = 1; sVar4 < 4; sVar4 = sVar4 + 1) {
      if (*(int *)(sVar4 * 0x24 + 0x100390d4) < iVar1) {
        iVar1 = *(int *)(sVar4 * 0x24 + 0x100390d4);
        sVar3 = sVar4;
      }
    }
    if (iVar1 <= param_2) {
      *(int *)(sVar3 * 0x24 + 0x100390d4) = param_2;
      *(undefined4 *)(sVar3 * 0x24 + 0x100390d0) = puVar2[1];
      *(undefined4 *)(sVar3 * 0x24 + 0x100390d8) = 0;
      *(undefined4 *)(sVar3 * 0x24 + 0x100390c8) = 0;
      *(undefined4 **)(&DAT_100390c4 + sVar3 * 0x24) = param_1;
      *(undefined4 *)(sVar3 * 0x24 + 0x100390cc) = 0;
      *(undefined4 *)(sVar3 * 0x24 + 0x100390c8) = *puVar2;
    }
  }
  return;
}

