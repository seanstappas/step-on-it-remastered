
void FUN_1001edac(int param_1)

{
  short local_18;
  short sStack_16;
  undefined4 local_14;
  
  .glue::SetPort(param_1);
  local_14 = *(undefined4 *)(param_1 + 0x14);
  _local_18 = CONCAT22((short)((uint)*(undefined4 *)(param_1 + 0x10) >> 0x10),local_14._2_2_ + -0xf)
  ;
  .glue::InvalRect(&local_18);
  .glue::EraseRect(&local_18);
  local_14._0_2_ = (short)((uint)*(undefined4 *)(param_1 + 0x14) >> 0x10);
  _local_18 = CONCAT22(local_14._0_2_ + -0xf,(short)*(undefined4 *)(param_1 + 0x10));
  local_14 = *(undefined4 *)(param_1 + 0x14);
  .glue::InvalRect(&local_18);
  .glue::EraseRect(&local_18);
  return;
}

