
void FUN_100257ac(void)

{
  int *piVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  int local_4c;
  undefined4 local_28;
  short local_24;
  short local_22;
  short local_20;
  short local_1e;
  undefined4 local_1c;
  short local_18;
  short sStack_16;
  
  piVar1 = (int *).glue::GetPicture(0x191);
  if (piVar1 == (int *)0x0) {
    FUN_100192f8(5);
  }
  else {
    .glue::GetPort(&local_28);
    .glue::SetPort(*(undefined4 *)(local_4c + 0x7570));
    .glue::SetGDevice(*(undefined4 *)(local_4c + 0x756c));
    uVar2 = *(undefined4 *)(*piVar1 + 2);
    uVar3 = *(undefined4 *)(*piVar1 + 6);
    local_1c._0_2_ = (short)((uint)uVar2 >> 0x10);
    local_18 = (short)((uint)uVar3 >> 0x10);
    local_18 = local_18 - local_1c._0_2_;
    sStack_16 = (short)uVar3;
    local_1c._2_2_ = (short)uVar2;
    sStack_16 = sStack_16 - local_1c._2_2_;
    local_1c = 0;
    local_22 = *(short *)(local_4c + 0x5338) + 0x18;
    local_24 = *(short *)(local_4c + 0x5336) + 0x18;
    local_1e = local_22 + sStack_16;
    local_20 = local_24 + local_18;
    .glue::DrawPicture(piVar1,&local_24);
    .glue::ReleaseResource(piVar1);
    .glue::SetPort(local_28);
    .glue::SetGDevice(*(undefined4 *)(local_4c + 0x7564));
  }
  return;
}

