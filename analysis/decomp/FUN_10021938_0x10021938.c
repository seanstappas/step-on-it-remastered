/* FUN_10021938 @ 0x10021938  calls: Button, TickCount */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10021938(char param_1)

{
  int iVar1;
  uint uVar2;
  char cVar3;
  undefined4 uVar4;
  int *piVar5;
  short sVar6;
  short sVar7;
  int local_4c;
  int *local_24;
  
  if (DAT_10039494 == '\0') {
    .glue::SetGDevice(_DAT_1003b6d4);
    .glue::SetPort(*(undefined4 *)(local_4c + 0x7568));
    .glue::GetGDevice();
    piVar5 = *(int **)(**(int **)(local_4c + 0x7564) + 0x16);
    _DAT_10039498 = *(int **)(*piVar5 + 0x2a);
    uVar4 = *(undefined4 *)**(undefined4 **)(*piVar5 + 0x2a);
    .glue::HandToHand(&DAT_10039498);
    .glue::MoveHHi(_DAT_10039498);
    .glue::HLock(_DAT_10039498);
    for (sVar6 = 0; sVar6 <= *(short *)(*_DAT_10039498 + 6); sVar6 = sVar6 + 1) {
      *(short *)(*_DAT_10039498 + 8 + sVar6 * 8) = sVar6;
    }
    .glue::HUnlock(_DAT_10039498);
    iVar1 = .glue::TickCount();
    for (sVar6 = 10; -1 < sVar6; sVar6 = sVar6 + -1) {
      local_24 = _DAT_10039498;
      .glue::HandToHand(&local_24);
      .glue::HLock(local_24);
      for (sVar7 = 0; sVar7 <= *(short *)(*local_24 + 6); sVar7 = sVar7 + 1) {
        *(ushort *)(*local_24 + 10 + sVar7 * 8) =
             (*(ushort *)(*local_24 + 10 + sVar7 * 8) / 10) * sVar6;
        *(ushort *)(*local_24 + 0xc + sVar7 * 8) =
             (*(ushort *)(*local_24 + 0xc + sVar7 * 8) / 10) * sVar6;
        *(ushort *)(*local_24 + 0xe + sVar7 * 8) =
             (*(ushort *)(*local_24 + 0xe + sVar7 * 8) / 10) * sVar6;
      }
      .glue::HUnlock(local_24);
      do {
        uVar2 = .glue::TickCount();
      } while (uVar2 < iVar1 + 1U);
      iVar1 = .glue::TickCount();
      .glue::SetEntries(0,(int)*(short *)(*local_24 + 6),*local_24 + 8);
      .glue::DisposeHandle(local_24);
      if (param_1 != '\0') {
        FUN_100186b8(((int)sVar6 << 8) / 10);
      }
      cVar3 = .glue::Button();
      if (cVar3 != '\0') {
        FUN_100186b8(0);
      }
    }
    *(undefined4 *)**(undefined4 **)(*piVar5 + 0x2a) = uVar4;
    *(undefined1 *)(local_4c + 0x5324) = 1;
  }
  return;
}

