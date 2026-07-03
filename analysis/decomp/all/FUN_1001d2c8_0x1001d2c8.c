
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001d2c8(void)

{
  bool bVar1;
  char cVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  uint uVar5;
  uint uVar6;
  int local_6c;
  short local_48;
  short sStack_46;
  short local_44;
  short sStack_42;
  undefined4 local_40;
  undefined1 auStack_3c [8];
  undefined1 auStack_34 [4];
  undefined1 auStack_30 [2];
  short local_2e [9];
  
  uVar3 = *(undefined4 *)(**(int **)(*_DAT_10039358 + 0x16) + 6);
  uVar4 = *(undefined4 *)(**(int **)(*_DAT_10039358 + 0x16) + 10);
  sStack_42 = (short)uVar4;
  sStack_46 = (short)uVar3;
  local_44 = (short)((uint)uVar4 >> 0x10);
  local_48 = (short)((uint)uVar3 >> 0x10);
  uVar6 = ((int)sStack_42 + (int)sStack_46) -
          (int)(short)(*(short *)(_DAT_100393a4 + 0x16) - *(short *)(_DAT_100393a4 + 0x12));
  uVar5 = (((int)local_44 + (int)local_48) -
          (int)(short)(*(short *)(_DAT_100393a4 + 0x14) - *(short *)(_DAT_100393a4 + 0x10))) + 0x14;
  .glue::MoveWindow(_DAT_100393a4,((int)uVar6 >> 1) + (uint)((int)uVar6 < 0 && (uVar6 & 1) != 0),
                    ((int)uVar5 >> 1) + (uint)((int)uVar5 < 0 && (uVar5 & 1) != 0),0);
  .glue::GetPort(&local_40);
  FUN_10024d5c();
  FUN_1001cf40();
  .glue::SelectDialogItemText(_DAT_100393a4,4,0,0x7fff);
  .glue::ShowWindow(_DAT_100393a4);
  .glue::DrawDialog(_DAT_100393a4);
  .glue::SelectWindow(_DAT_100393a4);
  .glue::SetPort(_DAT_100393a4);
  .glue::GetDialogItem(_DAT_100393a4,0x2e,auStack_30,auStack_34,auStack_3c);
  .glue::FrameRect(auStack_3c);
  *(undefined1 *)(local_6c + 0x51e7) = 0;
  bVar1 = false;
  FUN_10021c14();
  while (!bVar1) {
    .glue::ModalDialog(_DAT_10039380,local_2e);
    if (local_2e[0] == 2) {
      bVar1 = true;
    }
    else if (local_2e[0] < 2) {
      if (0 < local_2e[0]) {
        cVar2 = FUN_10024f40();
        if (cVar2 == '\0') {
          bVar1 = true;
          FUN_100251d8();
          if (DAT_1003ab6e != '\0') {
            FUN_1001ded4();
          }
        }
        else {
          .glue::Alert(0x19a,0);
        }
      }
    }
    else if (local_2e[0] < 4) {
      FUN_100254a0();
      FUN_1001cf40();
      .glue::SelectDialogItemText(_DAT_100393a4,4,0,0x7fff);
    }
  }
  FUN_10021938(0);
  .glue::HideWindow(_DAT_100393a4);
  FUN_10026014();
  *(undefined2 *)(local_6c + 0x613e) = 9;
  FUN_10024bb0();
  .glue::InitCursor();
  .glue::SetPort(local_40);
  return;
}

