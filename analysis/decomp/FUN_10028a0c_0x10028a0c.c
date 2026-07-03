/* FUN_10028a0c @ 0x10028a0c  calls: TickCount */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10028a0c(undefined4 param_1)

{
  short sVar1;
  short sVar2;
  int iVar3;
  int iVar4;
  char cVar6;
  uint uVar5;
  short sVar7;
  bool bVar8;
  short sVar9;
  int local_7c;
  
  FUN_10020f5c();
  DAT_1003ab02 = '\0';
  DAT_1003ab03 = '\0';
  DAT_1003ab01 = 0;
  DAT_1003ab00 = 0;
  DAT_1003ab04 = 0;
  _DAT_1003b294 = 0;
  if (DAT_100393d0 != '\0') {
    FUN_10017b68();
  }
  if ((DAT_1003ad0e != '\0') && (DAT_100393d0 == '\0')) {
    FUN_10016c90(param_1);
  }
  DAT_100393d0 = '\0';
  FUN_1002de00();
  FUN_10018c88((int)*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9e8));
  .glue::FreeMem();
  FUN_1001882c(1);
  .glue::FreeMem();
  iVar3 = FUN_10015fe4();
  do {
    iVar4 = FUN_10015fe4();
  } while (iVar3 == iVar4);
  iVar3 = FUN_10015fe4();
  do {
    iVar4 = FUN_10015fe4();
  } while (iVar3 == iVar4);
  FUN_10015fe4();
  sVar7 = 2;
  .glue::FlushEvents(0xffff,0);
  bVar8 = false;
  FUN_1001166c(param_1);
  FUN_100115c0(param_1);
  *(undefined1 *)(local_7c + 0x3bde) = 1;
  while (sVar9 = (short)param_1, !bVar8) {
    _DAT_1003b294 = _DAT_1003b294 - 1;
    if ((int)_DAT_1003b294 < 0) {
      if (sVar9 == 1) {
        FUN_1000503c((int)sRam1003aa20,(int)sRam1003aa24,2000,2000);
      }
      else {
        FUN_1000503c(2000,2000,(int)sRam1003aa90,(int)sRam1003aa94);
      }
    }
    else if ((_DAT_1003b294 & 1) != 0) {
      if (sVar9 == 1) {
        FUN_1000503c((int)sRam1003aa20,(int)sRam1003aa24,2000,2000);
      }
      else {
        FUN_1000503c(2000,2000,(int)sRam1003aa90,(int)sRam1003aa94);
      }
    }
    sVar7 = sVar7 + -1;
    if (sVar7 < 1) {
      sVar7 = 2;
      if (*(short *)(sVar9 * 0x70 + 0x1003aa0c) == 1) {
        sVar7 = 1;
      }
      FUN_1002d440();
      FUN_1001166c(param_1);
      if (*(char *)(sVar9 * 0x70 + 0x1003a9d8) == '\0') {
        FUN_1002bc64(param_1);
      }
    }
    else if (*(char *)(sVar9 * 0x70 + 0x1003a9d8) != '\0') {
      FUN_1001166c(param_1);
    }
    FUN_10018b98();
    iVar3 = 0;
    while (cVar6 = FUN_100193a8(), cVar6 == '\0') {
      iVar3 = iVar3 + 1;
    }
    FUN_100193c8();
    if (*(char *)(local_7c + 0x6994) != '\0') {
      iVar4 = .glue::TickCount();
      do {
        uVar5 = .glue::TickCount();
      } while (uVar5 < iVar4 + 10U);
    }
    *(int *)(local_7c + 0x6bec) = _DAT_1003ad60;
    _DAT_1003ad60 = _DAT_1003ad64;
    _DAT_1003ad64 = iVar3;
    FUN_10016784();
    FUN_10028958();
    FUN_10004180();
    FUN_1000f500();
    FUN_1000fd5c(&DAT_1003a9b0 + sVar9 * 0x70,param_1);
    FUN_10028060();
    FUN_100283a0();
    FUN_1000efb4();
    FUN_10004d14();
    if (*(char *)(sVar9 * 0x70 + 0x1003a9ea) == '\0') {
      FUN_100043a0(*(undefined4 *)(sVar9 * 0x70 + 0x1003a9ba),
                   (int)*(short *)(sVar9 * 0x70 + 0x1003a9c8),
                   (int)*(short *)(sVar9 * 0x70 + 0x1003a9c4),
                   (int)*(short *)(sVar9 * 0x70 + 0x1003a9c6),
                   *(undefined4 *)(sVar9 * 0x70 + 0x1003a9b6),
                   (int)*(short *)(sVar9 * 0x70 + 0x1003a9be),
                   (int)*(short *)(sVar9 * 0x70 + 0x1003a9b2),
                   (int)*(short *)(sVar9 * 0x70 + 0x1003a9b4));
      FUN_100115c0(param_1);
      FUN_10014a10(param_1);
    }
    FUN_100289c0();
    if (*(char *)(sVar9 * 0x70 + 0x1003a9d8) == '\0') {
      cVar6 = FUN_100299b4(param_1);
      if (cVar6 == '\0') {
        if (*(char *)(local_7c + 0x6990) == '\0') {
          if (*(char *)(local_7c + 0x6991) != '\0') {
            FUN_10012228(param_1);
            FUN_1000e9c8(param_1,0xffffffff);
          }
        }
        else {
          FUN_10012228(param_1);
          FUN_1000e9c8(param_1,-(*(short *)(sVar9 * 0x70 + 0x1003a9f6) + 1));
          *(undefined1 *)(local_7c + 0x5262) = 1;
        }
      }
      else if (*(short *)(sVar9 * 0x70 + 0x1003aa0c) != 2) {
        FUN_10012228(param_1);
        FUN_1000e9c8(param_1,0xffffffff);
      }
    }
    if (DAT_100393d0 != '\0') {
      FUN_1002707c();
      bVar8 = true;
    }
    if ((*(short *)(sVar9 * 0x70 + 0x1003a9e8) < *(short *)(local_7c + 0x712c)) &&
       (DAT_1003ab03 != '\0')) {
      *(undefined1 *)(sVar9 * 0x70 + 0x1003a9d9) = 1;
      *(undefined1 *)(sVar9 * 0x70 + 0x1003a9db) = 1;
    }
    if ((1 < *(short *)(sVar9 * 0x70 + 0x1003a9e8)) && (DAT_1003ab02 != '\0')) {
      *(undefined1 *)(sVar9 * 0x70 + 0x1003a9db) = 1;
      *(short *)(sVar9 * 0x70 + 0x1003a9e8) = *(short *)(sVar9 * 0x70 + 0x1003a9e8) + -2;
      *(undefined1 *)(sVar9 * 0x70 + 0x1003a9d9) = 1;
    }
    if (*(char *)(sVar9 * 0x70 + 0x1003a9d9) != '\0') {
      FUN_1001873c(0x14);
      *(undefined1 *)(sVar9 * 0x70 + 0x1003a9ea) = 1;
      *(short *)(sVar9 * 0x70 + 0x1003a9e8) = *(short *)(sVar9 * 0x70 + 0x1003a9e8) + 1;
      sVar1 = *(short *)(&DAT_1003a9b0 + sVar9 * 0x70);
      sVar2 = *(short *)(sVar9 * 0x70 + 0x1003a9b4);
      FUN_1002b020(0x1f,100);
      FUN_10028958();
      FUN_10004cb0(*(undefined4 *)(local_7c + 0x6bc8),(int)*(short *)(sVar9 * 0x70 + 0x1003a9c8),
                   (int)*(short *)(sVar9 * 0x70 + 0x1003a9c4),
                   (int)*(short *)(sVar9 * 0x70 + 0x1003a9c6));
      FUN_10014940(param_1);
      FUN_100289c0();
      FUN_10026bb8(sVar1 + 0xc,sVar2 + 0x10,1,2);
      if ((DAT_1003ab03 != '\0') || (DAT_1003ab02 != '\0')) {
        *(undefined4 *)(sVar9 * 0x70 + 0x1003a9ec) = 0;
      }
      if (DAT_1003ad0e == '\0') {
        FUN_100153d0(param_1);
      }
    }
    if (*(char *)(sVar9 * 0x70 + 0x1003a9ea) != '\0') {
      bVar8 = true;
    }
  }
  if (((DAT_100393d0 == '\0') && (DAT_1003ad0e != '\0')) && (*(char *)(local_7c + 0x5262) == '\0'))
  {
    if (*(char *)(sVar9 * 0x70 + 0x1003a9d9) == '\0') {
      *(short *)(sVar9 * 0x70 + 0x1003a9e8) = *(short *)(sVar9 * 0x70 + 0x1003a9e8) + 1;
    }
    FUN_10016f80(*(char *)(sVar9 * 0x70 + 0x1003a9d9) == '\0',param_1);
  }
  FUN_1001873c(0x14);
  .glue::FlushEvents(0xffff,0);
  return;
}

