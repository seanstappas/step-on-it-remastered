
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10011428(int param_1,int param_2)

{
  short sVar1;
  
  if (DAT_100370e4 == '\0') {
    param_1 = 1;
  }
  FUN_10028958();
  sVar1 = (short)param_1;
  if ((DAT_100370e4 == '\0') || (DAT_1003ab6e == '\0')) {
    if (*(short *)(sVar1 * 0x70 + 0x1003a9f4) == 1) {
      FUN_10004bb4(_DAT_1003ad28,param_2 + 0x1a,0xb4,8);
    }
    else {
      FUN_100043a0(_DAT_1003ad28,*(short *)(sVar1 * 0x70 + 0x1003a9f4) + 0x1a,0xb4,8,_DAT_1003ad28,
                   param_2 + 0x1a,0xb4,8);
    }
    *(short *)(sVar1 * 0x70 + 0x1003a9f4) = (short)param_2;
  }
  else {
    if (*(short *)(sVar1 * 0x70 + 0x1003a9f4) == 1) {
      FUN_10004bb4(_DAT_1003ad28,param_2 + 0x1a,0xb4,param_1 * 0x10 + -0x10);
    }
    else {
      FUN_100043a0(_DAT_1003ad28,*(short *)(sVar1 * 0x70 + 0x1003a9f4) + 0x1a,0xb4,
                   param_1 * 0x10 + -0x10,_DAT_1003ad28,param_2 + 0x1a,0xb4,param_1 * 0x10 + -0x10);
    }
    *(short *)(sVar1 * 0x70 + 0x1003a9f4) = (short)param_2;
  }
  FUN_100289c0();
  return;
}

