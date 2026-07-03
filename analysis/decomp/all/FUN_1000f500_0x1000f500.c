
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1000f500(void)

{
  int iVar1;
  short sVar2;
  
  if (3 < _DAT_10038eb0) {
    _DAT_10038eb0 = 3;
  }
  _DAT_10038eb0 = _DAT_10038eb0 + -1;
  if (_DAT_10038eb0 < 1) {
    _DAT_10038eb0 = 3;
    if ((DAT_1003ab6e == '\0') || (DAT_100370e4 == '\0')) {
      *(short *)(_DAT_100394a2 * 0x70 + 0x1003a9f0) =
           *(short *)(_DAT_100394a2 * 0x70 + 0x1003a9f0) + -1;
      if (*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9f0) == 1000) {
        FUN_10018b24();
      }
      if (*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9f0) < 0) {
        *(undefined2 *)(_DAT_100394a2 * 0x70 + 0x1003a9f0) = 0;
        if (*(char *)(_DAT_100394a2 * 0x70 + 0x1003a9d8) == '\0') {
          FUN_1000e9c8((int)_DAT_100394a2,0xffffffff);
        }
        FUN_10012228((int)_DAT_100394a2);
        if (DAT_1003ab6e != '\0') {
          if (cRam1003aab8 == '\0') {
            FUN_1000e9c8(2,0xffffffff);
          }
          FUN_10012228(2);
        }
      }
      if (DAT_1003ab70 == '\0') {
        FUN_1002b950((int)*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9f0),&DAT_1003abe0);
        for (iVar1 = 0; sVar2 = (short)iVar1, sVar2 < 5; iVar1 = iVar1 + 1) {
          if (*(short *)(&DAT_1003abd6 + sVar2 * 2) != *(short *)(&DAT_1003abe0 + sVar2 * 2)) {
            FUN_100043a0(_DAT_1003ad28,*(short *)(&DAT_1003abd6 + sVar2 * 2) + 5,
                         (4 - iVar1) * 8 + 0xf4,8,_DAT_1003ad28,
                         *(short *)(&DAT_1003abe0 + sVar2 * 2) + 5,(4 - iVar1) * 8 + 0xf4,8);
          }
        }
      }
      else {
        FUN_1002b950((int)*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9f0),&DAT_1003abd6);
        for (iVar1 = 0; sVar2 = (short)iVar1, sVar2 < 5; iVar1 = iVar1 + 1) {
          if (*(short *)(&DAT_1003abd6 + sVar2 * 2) != *(short *)(&DAT_1003abe0 + sVar2 * 2)) {
            FUN_100043a0(_DAT_1003ad28,*(short *)(&DAT_1003abe0 + sVar2 * 2) + 5,
                         (4 - iVar1) * 8 + 0xf4,8,_DAT_1003ad28,
                         *(short *)(&DAT_1003abd6 + sVar2 * 2) + 5,(4 - iVar1) * 8 + 0xf4,8);
          }
        }
      }
    }
    else {
      if ((sRam1003aa60 == 1000) && (cRam1003aa5a == '\0')) {
        FUN_10018b24();
      }
      if ((sRam1003aad0 == 1000) && (cRam1003aaca == '\0')) {
        FUN_10018b24();
      }
      if (cRam1003aa5a == '\0') {
        sRam1003aa60 = sRam1003aa60 + -1;
      }
      if (sRam1003aa60 < 0) {
        sRam1003aa60 = 0;
        if (cRam1003aa48 == '\0') {
          FUN_1000e9c8(1,0xffffffff);
        }
        FUN_10012228(1);
      }
      if (cRam1003aaca == '\0') {
        sRam1003aad0 = sRam1003aad0 + -1;
      }
      if (sRam1003aad0 < 0) {
        sRam1003aad0 = 0;
        if (cRam1003aab8 == '\0') {
          FUN_1000e9c8(2,0xffffffff);
        }
        FUN_10012228(2);
      }
      if (DAT_1003ab70 == '\0') {
        FUN_1002b950((int)sRam1003aa60,&DAT_1003abe0);
        FUN_1002b950((int)sRam1003aad0,&DAT_1003aba4);
        for (iVar1 = 0; sVar2 = (short)iVar1, sVar2 < 5; iVar1 = iVar1 + 1) {
          if (*(short *)(&DAT_1003abd6 + sVar2 * 2) != *(short *)(&DAT_1003abe0 + sVar2 * 2)) {
            FUN_100043a0(_DAT_1003ad28,*(short *)(&DAT_1003abd6 + sVar2 * 2) + 5,
                         (4 - iVar1) * 8 + 0xf4,0,_DAT_1003ad28,
                         *(short *)(&DAT_1003abe0 + sVar2 * 2) + 5,(4 - iVar1) * 8 + 0xf4,0);
          }
          if (*(short *)(&DAT_1003ab9a + sVar2 * 2) != *(short *)(&DAT_1003aba4 + sVar2 * 2)) {
            FUN_100043a0(_DAT_1003ad28,*(short *)(&DAT_1003ab9a + sVar2 * 2) + 5,
                         (4 - iVar1) * 8 + 0xf4,0x10,_DAT_1003ad28,
                         *(short *)(&DAT_1003aba4 + sVar2 * 2) + 5,(4 - iVar1) * 8 + 0xf4,0x10);
          }
        }
      }
      else {
        FUN_1002b950((int)sRam1003aa60,&DAT_1003abd6);
        FUN_1002b950((int)sRam1003aad0,&DAT_1003ab9a);
        for (iVar1 = 0; sVar2 = (short)iVar1, sVar2 < 5; iVar1 = iVar1 + 1) {
          if (*(short *)(&DAT_1003abd6 + sVar2 * 2) != *(short *)(&DAT_1003abe0 + sVar2 * 2)) {
            FUN_100043a0(_DAT_1003ad28,*(short *)(&DAT_1003abe0 + sVar2 * 2) + 5,
                         (4 - iVar1) * 8 + 0xf4,0,_DAT_1003ad28,
                         *(short *)(&DAT_1003abd6 + sVar2 * 2) + 5,(4 - iVar1) * 8 + 0xf4,0);
          }
          if (*(short *)(&DAT_1003ab9a + sVar2 * 2) != *(short *)(&DAT_1003aba4 + sVar2 * 2)) {
            FUN_100043a0(_DAT_1003ad28,*(short *)(&DAT_1003aba4 + sVar2 * 2) + 5,
                         (4 - iVar1) * 8 + 0xf4,0x10,_DAT_1003ad28,
                         *(short *)(&DAT_1003ab9a + sVar2 * 2) + 5,(4 - iVar1) * 8 + 0xf4,0x10);
          }
        }
      }
    }
    DAT_1003ab70 = DAT_1003ab70 == '\0';
  }
  return;
}

