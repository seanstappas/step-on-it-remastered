
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001768c(void)

{
  int iVar1;
  undefined4 uVar2;
  int *piVar3;
  int local_5c;
  undefined4 local_38;
  undefined4 local_34;
  undefined2 local_30;
  undefined2 local_2e;
  undefined2 local_2c;
  undefined1 auStack_2a [18];
  
  FUN_10018180();
  DAT_100394b6 = 0;
  FUN_1002dd90();
  FUN_10021938(1);
  .glue::HideWindow(_DAT_1003b6a0);
  iVar1 = .glue::GetMBarHeight();
  .glue::SetRect(auStack_2a,(int)sRam1003bafc,(int)sRam1003bafa,(int)sRam1003bb00,
                 sRam1003bafa + iVar1);
  uVar2 = .glue::NewRgn();
  .glue::RectRgn(uVar2,auStack_2a);
  .glue::RectRgn(*(undefined4 *)(_DAT_1003b6a4 + 0x18),_DAT_1003b6a4 + 0x10);
  .glue::UnionRgn(*(undefined4 *)(_DAT_1003b6a4 + 0x18),uVar2,*(undefined4 *)(_DAT_1003b6a4 + 0x18))
  ;
  .glue::DisposeRgn(uVar2);
  .glue::SetPort(_DAT_1003b6a4);
  local_2c = 0;
  local_2e = 0;
  local_30 = 0;
  .glue::RGBForeColor(&local_30);
  .glue::PaintRect(_DAT_1003b6a4 + 0x10);
  FUN_10021e60(*(undefined4 *)(local_5c + 0x70fc));
  FUN_10004ac8();
  piVar3 = (int *).glue::GetPicture(0x140);
  if (piVar3 == (int *)0x0) {
    FUN_100192f8(5);
  }
  FUN_10000a4c();
  .glue::SetPort(*(undefined4 *)(local_5c + 0x7570));
  .glue::SetGDevice(*(undefined4 *)(local_5c + 0x756c));
  .glue::RGBForeColor(&local_30);
  .glue::PaintRect(local_5c + 0x7584);
  local_38 = *(undefined4 *)(*piVar3 + 2);
  local_34 = *(undefined4 *)(*piVar3 + 6);
  .glue::DrawPicture(piVar3,&local_38);
  .glue::ReleaseResource(piVar3);
  .glue::SetPort(_DAT_1003b6a4);
  .glue::SetGDevice(*(undefined4 *)(local_5c + 0x7564));
  .glue::CopyBits(*(int *)(local_5c + 0x7570) + 2,_DAT_1003b6a4 + 2,&local_38,local_5c + 0x757c,0,
                  *(undefined4 *)(_DAT_1003b6a4 + 0x18));
  FUN_10021c14();
  FUN_1002b020(0x1e,10);
  FUN_10018414(6);
  FUN_1001882c(1);
  FUN_10021854();
  FUN_1001873c(0x1e);
  return;
}

