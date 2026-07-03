
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10003828(void)

{
  short sVar1;
  
  _DAT_10037872 = 0;
  for (sVar1 = 0; sVar1 < 0x3c; sVar1 = sVar1 + 1) {
    *(short *)(sVar1 * 0x14 + 0x100378a0) = sVar1 + 1;
  }
  uRam10037d3c = 0xffff;
  for (sVar1 = 0; sVar1 < 0x14; sVar1 = sVar1 + 1) {
    *(undefined2 *)(&DAT_10037874 + sVar1 * 2) = 0xffff;
  }
  uRam1003789c = 0xffff;
  _DAT_10037524 = 0;
  return;
}

