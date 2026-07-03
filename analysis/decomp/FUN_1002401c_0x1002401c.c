/* FUN_1002401c @ 0x1002401c  calls: Random, TickCount */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002401c(short param_1)

{
  int iVar1;
  bool bVar2;
  char cVar8;
  short sVar6;
  uint uVar3;
  short sVar7;
  int iVar4;
  char cVar9;
  uint uVar5;
  int iVar10;
  short asStack_600a8 [196580];
  int local_cc;
  short local_a8 [48];
  undefined1 auStack_48 [8];
  
  bVar2 = false;
  cVar8 = FUN_100248fc();
  uRam1003b260 = 0;
  uRam1003b25e = 0;
  _DAT_1003b25c = 0;
  .glue::RGBForeColor(&DAT_1003b25c);
  .glue::CopyBits(*(int *)(local_cc + 0x7568) + 2,*(int *)(local_cc + 0x7570) + 2,&DAT_1003b6ec,
                  &DAT_1003b6f4,0,0);
  .glue::SetGDevice(*(undefined4 *)(local_cc + 0x756c));
  .glue::SetPort(*(undefined4 *)(local_cc + 0x7570));
  .glue::SetRect(auStack_48,0x96,0xd7,0x1ea,0x113);
  uRam1003b260 = 0;
  uRam1003b25e = 0;
  _DAT_1003b25c = 0;
  .glue::RGBForeColor(&DAT_1003b25c);
  .glue::PaintRect(auStack_48);
  .glue::PenSize(3,3);
  uRam1003b260 = 50000;
  .glue::RGBForeColor(&DAT_1003b25c);
  .glue::FrameRect(auStack_48);
  if (param_1 != 0) {
    .glue::SetRect(auStack_48,0xf0,0x11d,0x18b,0x14f);
    uRam1003b260 = 0;
    uRam1003b25e = 0;
    _DAT_1003b25c = 0;
    .glue::RGBForeColor(&DAT_1003b25c);
    .glue::PaintRect(auStack_48);
    .glue::PenSize(3,3);
    _DAT_1003b25c = 50000;
    .glue::RGBForeColor(&DAT_1003b25c);
    .glue::FrameRect(auStack_48);
    uRam1003b260 = 0;
    uRam1003b25e = 0;
    _DAT_1003b25c = 0;
    if (param_1 == 1) {
      uRam1003b260 = 50000;
    }
    else {
      uRam1003b25e = 35000;
    }
    .glue::RGBForeColor(&DAT_1003b25c);
    .glue::TextSize(0x18);
    .glue::TextFace(1);
    .glue::TextFont(0x14);
    sVar6 = .glue::StringWidth(&DAT_1003700d);
    uVar3 = (int)sRam1003b6fa - (int)sVar6;
    .glue::MoveTo(((int)uVar3 >> 1) + (uint)((int)uVar3 < 0 && (uVar3 & 1) != 0),0x140);
    if (param_1 == 1) {
      .glue::DrawString(&DAT_1003700d);
    }
    else {
      .glue::DrawString(local_cc + 0x2ea6);
    }
  }
  .glue::SetGDevice(*(undefined4 *)(local_cc + 0x7564));
  .glue::SetPort(*(undefined4 *)(local_cc + 0x7568));
  .glue::SetPort(*(undefined4 *)(local_cc + 0x7534));
  .glue::SetRect(auStack_48,sRam1003b6ee + 0x96,_DAT_1003b6ec + 0xd7,sRam1003b6ee + 0x1ea,
                 _DAT_1003b6ec + 0x113);
  uRam1003b260 = 0;
  uRam1003b25e = 0;
  _DAT_1003b25c = 0;
  .glue::RGBForeColor(&DAT_1003b25c);
  .glue::PaintRect(auStack_48);
  .glue::PenSize(3,3);
  uRam1003b260 = 50000;
  .glue::RGBForeColor(&DAT_1003b25c);
  .glue::FrameRect(auStack_48);
  if (param_1 != 0) {
    .glue::SetRect(auStack_48,sRam1003b6ee + 0xf0,_DAT_1003b6ec + 0x11d,sRam1003b6ee + 0x18b,
                   _DAT_1003b6ec + 0x14f);
    uRam1003b260 = 0;
    uRam1003b25e = 0;
    _DAT_1003b25c = 0;
    .glue::RGBForeColor(&DAT_1003b25c);
    .glue::PaintRect(auStack_48);
    .glue::PenSize(3,3);
    _DAT_1003b25c = 50000;
    .glue::RGBForeColor(&DAT_1003b25c);
    .glue::FrameRect(auStack_48);
    uRam1003b260 = 0;
    uRam1003b25e = 0;
    _DAT_1003b25c = 0;
    if (param_1 == 1) {
      uRam1003b260 = 50000;
    }
    else {
      uRam1003b25e = 35000;
    }
    .glue::RGBForeColor(&DAT_1003b25c);
    .glue::TextSize(0x18);
    .glue::TextFace(1);
    .glue::TextFont(0x14);
    sVar6 = .glue::StringWidth(&DAT_1003700d);
    uVar3 = (int)sRam1003b6fa - (int)sVar6;
    .glue::MoveTo((int)sRam1003b6ee + ((int)uVar3 >> 1) + (uint)((int)uVar3 < 0 && (uVar3 & 1) != 0)
                  ,_DAT_1003b6ec + 0x140);
    if (param_1 == 1) {
      .glue::DrawString(&DAT_1003700d);
    }
    else {
      .glue::DrawString(local_cc + 0x2ea6);
    }
  }
  for (sVar6 = 0; sVar6 < 8; sVar6 = sVar6 + 1) {
    sVar7 = .glue::Random();
    local_a8[sVar6 * 6 + 2] = sVar7 / 0x6e + 300;
    uVar3 = (uint)local_a8[sVar6 * 6 + 2];
    local_a8[sVar6 * 6 + 2] =
         (short)(((int)uVar3 >> 1) + (uint)((int)uVar3 < 0 && (uVar3 & 1) != 0)) * 2;
    sVar7 = .glue::Random();
    local_a8[sVar6 * 6 + 3] = sVar7 / 0x96 + 0xdc;
    local_a8[sVar6 * 6] = local_a8[sVar6 * 6 + 2];
    local_a8[sVar6 * 6 + 1] = local_a8[sVar6 * 6 + 3];
    local_a8[sVar6 * 6 + 4] = sVar6 * 0x28 + 0xa0;
    local_a8[sVar6 * 6 + 5] = 0xe1;
  }
  FUN_10028958();
  for (iVar10 = 0; sVar6 = (short)iVar10, sVar6 < 8; iVar10 = iVar10 + 1) {
    FUN_10004bb4(_DAT_1003ad28,iVar10 + 0x13,(int)local_a8[sVar6 * 6],(int)local_a8[sVar6 * 6 + 1]);
  }
  FUN_100289c0();
  for (sVar6 = 1; sVar6 < 100; sVar6 = sVar6 + 1) {
    FUN_10028958();
    for (iVar10 = 0; sVar7 = (short)iVar10, sVar7 < 8; iVar10 = iVar10 + 1) {
      uVar3 = (uint)(short)(local_a8[sVar7 * 6] +
                           (short)((((int)local_a8[sVar7 * 6 + 4] - (int)local_a8[sVar7 * 6]) *
                                   (int)sVar6) / 99));
      iVar4 = (((int)uVar3 >> 1) + (uint)((int)uVar3 < 0 && (uVar3 & 1) != 0)) * 2;
      uVar3 = (uint)(short)(local_a8[sVar7 * 6 + 1] +
                           (short)((((int)local_a8[sVar7 * 6 + 5] - (int)local_a8[sVar7 * 6 + 1]) *
                                   (int)sVar6) / 99));
      iVar1 = (((int)uVar3 >> 1) + (uint)((int)uVar3 < 0 && (uVar3 & 1) != 0)) * 2;
      FUN_100043a0(_DAT_1003ad28,iVar10 + 0x13,(int)local_a8[sVar7 * 6 + 2],
                   (int)local_a8[sVar7 * 6 + 3],_DAT_1003ad28,iVar10 + 0x13,iVar4,iVar1);
      local_a8[sVar7 * 6 + 2] = (short)iVar4;
      local_a8[sVar7 * 6 + 3] = (short)iVar1;
    }
    FUN_100289c0();
    iVar10 = FUN_10015fe4();
    do {
      iVar4 = FUN_10015fe4();
    } while (iVar10 == iVar4);
    if ((cVar8 != '\0') && (cVar9 = FUN_100248fc(), cVar9 == '\0')) {
      cVar8 = '\0';
    }
    cVar9 = FUN_100248fc();
    if (((cVar9 != '\0') && (!bVar2)) && (cVar8 == '\0')) {
      sVar6 = 0x62;
      bVar2 = true;
    }
  }
  FUN_10028958();
  for (iVar10 = 0; sVar6 = (short)iVar10, sVar6 < 8; iVar10 = iVar10 + 1) {
    FUN_100043a0(_DAT_1003ad28,iVar10 + 0x13,(int)local_a8[sVar6 * 6 + 2],
                 (int)local_a8[sVar6 * 6 + 3],_DAT_1003ad28,iVar10 + 0x13,
                 (int)local_a8[sVar6 * 6 + 4],(int)local_a8[sVar6 * 6 + 5]);
  }
  FUN_100289c0();
  iVar10 = .glue::TickCount();
  uVar3 = iVar10 + 200;
  if (bVar2) {
    iVar10 = .glue::TickCount();
    uVar3 = iVar10 + 0x1e;
  }
  while (uVar5 = .glue::TickCount(), uVar5 < uVar3) {
    cVar8 = FUN_100248fc();
    if (cVar8 != '\0') {
      uVar3 = 0;
    }
  }
  return;
}

