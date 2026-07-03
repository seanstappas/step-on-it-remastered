
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10017a70(void)

{
  short sVar1;
  short sVar2;
  
  for (sVar1 = 1; sVar2 = _DAT_1003a36a, sVar1 < 0x14; sVar1 = sVar1 + 1) {
    (&DAT_10038ff8)[sVar1 * 4] = 0;
  }
  for (; sVar2 != 0; sVar2 = *(short *)(sVar2 * 0x46 + 0x10037e86)) {
    (&DAT_10038ff8)[*(short *)(&DAT_10034a70 + *(short *)(sVar2 * 0x46 + 0x10037e4a) * 2) * 4] = 1;
  }
  if (_DAT_1003b28e != 0) {
    (&DAT_10038ff8)[*(short *)(&DAT_10034a70 + _DAT_1003b28e * 2) * 4] = 1;
  }
  DAT_1003ad0e = 0;
  if (((&DAT_10038ff8)[sRam10034a8c * 4] != '\0') || ((&DAT_10038ff8)[sRam10034a8a * 4] != '\0')) {
    DAT_1003ad0e = 1;
  }
  return;
}

