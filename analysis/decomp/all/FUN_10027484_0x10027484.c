
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10027484(void)

{
  short sVar1;
  
  _DAT_1003a36e = 0;
  _DAT_1003a36c = 0xffff;
  for (sVar1 = 0; sVar1 < 0x3c; sVar1 = sVar1 + 1) {
    *(short *)(sVar1 * 0x18 + 0x1003a426) = sVar1 + 1;
  }
  uRam1003a9ae = 0xffff;
  return;
}

