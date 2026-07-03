
void FUN_100159f4(int param_1,int param_2)

{
  short sVar1;
  int *piVar2;
  uint uVar3;
  short sVar4;
  undefined2 local_28;
  short local_26;
  short local_24;
  short local_22;
  undefined4 local_20;
  undefined4 local_1c;
  
  sVar4 = (short)param_1;
  sVar1 = (short)param_2;
  if (sVar4 == 3) {
    piVar2 = (int *).glue::GetPicture(0x3fc);
    if (piVar2 == (int *)0x0) {
      FUN_100192f8(5);
    }
    local_20 = *(undefined4 *)(*piVar2 + 2);
    uVar3 = *(uint *)(*piVar2 + 6);
    local_1c._2_2_ = (short)uVar3;
    local_26 = sVar1 - ((local_1c._2_2_ >> 1) + (ushort)(local_1c._2_2_ < 0 && (uVar3 & 1) != 0));
    local_1c._0_2_ = (short)(uVar3 >> 0x10);
    local_22 = local_26 + local_1c._2_2_;
    local_28 = 0xf5;
    local_24 = local_1c._0_2_ + 0xf5;
    local_1c = uVar3;
    .glue::DrawPicture(piVar2,&local_28);
    .glue::ReleaseResource(piVar2);
    piVar2 = (int *).glue::GetPicture(0x3f2);
    if (piVar2 == (int *)0x0) {
      FUN_100192f8(5);
    }
    local_20 = *(undefined4 *)(*piVar2 + 2);
    uVar3 = *(uint *)(*piVar2 + 6);
    local_1c._2_2_ = (short)uVar3;
    local_26 = (sVar1 + -0x36) -
               ((local_1c._2_2_ >> 1) + (ushort)(local_1c._2_2_ < 0 && (uVar3 & 1) != 0));
    local_1c._0_2_ = (short)(uVar3 >> 0x10);
    local_22 = local_26 + local_1c._2_2_;
    local_28 = 0x96;
    local_24 = local_1c._0_2_ + 0x96;
    local_1c = uVar3;
    .glue::DrawPicture(piVar2,&local_28);
    .glue::ReleaseResource(piVar2);
    piVar2 = (int *).glue::GetPicture(0x3f3);
    if (piVar2 == (int *)0x0) {
      FUN_100192f8(5);
    }
    local_20 = *(undefined4 *)(*piVar2 + 2);
    uVar3 = *(uint *)(*piVar2 + 6);
    local_1c._2_2_ = (short)uVar3;
    local_26 = (sVar1 + 0x36) -
               ((local_1c._2_2_ >> 1) + (ushort)(local_1c._2_2_ < 0 && (uVar3 & 1) != 0));
    local_1c._0_2_ = (short)(uVar3 >> 0x10);
    local_22 = local_26 + local_1c._2_2_;
    local_28 = 0x96;
    local_24 = local_1c._0_2_ + 0x96;
    local_1c = uVar3;
    .glue::DrawPicture(piVar2,&local_28);
    .glue::ReleaseResource(piVar2);
    FUN_10015e90(sRam1003aa58 + -1,param_2 + 0x6d,0xff);
    FUN_10015e90(uRam1003aa5c,param_2 + 0x6d,0x17c);
  }
  else {
    piVar2 = (int *).glue::GetPicture(param_1 + 0x3fb);
    if (piVar2 == (int *)0x0) {
      FUN_100192f8(5);
    }
    local_20 = *(undefined4 *)(*piVar2 + 2);
    uVar3 = *(uint *)(*piVar2 + 6);
    local_1c._2_2_ = (short)uVar3;
    local_26 = sVar1 - ((local_1c._2_2_ >> 1) + (ushort)(local_1c._2_2_ < 0 && (uVar3 & 1) != 0));
    local_1c._0_2_ = (short)(uVar3 >> 0x10);
    local_22 = local_26 + local_1c._2_2_;
    local_28 = 0xf5;
    local_24 = local_1c._0_2_ + 0xf5;
    local_1c = uVar3;
    .glue::DrawPicture(piVar2,&local_28);
    .glue::ReleaseResource(piVar2);
    piVar2 = (int *).glue::GetPicture(param_1 + 0x3f1);
    if (piVar2 == (int *)0x0) {
      FUN_100192f8(5);
    }
    local_20 = *(undefined4 *)(*piVar2 + 2);
    uVar3 = *(uint *)(*piVar2 + 6);
    local_1c._2_2_ = (short)uVar3;
    local_26 = sVar1 - ((local_1c._2_2_ >> 1) + (ushort)(local_1c._2_2_ < 0 && (uVar3 & 1) != 0));
    local_1c._0_2_ = (short)(uVar3 >> 0x10);
    local_22 = local_26 + local_1c._2_2_;
    local_28 = 0x96;
    local_24 = local_1c._0_2_ + 0x96;
    local_1c = uVar3;
    .glue::DrawPicture(piVar2,&local_28);
    .glue::ReleaseResource(piVar2);
    FUN_10015e90(*(short *)(sVar4 * 0x70 + 0x1003a9e8) + -1,param_2 + 0x6d,0xff);
    FUN_10015e90(*(undefined4 *)(sVar4 * 0x70 + 0x1003a9ec),param_2 + 0x6d,0x17c);
  }
  return;
}

