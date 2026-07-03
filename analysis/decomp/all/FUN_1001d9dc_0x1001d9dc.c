
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_1001d9dc(void)

{
  undefined4 uVar1;
  bool bVar2;
  short local_18 [4];
  
  uVar1 = 0;
  .glue::SysBeep(1);
  .glue::ShowWindow(_DAT_10039398);
  .glue::DrawDialog(_DAT_10039398);
  .glue::SelectWindow(_DAT_10039398);
  bVar2 = false;
  while (!bVar2) {
    .glue::ModalDialog(_DAT_1003936c,local_18);
    if (local_18[0] == 2) {
      .glue::HideWindow(_DAT_10039398);
      bVar2 = true;
    }
    else if (local_18[0] < 2) {
      if (0 < local_18[0]) {
        .glue::HideWindow(_DAT_10039398);
        FUN_10020eb0();
        bVar2 = true;
        uVar1 = 1;
      }
    }
    else if (local_18[0] < 4) {
      .glue::HideWindow(_DAT_10039398);
      bVar2 = true;
      uVar1 = 1;
    }
  }
  .glue::InitCursor();
  .glue::HideWindow(_DAT_10039398);
  return uVar1;
}

