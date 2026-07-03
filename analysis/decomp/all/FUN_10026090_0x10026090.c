
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10026090(void)

{
  undefined2 uVar3;
  undefined4 uVar1;
  int *piVar2;
  undefined4 uVar4;
  int local_9c;
  undefined4 local_76;
  undefined1 auStack_72 [64];
  undefined4 local_32;
  short local_2e;
  short sStack_2c;
  undefined2 local_2a;
  undefined2 local_28;
  undefined2 local_26;
  undefined2 local_24;
  undefined2 local_22;
  undefined2 local_20;
  undefined1 auStack_1e [14];
  
  local_26 = 0x7777;
  local_28 = 0x7777;
  local_2a = 0x7777;
  FUN_10021938(0);
  uVar3 = .glue::GetMBarHeight();
  *(undefined2 *)(local_9c + 0x752c) = uVar3;
  _DAT_1003b6a4 = .glue::NewCWindow(0,0x1003bafa,local_9c + -0x17,1,2,0xffffffff,0,0);
  .glue::SetRect(auStack_1e,(int)sRam1003bafc,(int)sRam1003bafa,(int)sRam1003bb00,
                 (int)sRam1003bafa + (int)*(short *)(local_9c + 0x752c));
  uVar1 = .glue::NewRgn();
  .glue::RectRgn(uVar1,auStack_1e);
  .glue::RectRgn(*(undefined4 *)(_DAT_1003b6a4 + 0x18),_DAT_1003b6a4 + 0x10);
  .glue::UnionRgn(*(undefined4 *)(_DAT_1003b6a4 + 0x18),uVar1,*(undefined4 *)(_DAT_1003b6a4 + 0x18))
  ;
  .glue::DisposeRgn(uVar1);
  .glue::SetPort(_DAT_1003b6a4);
  local_20 = 0;
  local_22 = 0;
  local_24 = 0;
  .glue::RGBForeColor(&local_24);
  .glue::PaintRect(_DAT_1003b6a4 + 0x10);
  piVar2 = (int *).glue::GetPicture(800);
  if (piVar2 == (int *)0x0) {
    FUN_100192f8(5);
  }
  uVar1 = *(undefined4 *)(*piVar2 + 2);
  uVar4 = *(undefined4 *)(*piVar2 + 6);
  local_32._0_2_ = (short)((uint)uVar1 >> 0x10);
  local_2e = (short)((uint)uVar4 >> 0x10);
  sStack_2c = (short)uVar4;
  local_32._2_2_ = (short)uVar1;
  _local_2e = CONCAT22(local_2e - local_32._0_2_,sStack_2c - local_32._2_2_);
  local_32 = 0;
  FUN_10026344(&local_32);
  uVar1 = .glue::NewCWindow(0,local_9c + 0x533e,local_9c + -0x17,1,2,0xffffffff,0,0);
  *(undefined4 *)(local_9c + 30000) = uVar1;
  .glue::SetPort(*(undefined4 *)(local_9c + 30000));
  .glue::PaintRect(&local_32);
  .glue::DrawPicture(piVar2,&local_32);
  .glue::ReleaseResource(piVar2);
  *(undefined1 *)(local_9c + 0x5346) = 0;
  .glue::Gestalt(0x6b626420,&local_76);
  .glue::RGBForeColor(&local_24);
  .glue::MoveTo(10,10);
  .glue::TextSize(10);
  .glue::TextFace(0);
  .glue::TextFont(0x14);
  .glue::NumToString(local_76,auStack_72);
  FUN_10021c14();
  .glue::DrawMenuBar();
  return;
}

