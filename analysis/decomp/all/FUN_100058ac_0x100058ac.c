
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100058ac(void)

{
  short sVar1;
  
  _DAT_1003a36a = 0;
  _DAT_1003a368 = 1;
  uRam10038eee = 0;
  for (sVar1 = 1; sVar1 < 0x3c; sVar1 = sVar1 + 1) {
    *(int *)(&DAT_10037d58 + sVar1 * 4) = sVar1 * 0x46 + 0x10037e7e;
    *(short *)(sVar1 * 0x46 + 0x10037e86) = sVar1 + 1;
    *(short *)(&DAT_10037e48 + sVar1 * 0x46) = sVar1 + -1;
  }
  return;
}

