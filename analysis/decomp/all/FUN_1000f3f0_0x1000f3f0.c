
void FUN_1000f3f0(short param_1,short param_2)

{
  int iVar1;
  short sStack0000001e;
  
  sStack0000001e = param_2;
  if (*(short *)(param_1 * 0x70 + 0x1003a9f0) < 0x3e9) {
    if ((DAT_1003ab6e == '\0') || (DAT_100370e4 == '\0')) {
      FUN_10018ac4();
    }
    else {
      if ((param_1 == 1) && ((1000 < sRam1003aad0 || (cRam1003aaca != '\0')))) {
        FUN_10018ac4();
      }
      if ((param_1 == 2) && ((1000 < sRam1003aa60 || (cRam1003aa5a != '\0')))) {
        FUN_10018ac4();
      }
    }
  }
  iVar1 = (int)sStack0000001e + (int)*(short *)(param_1 * 0x70 + 0x1003a9f0);
  if (30000 < iVar1) {
    iVar1 = 30000;
  }
  *(short *)(param_1 * 0x70 + 0x1003a9f0) = (short)iVar1;
  return;
}

