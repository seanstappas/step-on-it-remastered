
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10004180(void)

{
  short sVar1;
  
  for (sVar1 = 1; sVar1 <= _DAT_100375a0; sVar1 = sVar1 + 1) {
    if (*(short *)(&DAT_100375a2 + sVar1 * 0xc) == 1) {
      FUN_1000195c(*(undefined4 *)(sVar1 * 0xc + 0x100375a4),
                   (int)*(short *)(sVar1 * 0xc + 0x100375a8),
                   (int)*(short *)(sVar1 * 0xc + 0x100375aa),
                   (int)*(short *)(sVar1 * 0xc + 0x100375ac),_DAT_1003ad44,(int)_DAT_1003ad40);
      FUN_1000195c(*(undefined4 *)(sVar1 * 0xc + 0x100375a4),
                   (int)*(short *)(sVar1 * 0xc + 0x100375a8),
                   (int)*(short *)(sVar1 * 0xc + 0x100375aa),
                   (int)*(short *)(sVar1 * 0xc + 0x100375ac),_DAT_1003b258,_DAT_1003b254);
      if (DAT_1003759e != '\0') {
        FUN_1000195c(*(undefined4 *)(sVar1 * 0xc + 0x100375a4),
                     (int)*(short *)(sVar1 * 0xc + 0x100375a8),
                     (int)*(short *)(sVar1 * 0xc + 0x100375aa),
                     (int)*(short *)(sVar1 * 0xc + 0x100375ac),_DAT_1003ad4c,_DAT_1003ad48);
      }
    }
    else if (DAT_1003759e == '\0') {
      FUN_100015c0(*(undefined4 *)(sVar1 * 0xc + 0x100375a4),
                   (int)*(short *)(sVar1 * 0xc + 0x100375a8),
                   (int)*(short *)(sVar1 * 0xc + 0x100375aa),
                   (int)*(short *)(sVar1 * 0xc + 0x100375ac));
    }
    else {
      FUN_10001724(*(undefined4 *)(sVar1 * 0xc + 0x100375a4),
                   (int)*(short *)(sVar1 * 0xc + 0x100375a8),
                   (int)*(short *)(sVar1 * 0xc + 0x100375aa),
                   (int)*(short *)(sVar1 * 0xc + 0x100375ac));
    }
  }
  _DAT_100375a0 = 0;
  return;
}

