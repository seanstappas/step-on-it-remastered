
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10021c14(void)

{
  int iVar1;
  uint uVar2;
  undefined4 uVar3;
  int *piVar4;
  short sVar5;
  short sVar6;
  int local_4c;
  int *local_24;
  
  if (DAT_10039494 != '\0') {
    .glue::GetGDevice();
    piVar4 = *(int **)(**(int **)(local_4c + 0x7564) + 0x16);
    uVar3 = *(undefined4 *)**(undefined4 **)(*piVar4 + 0x2a);
    iVar1 = .glue::TickCount();
    for (sVar5 = 1; sVar5 < 10; sVar5 = sVar5 + 1) {
      local_24 = _DAT_10039498;
      .glue::HandToHand(&local_24);
      .glue::HLock(local_24);
      for (sVar6 = 0; sVar6 <= *(short *)(*local_24 + 6); sVar6 = sVar6 + 1) {
        *(ushort *)(*local_24 + 10 + sVar6 * 8) =
             (*(ushort *)(*local_24 + 10 + sVar6 * 8) / 10) * sVar5;
        *(ushort *)(*local_24 + 0xc + sVar6 * 8) =
             (*(ushort *)(*local_24 + 0xc + sVar6 * 8) / 10) * sVar5;
        *(ushort *)(*local_24 + 0xe + sVar6 * 8) =
             (*(ushort *)(*local_24 + 0xe + sVar6 * 8) / 10) * sVar5;
      }
      .glue::HUnlock(local_24);
      do {
        uVar2 = .glue::TickCount();
      } while (uVar2 < iVar1 + 1U);
      iVar1 = .glue::TickCount();
      .glue::SetEntries(0xffffffff,(int)*(short *)(*local_24 + 6),*local_24 + 8);
      .glue::QDError();
      .glue::DisposeHandle(local_24);
    }
    .glue::SetEntries(0xffffffff,(int)*(short *)(*_DAT_10039498 + 6),*_DAT_10039498 + 8);
    *(undefined4 *)**(undefined4 **)(*piVar4 + 0x2a) = uVar3;
    .glue::DisposeHandle(_DAT_10039498);
    *(undefined1 *)(local_4c + 0x5324) = 0;
    .glue::MakeITable(0,0,0);
  }
  return;
}

