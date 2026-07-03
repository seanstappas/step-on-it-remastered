/* FUN_1001fcb0 @ 0x1001fcb0  depth=2 */

void FUN_1001fcb0(void)

{
  bool bVar1;
  int *piVar2;
  short sVar3;
  undefined1 uVar4;
  int iVar5;
  int *piVar6;
  int local_4c;
  byte local_24 [4];
  undefined4 local_20;
  undefined4 local_1c;
  undefined2 local_18;
  
  piVar2 = (int *).glue::GetGDevice();
  *(int **)(local_4c + 0x51e8) = piVar2;
  sVar3 = .glue::HasDepth(piVar2,8,1,1);
  if (sVar3 == 0) {
    FUN_100192f8(10);
  }
  piVar6 = *(int **)(*piVar2 + 0x16);
  iVar5 = *piVar6;
  local_20 = *(undefined4 *)(iVar5 + 6);
  local_1c = *(undefined4 *)(iVar5 + 10);
  if ((local_1c._2_2_ < 0x280) ||
     (local_1c._0_2_ = (short)((uint)local_1c >> 0x10), bVar1 = local_1c._0_2_ < 0x1e0, bVar1)) {
    FUN_100192f8(10);
  }
  *(undefined2 *)(local_4c + 0x51ee) = *(undefined2 *)(*piVar6 + 0x20);
  if (*(short *)(local_4c + 0x51ee) != 8) {
    sVar3 = .glue::HasDepth(piVar2,8,1,1);
    if (sVar3 == 0) {
      FUN_100192f8(10);
    }
    else {
      local_18 = .glue::SetDepth(piVar2,8,1,1);
    }
  }
  .glue::SndSoundManagerVersion(local_24);
  if (local_24[0] < 3) {
    FUN_100192f8(0xb);
  }
  uVar4 = FUN_1001ff30();
  *(undefined1 *)(local_4c + 0x4eda) = uVar4;
  uVar4 = FUN_1001fe54();
  *(undefined1 *)(local_4c + 0x4ed9) = uVar4;
  .glue::FreeMem();
  iVar5 = .glue::FreeMem();
  if (iVar5 < 0x3a1671) {
    *(undefined1 *)(local_4c + 0x523c) = 0;
  }
  else {
    *(undefined1 *)(local_4c + 0x523c) = 1;
  }
  return;
}

