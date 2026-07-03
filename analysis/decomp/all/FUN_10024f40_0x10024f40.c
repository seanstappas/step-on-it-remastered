
undefined4 FUN_10024f40(void)

{
  short sVar1;
  short sVar2;
  
  sVar2 = 1;
  while( true ) {
    if (2 < sVar2) {
      return 0;
    }
    sVar1 = FUN_100250bc(*(undefined4 *)(&DAT_1003a2b0 + sVar2 * 0x1c));
    if (1 < sVar1) {
      return 1;
    }
    sVar1 = FUN_100250bc(*(undefined4 *)(sVar2 * 0x1c + 0x1003a2b4));
    if (1 < sVar1) {
      return 1;
    }
    sVar1 = FUN_100250bc(*(undefined4 *)(sVar2 * 0x1c + 0x1003a2b8));
    if (1 < sVar1) {
      return 1;
    }
    sVar1 = FUN_100250bc(*(undefined4 *)(sVar2 * 0x1c + 0x1003a2bc));
    if (1 < sVar1) {
      return 1;
    }
    sVar1 = FUN_100250bc(*(undefined4 *)(sVar2 * 0x1c + 0x1003a2c0));
    if (1 < sVar1) {
      return 1;
    }
    sVar1 = FUN_100250bc(*(undefined4 *)(sVar2 * 0x1c + 0x1003a2c4));
    if (1 < sVar1) {
      return 1;
    }
    sVar1 = FUN_100250bc(*(undefined4 *)(sVar2 * 0x1c + 0x1003a2c8));
    if (1 < sVar1) break;
    sVar2 = sVar2 + 1;
  }
  return 1;
}

