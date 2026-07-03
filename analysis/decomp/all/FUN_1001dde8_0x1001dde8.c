
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_1001dde8(void)

{
  undefined4 uVar1;
  bool bVar2;
  short local_18 [6];
  
  uVar1 = 0;
  .glue::SysBeep(1);
  .glue::ShowWindow(_DAT_1003939c);
  .glue::DrawDialog(_DAT_1003939c);
  .glue::SelectWindow(_DAT_1003939c);
  bVar2 = false;
  while (!bVar2) {
    .glue::ModalDialog(0,local_18);
    if (local_18[0] == 2) {
      .glue::HideWindow(_DAT_1003939c);
      bVar2 = true;
    }
    else if ((local_18[0] < 2) && (0 < local_18[0])) {
      .glue::HideWindow(_DAT_1003939c);
      bVar2 = true;
      uVar1 = 1;
    }
  }
  .glue::InitCursor();
  .glue::HideWindow(_DAT_1003939c);
  return uVar1;
}

