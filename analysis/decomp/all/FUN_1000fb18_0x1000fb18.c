
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1000fb18(void)

{
  if ((DAT_100370e4 == '\0') || (DAT_1003ab6e == '\0')) {
    FUN_10004bb4(_DAT_1003ad28,0xf,0x140,4);
    if (*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9f6) < 0) {
      FUN_1002e48c(0,0x15c,8);
    }
    else {
      FUN_1002e48c((int)*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9f6),0x15c,8);
    }
    FUN_10004bb4(_DAT_1003ad28,0x10,0x16e,4);
    FUN_1002e48c((int)*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9fa),0x184,8);
    FUN_10004bb4(_DAT_1003ad28,0x11,0x1b8,4);
    FUN_1002e48c((int)*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9fc),0x1d4,8);
  }
  else {
    FUN_10004bb4(_DAT_1003ad28,0xf,0x140,4);
    if (sRam1003aa66 < 0) {
      FUN_1002e48c(0,0x15c,0);
    }
    else {
      FUN_1002e48c((int)sRam1003aa66,0x15c,0);
    }
    if (sRam1003aad6 < 0) {
      FUN_1002e48c(0,0x15c,0x10);
    }
    else {
      FUN_1002e48c((int)sRam1003aad6,0x15c,0x10);
    }
    FUN_10004bb4(_DAT_1003ad28,0x10,0x16e,4);
    FUN_1002e48c((int)sRam1003aa6a,0x184,0);
    FUN_1002e48c((int)sRam1003aada,0x184,0x10);
    FUN_10004bb4(_DAT_1003ad28,0x11,0x1b8,4);
    FUN_1002e48c((int)sRam1003aa6c,0x1d4,0);
    FUN_1002e48c((int)sRam1003aadc,0x1d4,0x10);
  }
  return;
}

