
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_1001d8e4(void)

{
  undefined4 uVar1;
  bool bVar2;
  short local_18 [4];
  
  uVar1 = 0;
  .glue::SysBeep(1);
  .glue::ShowWindow(_DAT_1003938c);
  .glue::DrawDialog(_DAT_1003938c);
  .glue::SelectWindow(_DAT_1003938c);
  bVar2 = false;
  while (!bVar2) {
    .glue::ModalDialog(_DAT_10039374,local_18);
    if (local_18[0] == 2) {
      .glue::HideWindow(_DAT_1003938c);
      bVar2 = true;
    }
    else if ((local_18[0] < 2) && (0 < local_18[0])) {
      .glue::HideWindow(_DAT_1003938c);
      bVar2 = true;
      uVar1 = 1;
    }
  }
  .glue::InitCursor();
  .glue::HideWindow(_DAT_1003938c);
  return uVar1;
}

