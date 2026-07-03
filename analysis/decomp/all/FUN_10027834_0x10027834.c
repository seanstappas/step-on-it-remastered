
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_10027834(short param_1,short param_2)

{
  short sVar1;
  int iVar2;
  
  iVar2 = -1;
  for (sVar1 = _DAT_1003ad58; sVar1 != -1; sVar1 = *(short *)(sVar1 * 0x10 + 0x1003a37e)) {
    if ((param_1 == *(short *)(&DAT_1003a370 + sVar1 * 0x10)) &&
       (param_2 == *(short *)(sVar1 * 0x10 + 0x1003a372))) {
      iVar2 = (int)sVar1;
    }
  }
  return iVar2;
}

