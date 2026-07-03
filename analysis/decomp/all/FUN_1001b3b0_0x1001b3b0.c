
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001b3b0(void)

{
  short sVar1;
  int iVar2;
  undefined4 uVar3;
  uint uVar4;
  int local_4c;
  
  iVar2 = .glue::GetNewMBar(400);
  if (iVar2 == 0) {
    FUN_100192f8(4);
  }
  .glue::SetMenuBar(iVar2);
  .glue::DisposeHandle(iVar2);
  _DAT_100393cc = .glue::GetMenu(100);
  .glue::InsertMenu(_DAT_100393cc,0xffffffff);
  _DAT_100393b4 = .glue::GetMenu(0x66);
  .glue::InsertMenu(_DAT_100393b4,0xffffffff);
  _DAT_100393bc = .glue::GetMenu(0x65);
  .glue::InsertMenu(_DAT_100393bc,0xffffffff);
  uVar3 = .glue::GetMenu(0x68);
  *(undefined4 *)(local_4c + 0x5254) = uVar3;
  .glue::InsertMenu(*(undefined4 *)(local_4c + 0x5254),0xffffffff);
  uVar4 = *(int *)(local_4c + 0x7116) - 9;
  if (9 < uVar4) {
    _DAT_100393c8 = 3;
    .glue::CheckItem(_DAT_100393cc,3,1);
    *(short *)(local_4c + 0x5242) = 8 - (short)*(undefined4 *)(local_4c + 0x4f4c);
    .glue::CheckItem(_DAT_100393b4,(int)*(short *)(local_4c + 0x5242),1);
    sVar1 = *(short *)(local_4c + 0x4edc);
    if (sVar1 == 0x200) {
      .glue::CheckItem(_DAT_100393bc,2,1);
      _DAT_100393b8 = 2;
    }
    else if (sVar1 < 0x200) {
      if (sVar1 == 0x80) {
        .glue::CheckItem(_DAT_100393bc,3,1);
        _DAT_100393b8 = 3;
      }
    }
    else if (sVar1 == 0x600) {
      .glue::CheckItem(_DAT_100393bc,1,1);
      _DAT_100393b8 = 1;
    }
    if (*(char *)(local_4c + 0x4fe5) == '\0') {
      uVar3 = .glue::GetMenu(0x68);
      .glue::CheckItem(uVar3,3,1);
      _DAT_100393c0 = 3;
    }
    else if (*(char *)(local_4c + 0x4fe4) == '\0') {
      uVar3 = .glue::GetMenu(0x68);
      .glue::CheckItem(uVar3,1,1);
      _DAT_100393c0 = 1;
    }
    else {
      uVar3 = .glue::GetMenu(0x68);
      .glue::CheckItem(uVar3,2,1);
      _DAT_100393c0 = 2;
    }
    uVar3 = .glue::GetMenu(0x83);
    .glue::CheckItem(uVar3,2,*(undefined1 *)(local_4c + 0x342e));
    uVar3 = .glue::GetMenu(0x85);
    .glue::CheckItem(uVar3,2,*(undefined1 *)(local_4c + 0x4fe4));
    uVar3 = .glue::GetMenu(0x83);
    .glue::CheckItem(uVar3,1,*(undefined1 *)(local_4c + 0x523d));
    uVar3 = .glue::GetMenuHandle(0x80);
    .glue::AppendResMenu(uVar3,0x44525652);
    FUN_1001c01c();
    .glue::DrawMenuBar();
    return;
  }
                    /* WARNING: Could not recover jumptable at 0x1001b4c0. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **)(local_4c + 0xae0 + uVar4 * 4))();
  return;
}

