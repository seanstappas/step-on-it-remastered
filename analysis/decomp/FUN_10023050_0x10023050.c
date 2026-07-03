/* FUN_10023050 @ 0x10023050  calls: TickCount */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10023050(int param_1)

{
  uint uVar1;
  int iVar2;
  uint uVar3;
  short sVar4;
  bool bVar5;
  short sVar6;
  char cVar7;
  int iVar8;
  short sVar9;
  int local_ac;
  undefined1 auStack_88 [8];
  int local_80 [12];
  undefined4 local_50;
  short local_4c;
  short local_4a;
  short local_48;
  uint local_46;
  
  iVar8 = 0;
  while( true ) {
    sVar9 = (short)iVar8;
    if (0xc < sVar9) break;
    iVar2 = .glue::GetCIcon(iVar8 + 0x80);
    local_80[sVar9] = iVar2;
    if (local_80[sVar9] == 0) {
      FUN_100192f8(5);
    }
    iVar8 = iVar8 + 1;
  }
  .glue::HideCursor();
  .glue::SetPort(*(undefined4 *)(local_ac + 0x7570));
  .glue::SetGDevice(*(undefined4 *)(local_ac + 0x756c));
  .glue::RGBForeColor(&DAT_10039778);
  .glue::PaintRect(local_ac + 0x7584);
  *(undefined1 *)(local_ac + 0x5346) = 0;
  .glue::SetGDevice(*(undefined4 *)(local_ac + 0x7564));
  .glue::SetPort(*(undefined4 *)(local_ac + 30000));
  sVar9 = 0;
  .glue::TextSize(0xe);
  .glue::TextFace(1);
  .glue::TextFont(0x14);
  uRam1003b260 = 0;
  uRam1003b25e = 0;
  _DAT_1003b25c = 0xffff;
  .glue::RGBForeColor(&DAT_1003b25c);
  .glue::MoveTo(0x32,param_1 * 0xc + 0x78);
  .glue::GetPen(&local_4c);
  .glue::SetRect(auStack_88,(int)local_4a,local_4c + -10,local_4a + 0xc,local_4c + 2);
  .glue::PlotCIcon(auStack_88,local_80[0]);
  iVar8 = .glue::TickCount();
  bVar5 = false;
  cVar7 = '\0';
  .glue::FlushEvents(0xffff,0);
  while (!bVar5) {
    uVar3 = .glue::TickCount();
    if (iVar8 + 2U < uVar3) {
      sVar9 = sVar9 + 1;
      if (0xb < sVar9) {
        sVar9 = 0;
      }
      .glue::GetPen(&local_4c);
      FUN_10028958();
      .glue::SetRect(auStack_88,(int)local_4a,local_4c + -10,local_4a + 0xc,local_4c + 2);
      .glue::PlotCIcon(auStack_88,local_80[sVar9]);
      FUN_100289c0();
      iVar8 = .glue::TickCount();
    }
    .glue::GetOSEvent(0xffff,&local_48);
    uVar3 = local_46;
    if ((local_48 == 3) || (local_48 == 5)) {
      uVar1 = local_46 & 0xff;
      sVar4 = (short)uVar1;
      if ((sVar4 == 0xd) || (sVar4 == 3)) {
        bVar5 = true;
      }
      else {
        sVar6 = (short)param_1;
        if (sVar4 == 8) {
          if ('\0' < cVar7) {
            .glue::MoveTo(0x32,param_1 * 0xc + 0x78);
            cVar7 = cVar7 + -1;
            (&DAT_10039782)[sVar6 * 0x104] = cVar7;
            .glue::DrawString(&DAT_10039782 + sVar6 * 0x104);
            .glue::GetPen(&local_4c);
            .glue::RGBForeColor(&DAT_10039778);
            .glue::DrawChar((int)*(char *)(sVar6 * 0x104 + (int)cVar7 + 0x10039783));
            uRam1003b260 = 0;
            uRam1003b25e = 0;
            _DAT_1003b25c = 0xffff;
            .glue::RGBForeColor(&DAT_1003b25c);
            .glue::MoveTo((int)local_4a,(int)local_4c);
            .glue::PlotCIcon(auStack_88,local_50);
          }
        }
        else if (cVar7 < ';') {
          sVar4 = .glue::StringWidth(&DAT_10039782 + sVar6 * 0x104);
          if (sVar4 < 0xd2) {
            cVar7 = cVar7 + '\x01';
            (&DAT_10039782)[sVar6 * 0x104 + (int)cVar7] = (char)uVar3;
            (&DAT_10039782)[sVar6 * 0x104] = cVar7;
            FUN_10028958();
            .glue::PlotCIcon(auStack_88,local_50);
            FUN_100289c0();
            .glue::DrawChar(uVar1);
            .glue::GetPen(&local_4c);
            .glue::SetRect(auStack_88,(int)local_4a,local_4c + -10,local_4a + 0xc,local_4c + 2);
            FUN_10028958();
            FUN_100289c0();
          }
        }
      }
    }
    else if (local_48 == 1) {
      .glue::SysBeep(1);
    }
  }
  FUN_10028958();
  FUN_100289c0();
  for (sVar9 = 0; sVar9 < 0xd; sVar9 = sVar9 + 1) {
    .glue::DisposeCIcon(local_80[sVar9]);
  }
  .glue::ShowCursor();
  return;
}

