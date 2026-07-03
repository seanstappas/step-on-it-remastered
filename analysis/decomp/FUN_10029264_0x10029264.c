/* FUN_10029264 @ 0x10029264  calls: Button, GetKeys */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10029264(undefined4 param_1)

{
  short sVar1;
  short sVar2;
  undefined4 uVar3;
  int iVar4;
  int iVar5;
  char cVar6;
  short sVar7;
  bool bVar8;
  short sVar9;
  int local_7c;
  
  DAT_1003b6bc = '\0';
  DAT_1003ab02 = '\0';
  DAT_1003ab03 = '\0';
  DAT_1003ab01 = '\0';
  DAT_1003ab00 = '\0';
  DAT_1003ab04 = 0;
  DAT_100393d0 = 0;
  _DAT_1003b294 = 0;
  uVar3 = .glue::GetResource(0x44454d4f,0x80);
  *(undefined4 *)(local_7c + 0x7550) = uVar3;
  .glue::MoveHHi(*(undefined4 *)(local_7c + 0x7550));
  .glue::HLock(*(undefined4 *)(local_7c + 0x7550));
  if (*(int *)(local_7c + 0x7550) == 0) {
    FUN_100192f8(5);
  }
  *(undefined4 *)(local_7c + 0x7554) = **(undefined4 **)(local_7c + 0x7550);
  if (DAT_1003b6bc == '\0') {
    FUN_1002a09c();
  }
  else {
    FUN_10029c08();
  }
  FUN_1002de00();
  FUN_10018c88(2);
  FUN_1001882c(1);
  iVar4 = FUN_10015fe4();
  do {
    iVar5 = FUN_10015fe4();
  } while (iVar4 == iVar5);
  iVar4 = FUN_10015fe4();
  do {
    iVar5 = FUN_10015fe4();
  } while (iVar4 == iVar5);
  FUN_10015fe4();
  sVar7 = 2;
  .glue::FlushEvents(0xffff,0);
  bVar8 = false;
  FUN_1001166c(param_1);
  FUN_100115c0(param_1);
  *(undefined1 *)(local_7c + 0x3bde) = 1;
  while (!bVar8) {
    sVar9 = (short)param_1;
    if (sVar9 == 1) {
      FUN_1000503c((int)sRam1003aa20,(int)sRam1003aa24,2000,2000);
    }
    else {
      FUN_1000503c(2000,2000,(int)sRam1003aa90,(int)sRam1003aa94);
    }
    sVar7 = sVar7 + -1;
    if (sVar7 < 1) {
      sVar7 = 2;
      if (DAT_1003b6bc == '\0') {
        FUN_10029ca0();
      }
      else {
        FUN_1002d440();
        FUN_1002a15c();
      }
      FUN_1001166c(param_1);
      if (*(char *)(sVar9 * 0x70 + 0x1003a9d8) == '\0') {
        FUN_1002bc64(param_1);
      }
    }
    else if (*(char *)(sVar9 * 0x70 + 0x1003a9d8) != '\0') {
      FUN_1001166c(param_1);
    }
    FUN_10018b98();
    iVar4 = 0;
    while (cVar6 = FUN_100193a8(), cVar6 == '\0') {
      iVar4 = iVar4 + 1;
    }
    FUN_100193c8();
    *(int *)(local_7c + 0x6bec) = _DAT_1003ad60;
    _DAT_1003ad60 = _DAT_1003ad64;
    _DAT_1003ad64 = iVar4;
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
        if (DAT_1003ab00 == '\0') {
          if (DAT_1003ab01 != '\0') {
            FUN_10012228(param_1);
            FUN_1000e9c8(param_1,0xffffffff);
          }
        }
        else {
          FUN_10012228(param_1);
          FUN_1000e9c8(param_1,-(*(short *)(sVar9 * 0x70 + 0x1003a9f6) + 1));
        }
      }
      else if (sRam1003aa7c != 2) {
        FUN_10012228(param_1);
        FUN_1000e9c8(param_1,0xffffffff);
      }
    }
    .glue::GetKeys(local_7c + 0x758c);
    cVar6 = .glue::Button();
    if ((cVar6 != '\0') || (cVar6 = FUN_1002d388(0x3100), cVar6 != '\0')) {
      *(undefined1 *)(sVar9 * 0x70 + 0x1003a9ea) = 1;
      *(undefined2 *)(sVar9 * 0x70 + 0x1003a9f6) = 0xffff;
    }
    if (((*(char *)(sVar9 * 0x70 + 0x1003a9d9) != '\0') || (DAT_1003ab03 != '\0')) ||
       (DAT_1003ab02 != '\0')) {
      FUN_100189ac();
      if (DAT_1003ab02 != '\0') {
        *(short *)(sVar9 * 0x70 + 0x1003a9e8) = *(short *)(sVar9 * 0x70 + 0x1003a9e8) + -2;
      }
      *(undefined1 *)(sVar9 * 0x70 + 0x1003a9ea) = 1;
      *(short *)(sVar9 * 0x70 + 0x1003a9e8) = *(short *)(sVar9 * 0x70 + 0x1003a9e8) + 1;
      sVar1 = *(short *)(sVar9 * 0x70 + 0x1003a9b4);
      sVar2 = *(short *)(&DAT_1003a9b0 + sVar9 * 0x70);
      FUN_1002b020(0x1f,100);
      FUN_10028958();
      FUN_10004cb0(*(undefined4 *)(local_7c + 0x6bc8),(int)*(short *)(sVar9 * 0x70 + 0x1003a9c8),
                   (int)*(short *)(sVar9 * 0x70 + 0x1003a9c4),
                   (int)*(short *)(sVar9 * 0x70 + 0x1003a9c6));
      FUN_100289c0();
      FUN_10026bb8(sVar2 + 0xc,sVar1 + 0x10,1,2);
      *(int *)(sVar9 * 0x70 + 0x1003a9ec) =
           *(int *)(sVar9 * 0x70 + 0x1003a9ec) +
           (int)*(short *)(sVar9 * 0x70 + 0x1003a9f4) * (int)*(short *)(sVar9 * 0x70 + 0x1003a9f0);
    }
    if (*(char *)(sVar9 * 0x70 + 0x1003a9ea) != '\0') {
      bVar8 = true;
    }
  }
  FUN_100189ac();
  if (DAT_1003b6bc == '\0') {
    .glue::HUnlock(*(undefined4 *)(local_7c + 0x7560));
    .glue::ReleaseResource(*(undefined4 *)(local_7c + 0x7560));
  }
  else {
    FUN_10029b6c();
  }
  .glue::HUnlock(*(undefined4 *)(local_7c + 0x7550));
  .glue::ReleaseResource(*(undefined4 *)(local_7c + 0x7550));
  .glue::FlushEvents(0xffff,0);
  return;
}

