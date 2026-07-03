/* FUN_1002707c @ 0x1002707c  calls: TickCount */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002707c(void)

{
  int iVar1;
  uint uVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  int local_4c;
  short local_28;
  short local_26;
  short local_24;
  short local_22;
  undefined4 local_20;
  short local_1c;
  short sStack_1a;
  
  .glue::SetPort(_DAT_1003b6a4);
  uVar3 = *(undefined4 *)(**(int **)(local_4c + 0x7130) + 2);
  uVar4 = *(undefined4 *)(**(int **)(local_4c + 0x7130) + 6);
  local_20._0_2_ = (short)((uint)uVar3 >> 0x10);
  local_1c = (short)((uint)uVar4 >> 0x10);
  local_1c = local_1c - local_20._0_2_;
  sStack_1a = (short)uVar4;
  local_20._2_2_ = (short)uVar3;
  sStack_1a = sStack_1a - local_20._2_2_;
  local_20 = 0;
  uVar2 = ((int)sRam1003b6f2 + (int)sRam1003b6ee) - (int)sStack_1a;
  local_26 = (short)((int)uVar2 >> 1) + (ushort)((int)uVar2 < 0 && (uVar2 & 1) != 0);
  local_22 = local_26 + sStack_1a;
  uVar2 = ((int)_DAT_1003b6ec + (int)sRam1003b6f0) - (int)local_1c;
  local_28 = (short)((int)uVar2 >> 1) + (ushort)((int)uVar2 < 0 && (uVar2 & 1) != 0) + 0x10;
  local_24 = local_28 + local_1c;
  .glue::DrawPicture(*(undefined4 *)(local_4c + 0x7130),&local_28);
  iVar1 = .glue::TickCount();
  do {
    uVar2 = .glue::TickCount();
  } while (uVar2 < iVar1 + 0xb4U);
  return;
}

