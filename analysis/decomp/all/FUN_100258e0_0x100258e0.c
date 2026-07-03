
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100258e0(void)

{
  int *piVar1;
  int iVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  int iVar5;
  short sVar6;
  int local_25c;
  undefined1 auStack_238 [256];
  undefined1 auStack_138 [256];
  undefined4 local_38;
  short local_34;
  short local_32;
  short local_30;
  short local_2e;
  undefined4 local_2c;
  short local_28;
  short sStack_26;
  
  piVar1 = (int *).glue::GetPicture(0x192);
  if (piVar1 == (int *)0x0) {
    FUN_100192f8(5);
  }
  else {
    .glue::GetPort(&local_38);
    .glue::SetPort(*(undefined4 *)(local_25c + 0x7570));
    .glue::SetGDevice(*(undefined4 *)(local_25c + 0x756c));
    uVar3 = *(undefined4 *)(*piVar1 + 2);
    uVar4 = *(undefined4 *)(*piVar1 + 6);
    local_2c._0_2_ = (short)((uint)uVar3 >> 0x10);
    local_28 = (short)((uint)uVar4 >> 0x10);
    local_28 = local_28 - local_2c._0_2_;
    sStack_26 = (short)uVar4;
    local_2c._2_2_ = (short)uVar3;
    sStack_26 = sStack_26 - local_2c._2_2_;
    local_2c = 0;
    local_32 = sRam100394a8 + 0x18;
    local_34 = _DAT_100394a6 + 0x18;
    local_2e = local_32 + sStack_26;
    local_30 = local_34 + local_28;
    .glue::DrawPicture(piVar1,&local_34);
    .glue::ReleaseResource(piVar1);
    .glue::TextSize(0xe);
    .glue::TextFace(1);
    .glue::TextFont(0x14);
    uRam1003b260 = 0;
    uRam1003b25e = 0;
    _DAT_1003b25c = 0;
    .glue::RGBForeColor(&DAT_1003b25c);
    .glue::MoveTo(sRam100394a8 + 0x32,_DAT_100394a6 + 0x73);
    .glue::DrawString(local_25c + 0x2e20);
    .glue::MoveTo(sRam100394a8 + 0x11e,_DAT_100394a6 + 0x73);
    .glue::DrawString(local_25c + 0x2e2d);
    _DAT_1003b25c = 0;
    uRam1003b260 = 0;
    uRam1003b25e = 0;
    .glue::RGBForeColor(&DAT_1003b25c);
    for (iVar5 = 1; sVar6 = (short)iVar5, sVar6 < 0xb; iVar5 = iVar5 + 1) {
      .glue::NumToString((int)sVar6,auStack_138);
      iVar2 = .glue::StringWidth(auStack_138);
      .glue::MoveTo((sRam100394a8 + 0x30) - iVar2,(int)_DAT_100394a6 + iVar5 * 0xc + 0x78);
      .glue::DrawString(auStack_138);
      .glue::NumToString(*(undefined4 *)(sVar6 * 0x104 + 0x10039882),auStack_238);
      .glue::MoveTo(sRam100394a8 + 0x32,(int)_DAT_100394a6 + iVar5 * 0xc + 0x78);
      .glue::DrawString(&DAT_10039782 + sVar6 * 0x104);
      iVar2 = .glue::StringWidth(auStack_238);
      .glue::MoveTo((sRam100394a8 + 0x14f) - iVar2,(int)_DAT_100394a6 + iVar5 * 0xc + 0x78);
      .glue::DrawString(auStack_238);
    }
    if (*(short *)(local_25c + 0x5334) == 1) {
      .glue::NumToString(*(undefined4 *)(local_25c + 0x534c),auStack_238);
      .glue::MoveTo(sRam100394a8 + 0x1e,_DAT_100394a6 + 0x104);
      .glue::DrawString(local_25c + 0x2e33);
      .glue::DrawString(auStack_238);
    }
    else if (*(short *)(local_25c + 0x5334) == 2) {
      .glue::MoveTo(sRam100394a8 + 0x1e,_DAT_100394a6 + 0x104);
      .glue::DrawString(local_25c + 0x2e41);
      .glue::NumToString(*(undefined4 *)(local_25c + 0x534c),auStack_238);
      .glue::DrawString(auStack_238);
      .glue::DrawString(local_25c + 0x2e54);
      .glue::NumToString(*(undefined4 *)(local_25c + 0x5348),auStack_238);
      .glue::DrawString(auStack_238);
    }
    .glue::SetPort(local_38);
    .glue::SetGDevice(*(undefined4 *)(local_25c + 0x7564));
  }
  return;
}

