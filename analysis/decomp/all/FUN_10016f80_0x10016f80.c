
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10016f80(char param_1,int param_2)

{
  int iVar1;
  undefined4 uVar2;
  int *piVar3;
  undefined4 uVar4;
  uint uVar5;
  short sVar6;
  int local_7c;
  short local_58;
  short local_56;
  short local_54;
  short local_52;
  undefined4 local_50;
  undefined4 local_4c;
  undefined4 local_48;
  undefined4 local_44;
  undefined2 local_40;
  undefined2 local_3e;
  undefined2 local_3c;
  undefined1 auStack_3a [14];
  
  sVar6 = (short)param_2;
  if (param_1 != '\0') {
    *(undefined4 *)(sVar6 * 0x70 + 0x1003a9ec) = _DAT_10038ff4;
    *(undefined2 *)(sVar6 * 0x70 + 0x1003a9f6) = _DAT_10038ff0;
    *(undefined2 *)(sVar6 * 0x70 + 0x1003a9fa) = _DAT_10038fee;
    *(undefined2 *)(sVar6 * 0x70 + 0x1003a9fc) = _DAT_10038fec;
  }
  DAT_100394b6 = 0;
  FUN_1002dd90();
  FUN_10021938(1);
  .glue::HideWindow(_DAT_1003b6a0);
  iVar1 = .glue::GetMBarHeight();
  .glue::SetRect(auStack_3a,(int)sRam1003bafc,(int)sRam1003bafa,(int)sRam1003bb00,
                 sRam1003bafa + iVar1);
  uVar2 = .glue::NewRgn();
  .glue::RectRgn(uVar2,auStack_3a);
  .glue::RectRgn(*(undefined4 *)(_DAT_1003b6a4 + 0x18),_DAT_1003b6a4 + 0x10);
  .glue::UnionRgn(*(undefined4 *)(_DAT_1003b6a4 + 0x18),uVar2,*(undefined4 *)(_DAT_1003b6a4 + 0x18))
  ;
  .glue::DisposeRgn(uVar2);
  .glue::SetPort(_DAT_1003b6a4);
  local_3c = 0;
  local_3e = 0;
  local_40 = 0;
  .glue::RGBForeColor(&local_40);
  .glue::PaintRect(_DAT_1003b6a4 + 0x10);
  FUN_10021e60(*(undefined4 *)(local_7c + 0x70fc));
  FUN_10004ac8();
  piVar3 = (int *).glue::GetPicture(0x12d);
  if (piVar3 == (int *)0x0) {
    FUN_100192f8(5);
  }
  FUN_10000a4c();
  .glue::SetPort(*(undefined4 *)(local_7c + 0x7570));
  .glue::SetGDevice(*(undefined4 *)(local_7c + 0x756c));
  .glue::RGBForeColor(&local_40);
  .glue::PaintRect(local_7c + 0x7584);
  local_48 = *(undefined4 *)(*piVar3 + 2);
  local_44 = *(undefined4 *)(*piVar3 + 6);
  .glue::DrawPicture(piVar3,&local_48);
  .glue::ReleaseResource(piVar3);
  if (param_1 == '\0') {
    piVar3 = (int *).glue::GetPicture(param_2 + 0x12e);
    if (piVar3 == (int *)0x0) {
      FUN_100192f8(5);
    }
    local_50 = *(undefined4 *)(*piVar3 + 2);
    uVar2 = *(undefined4 *)(*piVar3 + 6);
    local_4c._2_2_ = (short)uVar2;
    uVar5 = (int)local_4c._2_2_ - (int)local_50._2_2_;
    local_56 = 0x140 - ((short)((int)uVar5 >> 1) + (ushort)((int)uVar5 < 0 && (uVar5 & 1) != 0));
    local_58 = 0x8c;
    local_4c._0_2_ = (short)((uint)uVar2 >> 0x10);
    local_52 = local_56 + local_4c._2_2_;
    local_54 = local_4c._0_2_ + 0x8c;
    local_4c = uVar2;
    .glue::DrawPicture(piVar3,&local_58);
    FUN_10015e90(*(undefined4 *)(sVar6 * 0x70 + 0x1003a9ec),0x1ad,0xbf);
  }
  else {
    piVar3 = (int *).glue::GetPicture(0x12e);
    if (piVar3 == (int *)0x0) {
      FUN_100192f8(5);
    }
    uVar2 = *(undefined4 *)(*piVar3 + 2);
    uVar4 = *(undefined4 *)(*piVar3 + 6);
    local_50._2_2_ = (short)uVar2;
    local_4c._2_2_ = (short)uVar4;
    local_50._0_2_ = (short)((uint)uVar2 >> 0x10);
    uVar5 = (int)local_4c._2_2_ - (int)local_50._2_2_;
    local_4c._0_2_ = (short)((uint)uVar4 >> 0x10);
    local_56 = 0x13e - ((short)((int)uVar5 >> 1) + (ushort)((int)uVar5 < 0 && (uVar5 & 1) != 0));
    uVar5 = (int)local_4c._0_2_ - (int)local_50._0_2_;
    local_58 = 0x113 - ((short)((int)uVar5 >> 1) + (ushort)((int)uVar5 < 0 && (uVar5 & 1) != 0));
    local_52 = local_56 + local_4c._2_2_;
    local_54 = local_58 + local_4c._0_2_;
    local_50 = uVar2;
    local_4c = uVar4;
    .glue::DrawPicture(piVar3,&local_58);
  }
  .glue::SetPort(_DAT_1003b6a4);
  .glue::SetGDevice(*(undefined4 *)(local_7c + 0x7564));
  .glue::CopyBits(*(int *)(local_7c + 0x7570) + 2,_DAT_1003b6a4 + 2,&local_48,local_7c + 0x757c,0,
                  *(undefined4 *)(_DAT_1003b6a4 + 0x18));
  FUN_10021c14();
  FUN_100179c4(0x1e);
  if (param_1 == '\0') {
    if (*(short *)(sVar6 * 0x70 + 0x1003a9f4) == 1) {
      FUN_10015d94((int)*(short *)(sVar6 * 0x70 + 0x1003a9f0),0x1ad,0x9c);
      FUN_1002b020(0x2e,100);
      FUN_100179c4(0x1e);
      *(int *)(sVar6 * 0x70 + 0x1003a9ec) =
           *(int *)(sVar6 * 0x70 + 0x1003a9ec) + (int)*(short *)(sVar6 * 0x70 + 0x1003a9f0);
      FUN_10015d94(*(undefined4 *)(sVar6 * 0x70 + 0x1003a9ec),0x1ad,0xbf);
      FUN_1002b020(0x2f,100);
    }
    else {
      FUN_10015d94((int)*(short *)(sVar6 * 0x70 + 0x1003a9f0),0x1ad,0x9c);
      FUN_1002b020(0x2e,100);
      FUN_100179c4(0x1e);
      FUN_10004bb4(_DAT_1003ad2c,*(short *)(sVar6 * 0x70 + 0x1003a9f4) + 10,0x130,0x95);
      FUN_1002b020(0x2f,10);
      FUN_100179c4(0x1e);
      for (iVar1 = 0; (short)iVar1 < *(short *)(sVar6 * 0x70 + 0x1003a9f4); iVar1 = iVar1 + 1) {
        *(int *)(sVar6 * 0x70 + 0x1003a9ec) =
             *(int *)(sVar6 * 0x70 + 0x1003a9ec) + (int)*(short *)(sVar6 * 0x70 + 0x1003a9f0);
        FUN_10015d94(*(undefined4 *)(sVar6 * 0x70 + 0x1003a9ec),0x1ad,0xbf);
        FUN_1002b020(iVar1 + 0x30,100);
        FUN_100179c4(0x14);
      }
    }
    FUN_100179c4(0x3c);
    *(undefined2 *)(local_7c + 0x4e72) = 0x68;
    *(undefined2 *)(local_7c + 0x4e70) = 0xe1;
    FUN_100178f0((int)*(short *)(local_7c + 0x4e7a),_DAT_1003ad2c,10,0x15);
    FUN_100178f0((int)*(short *)(local_7c + 0x4e78),_DAT_1003ad2c,0x17,0x1c);
    FUN_100178f0((int)*(short *)(local_7c + 0x4e76),_DAT_1003ad2c,0x18,0x1d);
    FUN_100178f0((int)*(short *)(local_7c + 0x4e74),_DAT_1003ad2c,0x19,0x1e);
    FUN_100178f0((int)*(short *)(sVar6 * 0x70 + 0x1003a9f6) - (int)*(short *)(local_7c + 0x4e80),
                 _DAT_1003ad2c,0x10,0x18);
    FUN_100178f0((int)*(short *)(sVar6 * 0x70 + 0x1003a9fa) - (int)*(short *)(local_7c + 0x4e7e),
                 _DAT_1003ad2c,0x12,0x1a);
    FUN_100178f0((int)*(short *)(sVar6 * 0x70 + 0x1003a9fc) - (int)*(short *)(local_7c + 0x4e7c),
                 _DAT_1003ad2c,0x11,0x19);
  }
  else {
    FUN_1002b020(8,10);
  }
  FUN_10021854();
  return;
}

