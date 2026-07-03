
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001cd20(void)

{
  short sVar1;
  short sVar2;
  bool bVar3;
  int local_15c;
  undefined1 local_138 [4];
  undefined1 auStack_134 [256];
  undefined1 auStack_34 [8];
  undefined4 local_2c;
  undefined1 auStack_28 [2];
  short local_26 [9];
  
  sVar2 = _DAT_1003b29c;
  if ((DAT_1003ab6e != '\0') && (DAT_100370e4 != '\0')) {
    sVar2 = _DAT_1003b29a;
  }
  if (sVar2 == 0) {
    .glue::Alert(0x19e,0);
  }
  else {
    if (sVar2 < _DAT_1003b298) {
      _DAT_1003b298 = 1;
    }
    .glue::GetDialogItem(_DAT_10039394,3,auStack_28,&local_2c,auStack_34);
    .glue::NumToString((int)_DAT_1003b298,auStack_134);
    .glue::SetDialogItemText(local_2c,auStack_134);
    .glue::SelectDialogItemText(_DAT_10039394,3,0,0x7fff);
    .glue::NumToString((int)sVar2,auStack_134);
    .glue::ParamText(auStack_134,local_15c + -0x1c,local_15c + -0x1c,local_15c + -0x1c);
    .glue::ShowWindow(_DAT_10039394);
    .glue::DrawDialog(_DAT_10039394);
    .glue::SelectWindow(_DAT_10039394);
    bVar3 = false;
    while (!bVar3) {
      .glue::ModalDialog(_DAT_1003937c,local_26);
      if (local_26[0] == 2) {
        .glue::HideWindow(_DAT_10039394);
        bVar3 = true;
      }
      else if ((local_26[0] < 2) && (0 < local_26[0])) {
        .glue::HideWindow(_DAT_10039394);
        bVar3 = true;
        .glue::GetDialogItem(_DAT_10039394,3,auStack_28,&local_2c,auStack_34);
        .glue::GetDialogItemText(local_2c,auStack_134);
        .glue::StringToNum(auStack_134,local_138);
        sVar1 = local_138._2_2_;
        if ((0 < sVar1) && (sVar1 <= sVar2)) {
          _DAT_1003b298 = sVar1;
        }
      }
    }
    .glue::HideWindow(_DAT_10039394);
    .glue::InitCursor();
  }
  return;
}

