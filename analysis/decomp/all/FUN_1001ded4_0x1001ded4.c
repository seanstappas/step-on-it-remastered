
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001ded4(void)

{
  char cVar2;
  short sVar1;
  bool bVar3;
  int local_3c;
  undefined1 auStack_18 [8];
  undefined4 local_10;
  undefined1 auStack_c [2];
  short local_a;
  
  if ((DAT_10039356 == '\0') && (cVar2 = FUN_100252f8(), cVar2 != '\0')) {
    .glue::SysBeep(1);
    .glue::ShowWindow(_DAT_100393a0);
    .glue::DrawDialog(_DAT_100393a0);
    .glue::SelectWindow(_DAT_100393a0);
    bVar3 = false;
    while (!bVar3) {
      .glue::ModalDialog(0,&local_a);
      if (local_a == 2) {
        .glue::GetDialogItem(_DAT_100393a0,2,auStack_c,&local_10,auStack_18);
        sVar1 = .glue::GetControlValue(local_10);
        if (sVar1 == 1) {
          .glue::SetControlValue(local_10,0);
        }
        else {
          .glue::SetControlValue(local_10,1);
        }
      }
      else if ((local_a < 2) && (0 < local_a)) {
        .glue::HideWindow(_DAT_100393a0);
        bVar3 = true;
      }
    }
    .glue::GetDialogItem(_DAT_100393a0,2,auStack_c,&local_10,auStack_18);
    sVar1 = .glue::GetControlValue(local_10);
    if (sVar1 == 1) {
      *(undefined1 *)(local_3c + 0x51e6) = 1;
      *(undefined1 *)(local_3c + 0x5240) = 1;
    }
    .glue::InitCursor();
    .glue::HideWindow(_DAT_100393a0);
  }
  return;
}

