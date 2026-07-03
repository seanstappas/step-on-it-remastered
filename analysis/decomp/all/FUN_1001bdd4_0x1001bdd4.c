
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001bdd4(void)

{
  short sVar1;
  short sVar2;
  short sVar3;
  short sVar4;
  undefined4 uVar5;
  uint uVar6;
  undefined4 uVar7;
  uint uVar8;
  int *piVar9;
  undefined4 local_4c;
  undefined2 local_28;
  undefined2 uStack_26;
  undefined2 local_24;
  undefined2 uStack_22;
  
  FUN_1002dd90();
  piVar9 = *(int **)(*_DAT_10039358 + 0x16);
  sVar1 = *(short *)(_DAT_1003b6a0 + 0x12);
  sVar2 = *(short *)(_DAT_1003b6a0 + 0x16);
  sVar3 = *(short *)(_DAT_1003b6a0 + 0x10);
  sVar4 = *(short *)(_DAT_1003b6a0 + 0x14);
  uVar5 = *(undefined4 *)(*piVar9 + 6);
  uVar7 = *(undefined4 *)(*piVar9 + 10);
  .glue::MoveWindow(_DAT_1003b6a4,0,0,0);
  uStack_26 = (short)uVar5;
  uStack_22 = (short)uVar7;
  local_28 = (short)((uint)uVar5 >> 0x10);
  local_24 = (short)((uint)uVar7 >> 0x10);
  .glue::SizeWindow(*(undefined4 *)(local_4c + 0x7534),(int)uStack_22 - (int)uStack_26,
                    (int)local_24 - (int)local_28,1);
  uVar6 = ((int)uStack_22 + (int)uStack_26) - (int)(short)(sVar2 - sVar1);
  uVar8 = ((int)local_24 + (int)local_28) - (int)(short)(sVar4 - sVar3);
  .glue::MoveWindow(_DAT_1003b6a0,((int)uVar6 >> 1) + (uint)((int)uVar6 < 0 && (uVar6 & 1) != 0),
                    ((int)uVar8 >> 1) + (uint)((int)uVar8 < 0 && (uVar8 & 1) != 0),0);
  _DAT_1003b6b4 = *(undefined4 *)(*piVar9 + 6);
  uVar5 = *(undefined4 *)(*piVar9 + 10);
  uRam1003b6b8._2_2_ = (short)uVar5;
  uVar6 = (int)uRam1003b6b8._2_2_ - 0x280;
  sRam1003b6ee = (short)((int)uVar6 >> 1) + (ushort)((int)uVar6 < 0 && (uVar6 & 1) != 0);
  uRam1003b6b8._0_2_ = (short)((uint)uVar5 >> 0x10);
  uVar6 = (int)uRam1003b6b8._0_2_ - 0x1e0;
  _DAT_1003b6ec = (short)((int)uVar6 >> 1) + (ushort)((int)uVar6 < 0 && (uVar6 & 1) != 0);
  sRam1003b6f2 = sRam1003b6ee + 0x280;
  sRam1003b6f0 = _DAT_1003b6ec + 0x1e0;
  uRam1003b6b8 = uVar5;
  *(undefined4 *)(local_4c + 0x6bd4) = *(undefined4 *)*piVar9;
  *(ushort *)(local_4c + 0x6bd0) = *(ushort *)(*piVar9 + 4) & 0x7fff;
  *(int *)(local_4c + 0x6bd4) =
       *(int *)(local_4c + 0x6bd4) +
       (int)sRam1003b6ee + (int)_DAT_1003b6ec * (int)*(short *)(local_4c + 0x6bd0);
  return;
}

