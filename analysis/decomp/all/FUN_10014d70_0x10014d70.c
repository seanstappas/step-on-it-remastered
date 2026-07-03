
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10014d70(void)

{
  ushort uVar1;
  int iVar2;
  undefined4 uVar3;
  int *piVar4;
  uint uVar5;
  uint uVar6;
  short sVar7;
  short sVar8;
  short sVar9;
  int local_7c;
  undefined4 local_58;
  undefined4 local_54;
  short local_50;
  short local_4e;
  short local_4c;
  short local_4a;
  undefined4 local_48;
  undefined4 local_44;
  undefined2 local_40;
  undefined2 local_3e;
  undefined2 local_3c;
  undefined1 auStack_3a [14];
  
  DAT_100394b6 = 0;
  FUN_10018180();
  FUN_1002dd90();
  FUN_10021938(1);
  .glue::HideWindow(_DAT_1003b6a0);
  iVar2 = .glue::GetMBarHeight();
  .glue::SetRect(auStack_3a,(int)sRam1003bafc,(int)sRam1003bafa,(int)sRam1003bb00,
                 sRam1003bafa + iVar2);
  uVar3 = .glue::NewRgn();
  .glue::RectRgn(uVar3,auStack_3a);
  .glue::RectRgn(*(undefined4 *)(_DAT_1003b6a4 + 0x18),_DAT_1003b6a4 + 0x10);
  .glue::UnionRgn(*(undefined4 *)(_DAT_1003b6a4 + 0x18),uVar3,*(undefined4 *)(_DAT_1003b6a4 + 0x18))
  ;
  .glue::DisposeRgn(uVar3);
  .glue::SetPort(_DAT_1003b6a4);
  local_3c = 0;
  local_3e = 0;
  local_40 = 0;
  .glue::RGBForeColor(&local_40);
  .glue::PaintRect(_DAT_1003b6a4 + 0x10);
  FUN_10021e60(*(undefined4 *)(local_7c + 0x70fc));
  FUN_10004ac8();
  piVar4 = (int *).glue::GetPicture(0x15e);
  if (piVar4 == (int *)0x0) {
    FUN_100192f8(5);
  }
  FUN_10000a4c();
  .glue::SetPort(*(undefined4 *)(local_7c + 0x7570));
  .glue::SetGDevice(*(undefined4 *)(local_7c + 0x756c));
  .glue::RGBForeColor(&local_40);
  .glue::PaintRect(local_7c + 0x7584);
  local_58 = *(undefined4 *)(*piVar4 + 2);
  local_54 = *(undefined4 *)(*piVar4 + 6);
  .glue::DrawPicture(piVar4,&local_58);
  .glue::ReleaseResource(piVar4);
  FUN_10015e90(iRam1003aa5c,0x136,0x17c);
  FUN_10015e90(iRam1003aacc,0x224,0x17c);
  .glue::SetPort(_DAT_1003b6a4);
  .glue::SetGDevice(*(undefined4 *)(local_7c + 0x7564));
  .glue::CopyBits(*(int *)(local_7c + 0x7570) + 2,_DAT_1003b6a4 + 2,&local_58,local_7c + 0x757c,0,
                  *(undefined4 *)(_DAT_1003b6a4 + 0x18));
  FUN_10021c14();
  sVar8 = sRam1003aa66;
  if (cRam1003aa68 != '\0') {
    sVar8 = sRam1003aa66 + 1;
  }
  sVar7 = sRam1003aad6;
  if (cRam1003aad8 != '\0') {
    sVar7 = sRam1003aad6 + 1;
  }
  FUN_10015f8c(0x3c);
  FUN_10015d94((int)sVar8,0x136,0x158);
  if (sVar8 == 0) {
    FUN_1002b020(8,100);
  }
  FUN_10015f8c(0x1e);
  sVar9 = 0;
  while( true ) {
    if (sVar8 <= sVar9) break;
    iRam1003aa5c = iRam1003aa5c + 10000;
    FUN_10015d94(iRam1003aa5c,0x136,0x17c);
    FUN_1002b020(10,100);
    FUN_10015f8c(0xf);
    sVar9 = sVar9 + 1;
  }
  FUN_10015f8c(0x2d);
  FUN_10015d94((int)sVar7,0x224,0x158);
  if (sVar7 == 0) {
    FUN_1002b020(8,100);
  }
  FUN_10015f8c(0x1e);
  sVar8 = 0;
  while( true ) {
    if (sVar7 <= sVar8) break;
    iRam1003aacc = iRam1003aacc + 10000;
    FUN_10015d94(iRam1003aacc,0x224,0x17c);
    FUN_1002b020(10,100);
    FUN_10015f8c(0xf);
    sVar8 = sVar8 + 1;
  }
  FUN_10015f8c(0x5a);
  if (*(char *)(local_7c + 0x4eda) == '\0') {
    if (iRam1003aacc < iRam1003aa5c) {
      piVar4 = (int *).glue::GetPicture(0x406);
    }
    else if (iRam1003aa5c < iRam1003aacc) {
      piVar4 = (int *).glue::GetPicture(0x407);
    }
    else {
      piVar4 = (int *).glue::GetPicture(0x408);
    }
    if (piVar4 == (int *)0x0) {
      FUN_100192f8(5);
    }
    local_48 = *(undefined4 *)(*piVar4 + 2);
    uVar5 = *(uint *)(*piVar4 + 6);
    local_44._2_2_ = (short)uVar5;
    uVar1 = *(ushort *)(**(int **)(_DAT_1003b6a4 + 2) + 0xc);
    local_4e = ((((short)uVar1 >> 1) + (ushort)((short)uVar1 < 0 && (uVar1 & 1) != 0)) -
               ((local_44._2_2_ >> 1) + (ushort)(local_44._2_2_ < 0 && (uVar5 & 1) != 0))) + -2;
    local_44._0_2_ = (short)(uVar5 >> 0x10);
    local_4a = local_4e + local_44._2_2_;
    uVar1 = *(ushort *)(**(int **)(_DAT_1003b6a4 + 2) + 10);
    local_50 = (((short)uVar1 >> 1) + (ushort)((short)uVar1 < 0 && (uVar1 & 1) != 0)) -
               ((local_44._0_2_ >> 1) + (ushort)((int)uVar5 < 0 && (uVar5 & 0x10000) != 0));
    local_4c = local_50 + local_44._0_2_;
    local_44 = uVar5;
    .glue::DrawPicture(piVar4,&local_50);
    FUN_1002b020(0x16,100);
    .glue::ReleaseResource(piVar4);
  }
  else if (iRam1003aacc < iRam1003aa5c) {
    FUN_10018e88(local_7c + 0x76c);
    FUN_10018214(0x37);
    FUN_1002b020(0x37,100);
    uVar5 = (uint)sRam1003bb00;
    uVar6 = (uint)sRam1003bafe;
    FUN_100191f8(_DAT_10039050,_DAT_1003b6a4,
                 ((int)uVar5 >> 1) + (uint)((int)uVar5 < 0 && (uVar5 & 1) != 0) + -2,
                 ((int)uVar6 >> 1) + (uint)((int)uVar6 < 0 && (uVar6 & 1) != 0));
    FUN_10019078();
    FUN_10019cb8(0x37);
    FUN_10019020();
  }
  else if (iRam1003aa5c < iRam1003aacc) {
    FUN_10018e88(local_7c + 0x776);
    FUN_10018214(0x37);
    FUN_1002b020(0x37,100);
    uVar5 = (uint)sRam1003bb00;
    uVar6 = (uint)sRam1003bafe;
    FUN_100191f8(_DAT_10039050,_DAT_1003b6a4,
                 ((int)uVar5 >> 1) + (uint)((int)uVar5 < 0 && (uVar5 & 1) != 0) + -2,
                 ((int)uVar6 >> 1) + (uint)((int)uVar6 < 0 && (uVar6 & 1) != 0));
    FUN_10019078();
    FUN_10019cb8(0x37);
    FUN_10019020();
  }
  else {
    FUN_10018e88(local_7c + 0x781);
    uVar5 = (uint)sRam1003bb00;
    uVar6 = (uint)sRam1003bafe;
    FUN_100191f8(_DAT_10039050,_DAT_1003b6a4,
                 ((int)uVar5 >> 1) + (uint)((int)uVar5 < 0 && (uVar5 & 1) != 0) + -2,
                 ((int)uVar6 >> 1) + (uint)((int)uVar6 < 0 && (uVar6 & 1) != 0));
    FUN_10019078();
    FUN_10019020();
  }
  FUN_10021854();
  return;
}

