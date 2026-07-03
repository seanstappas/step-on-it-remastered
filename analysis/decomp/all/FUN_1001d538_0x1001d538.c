
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001d538(void)

{
  short sVar1;
  bool bVar2;
  int iVar3;
  short sVar4;
  undefined1 auStack_28 [8];
  undefined4 local_20;
  undefined1 auStack_1c [2];
  short local_1a;
  
  sVar1 = _DAT_1003b29c;
  if ((DAT_1003ab6e != '\0') && (DAT_100370e4 != '\0')) {
    sVar1 = _DAT_1003b29a;
  }
  if (sVar1 < _DAT_1003b298) {
    _DAT_1003b298 = 1;
  }
  .glue::GetDialogItem(uRam10039390,4,auStack_1c,&local_20,auStack_28);
  .glue::SetControlValue(local_20,0);
  .glue::GetDialogItem(uRam10039390,5,auStack_1c,&local_20,auStack_28);
  .glue::SetControlValue(local_20,0);
  .glue::GetDialogItem(uRam10039390,6,auStack_1c,&local_20,auStack_28);
  .glue::SetControlValue(local_20,0);
  .glue::GetDialogItem(uRam10039390,7,auStack_1c,&local_20,auStack_28);
  .glue::SetControlValue(local_20,0);
  .glue::GetDialogItem(uRam10039390,8,auStack_1c,&local_20,auStack_28);
  .glue::SetControlValue(local_20,0);
  if (_DAT_1003b298 == 1) {
    iVar3 = 4;
  }
  else if (_DAT_1003b298 == 0x15) {
    iVar3 = 5;
  }
  else if (_DAT_1003b298 == 0x29) {
    iVar3 = 6;
  }
  else if (_DAT_1003b298 == 0x3d) {
    iVar3 = 7;
  }
  else if (_DAT_1003b298 == 0x51) {
    iVar3 = 8;
  }
  else {
    _DAT_1003b298 = 1;
    iVar3 = 4;
  }
  .glue::GetDialogItem(uRam10039390,iVar3,auStack_1c,&local_20,auStack_28);
  .glue::SetControlValue(local_20,1);
  .glue::ShowWindow(uRam10039390);
  .glue::DrawDialog(uRam10039390);
  .glue::SelectWindow(uRam10039390);
  bVar2 = false;
  while (!bVar2) {
    .glue::ModalDialog(_DAT_10039378,&local_1a);
    if (local_1a != 3) {
      if (local_1a < 3) {
        if (local_1a == 1) {
          .glue::HideWindow(uRam10039390);
          bVar2 = true;
        }
        else if (0 < local_1a) {
          .glue::HideWindow(uRam10039390);
          bVar2 = true;
        }
      }
      else if (local_1a < 9) {
        .glue::GetDialogItem(uRam10039390,iVar3,auStack_1c,&local_20,auStack_28);
        .glue::SetControlValue(local_20,0);
        iVar3 = (int)local_1a;
        .glue::GetDialogItem(uRam10039390,iVar3,auStack_1c,&local_20,auStack_28);
        .glue::SetControlValue(local_20,1);
      }
    }
  }
  if (local_1a == 1) {
    sVar4 = (short)iVar3;
    if (sVar4 == 4) {
      _DAT_1003b298 = 1;
    }
    else if (sVar4 == 5) {
      _DAT_1003b298 = 0x15;
    }
    else if (sVar4 == 6) {
      _DAT_1003b298 = 0x29;
    }
    else if (sVar4 == 7) {
      _DAT_1003b298 = 0x3d;
    }
    else if (sVar4 == 8) {
      _DAT_1003b298 = 0x51;
    }
    else {
      _DAT_1003b298 = 1;
    }
  }
  if (sVar1 < _DAT_1003b298) {
    _DAT_1003b298 = 1;
  }
  .glue::HideWindow(uRam10039390);
  .glue::InitCursor();
  return;
}

