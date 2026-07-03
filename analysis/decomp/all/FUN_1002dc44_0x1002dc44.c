
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002dc44(void)

{
  int iVar1;
  undefined4 uVar2;
  int local_4c;
  undefined2 local_28;
  undefined2 local_26;
  undefined2 local_24;
  undefined1 auStack_22 [14];
  
  FUN_10021938(1);
  FUN_10021e60(_DAT_1003b264);
  iVar1 = .glue::GetMBarHeight();
  .glue::SetRect(auStack_22,(int)sRam1003bafc,(int)sRam1003bafa,(int)sRam1003bb00,
                 sRam1003bafa + iVar1);
  uVar2 = .glue::NewRgn();
  .glue::RectRgn(uVar2,auStack_22);
  .glue::RectRgn(*(undefined4 *)(_DAT_1003b6a4 + 0x18),_DAT_1003b6a4 + 0x10);
  .glue::UnionRgn(*(undefined4 *)(_DAT_1003b6a4 + 0x18),uVar2,*(undefined4 *)(_DAT_1003b6a4 + 0x18))
  ;
  .glue::DisposeRgn(uVar2);
  .glue::SetPort(_DAT_1003b6a4);
  local_24 = 0;
  local_26 = 0;
  local_28 = 0;
  .glue::RGBForeColor(&local_28);
  .glue::PaintRect(_DAT_1003b6a4 + 0x10);
  .glue::BringToFront(*(undefined4 *)(local_4c + 30000));
  .glue::ShowWindow(*(undefined4 *)(local_4c + 30000));
  .glue::LMSetMBarHeight((int)*(short *)(local_4c + 0x752c));
  .glue::DrawMenuBar();
  FUN_10018180();
  return;
}

