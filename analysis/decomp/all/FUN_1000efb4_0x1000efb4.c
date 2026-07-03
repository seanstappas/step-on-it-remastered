
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1000efb4(void)

{
  int iVar1;
  short sVar2;
  
  if ((DAT_1003ab6e == '\0') || (DAT_100370e4 == '\0')) {
    if (DAT_1003ab71 == '\0') {
      FUN_1002b900(*(undefined4 *)(_DAT_100394a2 * 0x70 + 0x1003a9ec),&DAT_1003abc2);
      for (iVar1 = 0; sVar2 = (short)iVar1, sVar2 < 10; iVar1 = iVar1 + 1) {
        if (*(short *)(&DAT_1003abae + sVar2 * 2) != *(short *)(&DAT_1003abc2 + sVar2 * 2)) {
          FUN_100043a0(_DAT_1003ad28,*(short *)(&DAT_1003abae + sVar2 * 2) + 5,
                       (9 - iVar1) * 8 + 0x50,8,_DAT_1003ad28,
                       *(short *)(&DAT_1003abc2 + sVar2 * 2) + 5,(9 - iVar1) * 8 + 0x50,8);
        }
      }
    }
    else {
      FUN_1002b900(*(undefined4 *)(_DAT_100394a2 * 0x70 + 0x1003a9ec),&DAT_1003abae);
      for (iVar1 = 0; sVar2 = (short)iVar1, sVar2 < 10; iVar1 = iVar1 + 1) {
        if (*(short *)(&DAT_1003abae + sVar2 * 2) != *(short *)(&DAT_1003abc2 + sVar2 * 2)) {
          FUN_100043a0(_DAT_1003ad28,*(short *)(&DAT_1003abc2 + sVar2 * 2) + 5,
                       (9 - iVar1) * 8 + 0x50,8,_DAT_1003ad28,
                       *(short *)(&DAT_1003abae + sVar2 * 2) + 5,(9 - iVar1) * 8 + 0x50,8);
        }
      }
    }
  }
  else if (DAT_1003ab71 == '\0') {
    FUN_1002b900(uRam1003aa5c,&DAT_1003abc2);
    FUN_1002b900(uRam1003aacc,&DAT_1003ab86);
    for (iVar1 = 0; sVar2 = (short)iVar1, sVar2 < 10; iVar1 = iVar1 + 1) {
      if (*(short *)(&DAT_1003abae + sVar2 * 2) != *(short *)(&DAT_1003abc2 + sVar2 * 2)) {
        FUN_100043a0(_DAT_1003ad28,*(short *)(&DAT_1003abae + sVar2 * 2) + 5,(9 - iVar1) * 8 + 0x50,
                     0,_DAT_1003ad28,*(short *)(&DAT_1003abc2 + sVar2 * 2) + 5,
                     (9 - iVar1) * 8 + 0x50,0);
      }
      if (*(short *)(&DAT_1003ab72 + sVar2 * 2) != *(short *)(&DAT_1003ab86 + sVar2 * 2)) {
        FUN_100043a0(_DAT_1003ad28,*(short *)(&DAT_1003ab72 + sVar2 * 2) + 5,(9 - iVar1) * 8 + 0x50,
                     0x10,_DAT_1003ad28,*(short *)(&DAT_1003ab86 + sVar2 * 2) + 5,
                     (9 - iVar1) * 8 + 0x50,0x10);
      }
    }
  }
  else {
    FUN_1002b900(uRam1003aa5c,&DAT_1003abae);
    FUN_1002b900(uRam1003aacc,&DAT_1003ab72);
    for (iVar1 = 0; sVar2 = (short)iVar1, sVar2 < 10; iVar1 = iVar1 + 1) {
      if (*(short *)(&DAT_1003abae + sVar2 * 2) != *(short *)(&DAT_1003abc2 + sVar2 * 2)) {
        FUN_100043a0(_DAT_1003ad28,*(short *)(&DAT_1003abc2 + sVar2 * 2) + 5,(9 - iVar1) * 8 + 0x50,
                     0,_DAT_1003ad28,*(short *)(&DAT_1003abae + sVar2 * 2) + 5,
                     (9 - iVar1) * 8 + 0x50,0);
      }
      if (*(short *)(&DAT_1003ab72 + sVar2 * 2) != *(short *)(&DAT_1003ab86 + sVar2 * 2)) {
        FUN_100043a0(_DAT_1003ad28,*(short *)(&DAT_1003ab86 + sVar2 * 2) + 5,(9 - iVar1) * 8 + 0x50,
                     0x10,_DAT_1003ad28,*(short *)(&DAT_1003ab72 + sVar2 * 2) + 5,
                     (9 - iVar1) * 8 + 0x50,0x10);
      }
    }
  }
  DAT_1003ab71 = DAT_1003ab71 == '\0';
  return;
}

