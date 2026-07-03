/* FUN_10029ca0 @ 0x10029ca0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10029ca0(void)

{
  byte bVar1;
  byte bVar2;
  byte bVar3;
  short sVar7;
  short sVar8;
  undefined4 uVar4;
  int iVar5;
  uint uVar6;
  char cVar9;
  undefined4 uVar10;
  byte *pbVar11;
  byte bVar12;
  undefined4 local_78 [5];
  undefined4 local_64 [5];
  short local_50;
  short local_4e;
  short local_4c;
  short local_4a;
  undefined4 local_48;
  undefined4 local_44;
  
  uRam1003aa3e = (DAT_1003b6c9 & 2) != 0;
  uRam1003aa3f = (DAT_1003b6c9 & 1) != 0;
  uRam1003aa40 = (DAT_1003b6c9 & 4) != 0;
  uRam1003aa41 = (DAT_1003b6c9 & 8) != 0;
  uRam1003aa42 = (DAT_1003b6c9 & 0x10) != 0;
  uRam1003aa44 = (DAT_1003b6c9 & 0x20) != 0;
  uRam1003aa43 = (DAT_1003b6c9 & 0x40) != 0;
  DAT_1003b6c8 = DAT_1003b6c8 + -1;
  if (DAT_1003b6c8 == '\0') {
    DAT_1003b6c8 = *_DAT_1003b6cc;
    DAT_1003b6c9 = _DAT_1003b6cc[1];
    _DAT_1003b6cc = _DAT_1003b6cc + 2;
  }
  if (DAT_1003b6c8 == '\0') {
    bVar1 = *_DAT_1003b6c4;
    _DAT_1003b6c4 = _DAT_1003b6c4 + 1;
    for (bVar12 = 0; bVar12 < bVar1; bVar12 = bVar12 + 1) {
      pbVar11 = _DAT_1003b6c4 + 1;
      bVar2 = *_DAT_1003b6c4;
      _DAT_1003b6c4 = _DAT_1003b6c4 + 2;
      sVar7 = FUN_1002e6ac(*pbVar11);
      bVar3 = *_DAT_1003b6c4;
      _DAT_1003b6c4 = _DAT_1003b6c4 + 1;
      sVar8 = FUN_1002e6bc(bVar3);
      sVar8 = sVar8 + _DAT_1003b6ec;
      sVar7 = sVar7 + sRam1003b6ee;
      if (DAT_1003b70c != '\0') {
        sVar7 = (short)(((int)sVar7 << 2) / 5);
        sVar8 = (short)(((int)sVar8 << 2) / 5);
      }
      uVar4 = .glue::GetPicture(bVar2);
      local_64[bVar12] = uVar4;
      uVar4 = *(undefined4 *)(*(int *)local_64[bVar12] + 2);
      uVar10 = *(undefined4 *)(*(int *)local_64[bVar12] + 6);
      local_48._0_2_ = (short)((uint)uVar4 >> 0x10);
      local_44._0_2_ = (short)((uint)uVar10 >> 0x10);
      local_50 = local_48._0_2_ + sVar8;
      local_48._2_2_ = (short)uVar4;
      local_44._2_2_ = (short)uVar10;
      local_4c = local_44._0_2_ + sVar8;
      local_4e = local_48._2_2_ + sVar7;
      local_4a = local_44._2_2_ + sVar7;
      local_48 = uVar4;
      local_44 = uVar10;
      uVar4 = FUN_100048b4(&local_50);
      local_78[bVar12] = uVar4;
      .glue::DrawPicture(local_64[bVar12],&local_50);
    }
    iVar5 = .glue::TickCount();
    .glue::GetKeys(&DAT_1003b6fc);
    while (((uVar6 = .glue::TickCount(), uVar6 < iVar5 + 200U &&
            (cVar9 = .glue::Button(), cVar9 == '\0')) &&
           (cVar9 = FUN_1002d388(0x3100), cVar9 == '\0'))) {
      .glue::GetKeys(&DAT_1003b6fc);
    }
    while ((cVar9 = .glue::Button(), cVar9 != '\0' || (cVar9 = FUN_1002d388(0x3100), cVar9 != '\0'))
          ) {
      .glue::GetKeys(&DAT_1003b6fc);
    }
    for (bVar12 = 0; bVar12 < bVar1; bVar12 = bVar12 + 1) {
      FUN_100049d8(local_78[bVar12]);
      .glue::ReleaseResource(local_64[bVar12]);
    }
    DAT_1003b6c8 = *_DAT_1003b6cc;
    DAT_1003b6c9 = _DAT_1003b6cc[1];
    _DAT_1003b6cc = _DAT_1003b6cc + 2;
  }
  return;
}

