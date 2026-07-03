
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100274e8(void)

{
  short sVar1;
  
  _DAT_1003ad5a = 0;
  _DAT_1003ad58 = 0xffff;
  for (sVar1 = 0; sVar1 < 10; sVar1 = sVar1 + 1) {
    *(short *)(sVar1 * 0x10 + 0x1003a37e) = sVar1 + 1;
  }
  uRam1003a40e = 0xffff;
  return;
}

