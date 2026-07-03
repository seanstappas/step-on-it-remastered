
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10026bb8(short param_1,short param_2,undefined4 param_3,short param_4)

{
  int *piVar1;
  undefined4 uVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  uint uVar8;
  int iVar9;
  int iVar10;
  short sVar11;
  short sVar12;
  int iVar13;
  int iVar14;
  int iVar15;
  undefined4 uVar16;
  short sStack0000001a;
  short sStack0000001e;
  short sStack00000026;
  int local_7c;
  undefined1 auStack_54 [8];
  short local_4c;
  
  sStack0000001a = param_1;
  sStack0000001e = param_2;
  sStack00000026 = param_4;
  FUN_100034e4();
  piVar1 = (int *).glue::GetGDevice();
  piVar1 = *(int **)(*piVar1 + 0x16);
  uVar16 = *(undefined4 *)**(undefined4 **)(*piVar1 + 0x2a);
  uVar2 = FUN_1002e6cc((int)sStack0000001a);
  iVar3 = FUN_1002e6ac(uVar2);
  iVar4 = FUN_1002e6cc((int)sStack0000001a);
  iVar4 = FUN_1002e6ac(iVar4 + 1);
  uVar2 = FUN_1002e6f8((int)sStack0000001e);
  iVar5 = FUN_1002e6bc(uVar2);
  iVar6 = FUN_1002e6f8((int)sStack0000001e);
  iVar6 = FUN_1002e6bc(iVar6 + 1);
  iVar5 = iVar5 + _DAT_1003b6ec;
  iVar3 = iVar3 + sRam1003b6ee;
  sVar12 = (short)iVar3 - sRam1003b6ee;
  sVar11 = (short)iVar5;
  iVar4 = iVar4 + sRam1003b6ee;
  iVar6 = iVar6 + _DAT_1003b6ec;
  if ((int)sVar12 < (int)sVar11 - (int)_DAT_1003b6ec) {
    sVar12 = sVar11 - _DAT_1003b6ec;
  }
  if ((int)sVar12 < (int)sRam1003b6f2 - (int)(short)iVar4) {
    sVar12 = sRam1003b6f2 - (short)iVar4;
  }
  if ((int)sVar12 < (int)sRam1003b6f0 - (int)(short)iVar6) {
    sVar12 = sRam1003b6f0 - (short)iVar6;
  }
  uVar8 = (uint)sRam1003b6f0;
  if ((int)sVar11 < (int)(((int)uVar8 >> 1) + (uint)((int)uVar8 < 0 && (uVar8 & 1) != 0))) {
    iVar9 = 1;
  }
  else {
    iVar9 = -1;
  }
  uVar8 = (uint)sRam1003b6f2;
  if ((int)(short)iVar3 < (int)(((int)uVar8 >> 1) + (uint)((int)uVar8 < 0 && (uVar8 & 1) != 0))) {
    iVar10 = 1;
  }
  else {
    iVar10 = -1;
  }
  .glue::PenSize(1,1);
  sVar11 = 0;
  .glue::PenSize(5,5);
  iVar13 = 0;
  iVar7 = .glue::TickCount();
  iVar15 = 1;
  while (iVar13 < sVar12) {
    *(int *)(*(int *)(local_7c + 0x7534) + 0x50) = 0xfe - sVar11;
    .glue::SetRect(auStack_54,
                   (iVar3 - (iVar13 * ((int)(short)iVar3 - (int)sRam1003b6ee)) / (int)sVar12) -
                   iVar15,(iVar5 - (iVar13 * ((int)(short)iVar5 - (int)_DAT_1003b6ec)) / (int)sVar12
                          ) - iVar15,
                   iVar4 + (iVar13 * ((int)sRam1003b6f2 - (int)(short)iVar4)) / (int)sVar12 + iVar15
                   ,iVar6 + (iVar13 * ((int)sRam1003b6f0 - (int)(short)iVar6)) / (int)sVar12 +
                            iVar15);
    .glue::FrameRect(auStack_54);
    sVar11 = sVar11 + 1;
    if (0x1d < sVar11) {
      sVar11 = 0;
    }
    iVar13 = iVar13 + (short)iVar15;
    iVar14 = iVar15;
    if (sVar11 == 0x1d) {
      iVar14 = iVar15 + 3;
      .glue::PenSize(iVar15 + 7,iVar15 + 7);
    }
    iVar3 = iVar3 + iVar10 * 2;
    iVar4 = iVar4 + iVar10 * 2;
    iVar5 = iVar5 + iVar9 * 2;
    iVar6 = iVar6 + iVar9 * 2;
    .glue::SetEntries(0xe1,0x1d,*_DAT_1003b268 + 8 + (sVar11 + 2) * 8);
    *(undefined4 *)**(undefined4 **)(*piVar1 + 0x2a) = uVar16;
    do {
      uVar8 = .glue::TickCount();
    } while (uVar8 <= iVar7 + 1U);
    iVar7 = .glue::TickCount();
    iVar15 = iVar14;
  }
  for (local_4c = 1; local_4c <= sStack00000026; local_4c = local_4c + 1) {
    for (; sVar11 < 0x1e; sVar11 = sVar11 + 1) {
      .glue::SetEntries(0xe1,0x1d,*_DAT_1003b268 + 8 + (sVar11 + 2) * 8);
      *(undefined4 *)**(undefined4 **)(*piVar1 + 0x2a) = uVar16;
      do {
        uVar8 = .glue::TickCount();
      } while (uVar8 <= iVar7 + 1U);
      iVar7 = .glue::TickCount();
    }
    sVar11 = 0;
  }
  *(undefined4 *)**(undefined4 **)(*piVar1 + 0x2a) = uVar16;
  return;
}

